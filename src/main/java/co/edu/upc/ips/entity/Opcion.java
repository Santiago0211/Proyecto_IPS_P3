package co.edu.upc.ips.entity;

/** Elemento de lista desplegable: id + texto visible. */
public class Opcion {
    private final int id;
    private final String texto;

    public Opcion(int id, String texto) {
        this.id = id;
        this.texto = texto;
    }

    public int getId() { return id; }
    public String getTexto() { return texto; }

    @Override
    public String toString() { return texto; }
}
