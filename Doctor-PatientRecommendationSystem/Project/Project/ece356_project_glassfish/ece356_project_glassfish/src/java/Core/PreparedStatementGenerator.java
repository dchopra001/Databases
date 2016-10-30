package Core;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.ArrayList;

/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 *
 * @author tjia
 */
public class PreparedStatementGenerator{
        ArrayList<Field> _fields = new ArrayList<>();
        public static class Field{
                public String Name;
                public String Value;
                public Field(String name, String value){
                        Name = name;
                        Value = value;
                }
        }
        public void addField(String name, String value){
                if(value != null && !value.isEmpty()){
                        _fields.add(new Field(name, value));
                }
        }
        public PreparedStatement generatePreparedStatement(String baseStatement, Connection con) throws SQLException{
 
 
                if(!_fields.isEmpty()){
 
                        Field[] fields = _fields.toArray(new Field[_fields.size()]);
                        String whereClause = "WHERE " + fields[0].Name + " = ? ";
                        for(int n = 1; n < fields.length; n++){
                                whereClause += " AND " + fields[n].Name + " = ? ";
                        }
 
                        PreparedStatement preparedStatement = con.prepareStatement(baseStatement + " " + whereClause);
                        for(int n = 0; n < fields.length; n++){
                                preparedStatement.setString(n+1, fields[n].Value);
                        }
                       
                        return preparedStatement;
                } else {
                        return con.prepareStatement(baseStatement);
                }
 
        }
    }