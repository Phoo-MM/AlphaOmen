package com.alphaomen.servlet;

import java.net.*;
import java.nio.charset.StandardCharsets;
import java.io.*;
import java.util.*;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

// Gson for JSON parsing
import com.google.gson.*;

@WebServlet("/AutoCorrectServlet")
public class AutoCorrectServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8"); // ensure correct encoding
        resp.setCharacterEncoding("UTF-8");

        String text = req.getParameter("text"); // text from your contenteditable
        String title = req.getParameter("title");
        String note_id = req.getParameter("note_id");
        if (text == null || text.trim().isEmpty()) {
            req.setAttribute("original", "");
            req.setAttribute("corrected", "");
            req.setAttribute("corrections", new ArrayList<>());
            req.getRequestDispatcher("home.jsp").forward(req, resp);
            return;
        }

        // Use Gson to safely build JSON
        JsonObject jsonObjToSend = new JsonObject();
        jsonObjToSend.addProperty("text", text);
        String jsonInput = new Gson().toJson(jsonObjToSend);

        // Call Flask API
        URL url = new URL("http://localhost:5000/autocorrect");
        HttpURLConnection con = (HttpURLConnection) url.openConnection();
        con.setRequestMethod("POST");
        con.setRequestProperty("Content-Type", "application/json; utf-8");
        con.setRequestProperty("Accept", "application/json");
        con.setDoOutput(true);

        try (OutputStream os = con.getOutputStream()) {
            os.write(jsonInput.getBytes(StandardCharsets.UTF_8));
        }

        // Read response safely (handles 400+ errors too)
        InputStream is;
        int code = con.getResponseCode();
        if (code >= 400) {
            is = con.getErrorStream(); // read error stream to debug
        } else {
            is = con.getInputStream();
        }

        StringBuilder responseStr = new StringBuilder();
        try (BufferedReader br = new BufferedReader(new InputStreamReader(is, StandardCharsets.UTF_8))) {
            String line;
            while ((line = br.readLine()) != null) {
                responseStr.append(line.trim());
            }
        }

        // Parse JSON response
        JsonObject jsonResp = JsonParser.parseString(responseStr.toString()).getAsJsonObject();
        String original = jsonResp.has("original") ? jsonResp.get("original").getAsString() : "";
        String corrected = jsonResp.has("corrected") ? jsonResp.get("corrected").getAsString() : "";

        // Convert corrections to List<Map<String, Object>>
        List<Map<String, Object>> corrections = new ArrayList<>();
        if (jsonResp.has("corrections")) {
            JsonArray corrArray = jsonResp.getAsJsonArray("corrections");
            for (JsonElement el : corrArray) {
                JsonObject obj = el.getAsJsonObject();
                Map<String, Object> map = new HashMap<>();
                map.put("word", obj.get("word").getAsString());

                List<String> suggs = new ArrayList<>();
                if (obj.has("suggestions")) {
                    JsonArray suggArray = obj.getAsJsonArray("suggestions");
                    for (JsonElement s : suggArray) {
                        suggs.add(s.getAsString());
                    }
                }
                map.put("suggestions", suggs);
                corrections.add(map);
            }
        }

        // Forward to JSP
        req.setAttribute("original", original);
        req.setAttribute("corrected", corrected);
        req.setAttribute("corrections", corrections);


        String targetJsp = req.getParameter("target"); // get JSP name from request
        if (targetJsp == null || targetJsp.isEmpty()) {
            targetJsp = "home.jsp";
        }
        RequestDispatcher rd = req.getRequestDispatcher(targetJsp);
        rd.forward(req, resp);

    }
}
