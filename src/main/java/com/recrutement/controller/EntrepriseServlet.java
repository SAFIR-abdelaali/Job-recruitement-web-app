package com.recrutement.controller;

import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.EntityTransaction;
import jakarta.persistence.Persistence;
import jakarta.persistence.TypedQuery;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

import com.recrutement.model.User;
import com.recrutement.model.Entreprise;
import com.recrutement.model.Offer;
import com.recrutement.model.Application;

@WebServlet("/entreprise/*")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2,
    maxFileSize = 1024 * 1024 * 10,
    maxRequestSize = 1024 * 1024 * 50
)
public class EntrepriseServlet extends HttpServlet {

    private EntityManagerFactory emf;

    @Override
    public void init() throws ServletException {
        emf = Persistence.createEntityManagerFactory("recrutementPU");
    }

    @Override
    public void destroy() {
        if (emf != null && emf.isOpen()) emf.close();
    }

    // ================= GET (Affichage) =================
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getPathInfo();
        
        // SÉCURITÉ
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null || !"ENTREPRISE".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/index.jsp?error=access_denied");
            return;
        }

        Entreprise entreprise = (Entreprise) user; 

        // ROUTAGE
        if (action == null || action.equals("/dashboard")) {
            afficherDashboard(request, response, entreprise);

        } else if (action.equals("/offer/new")) {
            // Formulaire vide pour nouvelle offre
            request.getRequestDispatcher("/WEB-INF/views/entreprise/offer_form.jsp").forward(request, response);

        } else if (action.equals("/offer/edit")) {
            // --- NOUVEAU : Charger l'offre pour modification ---
            chargerOffrePourEdition(request, response, entreprise);

        } else if (action.equals("/offer/delete")) {
            // --- NOUVEAU : Supprimer l'offre ---
            supprimerOffre(request, response, entreprise);

        } else if (action.equals("/profile/edit")) {
            request.getRequestDispatcher("/WEB-INF/views/entreprise/profile_form.jsp").forward(request, response);

        } else if (action.equals("/applications")) {
            afficherCandidatures(request, response);
        }
    }

    // ================= POST (Actions) =================
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getPathInfo();
        HttpSession session = request.getSession(false);
        
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }

        if (action != null) {
            switch (action) {
                case "/offer/save":
                    saveOffer(request, response);
                    break;
                case "/profile/save":
                    saveProfile(request, response);
                    break;
                default:
                    response.sendRedirect(request.getContextPath() + "/entreprise/dashboard");
                    break;
            }
        }
    }

    // ================= MÉTHODES MÉTIER =================

    private void afficherDashboard(HttpServletRequest request, HttpServletResponse response, Entreprise entreprise) throws ServletException, IOException {
        EntityManager em = emf.createEntityManager();
        try {
            // On force le rafraichissement pour voir les modifs/suppressions
            em.clear();
            TypedQuery<Offer> query = em.createQuery("SELECT o FROM Offer o WHERE o.entreprise.id = :entId", Offer.class);
            query.setParameter("entId", entreprise.getId());
            List<Offer> offers = query.getResultList();
            
            request.setAttribute("offres", offers);
            request.getRequestDispatcher("/WEB-INF/views/entreprise/dashboard.jsp").forward(request, response);
        } finally {
            em.close();
        }
    }

    // --- NOUVEAU : Charger l'offre pour l'édition ---
    private void chargerOffrePourEdition(HttpServletRequest request, HttpServletResponse response, Entreprise entreprise) throws ServletException, IOException {
        String idStr = request.getParameter("id");
        if (idStr != null) {
            EntityManager em = emf.createEntityManager();
            try {
                Offer offer = em.find(Offer.class, Long.parseLong(idStr));
                
                // Sécurité : Vérifier que l'offre appartient bien à l'entreprise connectée
                if (offer != null && offer.getEntreprise().getId().equals(entreprise.getId())) {
                    request.setAttribute("offer", offer); // On envoie l'objet 'offer' à la JSP pour pré-remplir les champs
                    request.getRequestDispatcher("/WEB-INF/views/entreprise/offer_form.jsp").forward(request, response);
                } else {
                    response.sendRedirect(request.getContextPath() + "/entreprise/dashboard?error=unauthorized");
                }
            } finally {
                em.close();
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/entreprise/dashboard");
        }
    }

    // --- NOUVEAU : Supprimer l'offre ---
    private void supprimerOffre(HttpServletRequest request, HttpServletResponse response, Entreprise entreprise) throws IOException {
        String idStr = request.getParameter("id");
        if (idStr != null) {
            EntityManager em = emf.createEntityManager();
            EntityTransaction tx = em.getTransaction();
            try {
                tx.begin();
                Offer offer = em.find(Offer.class, Long.parseLong(idStr));

                // Sécurité
                if (offer != null && offer.getEntreprise().getId().equals(entreprise.getId())) {
                    // 1. Supprimer d'abord toutes les candidatures liées (Cascade manuelle)
                    em.createQuery("DELETE FROM Application a WHERE a.offer.id = :oid")
                      .setParameter("oid", offer.getId())
                      .executeUpdate();

                    // 2. Supprimer l'offre
                    em.remove(offer);
                    tx.commit();
                    response.sendRedirect(request.getContextPath() + "/entreprise/dashboard?msg=deleted");
                } else {
                    response.sendRedirect(request.getContextPath() + "/entreprise/dashboard?error=unauthorized");
                }
            } catch (Exception e) {
                if (tx.isActive()) tx.rollback();
                e.printStackTrace();
                response.sendRedirect(request.getContextPath() + "/entreprise/dashboard?error=delete_failed");
            } finally {
                em.close();
            }
        }
    }

    private void saveOffer(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        EntityManager em = emf.createEntityManager();
        EntityTransaction tx = em.getTransaction();

        try {
            // Récupération de l'ID (s'il existe, c'est une modification)
            String idStr = request.getParameter("id");
            
            String titre = request.getParameter("titre");
            String description = request.getParameter("description");
            String typeContrat = request.getParameter("typeContrat");
            String localisation = request.getParameter("localisation");
            String salaireStr = request.getParameter("salaire");

            HttpSession session = request.getSession();
            User user = (User) session.getAttribute("user");

            tx.begin();
            
            Offer offer;
            
            // === LOGIQUE MODIFICATION vs CRÉATION ===
            if (idStr != null && !idStr.isEmpty()) {
                // UPDATE : On récupère l'existante
                offer = em.find(Offer.class, Long.parseLong(idStr));
                
                // Sécurité : on vérifie que c'est bien son offre
                if (!offer.getEntreprise().getId().equals(user.getId())) {
                    throw new Exception("Non autorisé à modifier cette offre");
                }
            } else {
                // INSERT : Nouvelle offre
                offer = new Offer();
                offer.setDatePublication(LocalDateTime.now());
                
                // On attache l'entreprise
                Entreprise entrepriseRef = em.find(Entreprise.class, user.getId());
                offer.setEntreprise(entrepriseRef);
            }

            // Mise à jour des champs communs
            offer.setTitre(titre);
            offer.setDescription(description);
            offer.setTypeContrat(typeContrat);
            offer.setLocalisation(localisation);
            if (salaireStr != null && !salaireStr.isEmpty()) {
                offer.setSalaire(Double.parseDouble(salaireStr));
            }

            // Si c'était une création, on persist. Si modif, le commit suffit (objet managé).
            if (idStr == null || idStr.isEmpty()) {
                em.persist(offer);
            }

            tx.commit();
            response.sendRedirect(request.getContextPath() + "/entreprise/dashboard?msg=saved");

        } catch (Exception e) {
            if (tx.isActive()) tx.rollback();
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/entreprise/offer/new?error=save_failed");
        } finally {
            em.close();
        }
    }

    private void afficherCandidatures(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String offerIdStr = request.getParameter("offerId");
        List<Application> apps = new ArrayList<>(); 

        if (offerIdStr != null && !offerIdStr.isEmpty()) {
            EntityManager em = emf.createEntityManager();
            try {
                Long offerId = Long.parseLong(offerIdStr);
                em.clear(); 
                TypedQuery<Application> query = em.createQuery(
                    "SELECT a FROM Application a WHERE a.offer.id = :oId", Application.class);
                query.setParameter("oId", offerId);
                apps = query.getResultList();
            } catch (Exception e) {
                e.printStackTrace();
            } finally {
                em.close();
            }
        }
        request.setAttribute("applications", apps);
        request.getRequestDispatcher("/WEB-INF/views/entreprise/application_list.jsp").forward(request, response);
    }

    private void saveProfile(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        EntityManager em = emf.createEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            HttpSession session = request.getSession();
            User currentUser = (User) session.getAttribute("user");

            String nomEntreprise = request.getParameter("nomEntreprise");
            String secteur = request.getParameter("secteurActivite");
            String adresse = request.getParameter("adresse");
            
            Part filePart = request.getPart("logo");
            String fileName = null;

            if (filePart != null && filePart.getSize() > 0) {
                fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
                String uploadPath = getServletContext().getRealPath("") + File.separator + "uploads";
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) uploadDir.mkdir();
                filePart.write(uploadPath + File.separator + fileName);
            }

            tx.begin();
            Entreprise entrepriseToUpdate = em.find(Entreprise.class, currentUser.getId());
            if (nomEntreprise != null) entrepriseToUpdate.setNomEntreprise(nomEntreprise);
            if (secteur != null) entrepriseToUpdate.setSecteurActivite(secteur);
            if (adresse != null) entrepriseToUpdate.setAdresse(adresse);
            if (fileName != null) entrepriseToUpdate.setLogo(fileName);
            em.merge(entrepriseToUpdate);
            tx.commit();

            session.setAttribute("user", entrepriseToUpdate);
            response.sendRedirect(request.getContextPath() + "/entreprise/dashboard?msg=profile_updated");

        } catch (Exception e) {
            if (tx.isActive()) tx.rollback();
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/entreprise/profile/edit?error=true");
        } finally {
            em.close();
        }
    }
}