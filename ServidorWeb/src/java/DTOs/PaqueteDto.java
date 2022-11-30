package DTOs;

import java.io.Serializable;
import java.util.Date;
import logica.clases.Paquete;

public class PaqueteDto implements Serializable{
    public static Paquete toPaquete(PaqueteDto item) {
        if (item == null)
            return null;
        return new Paquete(item.getNombre(), item.getDescripcion(), new Date(item.getFecha_inicio()), new Date(item.getFecha_fin()), item.getDescuento(), item.getId());
    }

    public static PaqueteDto fromPaquete(Paquete item) {
        if (item == null)
            return null;
        return new PaqueteDto(item);
    }
    
    private String nombre;
    private String descripcion;
    private long fecha_inicio;
    private long fecha_fin;
    private int descuento;
    private int id;

    public PaqueteDto(String nombre, String descripcion, long fecha_inicio, long fecha_fin, int descuento, int id) {
        this.nombre = nombre;
        this.descripcion = descripcion;
        this.fecha_inicio = fecha_inicio;
        this.fecha_fin = fecha_fin;
        this.descuento = descuento;
        this.id = id;
    }

    public PaqueteDto(Paquete r) {
        this.nombre = r.getNombre();
        this.descripcion = r.getDescripcion();
        this.fecha_inicio = r.getFecha_inicio().getTime();
        this.fecha_fin = r.getFecha_fin().getTime();
        this.descuento = r.getDescuento();
        this.id = r.getId();
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

    public long getFecha_inicio() {
        return fecha_inicio;
    }

    public void setFecha_inicio(long fecha_inicio) {
        this.fecha_inicio = fecha_inicio;
    }

    public long getFecha_fin() {
        return fecha_fin;
    }

    public void setFecha_fin(long fecha_fin) {
        this.fecha_fin = fecha_fin;
    }

    public int getDescuento() {
        return descuento;
    }

    public void setDescuento(int descuento) {
        this.descuento = descuento;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }
    
    
}

