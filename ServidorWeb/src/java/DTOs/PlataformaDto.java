package DTOs;

import java.io.Serializable;

public class PlataformaDto implements Serializable{
    private String nombre;
    private String descripcion;
    private String url;
    private int id;

    public PlataformaDto(String nombre, String descripcion, String url, int id) {
        this.nombre = nombre;
        this.descripcion = descripcion;
        this.url = url;
        this.id = id;
    }
     public PlataformaDto(String nombre, String descripcion, String url) {
        this.nombre = nombre;
        this.descripcion = descripcion;
        this.url = url;
      
    }

    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public String getDescripcion() {
        return descripcion;
    }

    public void setDescripcion(String descripcion) {
        this.descripcion = descripcion;
    }

    public String getUrl() {
        return url;
    }

    public void setUrl(String url) {
        this.url = url;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }
    
}
