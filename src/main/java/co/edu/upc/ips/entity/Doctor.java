package co.edu.upc.ips.entity;

public class Doctor {
    private String documento;
    private String numeroLicencia;
    private String primerNombre;
    private String segundoNombre;
    private String primerApellido;
    private String segundoApellido;
    private String telefono;
    private String correo;
    private int especialidadId;
    private String especialidadNombre;
    private String horaAtencion;
    private int usuarioId;

    public Doctor() { }

    public String getDocumento() { return documento; }
    public void setDocumento(String documento) { this.documento = documento; }

    public String getNumeroLicencia() { return numeroLicencia; }
    public void setNumeroLicencia(String numeroLicencia) { this.numeroLicencia = numeroLicencia; }

    public String getPrimerNombre() { return primerNombre; }
    public void setPrimerNombre(String primerNombre) { this.primerNombre = primerNombre; }

    public String getSegundoNombre() { return segundoNombre; }
    public void setSegundoNombre(String segundoNombre) { this.segundoNombre = segundoNombre; }

    public String getPrimerApellido() { return primerApellido; }
    public void setPrimerApellido(String primerApellido) { this.primerApellido = primerApellido; }

    public String getSegundoApellido() { return segundoApellido; }
    public void setSegundoApellido(String segundoApellido) { this.segundoApellido = segundoApellido; }

    public String getTelefono() { return telefono; }
    public void setTelefono(String telefono) { this.telefono = telefono; }

    public String getCorreo() { return correo; }
    public void setCorreo(String correo) { this.correo = correo; }

    public int getEspecialidadId() { return especialidadId; }
    public void setEspecialidadId(int especialidadId) { this.especialidadId = especialidadId; }

    public String getEspecialidadNombre() { return especialidadNombre; }
    public void setEspecialidadNombre(String especialidadNombre) { this.especialidadNombre = especialidadNombre; }

    public String getHoraAtencion() { return horaAtencion; }
    public void setHoraAtencion(String horaAtencion) { this.horaAtencion = horaAtencion; }

    public int getUsuarioId() { return usuarioId; }
    public void setUsuarioId(int usuarioId) { this.usuarioId = usuarioId; }

    public String getNombreCompleto() {
        return (primerNombre + " " + (segundoNombre == null ? "" : segundoNombre + " ")
                + primerApellido + " " + (segundoApellido == null ? "" : segundoApellido)).trim();
    }

    /** Horas de atencion como lista (el campo se guarda separado por comas: 06:00,06:20,...). */
    public java.util.List<String> getHoras() {
        java.util.List<String> horas = new java.util.ArrayList<>();
        if (horaAtencion != null) {
            for (String h : horaAtencion.split(",")) {
                if (!h.trim().isEmpty()) {
                    horas.add(h.trim());
                }
            }
        }
        return horas;
    }

    @Override
    public String toString() {
        return getNombreCompleto();
    }
}
