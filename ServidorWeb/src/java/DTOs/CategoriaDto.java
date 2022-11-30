
package DTOs;

import java.io.Serializable;
import logica.clases.Artista;
import logica.clases.Categoria;

public class CategoriaDto implements Serializable {
    public static CategoriaDto fromCategoria(Categoria item) {
        if (item == null)
            return null;
        return new CategoriaDto(item);
    }

    private String nombre;

    private int id;

    public CategoriaDto(String nombre, int id) {
        this.nombre = nombre;
        this.id = id;
    }

    public CategoriaDto(String nombre) {
        this.nombre = nombre;
    }

    public CategoriaDto(Categoria item) {
        this.nombre = item.getNombre();
        this.id = item.getId();
    }
   
    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    } 
    
}
