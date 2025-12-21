package com.recrutement.controller;

import java.io.File;
import java.io.IOException;
import java.util.List;
import com.recrutement.model.*;
import jakarta.persistence.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/candidate/*")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2,  // 2MB
    maxFileSize = 1024 * 1024 * 10,       // 10MB
    maxRequestSize = 1024 * 1024 * 50     // 50MB
)
public class CandidateServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private EntityManagerFactory emf;

    @Override
    public void init() throws ServletException {
        emf = Persistence.createEntityManagerFactory("recrutementPU");
    }

    @Override
    public void destroy() {
        if (emf != null && emf.isOpen()) emf.close();
    }

    // ============================================================
    //                    ROUTAGE (GET)
    // ============================================================
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        // Sécurité : Vérifier rôle CANDIDATE
        if (user == null || !"CANDIDATE".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/auth?action=login");
            return;
        }

        String path = request.getPathInfo();
        if (path == null || path.equals("/")) path = "/profile";

        try {
            switch (path) {
                case "/profile":
                    afficherProfil(request, response, user.getId());
                    break;
                case "/offers":
                    afficherToutesLesOffres(request, response);
                    break;
                case "/profile/edit":
                    afficherFormulaireEdit(request, response, user.getId());
                    break;
                case "/apply":
                    afficherFormulaireCandidature(request, response);
                    break;
                case "/applications":
                    afficherMesCandidatures(request, response, user.getId());
                    break;
                default:
                    response.sendRedirect(request.getContextPath() + "/candidate/profile");
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(500, "Erreur interne.");
        }
    }

    // ============================================================
    //                    ROUTAGE (POST)
    // ============================================================
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null || !"CANDIDATE".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/auth?action=login");
            return;
        }

        String path = request.getPathInfo();

        if ("/profile/save".equals(path)) {
            sauvegarderProfil(request, response, user.getId());
        } else if ("/apply/save".equals(path)) {
            sauvegarderCandidature(request, response, user.getId());
        } else {
            response.sendRedirect(request.getContextPath() + "/candidate/profile");
        }
    }

    // ============================================================
    //                    MÉTHODES MÉTIER
    // ============================================================

    // --- 1. GESTION DES OFFRES & CANDIDATURES ---

    private void afficherFormulaireCandidature(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        EntityManager em = emf.createEntityManager();
        try {
            String idParam = request.getParameter("id");
            if (idParam == null) {
                response.sendRedirect(request.getContextPath() + "/candidate/offers");
                return;
            }
            Long offerId = Long.parseLong(idParam);
            Offer offer = em.find(Offer.class, offerId);
            
            if (offer != null) {
                request.setAttribute("offre", offer);
                request.getRequestDispatcher("/WEB-INF/views/candidate/apply_form.jsp").forward(request, response);
            } else {
                response.sendRedirect(request.getContextPath() + "/candidate/offers?error=not_found");
            }
        } finally {
            em.close();
        }
    }

    private void sauvegarderCandidature(HttpServletRequest request, HttpServletResponse response, Long userId) 
            throws IOException, ServletException {
        EntityManager em = emf.createEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            
            Long offerId = Long.parseLong(request.getParameter("offerId"));
            Offer offer = em.find(Offer.class, offerId);
            Candidate candidate = em.find(Candidate.class, userId);

            // Vérifier si le candidat a déjà postulé à cette offre (Optionnel mais recommandé)
            Long count = em.createQuery("SELECT COUNT(a) FROM Application a WHERE a.offer.id = :oid AND a.candidate.id = :cid", Long.class)
                           .setParameter("oid", offerId)
                           .setParameter("cid", userId)
                           .getSingleResult();

            if (count > 0) {
                response.sendRedirect(request.getContextPath() + "/candidate/offers?error=already_applied");
                return;
            }

            if (offer != null && candidate != null) {
                Application app = new Application();
                app.setOffer(offer);
                app.setCandidate(candidate);
                app.setStatut("EN_ATTENTE"); // Statut par défaut
                app.setLettreMotivation(request.getParameter("lettreMotivation"));
                
                // --- UPLOAD DES DOCUMENTS ---
                // Ces méthodes supposent que votre modèle Application.java possède les champs : cv, bac, diplome, cin
                
                String cvName = saveUpload(request.getPart("cv"), "cv", userId, offerId);
                if (cvName != null) app.setCv(cvName);

                String bacName = saveUpload(request.getPart("bac"), "bac", userId, offerId);
                if (bacName != null) app.setBac(bacName);

                String diplomeName = saveUpload(request.getPart("diplome"), "diplome", userId, offerId);
                if (diplomeName != null) app.setDiplome(diplomeName);

                // Note: Assurez-vous que le champ s'appelle bien "cin" dans le formulaire JSP et dans l'entité Application
                String cinName = saveUpload(request.getPart("cin"), "cin", userId, offerId); 
                if (cinName != null) app.setCin(cinName);

                em.persist(app);
                tx.commit();
                
                response.sendRedirect(request.getContextPath() + "/candidate/applications?msg=applied");
            } else {
                response.sendRedirect(request.getContextPath() + "/candidate/offers?error=failed");
            }
        } catch (Exception e) {
            if (tx.isActive()) tx.rollback();
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/candidate/offers?error=exception");
        } finally {
            em.close();
        }
    }

    private void afficherMesCandidatures(HttpServletRequest request, HttpServletResponse response, Long userId) 
            throws ServletException, IOException {
        EntityManager em = emf.createEntityManager();
        try {
            // Utilisation de JOIN FETCH pour charger les relations EAGER
            List<Application> apps = em.createQuery(
                "SELECT a FROM Application a JOIN FETCH a.offer o JOIN FETCH o.entreprise WHERE a.candidate.id = :uid ORDER BY a.id DESC", 
                Application.class)
                .setParameter("uid", userId)
                .getResultList();
            
            request.setAttribute("applications", apps);
            request.getRequestDispatcher("/WEB-INF/views/candidate/my_applications.jsp").forward(request, response);
        } finally {
            em.close();
        }
    }

    /**
     * Méthode utilitaire robuste pour sauvegarder les fichiers
     */
    private String saveUpload(Part part, String typeDoc, Long userId, Long offerId) throws IOException {
        if (part != null && part.getSize() > 0 && part.getSubmittedFileName() != null && !part.getSubmittedFileName().isEmpty()) {
            
            String submittedFileName = part.getSubmittedFileName();
            String extension = "";
            int i = submittedFileName.lastIndexOf('.');
            if (i > 0) {
                extension = submittedFileName.substring(i);
            }

            // Nom de fichier unique pour éviter les collisions
            String fileName = typeDoc + "_" + userId + "_off" + offerId + "_" + System.currentTimeMillis() + extension;
            
            // Stockage dans /uploads/documents pour ne pas mélanger avec les logos/photos
            String uploadPath = getServletContext().getRealPath("") + File.separator + "uploads" + File.separator + "documents";
            
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) uploadDir.mkdirs(); // mkdirs() crée aussi les dossiers parents si nécessaire

            part.write(uploadPath + File.separator + fileName);
            return fileName;
        }
        return null;
    }

    // --- 2. PROFIL & OFFRES ---

    private void afficherToutesLesOffres(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        EntityManager em = emf.createEntityManager();
        try {
            List<Offer> offres = em.createQuery("SELECT o FROM Offer o JOIN FETCH o.entreprise", Offer.class).getResultList();
            request.setAttribute("offres", offres);
            request.getRequestDispatcher("/WEB-INF/views/candidate/offer_list.jsp").forward(request, response);
        } finally {
            em.close();
        }
    }
    
    private void afficherProfil(HttpServletRequest request, HttpServletResponse response, Long userId) 
            throws ServletException, IOException {
        EntityManager em = emf.createEntityManager();
        try {
            Candidate candidate = em.find(Candidate.class, userId);
            request.setAttribute("candidat", candidate);
            request.getRequestDispatcher("/WEB-INF/views/candidate/profile.jsp").forward(request, response);
        } finally {
            em.close();
        }
    }

    private void afficherFormulaireEdit(HttpServletRequest request, HttpServletResponse response, Long userId) 
            throws ServletException, IOException {
        EntityManager em = emf.createEntityManager();
        try {
            Candidate candidate = em.find(Candidate.class, userId);
            request.setAttribute("candidat", candidate);
            request.getRequestDispatcher("/WEB-INF/views/candidate/profile_form.jsp").forward(request, response);
        } finally {
            em.close();
        }
    }

    private void sauvegarderProfil(HttpServletRequest request, HttpServletResponse response, Long userId) 
            throws IOException, ServletException {
        EntityManager em = emf.createEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            Candidate candidate = em.find(Candidate.class, userId);
            
            candidate.setNom(request.getParameter("nom"));
            candidate.setPrenom(request.getParameter("prenom"));
            // L'email est souvent utilisé comme identifiant, attention si on le change
            candidate.setEmail(request.getParameter("email")); 
            candidate.setTitreProfil(request.getParameter("titreProfil"));
            candidate.setBio(request.getParameter("bio"));

            // Upload Photo de profil (Stockée dans /uploads à la racine)
            Part filePart = request.getPart("photo");
            if (filePart != null && filePart.getSize() > 0 && filePart.getSubmittedFileName() != null && !filePart.getSubmittedFileName().isEmpty()) {
                String uploadPath = getServletContext().getRealPath("") + File.separator + "uploads";
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) uploadDir.mkdirs();
                
                String extension = "";
                String sName = filePart.getSubmittedFileName();
                int i = sName.lastIndexOf('.');
                if(i > 0) extension = sName.substring(i);

                String fileName = "user_" + userId + "_" + System.currentTimeMillis() + extension;
                filePart.write(uploadPath + File.separator + fileName);
                
                candidate.setPhoto(fileName);
            }

            tx.commit();
            
            // Mise à jour de l'utilisateur en session pour refléter les changements immédiatement (ex: nom, photo)
            request.getSession().setAttribute("user", candidate);
            
            response.sendRedirect(request.getContextPath() + "/candidate/profile?msg=updated");
        } catch (Exception e) {
            if (tx.isActive()) tx.rollback();
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/candidate/profile?error=update_failed");
        } finally {
            em.close();
        }
    }
}