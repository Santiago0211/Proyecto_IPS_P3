package co.edu.upc.ips.bll;

import co.edu.upc.ips.dal.CitaDAO;
import co.edu.upc.ips.dal.DoctorDAO;
import co.edu.upc.ips.dal.PacienteDAO;
import co.edu.upc.ips.entity.Cita;
import co.edu.upc.ips.entity.Doctor;
import co.edu.upc.ips.util.AppException;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Set;

/** Reglas de negocio de las citas (portadas de ServicioCita.cs). */
public class CitaService {
    public static final String PENDIENTE = "Pendiente";
    public static final String COMPLETADA = "Completada";
    public static final String CANCELADA = "Cancelada";

    private final CitaDAO citas = new CitaDAO();
    private final DoctorDAO doctores = new DoctorDAO();
    private final PacienteDAO pacientes = new PacienteDAO();

    public void agendar(Cita c) {
        if (c.getPacienteDoc() == null || c.getPacienteDoc().trim().isEmpty()) {
            throw new AppException("El documento del paciente es obligatorio");
        }
        if (!pacientes.existe(c.getPacienteDoc())) {
            throw new AppException("El paciente no existe en el sistema");
        }
        if (c.getDoctorDoc() == null || c.getDoctorDoc().trim().isEmpty()) {
            throw new AppException("Debe seleccionar un doctor");
        }
        Doctor doctor = doctores.porDocumento(c.getDoctorDoc());
        if (doctor == null) {
            throw new AppException("El doctor no existe en el sistema");
        }
        if (c.getEspecialidadId() <= 0) {
            throw new AppException("Debe seleccionar una especialidad");
        }
        if (c.getFecha() == null) {
            throw new AppException("Debe seleccionar una fecha");
        }
        if (c.getFecha().isBefore(LocalDate.now())) {
            throw new AppException("No se pueden agendar citas en fechas pasadas");
        }
        if (c.getHora() == null || c.getHora().trim().isEmpty()) {
            throw new AppException("Debe seleccionar una hora");
        }
        if (!doctor.getHoras().contains(c.getHora())) {
            throw new AppException("El doctor no atiende a esa hora");
        }
        if (c.getFecha().isEqual(LocalDate.now()) && !LocalTime.parse(c.getHora()).isAfter(LocalTime.now())) {
            throw new AppException("Esa hora ya pasó, selecciona una hora posterior");
        }
        if (citas.doctorOcupado(c.getDoctorDoc(), c.getFecha(), c.getHora())) {
            throw new AppException("El doctor ya tiene una cita agendada en ese horario");
        }
        if (citas.pacienteOcupado(c.getPacienteDoc(), c.getFecha(), c.getHora())) {
            throw new AppException("Ya tienes una cita agendada a esa hora, por favor selecciona una hora o fecha distinta");
        }
        if (c.getEstado() == null || c.getEstado().isEmpty()) {
            c.setEstado(PENDIENTE);
        }
        if (!citas.insertar(c)) {
            throw new AppException("No se pudo agendar la cita");
        }
    }

    /** Horas del doctor que todavia estan libres en esa fecha. */
    public List<String> horasDisponibles(Doctor doctor, LocalDate fecha) {
        List<String> libres = new ArrayList<>();
        if (doctor == null || fecha == null) {
            return libres;
        }
        Set<String> ocupadas = citas.horasOcupadas(doctor.getDocumento(), fecha);
        boolean hoy = fecha.isEqual(LocalDate.now());
        for (String h : doctor.getHoras()) {
            if (ocupadas.contains(h)) {
                continue;
            }
            if (hoy && !LocalTime.parse(h).isAfter(LocalTime.now())) {
                continue;
            }
            libres.add(h);
        }
        return libres;
    }

    public void cancelar(int citaId) {
        Cita c = existente(citaId);
        if (CANCELADA.equals(c.getEstado())) {
            throw new AppException("La cita ya está cancelada");
        }
        if (COMPLETADA.equals(c.getEstado())) {
            throw new AppException("No se puede cancelar una cita completada");
        }
        cambiar(citaId, CANCELADA);
    }

    public void completar(int citaId) {
        Cita c = existente(citaId);
        if (CANCELADA.equals(c.getEstado())) {
            throw new AppException("No se puede completar una cita cancelada");
        }
        if (COMPLETADA.equals(c.getEstado())) {
            throw new AppException("La cita ya está completada");
        }
        cambiar(citaId, COMPLETADA);
    }

    public void reactivar(int citaId) {
        Cita c = existente(citaId);
        if (PENDIENTE.equals(c.getEstado())) {
            throw new AppException("La cita ya está activa");
        }
        if (citas.doctorOcupado(c.getDoctorDoc(), c.getFecha(), c.getHora())) {
            throw new AppException("El horario ya no está disponible");
        }
        cambiar(citaId, PENDIENTE);
    }

    private Cita existente(int citaId) {
        Cita c = citas.porId(citaId);
        if (c == null) {
            throw new AppException("La cita no existe");
        }
        return c;
    }

    private void cambiar(int citaId, String estado) {
        if (!citas.cambiarEstado(citaId, estado)) {
            throw new AppException("No se pudo actualizar la cita");
        }
    }

    public List<Cita> porPaciente(String documento) {
        return citas.porPaciente(documento);
    }

    public List<Cita> porDoctor(String documento) {
        return citas.porDoctor(documento);
    }

    public List<Cita> todas() {
        return citas.todas();
    }
}
