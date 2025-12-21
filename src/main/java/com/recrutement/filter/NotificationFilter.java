package com.recrutement.filter;

import java.io.IOException;
import jakarta.persistence.*;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import com.recrutement.model.User;

// Ce filtre s'applique à toutes les pages
@WebFilter("/*")
public class NotificationFilter implements Filter {

    private EntityManagerFactory emf;

    @Override
    public void init(FilterConfig filterConfig) {
        emf = Persistence.createEntityManagerFactory("recrutementPU");
    }

    @Override
    public void destroy() {
        if (emf != null) emf.close();
    }

    @Override
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain) throws IOException, ServletException {
        HttpServletRequest request = (HttpServletRequest) req;
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        // On ne calcule les notifs que si l'utilisateur est connecté et que ce n'est pas un fichier statique (css, js)
        String uri = request.getRequestURI();
        if (user != null && !uri.contains("/css/") && !uri.contains("/js/")) {
            
            EntityManager em = emf.createEntityManager();
            try {
                long unreadCount = 0;
                
                // Requête pour compter les messages non lus destinés à cet utilisateur
                if ("CANDIDATE".equals(user.getRole())) {
                    // Compter messages envoyés par ENTREPRISE vers ce CANDIDAT qui sont non lus
                    String jpql = "SELECT COUNT(m) FROM Message m WHERE m.application.candidate.id = :uid AND m.senderRole = 'ENTREPRISE' AND m.isRead = false";
                    unreadCount = (long) em.createQuery(jpql).setParameter("uid", user.getId()).getSingleResult();
                } 
                else if ("ENTREPRISE".equals(user.getRole())) {
                    // Compter messages envoyés par CANDIDATE vers cette ENTREPRISE qui sont non lus
                    String jpql = "SELECT COUNT(m) FROM Message m WHERE m.application.offer.entreprise.id = :uid AND m.senderRole = 'CANDIDATE' AND m.isRead = false";
                    unreadCount = (long) em.createQuery(jpql).setParameter("uid", user.getId()).getSingleResult();
                }

                // On stocke le résultat pour l'utiliser dans le JSP
                request.setAttribute("globalUnreadCount", unreadCount);
                
            } catch (Exception e) {
                e.printStackTrace();
            } finally {
                em.close();
            }
        }

        chain.doFilter(req, res);
    }
}