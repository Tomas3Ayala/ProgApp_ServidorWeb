package Utility;

import com.google.gson.Gson;
import java.io.BufferedReader;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Properties;
import java.util.logging.Level;
import java.util.logging.Logger;
import logica.clases.Espectaculo;

public class Sender {
    private static Properties getProperties() {
        try {
            FileInputStream file = new FileInputStream(System.getProperty("user.home") + "\\Documents\\GitHub\\ServidorAPIREST\\apiconfig.properties");
            Properties prop = new Properties();
            prop.load(file);
            return prop;
        } catch (FileNotFoundException ex) {
            Logger.getLogger(Sender.class.getName()).log(Level.SEVERE, null, ex);
        } catch (IOException ex) {
            Logger.getLogger(Sender.class.getName()).log(Level.SEVERE, null, ex);
        }
        return null;
    }
    public static String EMAIL_REGEX = "^[\\w-_\\.+]*[\\w-_\\.]\\@([\\w]+\\.)+[\\w]+[\\w]$";
    public static String WEB_REGEX = "^(https?:\\/\\/)?([\\w\\Q$-_+!*'(),%\\E]+\\.)+(\\w{2,63})(:\\d{1,4})?([\\w\\Q/$-_+!*'(),%\\E]+\\.?[\\w])*\\/?$";
    
    public static final Properties properties = getProperties();
    public static final String BASE_URL = properties.getProperty("url");
    
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
//        System.out.println("url: " + url);

        URL obj = new URL(url);
//        System.out.println("url2: " + obj);
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
//        System.out.println("gson " + new Gson().toJson(arguments_strings));

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

            String original = response.toString();
            byte[] utf8Bytes = original.getBytes();
            String roundTrip = new String(utf8Bytes, "UTF-8");
            return roundTrip;
        }
        System.out.println("POST Response Code (" + url + ") :: " + responseCode);
        return null;
    }
}
