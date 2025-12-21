package com.recrutement.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import jakarta.persistence.*;
import java.io.IOException;
import java.time.LocalDateTime;
import java.util.List;
import com.recrutement.model.*;
import com.recrutement.util.EmailService;

@WebServlet("/admin/*")
public class AdminServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private EntityManagerFactory emf;

    @Override
    public void init() {
        emf = Persistence.createEntityManagerFactory("recrutementPU");
    }

    @Override
    public void destroy() {
        if (emf != null && emf.isOpen()) emf.close();
    }

    // ============================================================
    //                    ROUTAGE GET (Affichage & Actions Liens)
    // ============================================================
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;
        
        if (user == null || !"ADMIN".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/auth?action=login");
            return;
        }

        String path = request.getPathInfo();
        if (path == null || path.equals("/")) path = "/dashboard";

        try {
            switch (path) {
                case "/dashboard":
                    afficherDashboard(request, response);
                    break;
                case "/users/pending":
                    afficherUtilisateursEnAttente(request, response);
                    break;
                case "/users/validate":
                    validerUtilisateur(request, response);
                    break;
                case "/users/delete":
                    supprimerUtilisateur(request, response);
                    break;
                case "/applications":
                    afficherToutesLesCandidatures(request, response);
                    break;
                case "/applications/delete": // <--- NOUVEAU : Suppression Candidature
                    supprimerCandidature(request, response);
                    break;
                default:
                    response.sendRedirect(request.getContextPath() + "/admin/dashboard");
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(500, "Erreur serveur : " + e.getMessage());
        }
    }

    // ============================================================
    //                    ROUTAGE POST (Formulaires)
    // ============================================================
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user != null && "ADMIN".equals(user.getRole())) {
            String uri = request.getRequestURI();
            EntityManager em = emf.createEntityManager();
            EntityTransaction tx = em.getTransaction();

            try {
                tx.begin();

                // 1. PLANIFIER ENTRETIEN (Google Meet)
                if (uri.endsWith("/schedule")) {
                    Long appId = Long.parseLong(request.getParameter("appId"));
                    Application app = em.find(Application.class, appId);
                    
                    app.setDateEntretient(LocalDateTime.parse(request.getParameter("dateEntretient")));
                    app.setLieuEntretient("Google Meet");
                    app.setMeetingLink(request.getParameter("meetingLink"));
                    app.setStatut("ENTRETIEN_PROGRAMME");
                    
                    // Notifier le candidat
                    final String email = app.getCandidate().getEmail();
                    final String link = request.getParameter("meetingLink");
                    new Thread(() -> EmailService.sendEmail(email, "Entretien Programmé", 
                        "<p>Votre entretien est confirmé via Google Meet : <a href='" + link + "'>" + link + "</a></p>")).start();
                    
                    tx.commit();
                    response.sendRedirect(request.getContextPath() + "/admin/applications?msg=scheduled");
                }
                
                // 2. SAUVEGARDER LE REPLAY
                else if (uri.endsWith("/saveRecording")) {
                    Long appId = Long.parseLong(request.getParameter("appId"));
                    Application app = em.find(Application.class, appId);
                    app.setRecordingLink(request.getParameter("recordingLink"));
                    
                    tx.commit();
                    response.sendRedirect(request.getContextPath() + "/admin/applications?msg=saved");
                }

            } catch (Exception e) {
                if (tx.isActive()) tx.rollback();
                e.printStackTrace();
            } finally {
                em.close();
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/auth?action=login");
        }
    }

    // ============================================================
    //                    MÉTHODES MÉTIER
    // ============================================================

    // --- 1. DASHBOARD ---
    private void afficherDashboard(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        EntityManager em = emf.createEntityManager();
        try {
            // Listes des utilisateurs VÉRIFIÉS uniquement
            List<Candidate> candidats = em.createQuery(
                "SELECT c FROM Candidate c WHERE c.isVerified = true", Candidate.class)
                .getResultList();
                
            List<Entreprise> entreprises = em.createQuery(
                "SELECT e FROM Entreprise e WHERE e.isVerified = true", Entreprise.class)
                .getResultList();

            request.setAttribute("candidats", candidats);
            request.setAttribute("entreprises", entreprises);
            
            // Compteurs Stats
            long pendingCount = (long) em.createQuery("SELECT COUNT(u) FROM User u WHERE u.isVerified = false AND u.role != 'ADMIN'").getSingleResult();
            request.setAttribute("pendingCount", pendingCount);

            long newApplicationsCount = (long) em.createQuery("SELECT COUNT(a) FROM Application a WHERE a.statut = 'EN_ATTENTE'").getSingleResult();
            request.setAttribute("notifApps", newApplicationsCount);

            request.getRequestDispatcher("/WEB-INF/views/admin/dashboard.jsp").forward(request, response);
        } finally {
            em.close();
        }
    }

    // --- 2. GESTION COMPTES (Validation) ---
    private void afficherUtilisateursEnAttente(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        EntityManager em = emf.createEntityManager();
        try {
            List<User> users = em.createQuery("SELECT u FROM User u WHERE u.isVerified = false AND u.role != 'ADMIN'", User.class).getResultList();
            request.setAttribute("pendingUsers", users);
            request.getRequestDispatcher("/WEB-INF/views/admin/pending_users.jsp").forward(request, response);
        } finally { em.close(); }
    }

    private void validerUtilisateur(HttpServletRequest request, HttpServletResponse response) throws IOException {
        EntityManager em = emf.createEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            // 1. Récupération sécurisée de l'ID (accepte 'userId' ou 'id')
            String idParam = request.getParameter("userId");
            if (idParam == null) idParam = request.getParameter("id");

            // 2. Si pas d'ID, on redirige au lieu de planter (Page blanche fixée)
            if (idParam == null || idParam.isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/admin/users/pending?error=missing_id");
                return;
            }

            tx.begin();
            Long userId = Long.parseLong(idParam);
            User u = em.find(User.class, userId);
            
            if (u != null) {
                u.setVerified(true);
                
                // Notification Email (dans un thread pour ne pas ralentir)
                final String email = u.getEmail();
                new Thread(() -> EmailService.sendEmail(email, "Compte Validé", 
                    "<h3>Félicitations !</h3><p>Votre compte a été validé par l'administrateur. Vous pouvez vous connecter.</p>")).start();
            }
            
            tx.commit();
            response.sendRedirect(request.getContextPath() + "/admin/users/pending?msg=validated");
            
        } catch (Exception e) {
            if (tx.isActive()) tx.rollback();
            e.printStackTrace();
            // En cas d'erreur technique, on redirige proprement
            response.sendRedirect(request.getContextPath() + "/admin/users/pending?error=exception");
        } finally {
            em.close();
        }
    }

    // --- 3. SUPPRESSION UTILISATEUR (Nettoyage Complet) ---
    private void supprimerUtilisateur(HttpServletRequest request, HttpServletResponse response) throws IOException {
        EntityManager em = emf.createEntityManager();
        EntityTransaction tx = em.getTransaction();
        
        try {
            tx.begin();
            
            // 1. Récupération de l'ID
            String idParam = request.getParameter("id");
            if (idParam == null) idParam = request.getParameter("userId");
            Long userId = Long.parseLong(idParam);
            
            User user = em.find(User.class, userId);

            if (user != null) {
                // === NETTOYAGE PROFOND (Deep Clean) ===
                
                if (user instanceof Entreprise) {
                    // A. Récupérer toutes les offres de l'entreprise
                    List<Offer> offers = em.createQuery("SELECT o FROM Offer o WHERE o.entreprise.id = :eid", Offer.class)
                                           .setParameter("eid", userId)
                                           .getResultList();
                    
                    for (Offer o : offers) {
                        // B. Récupérer toutes les candidatures liées à cette offre
                        List<Application> apps = em.createQuery("SELECT a FROM Application a WHERE a.offer.id = :oid", Application.class)
                                                   .setParameter("oid", o.getId())
                                                   .getResultList();

                        for (Application a : apps) {
                            // C. SUPPRIMER LES MESSAGES de cette candidature (C'est souvent ça qui bloque !)
                            em.createQuery("DELETE FROM Message m WHERE m.application.id = :aid")
                              .setParameter("aid", a.getId())
                              .executeUpdate();
                            
                            // D. Supprimer la candidature
                            em.remove(a);
                        }
                        
                        // E. Supprimer l'offre une fois qu'elle est vide de candidatures
                        em.remove(o);
                    }

                } else if (user instanceof Candidate) {
                    // Si c'est un candidat, on récupère ses candidatures
                    List<Application> apps = em.createQuery("SELECT a FROM Application a WHERE a.candidate.id = :cid", Application.class)
                                               .setParameter("cid", userId)
                                               .getResultList();

                    for (Application a : apps) {
                        // Supprimer les messages
                        em.createQuery("DELETE FROM Message m WHERE m.application.id = :aid")
                          .setParameter("aid", a.getId())
                          .executeUpdate();
                        
                        // Supprimer la candidature
                        em.remove(a);
                    }
                }

                // === SUPPRESSION FINALE DE L'UTILISATEUR ===
                // Pour être sûr, on force un flush pour que tout ce qui précède soit exécuté avant de tuer le user
                em.flush(); 
                em.remove(user);
            }
            
            tx.commit();
            response.sendRedirect(request.getContextPath() + "/admin/dashboard?msg=deleted");
            
        } catch (Exception e) {
            if (tx.isActive()) tx.rollback();
            e.printStackTrace(); // Regardez votre console (en bas d'Eclipse/IntelliJ) pour voir l'erreur exacte
            response.sendRedirect(request.getContextPath() + "/admin/dashboard?error=delete_failed");
        } finally {
            em.close();
        }
    }

    // --- 4. GESTION CANDIDATURES ---
    private void afficherToutesLesCandidatures(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        EntityManager em = emf.createEntityManager();
        try {
            List<Application> apps = em.createQuery(
                "SELECT a FROM Application a JOIN FETCH a.candidate JOIN FETCH a.offer ORDER BY a.datePostulation DESC", Application.class)
                .getResultList();
            request.setAttribute("applications", apps);
            request.getRequestDispatcher("/WEB-INF/views/admin/applications_list.jsp").forward(request, response);
        } finally { em.close(); }
    }

    // --- 5. SUPPRESSION CANDIDATURE (NOUVEAU) ---
    private void supprimerCandidature(HttpServletRequest request, HttpServletResponse response) throws IOException {
        EntityManager em = emf.createEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            Long appId = Long.parseLong(request.getParameter("id"));
            Application app = em.find(Application.class, appId);

            if (app != null) {
                // Nettoyage des messages avant suppression
                em.createQuery("DELETE FROM Message m WHERE m.application.id = :id")
                  .setParameter("id", appId)
                  .executeUpdate();
                em.remove(app);
            }
            tx.commit();
            response.sendRedirect(request.getContextPath() + "/admin/applications?msg=deleted");
        } catch (Exception e) {
            if (tx.isActive()) tx.rollback();
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/applications?error=failed");
        } finally { em.close(); }
    }
}