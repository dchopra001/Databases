/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package DTO;

import java.util.ArrayList;


public class DoctorProfileFull{
    public Doctor Doctor;
    public ArrayList<Integer> ReviewIDList;
    
    public DoctorProfileFull(Doctor doctor, ArrayList<Integer> reviewIDList){
        Doctor = doctor;
        ReviewIDList = reviewIDList;
    }   

}


