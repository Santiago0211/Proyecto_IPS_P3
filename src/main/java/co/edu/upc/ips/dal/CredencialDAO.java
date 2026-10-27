package co.edu.upc.ips.dal;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;

/** Acceso a la tabla Credenciales usando el paquete pkg_credenciales del proyecto original. */
public class CredencialDAO {

    public boolean verificar(String usuario, String hash) {
        String sql = "SELECT pkg_credenciales.FN_VERIFICAR_CREDENCIALES(?, ?) FROM DUAL";
        try (Connection c = Conexion.obtener(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, usuario);
            ps.setString(2, hash);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() && rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            throw Conexion.error("verificar las credenciales", e);
        }
    }

    public String tipoUsuario(String usuario) {
        String sql = "SELECT pkg_credenciales.FN_OBTENER_TIPO_USUARIO(?) FROM DUAL";
        try (Connection c = Conexion.obtener(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, usuario);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getString(1) : null;
            }
        } catch (SQLException e) {
            throw Conexion.error("consultar el tipo de usuario", e);
        }
    }

    public int idUsuario(String usuario) {
        String sql = "SELECT usuario_id FROM s_credenciales WHERE nombre_usuario = ?";
        try (Connection c = Conexion.obtener(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, usuario);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getInt(1) : -1;
            }
        } catch (SQLException e) {
            throw Conexion.error("consultar el usuario", e);
        }
    }

    public boolean existe(String usuario) {
        return idUsuario(usuario) > 0;
    }

    /** Inserta la credencial y devuelve el usuario_id generado (o -1 si fallo). */
    public int insertar(String usuario, String hash, String tipo) {
        String sql = "{call pkg_credenciales.SP_INSERTAR_CREDENCIALES(?, ?, ?, ?, ?)}";
        try (Connection c = Conexion.obtener(); CallableStatement cs = c.prepareCall(sql)) {
            cs.setString(1, usuario);
            cs.setString(2, hash);
            cs.setString(3, tipo);
            cs.registerOutParameter(4, Types.NUMERIC);
            cs.registerOutParameter(5, Types.NUMERIC);
            cs.execute();
            return cs.getInt(5) == 1 ? cs.getInt(4) : -1;
        } catch (SQLException e) {
            throw Conexion.error("crear las credenciales", e);
        }
    }

    public boolean cambiarPassword(String usuario, String nuevoHash) {
        String sql = "{call pkg_credenciales.SP_CAMBIAR_PASSWORD(?, ?, ?)}";
        try (Connection c = Conexion.obtener(); CallableStatement cs = c.prepareCall(sql)) {
            cs.setString(1, usuario);
            cs.setString(2, nuevoHash);
            cs.registerOutParameter(3, Types.NUMERIC);
            cs.execute();
            return cs.getInt(3) == 1;
        } catch (SQLException e) {
            throw Conexion.error("cambiar la contraseña", e);
        }
    }

    /** Se usa solo para deshacer una credencial cuando falla el registro del perfil. */
    public void eliminar(int usuarioId) {
        String sql = "DELETE FROM s_credenciales WHERE usuario_id = ?";
        try (Connection c = Conexion.obtener(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, usuarioId);
            ps.executeUpdate();
        } catch (SQLException e) {
            throw Conexion.error("deshacer la creación del usuario", e);
        }
    }
}
