package DTOs;

import java.io.Serializable;
import java.util.Date;
import logica.clases.Artista;

public class ArtistaDto extends UsuarioDto implements Serializable {

    public static Artista toArtista(ArtistaDto item) {
        if (item == null)
            return null;
        return new Artista(item.getDescripcion(), item.getBiografia(), item.getSitio_web(), item.getNickname(), item.getNombre(), item.getApellido(), item.getCorreo(), new Date(item.getNacimiento()), item.getId(), item.getContrasenia());
    }
    
    public static ArtistaDto fromArtista(Artista item) {
        if (item == null)
            return null;
        return new ArtistaDto(item);
    }
    
    private String descripcion;
    private String biografia;
    private String sitio_web;
    
    public ArtistaDto(Artista artista) {
        super(artista.getNickname(), artista.getNombre(), artista.getApellido(), artista.getCorreo(), artista.getNacimiento().getTime(), artista.getId(), artista.getContrasenia(), "ArtistaDto");
        this.descripcion = artista.getDescripcion();
        this.biografia = artista.getBiografia();
        this.sitio_web = artista.getSitio_web();
    }

    public ArtistaDto(String descripcion, String biografia, String sitio_web, String nickname, String nombre, String apellido, String correo, long nacimiento, int id, String contrasenia) {
        super(nickname, nombre, apellido, correo, nacimiento, id, contrasenia, "ArtistaDto");
        this.descripcion = descripcion;
        this.biografia = biografia;
        this.sitio_web = sitio_web;
    }

    public String getDescripcion() {
        return descripcion;
    }
  
    

    public void setDescripcion(String descripcion) {
        this.descripcion = descripcion;
    }

    public String getBiografia() {
        return biografia;
    }

    public void setBiografia(String biografia) {
        this.biografia = biografia;
    }

    public String getSitio_web() {
        return sitio_web;
    }

    public void setSitio_web(String sitio_web) {
        this.sitio_web = sitio_web;
    }
    @Override
    public String toString() {
        return getNombre();
    }

}
