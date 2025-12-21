<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Mon Profil | JobRecruit</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    
    <style>
        body { background-color: #f3f2ef; }

        /* --- Style Carte Profil Gauche --- */
        .profile-card {
            background: white;
            border-radius: 8px;
            overflow: hidden;
            border: 1px solid #e0e0e0;
            box-shadow: 0 4px 12px rgba(0,0,0,0.05);
            text-align: center;
        }

        .profile-banner {
            background: #a0b4b7;
            background-image: radial-gradient(circle, #bfaac1 0%, #6f42c1 100%);
            height: 100px;
            width: 100%;
        }

        .profile-avatar {
            width: 100px;
            height: 100px;
            border-radius: 50%;
            border: 4px solid white;
            margin-top: -50px;
            object-fit: cover;
            background: white;
            cursor: pointer;
        }

        .profile-name {
            font-weight: 600;
            font-size: 1.3rem;
            margin-top: 10px;
            color: #191919;
        }

        .profile-headline {
            font-size: 0.9rem;
            color: #666;
            margin-bottom: 15px;
            padding: 0 15px;
        }

        /* --- Style Section Droite (About) --- */
        .section-card {
            background: white;
            border-radius: 8px;
            border: 1px solid #e0e0e0;
            padding: 20px;
            margin-bottom: 20px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.05);
        }

        .section-title {
            font-size: 1.1rem;
            font-weight: 600;
            color: #191919;
            margin-bottom: 15px;
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
	                    <a class="nav-link" href="${pageContext.request.contextPath}/candidate/offers">Offres</a>
	                </li>

                    <li class="nav-item">
	                    <a class="nav-link" href="${pageContext.request.contextPath}/candidate/applications">Mes Candidatures</a>
	                </li>
	                
	                <li class="nav-item">
                        <a class="nav-link active fw-bold" href="${pageContext.request.contextPath}/candidate/profile" style="color:#6f42c1;">Mon Profil</a>
	                </li>
	
                    <li class="nav-item ms-3">
	                    <a href="${pageContext.request.contextPath}/auth?action=logout" class="btn btn-outline-secondary btn-sm rounded-pill">Déconnexion</a>
	                </li>
	            </ul>
	        </div>
	    </div>
	</nav>

    <div class="container" style="margin-top: 90px; margin-bottom: 50px;">
        <div class="row">
            
            <div class="col-md-4 col-lg-3 mb-3">
                <div class="profile-card pb-3">
                    <div class="profile-banner"></div>
                    
                    <c:choose>
                        <c:when test="${not empty candidat.photo}">
                            <img src="${pageContext.request.contextPath}/uploads/${candidat.photo}" class="profile-avatar shadow-sm">
                        </c:when>
                        <c:otherwise>
                            <img src="https://ui-avatars.com/api/?name=${candidat.prenom}+${candidat.nom}&background=random&size=128" class="profile-avatar shadow-sm">
                        </c:otherwise>
                    </c:choose>

                    <h1 class="profile-name">
                        <c:out value="${candidat.prenom}" /> <c:out value="${candidat.nom}" />
                    </h1>
                    
                    <p class="profile-headline">
                        ${candidat.titreProfil != null ? candidat.titreProfil : 'Aucun titre défini'}
                    </p>

                    <hr style="width: 90%; margin: 10px auto; color: #e0e0e0;">
                    
                    <div class="text-start px-3 py-1">
                         <small class="text-muted fw-bold" style="font-size: 0.75rem;">COORDONNÉES</small>
                         <div class="text-dark small mt-1">📧 ${candidat.email}</div>
                    </div>

                    <div class="mt-3">
                        <a href="profile/edit" class="btn btn-outline-primary rounded-pill btn-sm px-4 fw-bold">Modifier le profil</a>
                    </div>
                </div>
            </div>

            <div class="col-md-8 col-lg-9">
                
                <div class="section-card">
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <h2 class="section-title m-0">Infos & Bio</h2>
                        <a href="profile/edit" class="btn btn-sm btn-light rounded-circle p-2" title="Modifier">
                            ✏️
                        </a>
                    </div>
                    
                    <div class="text-muted">
                        <c:choose>
                            <c:when test="${not empty candidat.bio}">
                                <p style="white-space: pre-line; color: #191919;">${candidat.bio}</p>
                            </c:when>
                            <c:otherwise>
                                <p class="text-secondary fst-italic">Vous n'avez pas encore ajouté de biographie. Parlez de vos expériences pour attirer les recruteurs.</p>
                                <a href="profile/edit" class="btn btn-link p-0 text-decoration-none fw-bold" style="color:#6f42c1;">Ajouter une bio</a>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <div class="section-card">
                    <h2 class="section-title">Tableau de bord</h2>
                    <div class="row text-center">
                        <div class="col-6 border-end">
                            <h3 class="fw-bold text-primary m-0">0</h3>
                            <small class="text-muted">Vues du profil</small>
                        </div>
                        
                        <div class="col-6">
                            <a href="${pageContext.request.contextPath}/candidate/applications" class="text-decoration-none">
                                <h3 class="fw-bold text-primary m-0">Suivre</h3>
                                <small class="text-muted">Mes candidatures</small>
                            </a>
                        </div>
                    </div>
                </div>

            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>