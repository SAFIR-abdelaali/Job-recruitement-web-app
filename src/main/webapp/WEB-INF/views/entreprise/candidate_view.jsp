<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Profil Candidat #${candidat.id} - JobRecruit</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    
    <style>
        body { background-color: #f3f2ef; }

        /* Carte de Profil Principale */
        .profile-full-card {
            background: white;
            border-radius: 8px;
            overflow: hidden;
            border: 1px solid #e0e0e0;
            box-shadow: 0 4px 12px rgba(0,0,0,0.05);
            margin-bottom: 20px;
        }

        /* Bannière Neutre (Gris professionnel) pour remplacer le violet perso */
        .profile-cover {
            background: linear-gradient(135deg, #e0e0e0 0%, #f5f5f5 100%);
            height: 150px;
            width: 100%;
        }

        /* Avatar Centré Anonyme */
        .profile-main-avatar {
            width: 140px;
            height: 140px;
            border-radius: 50%;
            border: 5px solid white;
            margin-top: -70px;
            background: #f8f9fa;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 4rem;
            color: #6c757d;
        }

        .profile-name { font-weight: 700; color: #191919; margin-top: 15px; }
        .profile-headline { font-size: 1.1rem; color: #666; margin-bottom: 5px; }
        .profile-meta { font-size: 0.9rem; color: #666; }

        /* Section À Propos */
        .about-section {
            padding: 30px;
            border-top: 1px solid #f0f0f0;
        }
        
        .section-title {
            font-size: 1.1rem;
            font-weight: 600;
            color: #191919;
            margin-bottom: 15px;
        }

        .bio-text {
            color: #191919;
            line-height: 1.6;
            white-space: pre-line;
        }
    </style>
</head>
<body>

    <nav class="navbar navbar-expand-lg navbar-light bg-white border-bottom fixed-top">
        <div class="container">
            <a class="navbar-brand fw-bold" href="../dashboard" style="color:#6f42c1;">
                JobRecruit<span class="text-dark"> Recruiter</span>
            </a>
            
            <div class="d-flex">
                 <a href="${pageContext.request.contextPath}/auth?action=logout" class="btn btn-outline-secondary btn-sm rounded-pill">Déconnexion</a>
            </div>
        </div>
    </nav>

    <div class="container" style="margin-top: 90px; margin-bottom: 50px;">
        
        <div class="mb-3">
            <a href="javascript:history.back()" class="text-decoration-none fw-bold text-secondary">
                ← Retour
            </a>
        </div>

        <div class="row justify-content-center">
            <div class="col-lg-9">
                
                <div class="profile-full-card">
                    <div class="profile-cover"></div>
                    
                    <div class="d-flex flex-column align-items-center px-4 pb-4">
                        
                        <div class="profile-main-avatar">
                            <i class="bi bi-person-fill"></i>
                        </div>

                        <h1 class="h3 profile-name">Candidat #${candidat.id}</h1>
                        <p class="profile-headline">
                            ${candidat.titreProfil != null ? candidat.titreProfil : 'Profil Candidat'}
                        </p>
                        
                        <div class="profile-meta mb-4">
                            <span class="badge bg-secondary">Profil Anonymisé</span>
                            <span class="ms-2">📅 Inscrit depuis : ${candidat.dateInscription}</span>
                        </div>

                        <div class="alert alert-info border-0 d-flex align-items-center">
                            <i class="bi bi-info-circle-fill me-2"></i>
                            <div>
                                <strong>Ce profil vous intéresse ?</strong><br>
                                Contactez l'administrateur pour organiser un entretien.
                            </div>
                        </div>
                    </div>

                    <div class="about-section">
                        <h3 class="section-title">À propos</h3>
                        <div class="bio-text">
                            <c:choose>
                                <c:when test="${not empty candidat.bio}">
                                    ${candidat.bio}
                                </c:when>
                                <c:otherwise>
                                    <span class="text-muted fst-italic">Ce candidat n'a pas encore ajouté de description détaillée.</span>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>

                    <div class="about-section bg-light">
                        <h3 class="section-title">Informations professionnelles</h3>
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <small class="text-muted d-block fw-bold uppercase">DISPONIBILITÉ</small>
                                <span class="text-success fw-bold">Immédiate</span>
                            </div>
                            <div class="col-md-6 mb-3">
                                <small class="text-muted d-block fw-bold uppercase">LANGUES</small>
                                <span>(Données non renseignées)</span>
                            </div>
                        </div>
                    </div>

                </div>

            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>