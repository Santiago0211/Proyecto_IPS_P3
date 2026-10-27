package co.edu.upc.ips.dal;

import co.edu.upc.ips.util.AppException;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

/** Abre conexiones a Oracle leyendo config.properties (carpeta del proyecto). */
public final class Conexion {
    private static Properties props;

    private Conexion() { }

    private static synchronized Properties cargar() {
        if (props == null) {
            Properties p = new Properties();
            p.setProperty("db.url", "jdbc:oracle:thin:@//localhost:1521/XEPDB1");
            p.setProperty("db.user", "admin_ips");
            p.setProperty("db.password", "");
            File f = new File("config.properties");
            if (!f.exists()) {
                throw new AppException("No se encontró el archivo config.properties en:\n"
                        + f.getAbsolutePath() + "\nDebe estar en la carpeta principal del proyecto.");
            }
            try (InputStream in = new FileInputStream(f)) {
                p.load(in);
            } catch (IOException e) {
                throw new AppException("No se pudo leer config.properties", e);
            }
            props = p;
        }
        return props;
    }

    public static Connection obtener() {
        Properties p = cargar();
        try {
            return DriverManager.getConnection(
                    p.getProperty("db.url").trim(),
                    p.getProperty("db.user").trim(),
                    p.getProperty("db.password").trim());
        } catch (SQLException e) {
            throw new AppException("No se pudo conectar a Oracle. Revisa que la base de datos esté encendida "
                    + "y que config.properties tenga el usuario y la clave correctos.\nDetalle: " + e.getMessage(), e);
        }
    }

    /** Convierte un SQLException en un AppException con mensaje claro. */
    public static AppException error(String accion, SQLException e) {
        return new AppException("Error al " + accion + ": " + e.getMessage(), e);
    }
}
