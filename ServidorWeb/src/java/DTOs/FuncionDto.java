package DTOs;

import java.io.Serializable;
import java.util.Date;
import logica.clases.Funcion;

public class FuncionDto implements Serializable {

    public static Funcion toFuncion(FuncionDto item) {
        if (item == null)
            return null;
        return new Funcion(item.getNombre(), new Date(item.getFecha()), item.getHora_inicio(), new Date(item.getFecha_registro()), item.getId(), item.getId_espectaculo());
    }

    public static FuncionDto fromFuncion(Funcion item) {
        if (item == null)
            return null;
        return new FuncionDto(item);
    }

    private String nombre;
    private long fecha;
    private int hora_inicio;
    private long fecha_registro;
    private int id;
    private int id_espectaculo;

    public FuncionDto(String nombre, long fecha, int hora_inicio, long fecha_registro, int id, int id_espectaculo) {
        this.nombre = nombre;
        this.fecha = fecha;
        this.hora_inicio = hora_inicio;
        this.fecha_registro = fecha_registro;
        this.id = id;
        this.id_espectaculo = id_espectaculo;
    }

    public FuncionDto(Funcion item) {
        this.nombre = item.getNombre();
        this.fecha = item.getFecha().getTime();
        this.hora_inicio = item.getHora_inicio();
        this.fecha_registro = item.getFecha_registro().getTime();
        this.id = item.getId();
        this.id_espectaculo = item.getId_espectaculo();
    }

    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public long getFecha() {
        return fecha;
    }

    public void setFecha(long fecha) {
        this.fecha = fecha;
    }

    public int getHora_inicio() {
        return hora_inicio;
    }

    public void setHora_inicio(int hora_inicio) {
        this.hora_inicio = hora_inicio;
    }

    public long getFecha_registro() {
        return fecha_registro;
    }

    public void setFecha_registro(long fecha_registro) {
        this.fecha_registro = fecha_registro;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getId_espectaculo() {
        return id_espectaculo;
    }

    public void setId_espectaculo(int id_espectaculo) {
        this.id_espectaculo = id_espectaculo;
    }
    
}
