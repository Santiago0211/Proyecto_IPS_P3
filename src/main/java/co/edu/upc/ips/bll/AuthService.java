package co.edu.upc.ips.bll;

import co.edu.upc.ips.dal.CredencialDAO;
import co.edu.upc.ips.dal.DoctorDAO;
import co.edu.upc.ips.dal.PacienteDAO;
import co.edu.upc.ips.entity.Doctor;
import co.edu.upc.ips.entity.Paciente;
import co.edu.upc.ips.entity.Sesion;
import co.edu.upc.ips.util.AppException;
import co.edu.upc.ips.util.Seguridad;
import co.edu.upc.ips.util.Validador;

public class AuthService {
    private final CredencialDAO credenciales = new CredencialDAO();
    private final PacienteDAO pacientes = new PacienteDAO();
    private final DoctorDAO doctores = new DoctorDAO();

    public Sesion login(String usuario, String clave) {
        Validador.obligatorio(usuario, "Usuario");
        Validador.obligatorio(clave, "Contraseña");
        String u = usuario.trim();

        if (!credenciales.verificar(u, Seguridad.hash(clave))) {
            throw new AppException("Usuario o contraseña incorrectos, o la cuenta está inactiva");
        }

        Sesion s = new Sesion();
        s.setUsername(u);
        s.setTipo(String.valueOf(credenciales.tipoUsuario(u)).toUpperCase());
        s.setUsuarioId(credenciales.idUsuario(u));

        if (s.esPaciente()) {
            Paciente p = pacientes.porUsuarioId(s.getUsuarioId());
            if (p == null) {
                throw new AppException("Tu usuario no tiene un perfil de paciente asociado");
            }
            s.setDocumento(p.getDocumento());
            s.setNombre(p.getNombreCompleto());
        } else if (s.esDoctor()) {
            Doctor d = doctores.porUsuarioId(s.getUsuarioId());
            if (d == null) {
                throw new AppException("Tu usuario no tiene un perfil de doctor asociado");
            }
            s.setDocumento(d.getDocumento());
            s.setNombre("Dr(a). " + d.getNombreCompleto());
        } else if (s.esAdmin()) {
            s.setNombre("Administrador");
        } else {
            throw new AppException("Tipo de usuario no reconocido: " + s.getTipo());
        }
        return s;
    }
}
