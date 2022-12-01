package Utility;

import DTOs.ArtistaDto;
import DTOs.CategoriaDto;
import DTOs.EspectaculoDto;
import DTOs.EspectadorDto;
import DTOs.FuncionDto;
import DTOs.PaqueteDto;
import DTOs.Registro_funcionDto;
import DTOs.UsuarioDto;
import com.google.gson.Gson;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import logica.clases.Artista;
import logica.clases.Categoria;
import logica.clases.Espectaculo;
import logica.clases.Funcion;
import logica.clases.Paquete;
import logica.clases.Registro_funcion;
import logica.clases.Usuario;

public class Converter {
    public static String format_date(Date date) {
        String pattern = "yyyy-MM-dd";
        SimpleDateFormat simpleDateFormat = new SimpleDateFormat(pattern);
        return simpleDateFormat.format(date);
    }

    public static String formatear_date(Date date) {
        String pattern = "dd-MM-yyyy";
        SimpleDateFormat simpleDateFormat = new SimpleDateFormat(pattern);
        return simpleDateFormat.format(date);
    }
    
    public static ArrayList<Espectaculo> to_Espectaculo_list(ArrayList<String> l) {
        ArrayList<Espectaculo> r = new ArrayList<>();
        for (String s : l) {
            EspectaculoDto item = GsonToUse.gson.fromJson(s, EspectaculoDto.class);
            r.add(EspectaculoDto.toEspectaculo(item));
        }
        return r;
    }

    public static ArrayList<Paquete> to_Paquete_list(ArrayList<String> l) {
        ArrayList<Paquete> a = new ArrayList<>();
        for (String s : l) {
            PaqueteDto r = GsonToUse.gson.fromJson(s, PaqueteDto.class);
            a.add(PaqueteDto.toPaquete(r));
        }
        return a;
    }

    public static ArrayList<Categoria> to_Categoria_list(ArrayList<String> l) {
        ArrayList<Categoria> r = new ArrayList<>();
        for (String s : l) {
            CategoriaDto item = GsonToUse.gson.fromJson(s, CategoriaDto.class);
            r.add(new Categoria(item.getNombre(), item.getId()));
        }
        return r;
    }

    public static ArrayList<Registro_funcion> to_Registro_funcion_list(ArrayList<String> l) {
        ArrayList<Registro_funcion> r = new ArrayList<>();
        for (String s : l) {
            Registro_funcionDto item = GsonToUse.gson.fromJson(s, Registro_funcionDto.class);
            r.add(Registro_funcionDto.toRegistro_funcion(item));
        }
        return r;
    }
    
    //to_Artista_list

    public static ArrayList<Artista> to_Artista_list(ArrayList<String> l) {
        ArrayList<Artista> a = new ArrayList<>();
        for (String s : l) {
            ArtistaDto r = GsonToUse.gson.fromJson(s, ArtistaDto.class);
            a.add(ArtistaDto.toArtista(r));
        }
        return a;
    }

    public static ArrayList<Funcion> to_Funcion_list(ArrayList<String> l) {
        ArrayList<Funcion> r = new ArrayList<>();
        for (String s : l) {
            FuncionDto item = GsonToUse.gson.fromJson(s, FuncionDto.class);
            r.add(FuncionDto.toFuncion(item));
        }
        return r;
    }

    public static ArrayList<Usuario> to_Usuario_list(ArrayList<String> l) {
        ArrayList<Usuario> r = new ArrayList<>();
        for (String s : l) {
            UsuarioDto item = GsonToUse.gson.fromJson(s, UsuarioDto.class);
            if ("ArtistaDto".equals(item.getTipo())) {
                r.add(ArtistaDto.toArtista(GsonToUse.gson.fromJson(s, ArtistaDto.class)));
            }
            else
                r.add(EspectadorDto.toEspectador(GsonToUse.gson.fromJson(s, EspectadorDto.class)));
//            r.add(UsuarioDto.toUsuario(item));
        }
        return r;
    }
}
