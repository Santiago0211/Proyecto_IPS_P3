package co.edu.upc.ips.util;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

public final class Seguridad {
    private Seguridad() { }

    /** SHA-256 en hexadecimal mayuscula, igual que el HashPassword del proyecto original en C#. */
    public static String hash(String texto) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] bytes = md.digest(texto.getBytes(StandardCharsets.UTF_8));
            StringBuilder sb = new StringBuilder();
            for (byte b : bytes) {
                sb.append(String.format("%02X", b));
            }
            return sb.toString();
        } catch (NoSuchAlgorithmException e) {
            throw new AppException("No se pudo calcular el hash de la contraseña", e);
        }
    }
}
