/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 *
 * @author tjia
 */
package Core;
/*
import DTO.Doctor;
import DTO.DoctorProfileFull;
import DTO.ExtendedPatient;
import DTO.Name;

import DTO.Review;
import DTO.WorkAddress;
import java.util.ArrayList;

public class DBAOFake implements DBAO {

    @Override
    public ArrayList<ExtendedPatient> searchPatientProfile(String alias, String province, String city) throws Exception {
        throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }

    @Override
    public FriendRequestResult patientRequestFriend(String alias_a, String alias_b) throws Exception {
        throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }

    @Override
    public void addReview(String userAlias, String title, double rating, String text) throws Exception {
        throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }

    @Override
    public ArrayList<Review> fetchFullReviews() {
        throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }

  
    public void patientAcceptFriend(String alias_a, String alias_b) throws Exception {
        throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }

  

    public ArrayList<Doctor> searchDoctorProfile(String firstName, String middleName, String lastName, String gender, String province, String city, String street, String streetNumber, String apartmentNumber, String postalCode, String specialization, int numYearsLicensed, double avgStarRating, int numReview) throws Exception {
        throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }

   
    public DoctorProfileFull getDoctorProfileFull(String alias) throws Exception {
       
           Name name = new Name("Dis", "le", "Sigh");
            
            ArrayList<WorkAddress> workAddressList = new ArrayList<>();
            workAddressList.add(new WorkAddress("Ontario", "Waterloo", "K2Y9S", "King", "123", "1112"));
            workAddressList.add(new WorkAddress("Ontario", "Waterloo", "K2Y9S", "University", "232", "1411"));
            
            ArrayList<String> specializationList = new ArrayList<>();
            specializationList.add("Heart");
            specializationList.add("Brain");
            
            Doctor doctor = 
                    new Doctor("doc_bizarro",name, "male", workAddressList, specializationList, 10, 2.4, 5, "trololo@uwaterloo.ca");
            
            // TODO: get from database
            ArrayList<Review> reviewList = new ArrayList<>();
            reviewList.add(new Review(1,"This doctor sucks!", 5, "bambam"));
            reviewList.add(new Review(2,"He killed my turtle!", 5, "bambam"));
            reviewList.add(new Review(3,"OMG BEST DOCTOR EVA!", 1, "bambam"));
            
            return new DoctorProfileFull(doctor, reviewList);
        
    }
    public UserType validateLogin(String alias, String password){
        if("doc_aiken".equals(alias)){
           return UserType.Doctor;
        } else if("bullshit".equals(alias)){
            return UserType.Invalid;
        
        } else {
        
            return UserType.Patient;
        }
    }
}
*/