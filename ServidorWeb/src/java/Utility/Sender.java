package Utility;

import com.google.gson.Gson;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.ArrayList;
import java.util.HashMap;
import logica.clases.Espectaculo;

public class Sender {
    private static final String BASE_URL = "http://localhost:8080/ServidorAPIREST/api";
    
    public static String get(String api_service, HashMap<String, String> arguments) throws IOException {
        String url = BASE_URL + api_service;

        if (arguments.size() > 0) {
            boolean first = true;
            for (String key : arguments.keySet())
            {
                url += first ? '?':'&';
                first = false;
                url += arguments.get(key);
            }
        }
        System.out.println("url: " + url);

        URL obj = new URL(url);
        System.out.println("url2: " + obj);
        HttpURLConnection con = (HttpURLConnection) obj.openConnection();
        con.setRequestMethod("GET");
        con.setRequestProperty("Content-Length", Integer.toString((url).length()));
        con.setRequestProperty("Host", url);
        

        int responseCode = con.getResponseCode();

        if (responseCode == HttpURLConnection.HTTP_OK) { // success
            BufferedReader in = new BufferedReader(new InputStreamReader(con.getInputStream()));
            String inputLine;
            StringBuilder response = new StringBuilder();

            while ((inputLine = in.readLine()) != null) {
                response.append(inputLine);
            }
            in.close();
            return response.toString();
        }
        System.out.println("GET Response Code :: " + responseCode);
        return null;
    }

    public static String post(String api_service, Object[] arguments) throws IOException {
        String url = BASE_URL + api_service;
        URL obj = new URL(url);
        HttpURLConnection con = (HttpURLConnection) obj.openConnection();
        con.setRequestMethod("POST");

        // For POST only - START
        con.setDoOutput(true);
        OutputStream os = con.getOutputStream();

        ArrayList<String> arguments_strings = new ArrayList<>();
        for (Object argument : arguments)
            arguments_strings.add(new Gson().toJson(argument));
        os.write((new Gson().toJson(arguments_strings)).getBytes());

        os.flush();
        os.close();
        // For POST only - END

        int responseCode = con.getResponseCode();

        if (responseCode == HttpURLConnection.HTTP_OK) { //success
            BufferedReader in = new BufferedReader(new InputStreamReader(con.getInputStream()));
            String inputLine;
            StringBuffer response = new StringBuffer();

            while ((inputLine = in.readLine()) != null) {
                response.append(inputLine);
            }
            in.close();

            return response.toString();
        }
        System.out.println("POST Response Code (" + url + ") :: " + responseCode);
        return null;
    }
}
