/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 *
 * @author tjia
 */
package Core;

public class DBAOSingleton {
    private static DBAO _instance;
    public static DBAO getInstance(){
        if(_instance == null){
            _instance = new DBAOImpl();        
        }
        return _instance;
    }
}
