package DTOs;

import enums.EstadoEspectaculo;
import java.io.Serializable;
import java.util.Date;
import logica.clases.Artista;
import logica.clases.Espectaculo;

public class EspectaculoDto implements Serializable {

    public static Espectaculo toEspectaculo(EspectaculoDto item) {
        if (item == null)
            return null;
        return new Espectaculo(item.getPlataforma(), item.getNombre(), item.getDescripcion(), item.getDuracion(), item.getMin_espectador(), item.getMax_espectador(), item.getUrl(), item.getCosto(), new Date(item.getFecha_registro()), item.getId(), item.getId_artista(), item.getEstado());
    }

    private String plataforma;
    private String nombre;
    private String descripcion;
    private int duracion;
    private int min_espectador;
    private int max_espectador;
    private String url;
    private int costo;
    private long fecha_registro;
    private int id;
    private int id_artista;
    private EstadoEspectaculo estado;
    private String categoria;

  

   

    public EspectaculoDto(String plataforma, String nombre, String descripcion, int duracion, int min_espectador, int max_espectador, String url, int costo, long fecha_registro, int id, int id_artista, EstadoEspectaculo estado) {
        this.plataforma = plataforma;
        this.nombre = nombre;
        this.descripcion = descripcion;
        this.duracion = duracion;
        this.min_espectador = min_espectador;
        this.max_espectador = max_espectador;
        this.url = url;
        this.costo = costo;
        this.fecha_registro = fecha_registro;
        this.id = id;
        this.id_artista = id_artista;
        this.estado = estado;
    }

    public EspectaculoDto(Espectaculo item) {
        this.plataforma = item.getPlataforma();
        this.nombre = item.getNombre();
        this.descripcion = item.getDescripcion();
        this.duracion = item.getDuracion();
        this.min_espectador = item.getMin_espectador();
        this.max_espectador = item.getMax_espectador();
        this.url = item.getUrl();
        this.costo = item.getCosto();
        this.fecha_registro = item.getFecha_registro().getTime();
        this.id = item.getId();
        this.id_artista = item.getId_artista();
        this.estado = EstadoEspectaculo.valueOf(item.getEstado().toString()); // DEBUG, cambiar
    }

    public String getCategoria() {
        return categoria;
    }

    public void setCategoria(String categoria) {
        this.categoria = categoria;
    }
   public EspectaculoDto(String nombre,int id) {
       
        this.nombre = nombre;
        this.id = id;
       
    }

     public EstadoEspectaculo getEstado() {
        return estado;
    }

    public void setEstado(EstadoEspectaculo estado) {
        this.estado = estado;
    }

    public String getPlataforma() {
        return plataforma;
    }

    public void setPlataforma(String plataforma) {
        this.plataforma = plataforma;
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

    public int getDuracion() {
        return duracion;
    }

    public void setDuracion(int duracion) {
        this.duracion = duracion;
    }

    public int getMin_espectador() {
        return min_espectador;
    }

    public void setMin_espectador(int min_espectador) {
        this.min_espectador = min_espectador;
    }

    public int getMax_espectador() {
        return max_espectador;
    }

    public void setMax_espectador(int max_espectador) {
        this.max_espectador = max_espectador;
    }

    public String getUrl() {
        return url;
    }

    public void setUrl(String url) {
        this.url = url;
    }

    public int getCosto() {
        return costo;
    }

    public void setCosto(int costo) {
        this.costo = costo;
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

    public int getId_artista() {
        return id_artista;
    }

    public void setId_artista(int id_artista) {
        this.id_artista = id_artista;
    }
}
