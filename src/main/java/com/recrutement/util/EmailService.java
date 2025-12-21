package com.recrutement.util;

import java.io.InputStream;
import java.util.Properties;
import jakarta.mail.*;
import jakarta.mail.internet.*;

public class EmailService {
    public static void sendEmail(String toEmail, String subject, String body) {
        try {
            // Chargement des configs depuis le fichier
            Properties configProps = new Properties();
            InputStream input = EmailService.class.getClassLoader().getResourceAsStream("config.properties");
            if (input == null) {
                System.out.println("Désolé, impossible de trouver config.properties");
                return;
            }
            configProps.load(input);

            final String fromEmail = configProps.getProperty("mail.username");
            final String password = configProps.getProperty("mail.password");

            // Configuration SMTP (Gmail exemple)
            Properties props = new Properties();
            props.put("mail.smtp.host", "smtp.gmail.com");
            props.put("mail.smtp.port", "587");
            props.put("mail.smtp.auth", "true");
            props.put("mail.smtp.starttls.enable", "true");

            Session session = Session.getInstance(props, new Authenticator() {
                protected PasswordAuthentication getPasswordAuthentication() {
                    return new PasswordAuthentication(fromEmail, password);
                }
            });

            // Envoi...
            Message msg = new MimeMessage(session);
            msg.setFrom(new InternetAddress(fromEmail));
            msg.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            msg.setSubject(subject);
            msg.setContent(body, "text/html; charset=utf-8");
            Transport.send(msg);

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}