package DTOs;

import java.io.Serializable;
import java.util.Date;

public abstract class UsuarioDto implements Serializable {
    private String nickname;
    private String nombre;
    private String apellido;
    private String correo;
    private Date nacimiento;
    private int id;
    private String contrasenia;

    public UsuarioDto(String nickname, String nombre, String apellido, String correo, Date nacimiento, int id, String contrasenia) {
        this.nickname = nickname;
        this.nombre = nombre;
        this.apellido = apellido;
        this.correo = correo;
        this.nacimiento = nacimiento;
        this.id = id;
        this.contrasenia = contrasenia;
    }

    public String getContrasenia() {
        return contrasenia;
    }

    public void setContrasenia(String contrasenia) {
        this.contrasenia = contrasenia;
    }

    public String getNickname() {
        return nickname;
    }

    public void setNickname(String nickname) {
        this.nickname = nickname;
    }

    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public String getApellido() {
        return apellido;
    }

    public void setApellido(String apellido) {
        this.apellido = apellido;
    }

    public String getCorreo() {
        return correo;
    }

    public void setCorreo(String correo) {
        this.correo = correo;
    }

    public Date getNacimiento() {
        return nacimiento;
    }

    public void setNacimiento(Date nacimiento) {
        this.nacimiento = nacimiento;
    }

    public int getId() {
        return id;
    }
  public String getIdtoString (){
      String IdString= Integer.toString(id);
      return IdString;
  }
   

    public void setId(int id) {
        this.id = id;
    }
    
    
}
