package co.edu.upc.ips.entity;

public class Sesion {
    private String tipo;
    private int usuarioId;
    private String username;
    private String documento;
    private String nombre;

    public Sesion() { }

    public String getTipo() { return tipo; }
    public void setTipo(String tipo) { this.tipo = tipo; }

    public int getUsuarioId() { return usuarioId; }
    public void setUsuarioId(int usuarioId) { this.usuarioId = usuarioId; }

    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }

    public String getDocumento() { return documento; }
    public void setDocumento(String documento) { this.documento = documento; }

    public String getNombre() { return nombre; }
    public void setNombre(String nombre) { this.nombre = nombre; }

    public boolean esAdmin() { return "ADMIN".equalsIgnoreCase(tipo); }
    public boolean esDoctor() { return "DOCTOR".equalsIgnoreCase(tipo); }
    public boolean esPaciente() { return "PACIENTE".equalsIgnoreCase(tipo); }
}
