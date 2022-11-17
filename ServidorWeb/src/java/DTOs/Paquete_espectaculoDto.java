package DTOs;

import java.io.Serializable;

public class Paquete_espectaculoDto implements Serializable {
    private int id_espectaculo;
    private int id_paquete;

    public Paquete_espectaculoDto(int id_espectaculo, int id_paquete) {
        this.id_espectaculo = id_espectaculo;
        this.id_paquete = id_paquete;
    }

    public int getId_espectaculo() {
        return id_espectaculo;
    }

    public void setId_espectaculo(int id_espectaculo) {
        this.id_espectaculo = id_espectaculo;
    }

    public int getId_paquete() {
        return id_paquete;
    }

    public void setId_paquete(int id_paquete) {
        this.id_paquete = id_paquete;
    }
    
    
}
