package co.edu.upc.ips.dal;

import co.edu.upc.ips.entity.Doctor;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;

public class DoctorDAO {

    private static final String SELECT =
            "SELECT d.*, e.nombre AS esp_nombre FROM s_doctores d "
            + "LEFT JOIN s_especialidades e ON e.especialidad_id = d.especialidad_id ";

    public boolean insertar(Doctor d) {
        String sql = "{call pkg_doctor.SP_INSERTAR_DOCTOR(?,?,?,?,?,?,?,?,?,?,?,?)}";
        try (Connection c = Conexion.obtener(); CallableStatement cs = c.prepareCall(sql)) {
            cs.setString(1, d.getDocumento());
            cs.setString(2, d.getNumeroLicencia());
            cs.setString(3, d.getPrimerNombre());
            cs.setString(4, d.getSegundoNombre());
            cs.setString(5, d.getPrimerApellido());
            cs.setString(6, d.getSegundoApellido());
            cs.setString(7, d.getTelefono());
            cs.setString(8, d.getCorreo());
            cs.setInt(9, d.getEspecialidadId());
            cs.setString(10, d.getHoraAtencion());
            cs.setInt(11, d.getUsuarioId());
            cs.registerOutParameter(12, Types.NUMERIC);
            cs.execute();
            return cs.getInt(12) == 1;
        } catch (SQLException e) {
            throw Conexion.error("registrar el doctor", e);
        }
    }

    public boolean existe(String documento) {
        return porDocumento(documento) != null;
    }

    public Doctor porUsuarioId(int usuarioId) {
        return uno(SELECT + "WHERE d.usuario_id = ?", String.valueOf(usuarioId));
    }

    public Doctor porDocumento(String documento) {
        return uno(SELECT + "WHERE d.documentoid = ?", documento);
    }

    public List<Doctor> listar() {
        return lista(SELECT + "ORDER BY d.primer_apellido, d.primer_nombre", null);
    }

    public List<Doctor> porEspecialidad(int especialidadId) {
        return lista(SELECT + "WHERE d.especialidad_id = ? ORDER BY d.primer_apellido, d.primer_nombre",
                String.valueOf(especialidadId));
    }

    private Doctor uno(String sql, String parametro) {
        List<Doctor> l = lista(sql, parametro);
        return l.isEmpty() ? null : l.get(0);
    }

    private List<Doctor> lista(String sql, String parametro) {
        List<Doctor> lista = new ArrayList<>();
        try (Connection c = Conexion.obtener(); PreparedStatement ps = c.prepareStatement(sql)) {
            if (parametro != null) {
                ps.setString(1, parametro);
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Doctor d = new Doctor();
                    d.setDocumento(rs.getString("documentoid"));
                    d.setNumeroLicencia(rs.getString("numero_licencia"));
                    d.setPrimerNombre(rs.getString("primer_nombre"));
                    d.setSegundoNombre(rs.getString("segundo_nombre"));
                    d.setPrimerApellido(rs.getString("primer_apellido"));
                    d.setSegundoApellido(rs.getString("segundo_apellido"));
                    d.setTelefono(rs.getString("telefono"));
                    d.setCorreo(rs.getString("correo"));
                    d.setEspecialidadId(rs.getInt("especialidad_id"));
                    d.setEspecialidadNombre(rs.getString("esp_nombre"));
                    d.setHoraAtencion(rs.getString("horaatencion"));
                    d.setUsuarioId(rs.getInt("usuario_id"));
                    lista.add(d);
                }
            }
        } catch (SQLException e) {
            throw Conexion.error("consultar los doctores", e);
        }
        return lista;
    }
}
