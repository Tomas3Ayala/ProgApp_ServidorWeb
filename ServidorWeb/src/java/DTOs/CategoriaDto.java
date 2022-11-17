
package DTOs;

import java.io.Serializable;

public class CategoriaDto implements Serializable {
    
   private String nombre;
   private int id;

    public CategoriaDto(String nombre, int id) {
        this.nombre = nombre;
        this.id = id;
    }
     public CategoriaDto(String nombre) {
        this.nombre = nombre;
       
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
