    package Connections;


    import java.sql.Connection;
    import java.sql.DriverManager;
    import java.sql.SQLException;

    /*
     *
     * @author Gabriel Medina
     */public class MyConnection {
        private static final String URL="jdbc:mysql://localhost/AED";
        private static final String URLP = "jdbc:postgresql://localhost:5432/aed?characterEncoding=UTF-8";
        private static final String USERP = "postgres";
        private static final String USER="root";
        private static final String PASSWORD="root1234";
        private Connection con;

        public MyConnection(){
            try{
                Class.forName("com.mysql.cj.jdbc.Driver");
                //Class.forName("org.postgresql.Driver");

                con = DriverManager.getConnection(URL,USER,PASSWORD);
            }catch(ClassNotFoundException ex){
                System.out.println("Error al cargar el driver " + ex);
            }catch(SQLException se){
                System.out.println("Error de SQL "+se);
            }
        }

        public Connection getConnection(){
            return con;
        }
    }
