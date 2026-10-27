package co.edu.upc.ips.entity;

public class Paciente {
    private String documento;
    private String primerNombre;
    private String segundoNombre;
    private String primerApellido;
    private String segundoApellido;
    private String telefono;
    private String correo;
    private int edad;
    private String sexo;
    private String tipoSangre;
    private String rh;
    private String direccion;
    private String calle;
    private String barrio;
    private int ciudadId;
    private int epsId;
    private String documentoResponsable;
    private int usuarioId;

    public Paciente() { }

    public String getDocumento() { return documento; }
    public void setDocumento(String documento) { this.documento = documento; }

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

    public int getEdad() { return edad; }
    public void setEdad(int edad) { this.edad = edad; }

    public String getSexo() { return sexo; }
    public void setSexo(String sexo) { this.sexo = sexo; }

    public String getTipoSangre() { return tipoSangre; }
    public void setTipoSangre(String tipoSangre) { this.tipoSangre = tipoSangre; }

    public String getRh() { return rh; }
    public void setRh(String rh) { this.rh = rh; }

    public String getDireccion() { return direccion; }
    public void setDireccion(String direccion) { this.direccion = direccion; }

    public String getCalle() { return calle; }
    public void setCalle(String calle) { this.calle = calle; }

    public String getBarrio() { return barrio; }
    public void setBarrio(String barrio) { this.barrio = barrio; }

    public int getCiudadId() { return ciudadId; }
    public void setCiudadId(int ciudadId) { this.ciudadId = ciudadId; }

    public int getEpsId() { return epsId; }
    public void setEpsId(int epsId) { this.epsId = epsId; }

    public String getDocumentoResponsable() { return documentoResponsable; }
    public void setDocumentoResponsable(String documentoResponsable) { this.documentoResponsable = documentoResponsable; }

    public int getUsuarioId() { return usuarioId; }
    public void setUsuarioId(int usuarioId) { this.usuarioId = usuarioId; }

    public String getNombreCompleto() {
        return (primerNombre + " " + (segundoNombre == null ? "" : segundoNombre + " ")
                + primerApellido + " " + (segundoApellido == null ? "" : segundoApellido)).trim();
    }
}
