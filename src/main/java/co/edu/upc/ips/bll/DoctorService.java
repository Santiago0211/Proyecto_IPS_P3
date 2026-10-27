package co.edu.upc.ips.bll;

import co.edu.upc.ips.dal.CredencialDAO;
import co.edu.upc.ips.dal.DoctorDAO;
import co.edu.upc.ips.entity.Doctor;
import co.edu.upc.ips.util.AppException;
import co.edu.upc.ips.util.Seguridad;
import co.edu.upc.ips.util.Validador;
import java.util.List;

public class DoctorService {
    public static final String JORNADA_MANANA = "Mañana (06:00 - 11:40)";
    public static final String JORNADA_TARDE = "Tarde (14:00 - 21:40)";

    private final DoctorDAO doctores = new DoctorDAO();
    private final CredencialDAO credenciales = new CredencialDAO();

    public void registrar(Doctor d, String usuario, String clave, String jornada) {
        Validador.obligatorio(d.getDocumento(), "Documento");
        Validador.maximo(d.getDocumento(), 20, "Documento");
        Validador.obligatorio(d.getNumeroLicencia(), "Número de licencia");
        Validador.maximo(d.getNumeroLicencia(), 15, "Número de licencia");
        Validador.obligatorio(d.getPrimerNombre(), "Primer nombre");
        Validador.maximo(d.getPrimerNombre(), 20, "Primer nombre");
        Validador.maximo(d.getSegundoNombre(), 20, "Segundo nombre");
        Validador.obligatorio(d.getPrimerApellido(), "Primer apellido");
        Validador.maximo(d.getPrimerApellido(), 20, "Primer apellido");
        Validador.maximo(d.getSegundoApellido(), 20, "Segundo apellido");
        Validador.maximo(d.getTelefono(), 15, "Teléfono");
        Validador.obligatorio(d.getCorreo(), "Correo");
        Validador.maximo(d.getCorreo(), 50, "Correo");
        Validador.correo(d.getCorreo());
        if (d.getEspecialidadId() <= 0) {
            throw new AppException("Selecciona una especialidad");
        }
        Validador.obligatorio(usuario, "Usuario");
        if (usuario.trim().length() < 4 || usuario.trim().length() > 20) {
            throw new AppException("El usuario debe tener entre 4 y 20 caracteres");
        }
        Validador.obligatorio(clave, "Contraseña");
        if (clave.length() < 6) {
            throw new AppException("La contraseña debe tener al menos 6 caracteres");
        }
        if (doctores.existe(d.getDocumento().trim())) {
            throw new AppException("Ya existe un doctor con ese documento");
        }
        if (credenciales.existe(usuario.trim())) {
            throw new AppException("El nombre de usuario ya está en uso");
        }

        d.setDocumento(d.getDocumento().trim());
        d.setSegundoNombre(Validador.nulo(d.getSegundoNombre()));
        d.setSegundoApellido(Validador.nulo(d.getSegundoApellido()));
        d.setTelefono(Validador.nulo(d.getTelefono()));
        d.setHoraAtencion(JORNADA_TARDE.equals(jornada) ? horario(14, 21) : horario(6, 11));

        int usuarioId = credenciales.insertar(usuario.trim(), Seguridad.hash(clave), "DOCTOR");
        if (usuarioId <= 0) {
            throw new AppException("No se pudo crear el usuario");
        }
        d.setUsuarioId(usuarioId);

        if (!doctores.insertar(d)) {
            credenciales.eliminar(usuarioId);
            throw new AppException("No se pudo registrar el doctor. Revisa que los datos sean válidos.");
        }
    }

    /** Genera las horas cada 20 minutos entre horaInicio:00 y horaFin:40 (ej. 6 a 11 -> 06:00 ... 11:40). */
    static String horario(int horaInicio, int horaFin) {
        StringBuilder sb = new StringBuilder();
        for (int h = horaInicio; h <= horaFin; h++) {
            for (int m = 0; m < 60; m += 20) {
                if (sb.length() > 0) {
                    sb.append(',');
                }
                sb.append(String.format("%02d:%02d", h, m));
            }
        }
        return sb.toString();
    }

    public List<Doctor> listar() {
        return doctores.listar();
    }

    public List<Doctor> porEspecialidad(int especialidadId) {
        return doctores.porEspecialidad(especialidadId);
    }
}
