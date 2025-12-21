<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %> 

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>${not empty offre.id ? 'Modifier' : 'Créer'} une offre | JobRecruit</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    
    <style>
        body { background-color: #f3f2ef; }
        .form-card {
            background: white;
            border-radius: 8px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
            border: 1px solid #e0e0e0;
            overflow: hidden;
        }
        .form-header {
            background-color: white;
            padding: 20px 30px;
            border-bottom: 1px solid #e0e0e0;
        }
        .form-label { font-weight: 600; color: #444; font-size: 0.9rem; }
        .form-control:focus, .form-select:focus {
            border-color: #6f42c1;
            box-shadow: 0 0 0 0.2rem rgba(111, 66, 193, 0.25);
        }
    </style>
</head>
<body>

    <nav class="navbar navbar-expand-lg navbar-light bg-white border-bottom fixed-top">
        <div class="container">
            <a class="navbar-brand fw-bold" href="${pageContext.request.contextPath}/entreprise/dashboard" style="color:#6f42c1;">
                JobRecruit<span class="text-dark"> Recruiter</span>
            </a>
            <div class="d-flex">
                 <a href="${pageContext.request.contextPath}/auth?action=logout" class="btn btn-outline-secondary btn-sm rounded-pill">Déconnexion</a>
            </div>
        </div>
    </nav>

    <div class="container" style="margin-top: 100px; margin-bottom: 50px;">
        <div class="row justify-content-center">
            <div class="col-lg-8">
                
                <c:if test="${not empty error}">
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        <strong>Erreur !</strong> <c:out value="${error}" />
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                </c:if>

                <div class="form-card">
                    <div class="form-header d-flex justify-content-between align-items-center">
                        <h4 class="m-0 fw-bold text-dark">
                            ${not empty offre.id ? 'Modifier l\'offre' : 'Publier une nouvelle offre'}
                        </h4>
                        <a href="${pageContext.request.contextPath}/entreprise/dashboard" class="text-decoration-none text-muted small">✕ Annuler</a>
                    </div>

                    <div class="p-4 p-md-5">
                        <form action="${pageContext.request.contextPath}/entreprise/offer/save" method="post">
                            
                            <input type="hidden" name="id" value="${offer != null ? offer.id : ''}">

                            <div class="mb-4">
                                <label class="form-label">Intitulé du poste <span class="text-danger">*</span></label>
                                <input type="text" class="form-control form-control-lg" name="titre" 
                                       value="${offre.titre}" placeholder="Ex: Développeur Java Senior" required>
                            </div>

                            <div class="row mb-4">
                                <div class="col-md-6 mb-3 mb-md-0">
                                    <label class="form-label">Type de contrat</label>
                                    <select class="form-select" name="typeContrat">
                                        <option value="" disabled ${empty offre.typeContrat ? 'selected' : ''}>Choisir...</option>
                                        <c:set var="types" value="${{'CDI', 'CDD', 'Freelance', 'Stage', 'Alternance'}}" />
                                        <c:forEach items="${types}" var="type">
                                            <option value="${type}" ${offre.typeContrat == type ? 'selected' : ''}>${type}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label">Salaire mensuel (DH)</label>
                                    <div class="input-group">
                                        <input type="number" class="form-control" name="salaire" 
                                               value="${offre.salaire}" placeholder="Ex: 15000" min="0" step="0.01">
                                        <span class="input-group-text text-muted">DH</span>
                                    </div>
                                </div>
                            </div>

                            <div class="mb-4">
                                <label class="form-label">Lieu de travail</label>
                                <input type="text" class="form-control" name="localisation" 
                                       value="${offre.localisation}" placeholder="Ex: Casablanca, Hybride...">
                            </div>

                            <div class="mb-4">
                                <label class="form-label">Description du poste <span class="text-danger">*</span></label>
                                <textarea class="form-control" name="description" rows="8" 
                                          placeholder="Décrivez les responsabilités..." required><c:out value="${offre.description}"/></textarea>
                            </div>

                            <hr class="my-4">
                            
                            <div class="d-flex justify-content-end gap-3">
                                <a href="${pageContext.request.contextPath}/entreprise/dashboard" class="btn btn-outline-secondary rounded-pill px-4">
                                    Annuler
                                </a>
                                <button type="submit" class="btn btn-primary rounded-pill px-5 fw-bold">
                                    ${not empty offre.id ? 'Enregistrer' : 'Publier l\'offre'}
                                </button>
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