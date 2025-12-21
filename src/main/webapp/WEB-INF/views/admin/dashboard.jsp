<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Dashboard Admin | JobRecruit</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    
    <style>
        body { background-color: #f8f9fa; }
        .card-stat { transition: transform 0.2s; cursor: pointer; }
        .card-stat:hover { transform: translateY(-5px); }
        
        /* Sidebar Styles */
        .sidebar { min-height: 100vh; background-color: #212529; color: white; width: 250px; }
        .nav-link { color: rgba(255,255,255,.75); margin-bottom: 5px; }
        .nav-link:hover, .nav-link.active { color: white; background-color: rgba(255,255,255,0.1); border-radius: 5px; }
        .nav-link.text-danger:hover { background-color: rgba(220, 53, 69, 0.1); color: #dc3545 !important; }
        
        /* Table Styles */
        .table-action-btn { width: 32px; height: 32px; display: inline-flex; align-items: center; justify-content: center; }
    </style>
</head>
<body>

    <div class="d-flex">
        <div class="sidebar p-3 flex-shrink-0 fixed-start">
            <a href="#" class="d-flex align-items-center mb-3 mb-md-0 me-md-auto text-white text-decoration-none">
                <i class="bi bi-shield-lock-fill fs-4 me-2"></i>
                <span class="fs-4 fw-bold">AdminPanel</span>
            </a>
            <hr>
            <ul class="nav nav-pills flex-column mb-auto">
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/admin/dashboard" class="nav-link active">
                        <i class="bi bi-speedometer2 me-2"></i>Dashboard
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/admin/users/pending" class="nav-link position-relative">
                        <i class="bi bi-person-check me-2"></i>Validations
                        <c:if test="${pendingCount > 0}">
                            <span class="position-absolute top-50 end-0 translate-middle-y badge rounded-pill bg-danger me-2">
                                ${pendingCount}
                            </span>
                        </c:if>
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/admin/applications" class="nav-link position-relative">
                        <i class="bi bi-file-earmark-text me-2"></i>Candidatures
                        <c:if test="${notifApps > 0}">
                            <span class="position-absolute top-50 end-0 translate-middle-y badge rounded-pill bg-warning text-dark me-2">
                                ${notifApps}
                            </span>
                        </c:if>
                    </a>
                </li>
                <li class="mt-4 border-top pt-2">
                    <a href="${pageContext.request.contextPath}/auth?action=logout" class="nav-link text-danger fw-bold">
                        <i class="bi bi-box-arrow-right me-2"></i>Déconnexion
                    </a>
                </li>
            </ul>
        </div>

        <div class="flex-grow-1">
            
            <nav class="navbar navbar-light bg-white shadow-sm px-4 py-3 sticky-top">
                <div class="d-flex justify-content-between align-items-center w-100">
                    <h4 class="mb-0 text-secondary fw-bold">Vue d'ensemble</h4>
                    <div class="d-flex align-items-center">
                        <span class="badge bg-dark rounded-pill px-3 py-2">Administrateur</span>
                    </div>
                </div>
            </nav>

            <div class="container-fluid p-4">
                
                <c:if test="${param.msg == 'deleted'}">
                    <div class="alert alert-success alert-dismissible fade show shadow-sm border-success">
                        <i class="bi bi-check-circle-fill me-2"></i>Utilisateur et toutes ses données supprimés avec succès.
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>
                <c:if test="${param.error == 'delete_failed'}">
                    <div class="alert alert-danger alert-dismissible fade show shadow-sm">
                        <i class="bi bi-exclamation-triangle-fill me-2"></i>Erreur critique lors de la suppression. Vérifiez les logs.
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>

                <div class="row g-4 mb-5">
                    <div class="col-md-3">
                        <div class="card card-stat border-0 shadow-sm border-start border-4 border-primary h-100">
                            <div class="card-body">
                                <h6 class="text-muted text-uppercase small fw-bold">Candidats Actifs</h6>
                                <h2 class="mb-0 text-primary fw-bold">${candidats.size()}</h2>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="card card-stat border-0 shadow-sm border-start border-4 border-info h-100">
                            <div class="card-body">
                                <h6 class="text-muted text-uppercase small fw-bold">Entreprises Actives</h6>
                                <h2 class="mb-0 text-info fw-bold">${entreprises.size()}</h2>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="card card-stat border-0 shadow-sm border-start border-4 border-warning h-100">
                            <div class="card-body">
                                <h6 class="text-muted text-uppercase small fw-bold">Comptes à Valider</h6>
                                <h2 class="mb-0 text-warning fw-bold">${pendingCount}</h2>
                                <a href="${pageContext.request.contextPath}/admin/users/pending" class="stretched-link"></a>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="card card-stat border-0 shadow-sm border-start border-4 border-success h-100">
                            <div class="card-body">
                                <h6 class="text-muted text-uppercase small fw-bold">Nouvelles Candidatures</h6>
                                <h2 class="mb-0 text-success fw-bold">${notifApps}</h2>
                                <a href="${pageContext.request.contextPath}/admin/applications" class="stretched-link"></a>
                            </div>
                        </div>
                    </div>
                </div>

                <h5 class="mb-3 text-secondary border-bottom pb-2">Gestion des Utilisateurs Vérifiés</h5>

                <div class="card border-0 shadow-sm mb-4">
                    <div class="card-header bg-white py-3 border-bottom-0">
                        <div class="d-flex align-items-center text-primary">
                            <i class="bi bi-people-fill fs-5 me-2"></i>
                            <h6 class="m-0 fw-bold">Liste des Candidats</h6>
                        </div>
                    </div>
                    <div class="card-body p-0">
                        <div class="table-responsive">
                            <table class="table table-hover align-middle mb-0">
                                <thead class="table-light text-secondary small text-uppercase">
                                    <tr>
                                        <th class="ps-4" style="width: 5%;">ID</th>
                                        <th style="width: 30%;">Nom & Prénom</th>
                                        <th style="width: 35%;">Email</th>
                                        <th style="width: 15%;">Statut</th>
                                        <th class="text-end pe-4" style="width: 15%;">Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach items="${candidats}" var="c">
                                        <tr>
                                            <td class="ps-4 text-muted small">#${c.id}</td>
                                            <td class="fw-bold text-dark">${c.nom} ${c.prenom}</td>
                                            <td class="text-muted">${c.email}</td>
                                            <td><span class="badge bg-success bg-opacity-10 text-success border border-success px-2 py-1">Vérifié</span></td>
                                            <td class="text-end pe-4">
                                                <a href="${pageContext.request.contextPath}/admin/users/delete?id=${c.id}" 
                                                   class="btn btn-outline-danger btn-sm rounded-pill px-3"
                                                   onclick="return confirm('⚠️ ATTENTION : Supprimer ce candidat effacera DÉFINITIVEMENT :\n\n- Son compte\n- Toutes ses candidatures\n- Tous ses messages\n\nConfirmer la suppression ?');">
                                                    <i class="bi bi-trash-fill me-1"></i> Supprimer
                                                </a>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                    <c:if test="${empty candidats}">
                                        <tr><td colspan="5" class="text-center py-4 text-muted fst-italic">Aucun candidat actif pour le moment.</td></tr>
                                    </c:if>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>

                <div class="card border-0 shadow-sm">
                    <div class="card-header bg-white py-3 border-bottom-0">
                        <div class="d-flex align-items-center text-info">
                            <i class="bi bi-buildings-fill fs-5 me-2"></i>
                            <h6 class="m-0 fw-bold">Liste des Entreprises</h6>
                        </div>
                    </div>
                    <div class="card-body p-0">
                        <div class="table-responsive">
                            <table class="table table-hover align-middle mb-0">
                                <thead class="table-light text-secondary small text-uppercase">
                                    <tr>
                                        <th class="ps-4" style="width: 5%;">ID</th>
                                        <th style="width: 30%;">Entreprise</th>
                                        <th style="width: 35%;">Contact</th>
                                        <th style="width: 15%;">Statut</th>
                                        <th class="text-end pe-4" style="width: 15%;">Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach items="${entreprises}" var="e">
                                        <tr>
                                            <td class="ps-4 text-muted small">#${e.id}</td>
                                            <td>
                                                <div class="fw-bold text-dark">${e.nomEntreprise}</div>
                                                <div class="small text-muted"><i class="bi bi-geo-alt me-1"></i>${e.adresse}</div>
                                            </td>
                                            <td class="text-muted">${e.email}</td>
                                            <td><span class="badge bg-success bg-opacity-10 text-success border border-success px-2 py-1">Vérifié</span></td>
                                            <td class="text-end pe-4">
                                                <a href="${pageContext.request.contextPath}/admin/users/delete?id=${e.id}" 
                                                   class="btn btn-outline-danger btn-sm rounded-pill px-3"
                                                   onclick="return confirm('⚠️ DANGER CRITIQUE :\n\nSupprimer cette entreprise effacera :\n- Le compte entreprise\n- TOUTES les offres publiées\n- TOUTES les candidatures reçues\n- TOUS les messages associés\n\nÊtes-vous sûr à 100% ?');">
                                                    <i class="bi bi-trash-fill me-1"></i> Supprimer
                                                </a>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                    <c:if test="${empty entreprises}">
                                        <tr><td colspan="5" class="text-center py-4 text-muted fst-italic">Aucune entreprise active pour le moment.</td></tr>
                                    </c:if>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>

            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>