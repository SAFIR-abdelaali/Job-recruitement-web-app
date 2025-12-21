<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Modifier mon profil | JobRecruit</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    
    <style>
        body { background-color: #f3f2ef; }
        
        .edit-card {
            background: white;
            border-radius: 10px;
            border: none;
            box-shadow: 0 4px 12px rgba(0,0,0,0.05);
        }
        
        .form-section-title {
            font-size: 0.9rem;
            text-transform: uppercase;
            color: #666;
            font-weight: 600;
            margin-bottom: 15px;
            border-bottom: 1px solid #eee;
            padding-bottom: 5px;
            margin-top: 20px;
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

    <div class="container" style="margin-top: 100px; margin-bottom: 50px;">
        <div class="row justify-content-center">
            <div class="col-md-8 col-lg-7">
                
                <div class="card edit-card">
                    <div class="card-body p-4">
                        
                        <div class="d-flex justify-content-between align-items-center mb-4">
                            <h4 class="m-0 fw-bold">Modifier le profil</h4>
                            <a href="${pageContext.request.contextPath}/candidate/profile" class="text-decoration-none small text-muted">← Retour au profil</a>
                        </div>

                        <form action="${pageContext.request.contextPath}/candidate/profile/save" method="post" enctype="multipart/form-data">
                            
                            <div class="mb-4 text-center">
                                <div class="mb-2">
                                    <c:choose>
                                        <c:when test="${not empty candidat.photo}">
                                            <img src="${pageContext.request.contextPath}/uploads/${candidat.photo}" 
                                                 class="rounded-circle shadow-sm mb-2" alt="Avatar"
                                                 style="width: 100px; height: 100px; object-fit: cover;">
                                        </c:when>
                                        <c:otherwise>
                                            <img src="https://ui-avatars.com/api/?name=${candidat.prenom}+${candidat.nom}&background=random&size=100" 
                                                 class="rounded-circle shadow-sm mb-2" alt="Avatar">
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                <label class="btn btn-sm btn-outline-primary rounded-pill">
                                    📸 Changer la photo
                                    <input type="file" name="photo" accept="image/*" style="display: none;">
                                </label>
                            </div>

                            <div class="form-section-title">Informations Personnelles</div>
                            
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label class="form-label text-secondary small fw-bold">Prénom</label>
                                    <input type="text" class="form-control" name="prenom" value="${candidat.prenom}" required>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label class="form-label text-secondary small fw-bold">Nom</label>
                                    <input type="text" class="form-control" name="nom" value="${candidat.nom}" required>
                                </div>
                            </div>

                            <div class="mb-3">
                                <label class="form-label text-secondary small fw-bold">Email</label>
                                <input type="email" class="form-control" name="email" value="${candidat.email}" required>
                            </div>

                            <div class="form-section-title">Parcours Professionnel</div>

                            <div class="mb-3">
                                <label class="form-label text-secondary small fw-bold">Titre du Profil (Headline)</label>
                                <input type="text" class="form-control" name="titreProfil" value="${candidat.titreProfil}" placeholder="Ex: Développeur Fullstack Java/Angular">
                            </div>

                            <div class="mb-4">
                                <label class="form-label text-secondary small fw-bold">Bio / Résumé</label>
                                <textarea class="form-control" name="bio" rows="6" placeholder="Parlez de vos expériences, vos compétences et ce que vous recherchez...">${candidat.bio}</textarea>
                                <div class="form-text text-muted text-end">Soyez concis et percutant.</div>
                            </div>
                            
                            <hr>
                            <div class="d-flex justify-content-end gap-2">
                                <a href="${pageContext.request.contextPath}/candidate/profile" class="btn btn-outline-secondary rounded-pill px-4">Annuler</a>
                                <button type="submit" class="btn btn-primary rounded-pill px-4 fw-bold">Enregistrer les modifications</button>
                            </div>

                        </form>
                    </div>
                </div>

            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>