package com.alphaomen.service;

import jakarta.mail.*;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;
import java.util.Properties;

public class EmailService {
    private static final String SMTP_HOST = "smtp.gmail.com";
    private static final String SMTP_PORT = "587";
    private static final String SENDER_EMAIL = "daitsuki1735@gmail.com"; // Change this
    private static final String SENDER_PASSWORD = "elxqzqjixkrbvqbb "; // Use App Password
    
    public static void sendOTPEmail(String toEmail, String otp) throws MessagingException {
        Properties props = new Properties();
        props.put("mail.smtp.host", SMTP_HOST);
        props.put("mail.smtp.port", SMTP_PORT);
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        
        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(SENDER_EMAIL, SENDER_PASSWORD);
            }
        });
        
        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(SENDER_EMAIL));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            message.setSubject("Sticky Notes - Your OTP Code");
            message.setText("Dear User,\n\nYour OTP code for Sticky Notes is: " + otp + 
                           "\n\nThis code is valid for 10 minutes.\n\nThank you!");
            
            Transport.send(message);
        } catch (MessagingException e) {
            throw new MessagingException("Failed to send OTP email", e);
        }
    }
    public static void main(String[] args) {
        try {
            sendOTPEmail("your_test_email@gmail.com", "123456");
            System.out.println("Email sent!");
        } catch (MessagingException e) {
            e.printStackTrace();
        }
    }

}