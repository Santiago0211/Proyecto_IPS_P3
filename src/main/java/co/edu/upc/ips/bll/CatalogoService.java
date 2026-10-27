package co.edu.upc.ips.bll;

import co.edu.upc.ips.dal.CatalogoDAO;
import co.edu.upc.ips.entity.Opcion;
import java.util.List;

public class CatalogoService {
    private final CatalogoDAO dao = new CatalogoDAO();

    public List<Opcion> especialidades() { return dao.especialidades(); }
    public List<Opcion> ciudades() { return dao.ciudades(); }
    public List<Opcion> eps() { return dao.eps(); }
}
