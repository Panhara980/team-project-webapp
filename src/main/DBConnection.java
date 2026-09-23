package com.notes.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {

    // ── Configure these three values for your environment ──
	private static final String URL =
		    "jdbc:mysql://localhost:3306/notes_system?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";
    private static final String USERNAME = "root";
    private static final String PASSWORD = "newpassword123"; // <-- change this

    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new RuntimeException(
                "MySQL JDBC driver not found on the classpath. " +
                "Check that mysql-connector-j-*.jar is in WEB-INF/lib.", e);
        }
    }

    private DBConnection() {
        // utility class — no instances
    }

    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USERNAME, PASSWORD);
    }
}