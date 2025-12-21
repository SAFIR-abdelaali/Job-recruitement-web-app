<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>S'identifier | JobRecruit</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    
    <style>
        body { 
            background-color: #f3f2ef; 
            display: flex;
            align-items: center;
            justify-content: center;
            min-height: 100vh;
            padding-top: 0;
        }
        .login-brand {
            color: #6f42c1;
            font-weight: bold;
            font-size: 2rem;
            text-decoration: none;
            display: block;
            margin-bottom: 20px;
        }
        .card-login {
            border: none;
            border-radius: 10px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
            background: white;
        }
        .form-control {
            height: 48px;
            border-radius: 5px;
        }
    </style>
</head>
<body>

    <div class="container">
        <div class="row justify-content-center">
            <div class="col-md-5 col-lg-4">
                
                <div class="text-center">
                    <a href="${pageContext.request.contextPath}/index.jsp" class="login-brand">JobRecruit<span style="color:#212529;">.</span></a>
                </div>

                <div class="card card-login p-4">
                    <div class="mb-4">
                        <h4 class="fw-bold">S'identifier</h4>
                        <p class="text-secondary small">Restez informé sur votre monde professionnel.</p>
                    </div>

                    <c:if test="${not empty param.error}">
                        <div class="alert alert-danger py-2 small">
                            <c:choose>
                                <c:when test="${param.error == 'invalid_credentials'}">
                                    Email ou mot de passe incorrect.
                                </c:when>
                                <c:when test="${param.error == 'account_not_verified'}">
                                    <strong>Compte en attente !</strong> Votre compte doit être validé par un administrateur avant de pouvoir vous connecter.
                                </c:when>
                                <c:when test="${param.error == 'invalid_role'}">
                                    Rôle utilisateur invalide.
                                </c:when>
                                <c:otherwise>
                                    Une erreur est survenue. Veuillez réessayer.
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </c:if>

                    <c:if test="${not empty param.msg}">
                        <div class="alert alert-success py-2 small">
                            <c:choose>
                                <c:when test="${param.msg == 'logged_out'}">
                                    Vous avez été déconnecté avec succès.
                                </c:when>
                                <c:when test="${param.msg == 'registered_pending_validation'}">
                                    <strong>Inscription réussie !</strong> Votre compte est en cours de validation par l'administration. Vous pourrez vous connecter une fois validé.
                                </c:when>
                                <c:otherwise>
                                    Action effectuée avec succès.
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </c:if>
                    <form action="${pageContext.request.contextPath}/auth" method="post">
                        <input type="hidden" name="action" value="login">

                        <div class="mb-3">
                            <input type="email" class="form-control" id="email" name="email" required placeholder="Email">
                        </div>
                        
                        <div class="mb-3">
                            <input type="password" class="form-control" id="password" name="password" required placeholder="Mot de passe">
                        </div>
                        
                        <div class="mb-3">
                            <a href="#" class="text-decoration-none small fw-bold" style="color:#6f42c1;">Mot de passe oublié ?</a>
                        </div>

                        <div class="d-grid gap-2">
                            <button type="submit" class="btn btn-primary btn-lg rounded-pill fw-bold">S'identifier</button>
                        </div>
                    </form>
                </div>

                <div class="text-center mt-4">
                    <p class="small text-secondary">Nouveau sur JobRecruit ? 
                        <a href="${pageContext.request.contextPath}/register.jsp" class="fw-bold text-decoration-none" style="color:#6f42c1;">S'inscrire</a>
                    </p>
                </div>

            </div>
        </div>
    </div>

</body>
</html>