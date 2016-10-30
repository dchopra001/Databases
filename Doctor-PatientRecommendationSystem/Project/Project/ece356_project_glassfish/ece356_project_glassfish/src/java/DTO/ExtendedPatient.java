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
public class ExtendedPatient {

    public String Alias;
    public String HomeAddress;
    public int NumReviews;
    public Date DateLastReview;
    public int IsFriend;

    public ExtendedPatient(String alias, String homeAddress, int numReviews, Date dateLastReview, int isFriend) {
        this.Alias = alias;
        this.IsFriend = isFriend;
        this.HomeAddress = homeAddress;
        this.NumReviews = numReviews;
        this.DateLastReview = dateLastReview;
    }
}
