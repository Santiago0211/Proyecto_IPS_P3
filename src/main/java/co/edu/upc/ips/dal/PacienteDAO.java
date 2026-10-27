package co.edu.upc.ips.dal;

import co.edu.upc.ips.entity.Paciente;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;

public class PacienteDAO {

    public boolean insertar(Paciente p) {
        String sql = "{call pkg_paciente.SP_INSERTAR_PACIENTE(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)}";
        try (Connection c = Conexion.obtener(); CallableStatement cs = c.prepareCall(sql)) {
            cs.setString(1, p.getDocumento());
            cs.setString(2, p.getPrimerNombre());
            cs.setString(3, p.getSegundoNombre());
            cs.setString(4, p.getPrimerApellido());
            cs.setString(5, p.getSegundoApellido());
            cs.setString(6, p.getTelefono());
            cs.setString(7, p.getCorreo());
            cs.setInt(8, p.getEdad());
            cs.setString(9, p.getSexo());
            cs.setString(10, p.getTipoSangre());
            cs.setString(11, p.getRh());
            cs.setString(12, p.getDireccion());
            cs.setString(13, p.getCalle());
            cs.setString(14, p.getBarrio());
            cs.setInt(15, p.getCiudadId());
            cs.setInt(16, p.getEpsId());
            cs.setString(17, p.getDocumentoResponsable());
            cs.setInt(18, p.getUsuarioId());
            cs.registerOutParameter(19, Types.NUMERIC);
            cs.execute();
            return cs.getInt(19) == 1;
        } catch (SQLException e) {
            throw Conexion.error("registrar el paciente", e);
        }
    }

    public boolean existe(String documento) {
        String sql = "SELECT COUNT(*) FROM s_pacientes WHERE documentoid = ?";
        try (Connection c = Conexion.obtener(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, documento);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() && rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            throw Conexion.error("consultar el paciente", e);
        }
    }

    public Paciente porUsuarioId(int usuarioId) {
        return uno("SELECT * FROM s_pacientes WHERE usuario_id = ?", String.valueOf(usuarioId));
    }

    public Paciente porDocumento(String documento) {
        return uno("SELECT * FROM s_pacientes WHERE documentoid = ?", documento);
    }

    public List<Paciente> listar() {
        List<Paciente> lista = new ArrayList<>();
        try (Connection c = Conexion.obtener();
             PreparedStatement ps = c.prepareStatement("SELECT * FROM s_pacientes ORDER BY primer_apellido, primer_nombre");
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                lista.add(mapear(rs));
            }
        } catch (SQLException e) {
            throw Conexion.error("listar los pacientes", e);
        }
        return lista;
    }

    private Paciente uno(String sql, String parametro) {
        try (Connection c = Conexion.obtener(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, parametro);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? mapear(rs) : null;
            }
        } catch (SQLException e) {
            throw Conexion.error("consultar el paciente", e);
        }
    }

    private Paciente mapear(ResultSet rs) throws SQLException {
        Paciente p = new Paciente();
        p.setDocumento(rs.getString("documentoid"));
        p.setPrimerNombre(rs.getString("primer_nombre"));
        p.setSegundoNombre(rs.getString("segundo_nombre"));
        p.setPrimerApellido(rs.getString("primer_apellido"));
        p.setSegundoApellido(rs.getString("segundo_apellido"));
        p.setTelefono(rs.getString("telefono"));
        p.setCorreo(rs.getString("correo"));
        p.setEdad(rs.getInt("edad"));
        p.setSexo(rs.getString("sexo"));
        p.setTipoSangre(rs.getString("tipo_sangre"));
        p.setRh(rs.getString("rh"));
        p.setDireccion(rs.getString("direccion"));
        p.setCalle(rs.getString("calle"));
        p.setBarrio(rs.getString("barrio"));
        p.setCiudadId(rs.getInt("ciudad_id"));
        p.setEpsId(rs.getInt("eps_id"));
        p.setDocumentoResponsable(rs.getString("documento_responsable"));
        p.setUsuarioId(rs.getInt("usuario_id"));
        return p;
    }
}
