/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package DTO;

import java.util.ArrayList;

/**
 *
 * @author tjia
 */
public class Doctor{
    public String Alias;
    public Name Name;
    public String Gender;
    public ArrayList<WorkAddress> WorkAddressList;
    public ArrayList<String> SpecializationList;
    public int NumYearsLicensed;
    public double AvgStarRating;
    public int NumReview;
    public String Email;
    
    public Doctor(String alias, Name name, String gender, ArrayList<WorkAddress> workAddressList, ArrayList<String> specializationList, int numYearsLicensed, double avgStarRating, int numReview, String email) {
        this.Alias = alias;
        this.Name = name;
        this.Gender = gender;
        this.WorkAddressList = workAddressList;
        this.SpecializationList = specializationList;
        this.NumYearsLicensed = numYearsLicensed;
        this.AvgStarRating = avgStarRating;
        this.NumReview = numReview;
        this.Email = email;
    }
}
