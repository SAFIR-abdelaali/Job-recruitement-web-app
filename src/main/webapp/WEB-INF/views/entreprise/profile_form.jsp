<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Modifier le profil Entreprise | JobRecruit</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    
    <style>
        body { background-color: #f3f2ef; }
        
        .edit-card {
            background: white;
            border-radius: 8px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
            border: 1px solid #e0e0e0;
            overflow: hidden;
        }

        .form-section-title {
            font-size: 0.85rem;
            text-transform: uppercase;
            color: #666;
            font-weight: 700;
            margin-bottom: 15px;
            border-bottom: 1px solid #eee;
            padding-bottom: 5px;
            margin-top: 25px;
            letter-spacing: 0.5px;
        }

        .logo-preview-container {
            position: relative;
            display: inline-block;
        }

        .logo-preview {
            width: 120px;
            height: 120px;
            object-fit: contain;
            border: 1px solid #dee2e6;
            border-radius: 50%; /* Circle looks more modern for profiles */
            background: white;
            padding: 4px;
            transition: all 0.3s ease;
        }
        
        /* Hover effect to hint it's editable */
        .logo-label:hover .logo-preview {
            opacity: 0.7;
            border-color: #6f42c1;
            cursor: pointer;
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
            <div class="col-md-8 col-lg-7">
                
                <c:if test="${not empty error}">
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        <c:out value="${error}" />
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>
                <c:if test="${not empty success}">
                    <div class="alert alert-success alert-dismissible fade show" role="alert">
                        <c:out value="${success}" />
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>

                <div class="edit-card">
                    <div class="card-body p-4 p-md-5">
                        
                        <div class="d-flex justify-content-between align-items-center mb-4">
                            <h4 class="m-0 fw-bold text-dark">Profil de l'entreprise</h4>
                            <a href="${pageContext.request.contextPath}/entreprise/dashboard" class="text-decoration-none small text-muted">✕ Annuler</a>
                        </div>

                        <form action="${pageContext.request.contextPath}/entreprise/profile/save" method="post" enctype="multipart/form-data">
                            
                            <div class="text-center mb-5">
                                <label class="logo-label position-relative" title="Cliquez pour changer le logo">
                                    
                                    <c:choose>
                                        <c:when test="${not empty entreprise.logo}">
                                            <img id="logoPreviewImg" src="${pageContext.request.contextPath}/uploads/${entreprise.logo}" class="logo-preview shadow-sm">
                                        </c:when>
                                        <c:otherwise>
                                            <img id="logoPreviewImg" src="https://ui-avatars.com/api/?name=${entreprise.nomEntreprise}&background=random&size=120&rounded=true" class="logo-preview shadow-sm">
                                        </c:otherwise>
                                    </c:choose>

                                    <input type="file" id="logoInput" name="logo" accept="image/*" style="display: none;" onchange="previewImage(event)">
                                    
                                    <div class="position-absolute bottom-0 end-0 bg-white rounded-circle p-1 border shadow-sm" style="width: 32px; height: 32px;">
                                        📷
                                    </div>
                                </label>
                                <div class="form-text mt-2">Cliquez sur l'image pour modifier (JPG, PNG max 2Mo)</div>
                            </div>

                            <div class="form-section-title">Identité</div>

                            <div class="mb-3">
                                <label class="form-label text-secondary small fw-bold">Nom de l'entreprise <span class="text-danger">*</span></label>
                                <input type="text" class="form-control" name="nomEntreprise" value="${entreprise.nomEntreprise}" required>
                            </div>

                            <div class="mb-3">
                                <label class="form-label text-secondary small fw-bold">Secteur d'activité <span class="text-danger">*</span></label>
                                <input type="text" class="form-control" name="secteurActivite" value="${entreprise.secteurActivite}" placeholder="Ex: Informatique, Finance..." required>
                            </div>

                            <div class="mb-3">
                                <label class="form-label text-secondary small fw-bold">Adresse / Siège Social</label>
                                <input type="text" class="form-control" name="adresse" value="${entreprise.adresse}" placeholder="Adresse complète">
                            </div>

                            <div class="form-section-title">Présentation</div>

                            <div class="mb-4">
                                <label class="form-label text-secondary small fw-bold">À propos de l'entreprise</label>
                                <textarea class="form-control" name="description" rows="6" 
                                          placeholder="Décrivez votre culture, vos valeurs et ce que vous faites..."><c:out value="${entreprise.description}"/></textarea>
                                <div class="form-text text-muted">Cette description sera visible par les candidats sur vos offres.</div>
                            </div>

                            <hr class="my-4">
                            
                            <div class="d-flex justify-content-end gap-2">
                                <a href="${pageContext.request.contextPath}/entreprise/dashboard" class="btn btn-outline-secondary rounded-pill px-4">Annuler</a>
                                <button type="submit" class="btn btn-primary rounded-pill px-4 fw-bold">Enregistrer</button>
                            </div>
                        </form>
                        
                    </div>
                </div>

            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
        function previewImage(event) {
            const input = event.target;
            if (input.files && input.files[0]) {
                const reader = new FileReader();
                reader.onload = function(e) {
                    const img = document.getElementById('logoPreviewImg');
                    img.src = e.target.result;
                }
                reader.readAsDataURL(input.files[0]);
            }
        }
    </script>
</body>
</html>