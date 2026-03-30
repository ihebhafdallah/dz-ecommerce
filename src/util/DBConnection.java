package util;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBConnection {

    public static Connection getConnection() {
        try {
            String url = "jdbc:sqlserver://localhost:1433;databaseName=DZ_Ecommerce";
            String user = "sa";
            String password = "ab123456789";
            
            url = url + ";encrypt=true;trustServerCertificate=true";

            return DriverManager.getConnection(url, user, password);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
}