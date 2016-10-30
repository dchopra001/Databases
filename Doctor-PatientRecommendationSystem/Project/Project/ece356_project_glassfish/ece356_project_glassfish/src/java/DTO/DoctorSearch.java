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
public class DoctorSearch{
    
    public Name Name;
    public String Gender;
    public String Province;
    public String City;
    public String Street;
    public String StreetNumber;
    public String ApartmentNumber;
    public String PostalCode;
    public String Specialization;
    public int NumYearsLicensed;
    public Double AvgStarRating;
    public boolean ReviewByFriend;
    public String Keyword;
    
    public DoctorSearch(Name name, String gender, String province, String city, String street,
            String streetNumber, String apartmentNumber, String postalCode, String specialization,
            int numYearsLicensed, Double avgStarRating, boolean reviewByFriend, String keyword) {
        this.Name = name;
        this.Gender = gender;
        this.Province = province;
        this.City = city;
        this.Street = street;
        this.StreetNumber = streetNumber;
        this.ApartmentNumber = apartmentNumber;
        this.PostalCode = postalCode;
        this.Specialization = specialization;
        this.NumYearsLicensed = numYearsLicensed;
        this.AvgStarRating = avgStarRating;
        this.ReviewByFriend = reviewByFriend;
        this.Keyword = keyword;
    }
}
