/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 *
 * @author tjia
 */

package Core;

import DTO.Doctor;
import DTO.DoctorProfileFull;
import DTO.DoctorResult;
import DTO.ExtendedPatient;
import DTO.FriendRequest;
import DTO.Name;
import DTO.Review;
import DTO.WorkAddress;

import java.sql.*;
import java.util.ArrayList;
import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

public class DBAOImpl implements DBAO{

    @Override
    public ArrayList<ExtendedPatient> searchPatientProfile(String alias, String province, String city, String searcherAlias) throws Exception {
         Connection con = null;
         CallableStatement stmt = null;
        
         try{
             con = getConnection();                    
           
            stmt = con.prepareCall("{ call ece356db_jaurquha.patientToPatientSearchFriend(?, ?, ?, ?)}");
            stmt.setString(1, alias);        
            stmt.setString(2, province);
            stmt.setString(3, city);   
            stmt.setString(4, searcherAlias);
            
             ResultSet resultSet = stmt.executeQuery();
             ArrayList<ExtendedPatient> results = new ArrayList<>();
                     
             while(resultSet.next()){                 
                 ExtendedPatient p = new ExtendedPatient(
                            resultSet.getString("gAlias"),
                            resultSet.getString("City") + "," + resultSet.getString("Province"),
                            resultSet.getInt("ReviewCount"),
                            resultSet.getTimestamp("LastReviewDate"),
                            resultSet.getInt("IsFriend")
                         );    
                 results.add(p);
             }
             
             return results;
         }finally {
             if(stmt != null){
                 stmt.close();
             }
             if(con != null){
                 con.close();
             }
         } 
    }

    
    public FriendRequestResult patientRequestFriend(String alias_a, String alias_b) throws Exception {
        Connection con = null;
        CallableStatement stmt = null;

        try{
            con = getConnection();                    
            
            stmt = con.prepareCall("{ call ece356db_jaurquha.Friendship(?,?)}");
            stmt.setString(1, alias_a);
            stmt.setString(2, alias_b);
            

            ResultSet resultSet = stmt.executeQuery();

            resultSet.next();
            
            int ret = resultSet.getInt("rslt");
            FriendRequestResult friendRequestResult = FriendRequestResult.InvalidState;
            
            if(ret == 0){
                friendRequestResult = FriendRequestResult.AlreadyFriends;                 
            } else if (ret == 1){
               friendRequestResult = FriendRequestResult.AlreadyRequested;
            } else if (ret == 2){
               friendRequestResult = FriendRequestResult.NewFriendshipFormed;
            } else if (ret == 3){
               friendRequestResult = FriendRequestResult.NewRequestAdded;
            }
            return friendRequestResult;
        }       
        finally {
            if(stmt != null){
                stmt.close();
            }
            if(con != null){
                con.close();
            }
        } 
    } 

    
    public ArrayList<FriendRequest> fetchFriendRequest(String alias) throws Exception {
        Connection con = null;
      CallableStatement stmt = null;

      try{
        con = getConnection();                    

        stmt = con.prepareCall("{ call ece356db_jaurquha.viewMyFriendRequests(?)}");
        stmt.setString(1, alias);

            
        ResultSet resultSet = stmt.executeQuery();
        ArrayList<FriendRequest> results = new ArrayList<>();

        while(resultSet.next()){                 
            FriendRequest fr = new FriendRequest(
                    resultSet.getString("RequestergAlias"),
                    resultSet.getString("EmailAddress")
                    );    
            results.add(fr);
        }

        return results;
      }finally {
          if(stmt != null){
              stmt.close();
          }
          if(con != null){
              con.close();
          }
      } 
    } 
    
    
    @Override
    public ArrayList<DoctorResult> searchDoctorProfile(
            String patientAlias, 
            String firstName, 
            String middleName, 
            String lastName, 
            String gender, 
            String province, 
            String city, 
            String street, 
            String streetNumber, 
            String apartmentNumber,
            String postalCode, 
            String specialization, 
            int numYearsLicensed,
            double avgStarRating,
            int reviewedByFriend,
            String reviewKeyword
            ) throws Exception {
       
                Connection con = null;
                CallableStatement stmt = null;

                try{
                    con = getConnection();                    
                    
                    float fAvgStarRating = (float) avgStarRating;
                    
                    stmt = con.prepareCall("{ call ece356db_jaurquha.superDoctorSearch(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)}");
                    stmt.setString(1, patientAlias);
                    stmt.setString(2, firstName);    
                    stmt.setString(3, middleName);
                    stmt.setString(4, lastName);
                    stmt.setString(5, gender);
                    stmt.setInt(6, numYearsLicensed);
                    stmt.setString(7, street);
                    stmt.setString(8, streetNumber);
                    stmt.setString(9, apartmentNumber);
                    stmt.setString(10, postalCode);
                    stmt.setString(11, city);
                    stmt.setString(12, province);
                    stmt.setString(13, specialization);
                    stmt.setFloat(14, fAvgStarRating);
                    stmt.setInt(15, reviewedByFriend);
                    stmt.setString(16, reviewKeyword);
                   

                    ResultSet resultSet = stmt.executeQuery();
                    ArrayList<DoctorResult> results = new ArrayList<>();

                    while(resultSet.next()){                 
                        DoctorResult d = new DoctorResult(
                                resultSet.getString("DoctorAlias"),
                                new Name(
                                    resultSet.getString("FirstName"),
                                    resultSet.getString("MiddleName"),
                                    resultSet.getString("LastName")
                                ),
                                resultSet.getString("Gender"),
                                resultSet.getDouble("AvgStarRating"),
                                resultSet.getInt("ReviewCount")
                                
                             );   
                                
                        results.add(d);
                    }

                    return results;
                }finally {
                    if(stmt != null){
                        stmt.close();
                    }
                    if(con != null){
                        con.close();
                    }
                } 
    }

    @Override
    public DoctorProfileFull getDoctorProfileFull(String alias) throws Exception {
        Connection con = null;
        CallableStatement stmt = null;

        try{
            con = getConnection();                    
            
            // Get general doc info
            //
            stmt = con.prepareCall("{ call ece356db_jaurquha.getDoctorProfileInfo(?)}");
            stmt.setString(1, alias);
            
            ResultSet DoctorProfileInfoResultSet = stmt.executeQuery();
        
            DoctorProfileInfoResultSet.next();
            
            int numYearsLicensed = 2015 - Integer.parseInt(DoctorProfileInfoResultSet.getString("YearMedicalLicense"));
            
            

        
            // Get work address info
            //
            stmt = con.prepareCall("{ call ece356db_jaurquha.getDoctorWorkAddresses(?)}");
            stmt.setString(1, alias);
            
            ResultSet DoctorWorkAddressesResultSet = stmt.executeQuery();
            
            ArrayList<WorkAddress> workAddressResults = new ArrayList<>();

            while(DoctorWorkAddressesResultSet.next()){                 
                WorkAddress wa = new WorkAddress(
                        DoctorWorkAddressesResultSet.getString("Province"),
                        DoctorWorkAddressesResultSet.getString("City"),
                        DoctorWorkAddressesResultSet.getString("PostalCode"),
                        DoctorWorkAddressesResultSet.getString("Street_Name"),
                        DoctorWorkAddressesResultSet.getString("Street_Number"),
                        DoctorWorkAddressesResultSet.getString("Apt_Number")
                        );    
                workAddressResults.add(wa);
            }
            
  
            
            // Get specialization info
            //
            stmt = con.prepareCall("{ call ece356db_jaurquha.getDoctorSpecialization(?)}");
            stmt.setString(1, alias);
            
            ResultSet DoctorSpecializationResultSet = stmt.executeQuery();
            
            ArrayList<String> doctorSpecializationResults = new ArrayList<>();

            while(DoctorSpecializationResultSet.next()){                 
                doctorSpecializationResults.add(DoctorSpecializationResultSet.getString("SpecializationName"));
            }
            
            
            
            // Get review stats info
            //
            stmt = con.prepareCall("{ call ece356db_jaurquha.getDoctorReviewStats(?)}");
            stmt.setString(1, alias);
            
            ResultSet DoctorReviewStatsResultSet = stmt.executeQuery();
        
            DoctorReviewStatsResultSet.next();
            
            
            
            // Create doctor object
            //
            Doctor doctor = new Doctor(
                DoctorProfileInfoResultSet.getString("gAlias"),
                new Name(
                    DoctorProfileInfoResultSet.getString("FirstName"),
                    DoctorProfileInfoResultSet.getString("MiddleName"),
                    DoctorProfileInfoResultSet.getString("LastName")
                ),
                DoctorProfileInfoResultSet.getString("Gender"),
                workAddressResults,
                doctorSpecializationResults,
                numYearsLicensed,
                DoctorReviewStatsResultSet.getDouble("AvgRating"),
                DoctorReviewStatsResultSet.getInt("NumReviews"),
                DoctorProfileInfoResultSet.getString("EmailAddress")
            );
            

            
            // Get review ID info
            //
            stmt = con.prepareCall("{ call ece356db_jaurquha.getReviewIDs(?)}");
            stmt.setString(1, alias);
            
            ResultSet ReviewIDsResultSet = stmt.executeQuery();
            
            ArrayList<Integer> reviewIDsResults = new ArrayList<>();

            while(ReviewIDsResultSet.next()){                 
                reviewIDsResults.add(ReviewIDsResultSet.getInt("ReviewContentID"));
            }
            
            
            
            // Create full doctor profile object
            //
            DoctorProfileFull doctorProfileFull = new DoctorProfileFull(
                doctor,
                reviewIDsResults 
            );
            
            return doctorProfileFull;

        }       
        finally {
            if(stmt != null){
                stmt.close();
            }
            if(con != null){
                con.close();
            }
        } 
    } 

    @Override
    public void addReview(String userAlias, String doctorAlias, String text, double rating) throws Exception {
        Connection con = null;
         CallableStatement stmt = null;
        
         try{
             con = getConnection();                    
           
            stmt = con.prepareCall("{ call ece356db_jaurquha.writeDoctorReview(?, ?, ?, ?)}");
            
          
            float fRating = (float) rating;

            stmt.setString(1, userAlias);        
            stmt.setString(2, doctorAlias);
            stmt.setFloat(3, fRating);   
            stmt.setString(4, text);
            
             ResultSet resultSet = stmt.executeQuery();
    
         }finally {
             if(stmt != null){
                 stmt.close();
             }
             if(con != null){
                 con.close();
             }
         } 
    }

    @Override
    public Review fetchFullReview(int reviewId) throws Exception {
         
        Connection con = null;
        CallableStatement stmt = null;

        try{
            con = getConnection();                    

            stmt = con.prepareCall("{ call ece356db_jaurquha.getReviewAndNeighbors(?)}");
            stmt.setInt(1, reviewId);          
          
            ResultSet reviewResultSet = stmt.executeQuery();

            reviewResultSet.next();
            
            Name doctorName = new Name(
                    reviewResultSet.getString("FirstName"),
                    reviewResultSet.getString("MiddleName"),
                    reviewResultSet.getString("LastName")
            );
            
            
            Review review = new Review(
                    reviewResultSet.getString("DoctorAlias"),
                    doctorName,
                    reviewResultSet.getDouble("StarRating"),
                    reviewResultSet.getString("Comments"),
                    reviewResultSet.getDate("ReviewDate"),
                    0,
                    reviewResultSet.getInt("prevReviewId"),
                    reviewResultSet.getInt("nextReviewId")
            );
                        

            return review;
        }       
        finally {
            if(stmt != null){
                stmt.close();
            }
            if(con != null){
                con.close();
            }
        } 
    } 
     
    @Override
    public ArrayList<String> fetchSpecialization() throws Exception {
         
        Connection con = null;
        CallableStatement stmt = null;

        try{
            con = getConnection();                    

            stmt = con.prepareCall("{ call ece356db_jaurquha.getAllSpecializations()}");
          
            ResultSet specializationResultSet = stmt.executeQuery();
            
            ArrayList<String> specializationList = new ArrayList<>();
            
            
            while(specializationResultSet.next()){                 
                specializationList.add(specializationResultSet.getString("SpecializationName"));
            }
                        

            return specializationList;
        }       
        finally {
            if(stmt != null){
                stmt.close();
            }
            if(con != null){
                con.close();
            }
        } 
    } 
    
    
    public static final String url = "jdbc:mysql://eceweb.uwaterloo.ca:3306/";
    public static final String user = "user_jaurquha";
    public static final String pwd = "user_jaurquha";
    
    public static Connection getConnection() throws ClassNotFoundException, SQLException, Exception {
        
        InitialContext cxt = new InitialContext();
        if (cxt == null) {
        throw new RuntimeException("Unable to create naming context!");
        }
        Context dbContext = (Context) cxt.lookup("java:comp/env");
        DataSource ds = (DataSource) dbContext.lookup("jdbc/myDatasource");
        if (ds == null) {
        throw new RuntimeException("Data source not found!");
        }
        Connection con = ds.getConnection();
      
       
        
        Statement stmt =  null;
        
        try {
            con.createStatement();
            stmt = con.createStatement();
            stmt.execute("USE ece356db_jaurquha;");
            
        } finally {
            if(stmt != null){
                stmt.close();                
            }
        }
        return con;

    }
    
    public UserType validateLogin(String alias, String password) throws Exception{
         Connection con = null;
         CallableStatement stmt = null;
         
         UserType userType = UserType.Invalid;
         
         try{
            con = getConnection();             
           
            stmt = con.prepareCall("{ call ece356db_jaurquha.loginValidation(?, ?)}");
            stmt.setString(1, alias);
            stmt.setString(2, password);           
              
            
            boolean hadResults = stmt.execute();

            ResultSet rs = stmt.getResultSet();

            rs.next();

            
            int ret = rs.getInt("answer");                  
         
             
            if(ret == 1){
                userType = UserType.Doctor;                 
            } else if (ret == 0){
               userType = UserType.Patient;
            }                  
         
         }finally {
             if(stmt != null){
                 stmt.close();
             }
             if(con != null){
                 con.close();
             }
         } 
         return userType;
    }
}
