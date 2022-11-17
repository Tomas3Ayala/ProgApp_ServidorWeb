package DTOs;

import java.io.Serializable;
import java.util.Date;

public class EspectadorDto extends UsuarioDto implements Serializable {

    public EspectadorDto(String nickname, String nombre, String apellido, String correo, Date nacimiento, int id, String contrasenia) {
        super(nickname, nombre, apellido, correo, nacimiento, id, contrasenia);
    }

}
