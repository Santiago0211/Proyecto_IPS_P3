package co.edu.upc.ips.dal;

import co.edu.upc.ips.entity.Cita;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

public class CitaDAO {

    private static final String SELECT =
            "SELECT c.cita_id, c.paciente_documentoid, c.doctor_documentoid, c.fecha, c.hora, c.estado, "
            + "c.especialidad_id, "
            + "p.primer_nombre || ' ' || p.primer_apellido AS pac_nombre, "
            + "d.primer_nombre || ' ' || d.primer_apellido AS doc_nombre, "
            + "e.nombre AS esp_nombre "
            + "FROM s_citas c "
            + "JOIN s_pacientes p ON p.documentoid = c.paciente_documentoid "
            + "JOIN s_doctores d ON d.documentoid = c.doctor_documentoid "
            + "LEFT JOIN s_especialidades e ON e.especialidad_id = c.especialidad_id ";

    private static final String ORDEN = " ORDER BY c.fecha DESC, c.hora DESC";

    public boolean insertar(Cita cita) {
        String sql = "{call pkg_cita.SP_INSERTAR_CITA(?, ?, ?, ?, ?, ?, ?)}";
        try (Connection c = Conexion.obtener(); CallableStatement cs = c.prepareCall(sql)) {
            cs.setString(1, cita.getPacienteDoc());
            cs.setString(2, cita.getDoctorDoc());
            cs.setDate(3, Date.valueOf(cita.getFecha()));
            cs.setString(4, cita.getHora());
            cs.setString(5, cita.getEstado());
            cs.setInt(6, cita.getEspecialidadId());
            cs.registerOutParameter(7, Types.NUMERIC);
            cs.execute();
            return cs.getInt(7) == 1;
        } catch (SQLException e) {
            throw Conexion.error("agendar la cita", e);
        }
    }

    public boolean cambiarEstado(int citaId, String estado) {
        String sql = "{call pkg_cita.SP_CAMBIAR_ESTADO_CITA(?, ?, ?)}";
        try (Connection c = Conexion.obtener(); CallableStatement cs = c.prepareCall(sql)) {
            cs.setInt(1, citaId);
            cs.setString(2, estado);
            cs.registerOutParameter(3, Types.NUMERIC);
            cs.execute();
            return cs.getInt(3) == 1;
        } catch (SQLException e) {
            throw Conexion.error("cambiar el estado de la cita", e);
        }
    }

    public boolean doctorOcupado(String doctorDoc, LocalDate fecha, String hora) {
        return funcion("SELECT pkg_cita.FN_EXISTE_CITA_HORARIO(?, ?, ?) FROM DUAL", doctorDoc, fecha, hora);
    }

    public boolean pacienteOcupado(String pacienteDoc, LocalDate fecha, String hora) {
        return funcion("SELECT pkg_cita.FN_EXISTE_CITA_PACIENTE(?, ?, ?) FROM DUAL", pacienteDoc, fecha, hora);
    }

    private boolean funcion(String sql, String doc, LocalDate fecha, String hora) {
        try (Connection c = Conexion.obtener(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, doc);
            ps.setDate(2, Date.valueOf(fecha));
            ps.setString(3, hora);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() && rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            throw Conexion.error("verificar la disponibilidad", e);
        }
    }

    /** Horas ya tomadas por el doctor en esa fecha (sin contar las canceladas). */
    public Set<String> horasOcupadas(String doctorDoc, LocalDate fecha) {
        String sql = "SELECT hora FROM s_citas WHERE doctor_documentoid = ? "
                + "AND TRUNC(fecha) = ? AND estado <> 'Cancelada'";
        Set<String> horas = new HashSet<>();
        try (Connection c = Conexion.obtener(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, doctorDoc);
            ps.setDate(2, Date.valueOf(fecha));
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    horas.add(rs.getString(1));
                }
            }
        } catch (SQLException e) {
            throw Conexion.error("consultar las horas ocupadas", e);
        }
        return horas;
    }

    public Cita porId(int id) {
        List<Cita> l = lista(SELECT + "WHERE c.cita_id = ?", String.valueOf(id));
        return l.isEmpty() ? null : l.get(0);
    }

    public List<Cita> porPaciente(String documento) {
        return lista(SELECT + "WHERE c.paciente_documentoid = ?" + ORDEN, documento);
    }

    public List<Cita> porDoctor(String documento) {
        return lista(SELECT + "WHERE c.doctor_documentoid = ?" + ORDEN, documento);
    }

    public List<Cita> todas() {
        return lista(SELECT + ORDEN, null);
    }

    private List<Cita> lista(String sql, String parametro) {
        List<Cita> lista = new ArrayList<>();
        try (Connection c = Conexion.obtener(); PreparedStatement ps = c.prepareStatement(sql)) {
            if (parametro != null) {
                ps.setString(1, parametro);
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Cita ci = new Cita();
                    ci.setId(rs.getInt("cita_id"));
                    ci.setPacienteDoc(rs.getString("paciente_documentoid"));
                    ci.setDoctorDoc(rs.getString("doctor_documentoid"));
                    ci.setFecha(rs.getDate("fecha").toLocalDate());
                    ci.setHora(rs.getString("hora"));
                    ci.setEstado(rs.getString("estado"));
                    ci.setEspecialidadId(rs.getInt("especialidad_id"));
                    ci.setPacienteNombre(rs.getString("pac_nombre"));
                    ci.setDoctorNombre(rs.getString("doc_nombre"));
                    ci.setEspecialidadNombre(rs.getString("esp_nombre"));
                    lista.add(ci);
                }
            }
        } catch (SQLException e) {
            throw Conexion.error("consultar las citas", e);
        }
        return lista;
    }
}
