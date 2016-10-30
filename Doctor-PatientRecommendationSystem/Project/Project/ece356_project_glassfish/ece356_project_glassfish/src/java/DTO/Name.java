/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package DTO;

/**
 *
 * @author tjia
 */
public class Name {
    public String FirstName;
    public String MiddleName;
    public String LastName;
    
    public Name(String firstName, String middleName, String lastName){
        FirstName = firstName;
        MiddleName = middleName;
        LastName = lastName;    
    }
    
    public String getFullName(){
        String s = "";
        if(FirstName != null && FirstName != ""){
            s += FirstName;
        }
        if(MiddleName != null && MiddleName != ""){
            s += " " + MiddleName;
        }
        if(LastName != null && LastName != ""){
            s += " " + LastName;
        }
        
        return s;
    
    }
}
