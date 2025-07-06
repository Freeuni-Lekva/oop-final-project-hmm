package listener;

import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;
import java.sql.Connection;
//import util.DbUtil; // or wherever your connection code lives

public class AppContextListener implements ServletContextListener
{
    private Connection _connection;

    @Override
    public void contextInitialized(ServletContextEvent e) {
        try
        {
            System.out.println("Initializing DB connection...");
            //_connection = DbUtil.getConnection(); //
            e.getServletContext().setAttribute("DBConnection", _connection);
        }
        catch (Exception ex)
        {
            ex.printStackTrace();
            throw new RuntimeException("Failed to connect to DB");
        }
    }

    @Override
    public void contextDestroyed(ServletContextEvent e)
    {
        try
        {
            System.out.println("Closing DB connection...");
            _connection.close();
        }
        catch (Exception ex)
        {
            ex.printStackTrace();
        }
    }
}
