<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Postuler - ${offre.titre}</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    
    <style>
        /* Ajustements locaux pour la zone de résumé de l'offre */
        .offer-summary-card {
            background-color: #f8f9fa;
            border-left: 5px solid #6f42c1; /* Bordure Violette */
            padding: 20px;
            border-radius: 5px;
        }
        .form-section-title {
            font-size: 0.9rem;
            text-transform: uppercase;
            letter-spacing: 1px;
            color: #6f42c1;
            margin-top: 20px;
            margin-bottom: 10px;
            font-weight: bold;
            border-bottom: 1px solid #eee;
            padding-bottom: 5px;
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
	                    <a class="nav-link" href="${pageContext.request.contextPath}/candidate/profile">Mon Profil</a>
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
                
                <div class="card shadow-sm border-0">
                    <div class="card-body p-4">
                        
                        <h2 class="h4 mb-4 fw-bold text-dark">Finalisez votre candidature</h2>

                        <div class="offer-summary-card mb-4">
                            <h4 class="h5 mb-2" style="color:#6f42c1;">${offre.titre}</h4>
                            <div class="text-muted small">
                                <span class="fw-bold text-dark">${offre.entreprise.nomEntreprise}</span> • ${offre.localisation}
                            </div>
                        </div>

                        <form action="${pageContext.request.contextPath}/candidate/apply/save" method="post" enctype="multipart/form-data">
                            
                            <input type="hidden" name="offerId" value="${offre.id}">

                            <div class="form-section-title">Vos Documents</div>
                            
                            <div class="mb-3">
                                <label class="form-label fw-bold text-secondary small">CV (PDF uniquement) <span class="text-danger">*</span></label>
                                <input type="file" class="form-control" name="cv" accept=".pdf" required>
                            </div>

                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label class="form-label fw-bold text-secondary small">Baccalauréat <span class="text-danger">*</span></label>
                                    <input type="file" class="form-control" name="bac" accept=".pdf, .jpg, .jpeg, .png" required>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label class="form-label fw-bold text-secondary small">Diplôme (Supérieur) <span class="text-danger">*</span></label>
                                    <input type="file" class="form-control" name="diplome" accept=".pdf, .jpg, .jpeg, .png" required>
                                </div>
                            </div>

                            <div class="mb-4">
                                <label class="form-label fw-bold text-secondary small">Pièce d'identité (CIN) <span class="text-danger">*</span></label>
                                <input type="file" class="form-control" name="cin" accept=".pdf, .jpg, .jpeg, .png" required>
                                <div class="form-text text-muted">Formats acceptés : PDF, JPG, PNG.</div>
                            </div>

                            <div class="form-section-title">Motivation</div>

                            <div class="mb-4">
                                <label class="form-label fw-bold text-secondary small">Lettre de motivation <span class="text-danger">*</span></label>
                                <textarea class="form-control" name="lettreMotivation" rows="5" 
                                    placeholder="Présentez-vous brièvement et expliquez pourquoi ce poste vous correspond..." required></textarea>
                            </div>

                            <div class="d-flex justify-content-end gap-3 pt-2">
                                <a href="${pageContext.request.contextPath}/candidate/offers" class="btn btn-outline-secondary rounded-pill px-4">Annuler</a>
                                <button type="submit" class="btn btn-primary rounded-pill px-4 fw-bold">Envoyer ma candidature</button>
                            </div>
                        </form>

                    </div>
                </div>

            </div>
        </div>
    </div>

</body>
</html>