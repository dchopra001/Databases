/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package DTO;

/**
 *
 * @author tjia
 */
public class WorkAddress {
    
    public String Province;
    public String City;
    public String PostalCode;
    public String StreetName;
    public String StreetNumber;
    public String AptNumber;

    public WorkAddress(String province, String city, String postalCode, String streetName, String streetNumber, String aptNumber){
        Province = province; 
        City = city;
        PostalCode = postalCode;
        StreetName = streetName;
        StreetNumber = streetNumber;
        AptNumber = aptNumber;
    }
}
