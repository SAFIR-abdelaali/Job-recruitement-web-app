package com.recrutement.controller;

import java.io.IOException;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.NoResultException;
import jakarta.persistence.Persistence;
import jakarta.persistence.TypedQuery;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.recrutement.model.User;
import com.recrutement.model.Candidate;
import com.recrutement.model.Entreprise;

@WebServlet("/auth")
public class AuthServlet extends HttpServlet {

    private EntityManagerFactory emf;

    @Override
    public void init() throws ServletException {
        // Initialisation de la connexion BDD
        emf = Persistence.createEntityManagerFactory("recrutementPU");
    }

    @Override
    public void destroy() {
        if (emf != null && emf.isOpen()) emf.close();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("login".equals(action)) {
            handleLogin(request, response);
        } else if ("register".equals(action)) {
            handleRegister(request, response);
        } else {
            response.sendRedirect("index.jsp");
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        // Gestion de la déconnexion
        if ("logout".equals(action)) {
            HttpSession session = request.getSession(false);
            if (session != null) {
                session.invalidate();
            }
            response.sendRedirect("index.jsp?msg=logged_out");
        } else {
            response.sendRedirect("index.jsp");
        }
    }

    private void handleLogin(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        EntityManager em = emf.createEntityManager();
        try {
            // 1. Vérification des identifiants
            TypedQuery<User> query = em.createQuery("SELECT u FROM User u WHERE u.email = :email AND u.password = :pass", User.class);
            query.setParameter("email", email);
            query.setParameter("pass", password);

            User user = query.getSingleResult();

            // 2. Vérification si le compte est validé (Sauf pour l'ADMIN qui passe toujours)
            if (!user.isVerified() && !"ADMIN".equals(user.getRole())) {
                response.sendRedirect("index.jsp?error=account_not_verified");
                return;
            }

            // 3. Connexion réussie : On met l'utilisateur en session
            HttpSession session = request.getSession();
            session.setAttribute("user", user);

            // 4. REDIRECTION CORRECTE SELON LE RÔLE
            // C'est cette partie qui corrige votre erreur 404
            String redirectUrl = request.getContextPath(); // "/JobRecrutementApp"
            
            switch (user.getRole()) {
                case "ADMIN":
                    redirectUrl += "/admin/dashboard";
                    break;
                case "ENTREPRISE":
                    redirectUrl += "/entreprise/dashboard";
                    break;
                case "CANDIDATE":
                    redirectUrl += "/candidate/dashboard";
                    break;
                default:
                    redirectUrl += "/index.jsp";
                    break;
            }
            
            response.sendRedirect(redirectUrl);

        } catch (NoResultException e) {
            response.sendRedirect("index.jsp?error=invalid_credentials");
        } finally {
            em.close();
        }
    }

    private void handleRegister(HttpServletRequest request, HttpServletResponse response) throws IOException {
        EntityManager em = emf.createEntityManager();
        try {
            String role = request.getParameter("role");
            String email = request.getParameter("email");
            String password = request.getParameter("password");
            
            // Vérifier si l'email existe déjà
            Long count = em.createQuery("SELECT COUNT(u) FROM User u WHERE u.email = :email", Long.class)
                           .setParameter("email", email)
                           .getSingleResult();
            
            if (count > 0) {
                response.sendRedirect("register.jsp?error=email_exists");
                return;
            }

            em.getTransaction().begin();

            if ("CANDIDATE".equals(role)) {
                Candidate c = new Candidate();
                c.setEmail(email);
                c.setPassword(password);
                c.setRole("CANDIDATE");
                c.setVerified(false); // Doit être validé par l'admin
                
                c.setPrenom(request.getParameter("prenom"));
                c.setNom(request.getParameter("nom"));
                c.setTitreProfil(request.getParameter("titreProfil"));
                
                em.persist(c);

            } else if ("ENTREPRISE".equals(role)) {
                Entreprise e = new Entreprise();
                e.setEmail(email);
                e.setPassword(password);
                e.setRole("ENTREPRISE");
                e.setVerified(false); // Doit être validé par l'admin
                
                e.setNomEntreprise(request.getParameter("nomEntreprise"));
                e.setSecteurActivite(request.getParameter("secteurActivite"));
                e.setAdresse(request.getParameter("adresse"));
                
                em.persist(e);
            }

            em.getTransaction().commit();
            response.sendRedirect("index.jsp?msg=registered_pending_validation");

        } catch (Exception ex) {
            if (em.getTransaction().isActive()) em.getTransaction().rollback();
            ex.printStackTrace();
            response.sendRedirect("register.jsp?error=server_error");
        } finally {
            em.close();
        }
    }
}