/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package DTO;


/**
 *
 * @author tjia
 */
public class DoctorResult{
    public String Alias;
    public Name Name;
    public String Gender;
    public Double AvgStarRating;
    public int NumReview;
    
    public DoctorResult(String alias, Name name, String gender, Double avgStarRating, int numReview) {
        this.Alias = alias;
        this.Name = name;
        this.Gender = gender;
        this.AvgStarRating = avgStarRating;
        this.NumReview = numReview;
    }
}
