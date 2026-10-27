package co.edu.upc.ips.util;

/** Error de negocio o de base de datos con un mensaje listo para mostrar al usuario. */
public class AppException extends RuntimeException {
    public AppException(String mensaje) {
        super(mensaje);
    }

    public AppException(String mensaje, Throwable causa) {
        super(mensaje, causa);
    }
}
