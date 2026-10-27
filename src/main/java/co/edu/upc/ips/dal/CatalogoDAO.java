package co.edu.upc.ips.dal;

import co.edu.upc.ips.entity.Opcion;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/** Listas de apoyo: especialidades, ciudades y EPS. */
public class CatalogoDAO {

    public List<Opcion> especialidades() {
        return consultar("SELECT especialidad_id, nombre FROM s_especialidades ORDER BY nombre", "cargar especialidades");
    }

    public List<Opcion> ciudades() {
        return consultar("SELECT ciudad_id, nombre FROM s_ciudades ORDER BY nombre", "cargar ciudades");
    }

    public List<Opcion> eps() {
        return consultar("SELECT eps_id, nombre FROM s_eps ORDER BY nombre", "cargar EPS");
    }

    private List<Opcion> consultar(String sql, String accion) {
        List<Opcion> lista = new ArrayList<>();
        try (Connection c = Conexion.obtener();
             PreparedStatement ps = c.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                lista.add(new Opcion(rs.getInt(1), rs.getString(2)));
            }
        } catch (SQLException e) {
            throw Conexion.error(accion, e);
        }
        return lista;
    }
}
