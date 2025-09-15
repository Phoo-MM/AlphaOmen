package com.alphaomen.servlet;

import java.io.*;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import com.alphaomen.engine.ChatbotEngine;
import java.nio.file.Files;
import java.nio.file.Paths;

@WebServlet ("/chat")
public class ChatServlet extends HttpServlet {
    private ChatbotEngine bot;

    @Override
    public void init() throws ServletException {
        try {
            String path = getServletContext().getRealPath("/WEB-INF/classes/notes.json");
            String jsonData = new String(Files.readAllBytes(Paths.get(path)));
            bot = new ChatbotEngine(jsonData);
        } catch (Exception e) {
            throw new ServletException("Error initializing chatbot", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
        throws ServletException, IOException {
        
        String userInput = request.getParameter("message");
        String botReply = bot.getResponse(userInput);

        // Save chat data in session so it persists after redirect
        HttpSession session = request.getSession();
        session.setAttribute("userInput", userInput);
        session.setAttribute("botReply", botReply);
        
        // redirect back to the page the user came from
        String referer = request.getHeader("referer");
        if (referer != null) {
            response.sendRedirect(referer);
        } else {
            response.sendRedirect("notes.jsp"); // fallback
        }  
    }
}
