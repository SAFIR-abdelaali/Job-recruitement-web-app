<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Offres d'emploi | JobRecruit</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    
    <style>
        body { background-color: #f3f2ef; }

        .feed-container {
            max-width: 800px;
            margin: 0 auto;
            margin-top: 20px;
        }

        .job-card {
            background: white;
            border: 1px solid #e0e0e0;
            border-radius: 8px;
            padding: 24px;
            margin-bottom: 16px;
            transition: box-shadow 0.2s, border-color 0.2s;
            position: relative;
        }

        .job-card:hover {
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
            border-color: #cbb2ea;
        }

        .company-logo-placeholder {
            width: 56px;
            height: 56px;
            object-fit: cover;
            border-radius: 4px;
        }

        .job-title-link {
            color: #6f42c1;
            font-weight: 600;
            font-size: 1.1rem;
            text-decoration: none;
        }
        .job-title-link:hover { text-decoration: underline; }

        .company-name {
            font-size: 0.9rem;
            color: #191919;
            margin-bottom: 4px;
        }

        .job-meta {
            font-size: 0.85rem;
            color: #666;
            margin-bottom: 12px;
        }

        .job-description-preview {
            font-size: 0.9rem;
            color: #444;
            line-height: 1.5;
            margin-bottom: 15px;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
        }

        .easy-apply-text {
            color: #6f42c1;
            font-size: 0.8rem;
            font-weight: bold;
            display: flex;
            align-items: center;
        }
    </style>
</head>
<body>

    <nav class="navbar navbar-expand-lg navbar-light bg-white border-bottom fixed-top">
        <div class="container">
            <a class="navbar-brand fw-bold" href="${pageContext.request.contextPath}/candidate/profile" style="color:#6f42c1;">
                JobRecruit<span class="text-dark">.</span>
            </a>
            
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            
            <div class="collapse navbar-collapse justify-content-end" id="navbarNav">
                <ul class="navbar-nav align-items-center">
                    
                    <li class="nav-item">
                        <a class="nav-link active fw-bold" href="${pageContext.request.contextPath}/candidate/offers" style="color:#6f42c1;">Offres</a>
                    </li>

                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/candidate/applications">Mes Candidatures</a>
                    </li>
                    
                    <li class="nav-item">
                        <a href="${pageContext.request.contextPath}/chat" class="btn btn-outline-primary border-0 fw-bold ms-2 position-relative">
                            <i class="bi bi-chat-dots-fill me-1"></i> Messagerie
                            
                            <c:if test="${globalUnreadCount > 0}">
                                <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger">
                                    ${globalUnreadCount}
                                    <span class="visually-hidden">nouveaux messages</span>
                                </span>
                            </c:if>
                        </a>
                    </li>
                    
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/candidate/profile">Mon Profil</a>
                    </li>
    
                    <li class="nav-item ms-3">
                        <a href="${pageContext.request.contextPath}/auth?action=logout" class="btn btn-outline-secondary btn-sm rounded-pill">Déconnexion</a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <div class="container" style="margin-top: 90px; margin-bottom: 50px;">
        <div class="feed-container">
            
            <h4 class="mb-4 fw-light">Opportunités recommandées pour vous</h4>

            <c:if test="${param.msg == 'applied'}">
                <div class="alert alert-success d-flex align-items-center rounded-3 shadow-sm" role="alert">
                    <span class="me-2">✅</span> <strong>Félicitations !</strong> &nbsp; Votre candidature a été envoyée.
                </div>
            </c:if>
            <c:if test="${param.error == 'failed'}">
                <div class="alert alert-danger rounded-3 shadow-sm" role="alert">
                    Une erreur est survenue lors de la candidature.
                </div>
            </c:if>

            <c:forEach items="${offres}" var="offre">
                <div class="job-card">
                    <div class="d-flex">
                        <div class="me-3">
                            <img src="https://ui-avatars.com/api/?name=${offre.entreprise.nomEntreprise}&background=random&size=56&font-size=0.4" 
                                 class="company-logo-placeholder shadow-sm" alt="Logo">
                        </div>
                        
                        <div class="flex-grow-1">
                            <a href="${pageContext.request.contextPath}/candidate/apply?id=${offre.id}" class="job-title-link stretched-link">${offre.titre}</a>
                            <div class="company-name">${offre.entreprise.nomEntreprise}</div>
                            <div class="job-meta">
                                ${offre.localisation} <span class="mx-1">•</span> 
                                <span class="text-success fw-bold">${offre.typeContrat}</span> <span class="mx-1">•</span> 
                                ${offre.salaire} DH
                            </div>
                            
                            <div class="job-description-preview">
                                ${offre.description}
                            </div>

                            <div class="d-flex align-items-center justify-content-between mt-2">
                                <span class="text-muted small">Publié le ${offre.datePublication}</span>
                                
                                <a href="${pageContext.request.contextPath}/candidate/apply?id=${offre.id}" 
                                   class="btn btn-outline-primary btn-sm rounded-pill px-3" 
                                   style="position: relative; z-index: 2;">
                                    Postuler
                                </a>
                            </div>
                            
                            <div class="easy-apply-text mt-2">
                                <img src="https://upload.wikimedia.org/wikipedia/commons/c/ca/LinkedIn_logo_initials.png" width="14" class="me-1"> 
                                Candidature simplifiée
                            </div>
                        </div>
                    </div>
                </div>
            </c:forEach>

            <c:if test="${empty offres}">
                <div class="text-center p-5 bg-white rounded shadow-sm border">
                    <h5 class="text-muted">Aucune offre disponible pour le moment.</h5>
                    <p class="text-secondary small">Revenez plus tard.</p>
                </div>
            </c:if>

        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>