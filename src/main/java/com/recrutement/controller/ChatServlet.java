package com.recrutement.controller;

import java.io.IOException;
// === CES IMPORTS SONT OBLIGATOIRES ===
import java.util.List;
import java.util.ArrayList;
// =====================================

import jakarta.persistence.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import com.recrutement.model.*;

@WebServlet("/chat")
public class ChatServlet extends HttpServlet {

    private EntityManagerFactory emf;

    @Override
    public void init() {
        emf = Persistence.createEntityManagerFactory("recrutementPU");
    }

    @Override
    public void destroy() {
        if (emf != null && emf.isOpen()) emf.close();
    }

    // --- PARTIE LECTURE (GET) ---
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/auth?action=login");
            return;
        }

        EntityManager em = emf.createEntityManager();
        try {
            // 1. Charger les conversations
            String jpql = "";
            if ("CANDIDATE".equals(user.getRole())) {
                jpql = "SELECT a FROM Application a WHERE a.candidate.id = :uid AND a.dateEntretient IS NOT NULL ORDER BY a.dateEntretient DESC";
            } else if ("ENTREPRISE".equals(user.getRole())) {
                jpql = "SELECT a FROM Application a WHERE a.offer.entreprise.id = :uid AND a.dateEntretient IS NOT NULL ORDER BY a.dateEntretient DESC";
            } else {
                response.sendRedirect(request.getContextPath() + "/index.jsp"); 
                return;
            }

            TypedQuery<Application> query = em.createQuery(jpql, Application.class);
            query.setParameter("uid", user.getId());
            List<Application> conversations = query.getResultList();
            
            request.setAttribute("conversations", conversations);

            // 2. Charger la conversation active
            String appId = request.getParameter("appId");
            Application activeApp = null;

            if (appId != null) {
                activeApp = em.find(Application.class, Long.parseLong(appId));
            } else if (!conversations.isEmpty()) {
                activeApp = conversations.get(0);
            }

            // 3. PRÉ-CHARGEMENT DES MESSAGES (Anti-Erreur 500)
            if (activeApp != null) {
                // Vérification sécurité (code existant...)
                boolean isAuthorized = false;
                if ("CANDIDATE".equals(user.getRole()) && activeApp.getCandidate().getId().equals(user.getId())) isAuthorized = true;
                if ("ENTREPRISE".equals(user.getRole()) && activeApp.getOffer().getEntreprise().getId().equals(user.getId())) isAuthorized = true;
                
                if (isAuthorized) {
                    em.refresh(activeApp); 
                    activeApp.getMessages().size(); 

                    // === AJOUT : MARQUER LES MESSAGES COMME LUS ===
                    EntityTransaction tx = em.getTransaction();
                    tx.begin();
                    for (Message m : activeApp.getMessages()) {
                        // Si le message vient de l'AUTRE et n'est pas encore lu -> On le marque Lu
                        if (!m.getSenderRole().equals(user.getRole()) && !m.isRead()) {
                            m.setRead(true);
                        }
                    }
                    tx.commit();
                    // ==============================================

                    request.setAttribute("activeApp", activeApp);
                } else {
                    activeApp = null; 
                }
            }

            request.getRequestDispatcher("/WEB-INF/views/chat_inbox.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            em.close();
        }
    }

    // --- PARTIE ÉCRITURE (POST) ---
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user != null) {
            String action = request.getParameter("action"); 
            String appId = request.getParameter("appId");
            
            EntityManager em = emf.createEntityManager();
            EntityTransaction tx = em.getTransaction();
            try {
                tx.begin();
                Application app = em.find(Application.class, Long.parseLong(appId));
                
                if (app != null && app.getDateEntretient() != null) {
                    if (action == null || "send".equals(action)) {
                        String content = request.getParameter("message");
                        if(content != null && !content.trim().isEmpty()) {
                            em.persist(new Message(content, user.getRole(), app));
                        }
                    } 
                    else if ("edit".equals(action)) {
                        Message msg = em.find(Message.class, Long.parseLong(request.getParameter("messageId")));
                        if (msg != null && msg.getSenderRole().equals(user.getRole())) {
                            msg.setContenu(request.getParameter("message"));
                            msg.setEdited(true);
                        }
                    }
                    else if ("delete".equals(action)) {
                        Message msg = em.find(Message.class, Long.parseLong(request.getParameter("messageId")));
                        if (msg != null && msg.getSenderRole().equals(user.getRole())) {
                            msg.setDeleted(true);
                        }
                    }
                }
                tx.commit();
            } catch (Exception e) {
                if (tx.isActive()) tx.rollback();
            } finally {
                em.close();
            }
            response.sendRedirect(request.getContextPath() + "/chat?appId=" + appId);
        } else {
            response.sendRedirect(request.getContextPath() + "/auth?action=login");
        }
    }
}