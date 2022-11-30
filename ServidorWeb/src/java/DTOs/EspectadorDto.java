package DTOs;

import java.io.Serializable;
import java.util.Date;
import logica.clases.Espectador;

public class EspectadorDto extends UsuarioDto implements Serializable {

    public static Espectador toEspectador(EspectadorDto item) {
        if (item == null)
            return null;
        return new Espectador(item.getNickname(), item.getNombre(), item.getApellido(), item.getCorreo(), new Date(item.getNacimiento()), item.getId(), item.getContrasenia());
    }

    public static EspectadorDto fromEspectador(Espectador item) {
        if (item == null)
            return null;
        return new EspectadorDto(item);
    }
    
    public EspectadorDto(Espectador espectador) {
        super(espectador.getNickname(), espectador.getNombre(), espectador.getApellido(), espectador.getCorreo(), espectador.getNacimiento().getTime(), espectador.getId(), espectador.getContrasenia(), "EspectadorDto");
    }

    public EspectadorDto(String nickname, String nombre, String apellido, String correo, long nacimiento, int id, String contrasenia) {
        super(nickname, nombre, apellido, correo, nacimiento, id, contrasenia, "EspectadorDto");
    }

}
