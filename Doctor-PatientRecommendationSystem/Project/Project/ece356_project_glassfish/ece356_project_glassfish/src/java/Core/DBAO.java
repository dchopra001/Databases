/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 *
 * @author tjia
 */
package Core;

import DTO.DoctorProfileFull;
import DTO.DoctorResult;
import DTO.ExtendedPatient;
import DTO.FriendRequest;
import DTO.Review;
import java.util.ArrayList;

public interface DBAO {
    UserType validateLogin(String alias, String password) throws Exception;
   

    ArrayList<ExtendedPatient> searchPatientProfile(String alias, String province, String city, String searcherAlias) throws Exception;
    
   
    
    FriendRequestResult patientRequestFriend(String alias_a, String alias_b) throws Exception;
    
    ArrayList<FriendRequest> fetchFriendRequest(String alias) throws Exception;
    
    
    
    
    ArrayList<DoctorResult> searchDoctorProfile(String patientAlias, String firstName, String middleName, String lastName, String gender,
                                          String province, String city, String street, String streetNumber, String apartmentNumber, String postalCode,
                                          String specialization, int numYearsLicensed, double avgStarRating, int reviewedByFriend, String reviewKeyword) throws Exception;
    
    DoctorProfileFull getDoctorProfileFull(String alias) throws Exception;
    
    void addReview(String userAlias, String doctorAlias, String text, double rating) throws Exception;
    
    Review fetchFullReview(int reviewId) throws Exception;
    
    ArrayList<String> fetchSpecialization() throws Exception;
    
     
    public enum UserType{
        Patient,
        Doctor,
        Invalid    
    }
    public enum FriendRequestResult{
        AlreadyFriends,
        AlreadyRequested,
        NewRequestAdded,
        NewFriendshipFormed,
        InvalidState
    }
}
