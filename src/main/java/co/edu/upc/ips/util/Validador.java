package co.edu.upc.ips.util;

import java.util.regex.Pattern;

public final class Validador {
    private static final Pattern CORREO =
            Pattern.compile("^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$");

    private Validador() { }

    public static boolean vacio(String s) {
        return s == null || s.trim().isEmpty();
    }

    public static void obligatorio(String valor, String campo) {
        if (vacio(valor)) {
            throw new AppException("El campo \"" + campo + "\" es obligatorio");
        }
    }

    public static void maximo(String valor, int max, String campo) {
        if (valor != null && valor.trim().length() > max) {
            throw new AppException("El campo \"" + campo + "\" no puede tener más de " + max + " caracteres");
        }
    }

    public static void correo(String valor) {
        if (!vacio(valor) && !CORREO.matcher(valor.trim()).matches()) {
            throw new AppException("El correo electrónico no tiene un formato válido");
        }
    }

    /** Devuelve null si el texto esta vacio, para guardar NULL en la base de datos. */
    public static String nulo(String s) {
        return vacio(s) ? null : s.trim();
    }
}
