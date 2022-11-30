package DTOs;

import java.io.Serializable;
import java.util.Date;
import logica.clases.Registro_funcion;

public class Registro_funcionDto implements Serializable{
    public static Registro_funcion toRegistro_funcion(Registro_funcionDto item) {
        if (item == null)
            return null;
        return new Registro_funcion(new Date(item.getFecha_registro()), item.getCosto(), item.getId_funcion(), item.getId_espectador());
    }

    public static Registro_funcionDto fromRegistro_funcion(Registro_funcion item) {
        if (item == null)
            return null;
        return new Registro_funcionDto(item);
    }
    
    private long fecha_registro;
    private int costo;
    private int id_funcion;
    private int id_espectador;

    public Registro_funcionDto(long fecha_registro, int costo, int id_funcion, int id_espectador) {
        this.fecha_registro = fecha_registro;
        this.costo = costo;
        this.id_funcion = id_funcion;
        this.id_espectador = id_espectador;
    }

    public Registro_funcionDto(Registro_funcion item) {
        this.fecha_registro = item.getFecha_registro().getTime();
        this.costo = item.getCosto();
        this.id_funcion = item.getId_funcion();
        this.id_espectador = item.getId_espectador();
    }

    public long getFecha_registro() {
        return fecha_registro;
    }

    public void setFecha_registro(long fecha_registro) {
        this.fecha_registro = fecha_registro;
    }

    public int getCosto() {
        return costo;
    }

    public void setCosto(int costo) {
        this.costo = costo;
    }

    public int getId_funcion() {
        return id_funcion;
    }

    public void setId_funcion(int id_funcion) {
        this.id_funcion = id_funcion;
    }

    public int getId_espectador() {
        return id_espectador;
    }

    public void setId_espectador(int id_espectador) {
        this.id_espectador = id_espectador;
    }
    
    
}
