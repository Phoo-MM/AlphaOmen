package com.alphaomen.servlet;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;

import jakarta.servlet.ServletOutputStream;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/voice")
public class VoiceServlet extends HttpServlet {
    private static final String UPLOAD_DIR = "C:/VoiceUploads/";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String fileName = request.getParameter("file");
        if (fileName == null || fileName.isEmpty()) return;

        File file = new File(UPLOAD_DIR, fileName);
        if (!file.exists()) return;

        response.setContentType("audio/webm");
        try (FileInputStream fis = new FileInputStream(file);
             ServletOutputStream out = response.getOutputStream()) {
            byte[] buffer = new byte[4096];
            int bytesRead;
            while ((bytesRead = fis.read(buffer)) != -1) {
                out.write(buffer, 0, bytesRead);
            }
        }
    }
}
