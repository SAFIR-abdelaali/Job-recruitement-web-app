<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Mes Candidatures | JobRecruit</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    
    <style>
        body { background-color: #f8f9fa; padding-top: 80px; }
        .interview-box {
            background-color: #fff;
            border: 1px solid #198754; /* Bordure verte */
            border-left: 5px solid #198754;
            border-radius: 6px;
            padding: 15px;
            margin-top: 10px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.05);
        }
        .table-hover tbody tr:hover { background-color: white; }
    </style>
</head>
<body>

    <nav class="navbar navbar-expand-lg navbar-light bg-white fixed-top shadow-sm">
        <div class="container">
            <a class="navbar-brand fw-bold" href="#" style="color:#6f42c1;">JobRecruit</a>
            <div class="d-flex gap-3">
                 
                 <a href="${pageContext.request.contextPath}/chat" class="btn btn-outline-primary btn-sm position-relative">
                    <i class="bi bi-chat-dots-fill me-1"></i> Messagerie
                    
                    <c:if test="${globalUnreadCount > 0}">
                        <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger">
                            ${globalUnreadCount}
                            <span class="visually-hidden">nouveaux messages</span>
                        </span>
                    </c:if>
                 </a>

                 <a href="${pageContext.request.contextPath}/candidate/dashboard" class="btn btn-outline-secondary btn-sm">
                    <i class="bi bi-arrow-left"></i> Retour au Dashboard
                 </a>
                 <a href="${pageContext.request.contextPath}/auth?action=logout" class="text-danger fw-bold text-decoration-none d-flex align-items-center">
                    <i class="bi bi-box-arrow-right fs-5"></i>
                 </a>
            </div>
        </div>
    </nav>

    <div class="container pb-5">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h3 class="fw-bold text-dark m-0">Suivi des Candidatures</h3>
            <span class="badge bg-secondary rounded-pill">${applications.size()} dossiers</span>
        </div>

        <c:if test="${param.msg == 'applied'}">
            <div class="alert alert-success alert-dismissible fade show">
                <i class="bi bi-check-circle-fill me-2"></i> Votre candidature a été envoyée avec succès !
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <div class="card border-0 shadow-sm rounded-3 overflow-hidden">
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="bg-light text-secondary small text-uppercase">
                            <tr>
                                <th class="ps-4" style="width: 30%;">Offre & Contrat</th>
                                <th style="width: 25%;">Entreprise & Lieu</th>
                                <th style="width: 15%;">Date Envoi</th>
                                <th style="width: 30%;">État d'avancement</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${applications}" var="app">
                                <tr>
                                    <td class="ps-4">
                                        <div class="fw-bold text-primary mb-1 text-uppercase small ls-1">${app.offer.titre}</div>
                                        <span class="badge bg-light text-dark border fw-normal">
                                            <i class="bi bi-briefcase me-1"></i>${app.offer.typeContrat}
                                        </span>
                                    </td>

                                    <td>
                                        <div class="fw-bold text-dark">${app.offer.entreprise.nomEntreprise}</div>
                                        <small class="text-muted">
                                            <i class="bi bi-geo-alt-fill text-danger"></i> ${app.offer.localisation}
                                        </small>
                                    </td>

                                    <td>
                                        <div class="small text-muted">
                                            <i class="bi bi-clock"></i> 
                                            ${app.datePostulation.toString().replace('T', ' ').substring(0, 10)}
                                        </div>
                                    </td>

                                    <td class="pe-4">
                                        <c:choose>
                                            <c:when test="${app.statut == 'EN_ATTENTE'}">
                                                <span class="badge bg-warning bg-opacity-10 text-warning border border-warning">En attente</span>
                                            </c:when>
                                            <c:when test="${app.statut == 'REFUSE'}">
                                                <span class="badge bg-danger bg-opacity-10 text-danger border border-danger">Candidature non retenue</span>
                                            </c:when>
                                            <c:when test="${app.statut == 'ENTRETIEN_PROGRAMME' or not empty app.dateEntretient}">
                                                <span class="badge bg-success bg-opacity-10 text-success border border-success">
                                                    <i class="bi bi-check-circle-fill me-1"></i> Retenu pour entretien
                                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-secondary">${app.statut}</span>
                                            </c:otherwise>
                                        </c:choose>

                                        <c:if test="${not empty app.dateEntretient}">
                                            <div class="interview-box">
                                                <div class="d-flex align-items-center mb-2 border-bottom border-success-subtle pb-2">
                                                    <i class="bi bi-camera-video-fill fs-5 me-2 text-success"></i>
                                                    <span class="fw-bold small text-uppercase text-success">Entretien Vidéo</span>
                                                </div>
                                                
                                                <div class="mb-3">
                                                    <div class="fw-bold text-dark">
                                                        ${app.dateEntretient.toString().replace('T', ' à ')}
                                                    </div>
                                                </div>

                                                <c:if test="${not empty app.meetingLink}">
                                                    <a href="${app.meetingLink}" target="_blank" class="btn btn-success btn-sm w-100 mb-2 shadow-sm fw-bold">
                                                        <i class="bi bi-camera-video me-2"></i>Rejoindre la réunion
                                                    </a>
                                                </c:if>
                                                
                                                <c:if test="${empty app.meetingLink}">
                                                     <div class="mb-2 text-muted small"><i class="bi bi-geo-alt me-1"></i>${app.lieuEntretient}</div>
                                                </c:if>

                                                <c:if test="${not empty app.recordingLink}">
                                                    <a href="${app.recordingLink}" target="_blank" class="btn btn-outline-danger btn-sm w-100 mb-2 fw-bold">
                                                        <i class="bi bi-play-circle-fill me-2"></i>Voir l'enregistrement
                                                    </a>
                                                </c:if>

                                                <a href="${pageContext.request.contextPath}/chat?appId=${app.id}" class="btn btn-primary btn-sm w-100 shadow-sm">
                                                    <i class="bi bi-chat-dots-fill me-2"></i>Ouvrir le chat
                                                </a>
                                            </div>
                                        </c:if>
                                    </td>
                                </tr>
                            </c:forEach>
                            
                            <c:if test="${empty applications}">
                                <tr>
                                    <td colspan="4" class="text-center py-5">
                                        <div class="text-muted">
                                            <i class="bi bi-inbox fs-1 opacity-25"></i>
                                            <p class="mt-3 mb-3">Vous n'avez pas encore postulé à des offres.</p>
                                        </div>
                                        <a href="${pageContext.request.contextPath}/candidate/dashboard" class="btn btn-primary rounded-pill px-4">
                                            Parcourir les offres
                                        </a>
                                    </td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>