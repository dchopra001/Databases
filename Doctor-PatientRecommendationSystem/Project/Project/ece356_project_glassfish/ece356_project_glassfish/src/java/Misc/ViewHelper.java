/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Misc;

/**
 *
 * @author tjia
 */
public class ViewHelper {
    public static String StarReviewAsString(double starRating){
        
            return  Double.toString(starRating);
        /*
          String result = "";
            if(starRating < 1){
                result = "";        
            } else if(starRating < 2){
                result = "*";
            }else if(starRating < 3){
                result = "**";
            }
            else if(starRating < 4){
                result = "***";
            }
            else if(starRating < 5){
                result = "****";
            } else {
                result = "*****";        
            }        

            return result;
            */ 
            
    }
}
