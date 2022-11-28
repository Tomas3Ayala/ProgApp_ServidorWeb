package Utility;

import DTOs.ArtistaDto;
import com.google.gson.Gson;
import java.util.ArrayList;
import logica.clases.Artista;
import logica.clases.Categoria;
import logica.clases.Espectaculo;
import logica.clases.Paquete;
import logica.clases.Registro_funcion;

public class Converter {
    public static ArrayList<Espectaculo> to_espectaculos(ArrayList<String> espectaculos) {
        ArrayList<Espectaculo> r = new ArrayList<>();
        for (String s : espectaculos) {
            r.add(GsonToUse.gson.fromJson(s, Espectaculo.class));
        }
        return r;
    }

    public static ArrayList<Espectaculo> to_Espectaculo_list(ArrayList<String> l) {
        ArrayList<Espectaculo> r = new ArrayList<>();
        for (String s : l)
            r.add(GsonToUse.gson.fromJson(s, Espectaculo.class));
        return r;
    }

    public static ArrayList<Paquete> to_Paquete_list(ArrayList<String> l) {
        ArrayList<Paquete> r = new ArrayList<>();
        for (String s : l)
            r.add(GsonToUse.gson.fromJson(s, Paquete.class));
        return r;
    }

    public static ArrayList<Categoria> to_Categoria_list(ArrayList<String> l) {
        ArrayList<Categoria> r = new ArrayList<>();
        for (String s : l)
            r.add(GsonToUse.gson.fromJson(s, Categoria.class));
        return r;
    }

    public static ArrayList<Registro_funcion> to_Registro_funcion_list(ArrayList<String> l) {
        ArrayList<Registro_funcion> r = new ArrayList<>();
        for (String s : l)
            r.add(GsonToUse.gson.fromJson(s, Registro_funcion.class));
        return r;
    }
    
    //to_Artista_list

    public static ArrayList<Artista> to_Artista_list(ArrayList<String> l) {
        ArrayList<Artista> r = new ArrayList<>();
        for (String s : l)
            r.add(GsonToUse.gson.fromJson(s, Artista.class));
        return r;
    }
}
