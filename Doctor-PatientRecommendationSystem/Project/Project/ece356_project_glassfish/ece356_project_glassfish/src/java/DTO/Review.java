/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package DTO;

import java.util.Date;

/**
 *
 * @author tjia
 */
public class Review {
    
    public String DoctorAlias;
    public Name DoctorName;
    public double StarRating;
    public String Comments;
    public Date ReviewDate;
    public int Id;
    public int PrevId;
    public int NextId;
    
    public Review(String doctorAlias, Name doctorName, double starRating,  String comments, Date reviewDate, int id, int prevId, int nextId){
        DoctorAlias = doctorAlias;
        
        ReviewDate = reviewDate;
        DoctorName = doctorName;
        StarRating = starRating;
        Comments = comments;
        Id = id;
        PrevId = prevId;
        NextId = nextId;
    }
}
