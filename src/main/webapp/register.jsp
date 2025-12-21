<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>S'inscrire | JobRecruit</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    
    <style>
        body { 
            background-color: #f3f2ef; 
            padding-top: 40px;
            padding-bottom: 40px;
        }
        .register-brand {
            color: #6f42c1;
            font-weight: bold;
            font-size: 2rem;
            text-decoration: none;
            display: block;
            margin-bottom: 20px;
        }
        .card-register {
            border: none;
            border-radius: 10px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
            background: white;
        }
        .form-section-title {
            font-size: 0.9rem;
            text-transform: uppercase;
            color: #666;
            font-weight: 600;
            margin-bottom: 15px;
            border-bottom: 1px solid #eee;
            padding-bottom: 5px;
        }
    </style>
    
    <script>
        function toggleFields() {
            var role = document.getElementById("role").value;
            var divEnt = document.getElementById("entrepriseFields");
            var divCand = document.getElementById("candidateFields");

            if (role === 'ENTREPRISE') {
                divEnt.style.display = 'block';
                divCand.style.display = 'none';
                
                // Active le "required" pour les champs visibles uniquement
                enableInputs(divEnt, true);
                enableInputs(divCand, false);
            } else {
                divEnt.style.display = 'none';
                divCand.style.display = 'block';
                
                enableInputs(divEnt, false);
                enableInputs(divCand, true);
            }
        }

        function enableInputs(container, shouldEnable) {
            var inputs = container.getElementsByTagName("input");
            for (var i = 0; i < inputs.length; i++) {
                if (shouldEnable) {
                    inputs[i].setAttribute("required", "");
                } else {
                    inputs[i].removeAttribute("required");
                }
            }
        }
    </script>
</head>
<body>

    <div class="container">
        <div class="row justify-content-center">
            <div class="col-md-8 col-lg-6">
                
                <div class="text-center">
                    <a href="${pageContext.request.contextPath}/index.jsp" class="register-brand">JobRecruit<span style="color:#212529;">.</span></a>
                    <h2 class="h4 mb-4">Tirez le meilleur parti de votre vie professionnelle</h2>
                </div>

                <c:if test="${not empty param.error}">
                    <div class="alert alert-danger text-center">
                        <c:choose>
                            <c:when test="${param.error == 'email_exists_or_error'}">
                                Cet email est déjà utilisé ou une erreur technique est survenue.
                            </c:when>
                            <c:when test="${param.error == 'invalid_role'}">
                                Veuillez sélectionner un rôle valide.
                            </c:when>
                            <c:otherwise>
                                Une erreur est survenue lors de l'inscription.
                            </c:otherwise>
                        </c:choose>
                    </div>
                </c:if>

                <div class="card card-register p-4">
                    
                    <form action="${pageContext.request.contextPath}/auth" method="post">
                        <input type="hidden" name="action" value="register">

                        <div class="mb-4">
                            <label class="form-label text-secondary small">Type de compte</label>
                            <select class="form-select form-select-lg" name="role" id="role" onchange="toggleFields()" required>
                                <option value="CANDIDATE">Candidat (Je cherche un emploi)</option>
                                <option value="ENTREPRISE">Entreprise (Je recrute)</option>
                            </select>
                        </div>

                        <div class="mb-3">
                            <label class="form-label text-secondary small">Email</label>
                            <input type="email" class="form-control" name="email" required placeholder="votre@email.com">
                        </div>
                        <div class="mb-3">
                            <label class="form-label text-secondary small">Mot de passe (6+ caractères)</label>
                            <input type="password" class="form-control" name="password" required minlength="6">
                        </div>

                        <div id="candidateFields">
                            <div class="form-section-title mt-4">Vos informations</div>
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label class="form-label text-secondary small">Prénom</label>
                                    <input type="text" class="form-control" name="prenom">
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label class="form-label text-secondary small">Nom</label>
                                    <input type="text" class="form-control" name="nom">
                                </div>
                            </div>
                            <div class="mb-3">
                                <label class="form-label text-secondary small">Titre du profil</label>
                                <input type="text" class="form-control" name="titreProfil" placeholder="Ex: Développeur Fullstack, Commercial...">
                            </div>
                        </div>

                        <div id="entrepriseFields" style="display:none;">
                            <div class="form-section-title mt-4">Détails de l'entreprise</div>
                            <div class="mb-3">
                                <label class="form-label text-secondary small">Nom de l'entreprise</label>
                                <input type="text" class="form-control" name="nomEntreprise">
                            </div>
                            <div class="mb-3">
                                <label class="form-label text-secondary small">Secteur d'activité</label>
                                <input type="text" class="form-control" name="secteurActivite" placeholder="Ex: Informatique, Banque, Industrie...">
                            </div>
                            <div class="mb-3">
                                <label class="form-label text-secondary small">Adresse / Siège social</label>
                                <input type="text" class="form-control" name="adresse" placeholder="Ex: Casablanca, Maroc">
                            </div>
                        </div>

                        <div class="d-grid gap-2 mt-4">
                            <p class="text-center small text-muted mb-2">En cliquant sur Accepter et s'inscrire, vous acceptez les <a href="#" style="color:#6f42c1;">Conditions d'utilisation</a>.</p>
                            <button type="submit" class="btn btn-primary btn-lg rounded-pill fw-bold">Accepter et s'inscrire</button>
                        </div>
                    </form>
                </div>
                
                <div class="text-center mt-4">
                    <p>Déjà sur JobRecruit ? <a href="${pageContext.request.contextPath}/index.jsp" class="fw-bold text-decoration-none" style="color:#6f42c1;">S'identifier</a></p>
                </div>

            </div>
        </div>
    </div>

    <script>toggleFields();</script>

</body>
</html>