package co.edu.upc.ips.bll;

import co.edu.upc.ips.dal.CredencialDAO;
import co.edu.upc.ips.dal.PacienteDAO;
import co.edu.upc.ips.entity.Paciente;
import co.edu.upc.ips.util.AppException;
import co.edu.upc.ips.util.Seguridad;
import co.edu.upc.ips.util.Validador;
import java.util.List;

public class PacienteService {
    private final PacienteDAO pacientes = new PacienteDAO();
    private final CredencialDAO credenciales = new CredencialDAO();

    /** Valida los datos, crea el usuario y registra al paciente. */
    public void registrar(Paciente p, String usuario, String clave, String claveConfirmada) {
        Validador.obligatorio(p.getDocumento(), "Documento");
        Validador.maximo(p.getDocumento(), 20, "Documento");
        Validador.obligatorio(p.getPrimerNombre(), "Primer nombre");
        Validador.maximo(p.getPrimerNombre(), 20, "Primer nombre");
        Validador.maximo(p.getSegundoNombre(), 20, "Segundo nombre");
        Validador.obligatorio(p.getPrimerApellido(), "Primer apellido");
        Validador.maximo(p.getPrimerApellido(), 20, "Primer apellido");
        Validador.maximo(p.getSegundoApellido(), 20, "Segundo apellido");
        Validador.maximo(p.getTelefono(), 15, "Teléfono");
        Validador.obligatorio(p.getCorreo(), "Correo");
        Validador.maximo(p.getCorreo(), 50, "Correo");
        Validador.correo(p.getCorreo());
        Validador.maximo(p.getDireccion(), 30, "Dirección");
        Validador.maximo(p.getBarrio(), 30, "Barrio");
        Validador.maximo(p.getCalle(), 30, "Calle");

        if (p.getEdad() < 0 || p.getEdad() > 120) {
            throw new AppException("La edad debe estar entre 0 y 120");
        }
        if (p.getCiudadId() <= 0) {
            throw new AppException("Selecciona una ciudad");
        }
        if (p.getEpsId() <= 0) {
            throw new AppException("Selecciona una EPS");
        }

        Validador.obligatorio(usuario, "Usuario");
        if (usuario.trim().length() < 4 || usuario.trim().length() > 20) {
            throw new AppException("El usuario debe tener entre 4 y 20 caracteres");
        }
        Validador.obligatorio(clave, "Contraseña");
        if (clave.length() < 6) {
            throw new AppException("La contraseña debe tener al menos 6 caracteres");
        }
        if (!clave.equals(claveConfirmada)) {
            throw new AppException("Las contraseñas no coinciden");
        }

        if (pacientes.existe(p.getDocumento().trim())) {
            throw new AppException("Ya existe un paciente con ese documento");
        }
        if (credenciales.existe(usuario.trim())) {
            throw new AppException("El nombre de usuario ya está en uso");
        }

        p.setDocumento(p.getDocumento().trim());
        p.setSegundoNombre(Validador.nulo(p.getSegundoNombre()));
        p.setSegundoApellido(Validador.nulo(p.getSegundoApellido()));
        p.setTelefono(Validador.nulo(p.getTelefono()));
        p.setDireccion(Validador.nulo(p.getDireccion()));
        p.setBarrio(Validador.nulo(p.getBarrio()));
        p.setCalle(Validador.nulo(p.getCalle()));
        p.setDocumentoResponsable(Validador.nulo(p.getDocumentoResponsable()));

        int usuarioId = credenciales.insertar(usuario.trim(), Seguridad.hash(clave), "PACIENTE");
        if (usuarioId <= 0) {
            throw new AppException("No se pudo crear el usuario");
        }
        p.setUsuarioId(usuarioId);

        if (!pacientes.insertar(p)) {
            credenciales.eliminar(usuarioId);
            throw new AppException("No se pudo registrar el paciente. Revisa que los datos sean válidos.");
        }
    }

    public List<Paciente> listar() {
        return pacientes.listar();
    }
}
