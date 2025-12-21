<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Espace Recruteur | JobRecruit</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    
    <style>
        body { background-color: #f3f2ef; }
        .nav-top { background: white; border-bottom: 1px solid #e0e0e0; height: 60px; }
        .stat-card { background: white; border-radius: 8px; border: 1px solid #e0e0e0; transition: 0.2s; }
        .stat-card:hover { transform: translateY(-3px); box-shadow: 0 4px 12px rgba(0,0,0,0.1); }
        .btn-create { background-color: #6f42c1; color: white; border-radius: 20px; padding: 6px 20px; font-weight: bold; }
        .btn-create:hover { background-color: #5a32a3; color: white; }
    </style>
</head>
<body>

    <nav class="navbar navbar-expand-lg nav-top fixed-top">
        <div class="container">
            <a class="navbar-brand fw-bold" href="#" style="color:#6f42c1;">JobRecruit<span class="text-dark"> Recruiter</span></a>
            
            <div class="d-flex align-items-center gap-3">
                <span class="text-muted small d-none d-md-block">Bonjour, ${sessionScope.user.nomEntreprise}</span>
                
                <a href="${pageContext.request.contextPath}/chat" class="btn btn-outline-primary border-0 position-relative me-2">
                    <i class="bi bi-chat-dots-fill fs-5"></i>
                    <span class="d-none d-md-inline ms-2">Messagerie</span>
                    
                    <c:if test="${globalUnreadCount > 0}">
                        <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger">
                            ${globalUnreadCount}
                            <span class="visually-hidden">nouveaux messages</span>
                        </span>
                    </c:if>
                </a>

                <a href="${pageContext.request.contextPath}/entreprise/profile/edit" class="btn btn-outline-secondary btn-sm rounded-pill">
                    <i class="fas fa-building"></i> Mon Profil
                </a>
                <a href="${pageContext.request.contextPath}/auth?action=logout" class="text-danger small text-decoration-none fw-bold">
                    <i class="fas fa-sign-out-alt"></i>
                </a>
            </div>
        </div>
    </nav>

    <div class="container" style="margin-top: 90px;">
        
        <c:if test="${param.msg == 'deleted'}">
            <div class="alert alert-success alert-dismissible fade show">Offre supprimée avec succès.<button type="button" class="btn-close" data-bs-dismiss="alert"></button></div>
        </c:if>
        <c:if test="${param.msg == 'saved'}">
            <div class="alert alert-success alert-dismissible fade show">Offre enregistrée avec succès.<button type="button" class="btn-close" data-bs-dismiss="alert"></button></div>
        </c:if>

        <div class="d-flex justify-content-between align-items-center mb-4">
            <h4 class="fw-bold text-dark m-0">Tableau de bord</h4>
            <a href="${pageContext.request.contextPath}/entreprise/offer/new" class="btn btn-create shadow-sm">
                <i class="fas fa-plus me-1"></i> Publier une offre
            </a>
        </div>

        <div class="row mb-4">
            <div class="col-md-4">
                <div class="p-3 stat-card">
                    <div class="d-flex justify-content-between">
                        <div>
                            <small class="text-muted fw-bold text-uppercase">Offres Actives</small>
                            <h3 class="fw-bold m-0 mt-1">${offres != null ? offres.size() : 0}</h3> 
                        </div>
                        <div class="text-primary fs-2"><i class="fas fa-briefcase"></i></div>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="p-3 stat-card">
                    <div class="d-flex justify-content-between">
                        <div>
                            <small class="text-muted fw-bold text-uppercase">Candidatures</small>
                            <h3 class="fw-bold m-0 mt-1">-</h3> </div>
                        <div class="text-success fs-2"><i class="fas fa-users"></i></div>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="p-3 stat-card">
                    <div class="d-flex justify-content-between">
                        <div>
                            <small class="text-muted fw-bold text-uppercase">Vues totales</small>
                            <h3 class="fw-bold m-0 mt-1">-</h3>
                        </div>
                        <div class="text-warning fs-2"><i class="fas fa-eye"></i></div>
                    </div>
                </div>
            </div>
        </div>

        <div class="card border-0 shadow-sm rounded-3 overflow-hidden">
            <div class="card-header bg-white py-3 border-bottom">
                <h6 class="m-0 fw-bold">Vos offres d'emploi récentes</h6>
            </div>
            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0">
                    <thead class="bg-light text-secondary small">
                        <tr>
                            <th class="ps-4">Intitulé du poste</th>
                            <th>Lieu</th>
                            <th>Candidats</th>
                            <th>Date</th>
                            <th class="text-end pe-4">Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${offres}" var="o">
                            <tr>
                                <td class="ps-4">
                                    <div class="fw-bold text-dark">${o.titre}</div>
                                    <span class="badge bg-light text-dark border">${o.typeContrat}</span>
                                </td>
                                <td class="text-muted small"><i class="fas fa-map-marker-alt me-1"></i> ${o.localisation}</td>
                                <td>
                                    <a href="${pageContext.request.contextPath}/entreprise/applications?offerId=${o.id}" class="text-decoration-none fw-bold">
                                        Voir les candidats
                                    </a>
                                </td>
                                <td class="text-muted small">${o.datePublication}</td>
                                
                                <td class="text-end pe-4">
                                    <a href="${pageContext.request.contextPath}/entreprise/offer/edit?id=${o.id}" 
                                       class="btn btn-sm btn-light text-primary" title="Modifier">
                                        <i class="fas fa-edit"></i>
                                    </a>
                                    
                                    <a href="${pageContext.request.contextPath}/entreprise/offer/delete?id=${o.id}" 
                                       class="btn btn-sm btn-light text-danger" 
                                       onclick="return confirm('Êtes-vous sûr de vouloir supprimer cette offre ? Cette action est irréversible.');"
                                       title="Supprimer">
                                        <i class="fas fa-trash"></i>
                                    </a>
                                </td>
                                </tr>
                        </c:forEach>
                        
                        <c:if test="${empty offres}">
                            <tr>
                                <td colspan="5" class="text-center py-5">
                                    <img src="https://cdni.iconscout.com/illustration/premium/thumb/empty-state-2130362-1800926.png" height="150" alt="Empty">
                                    <p class="text-muted mt-2">Vous n'avez publié aucune offre pour le moment.</p>
                                    <a href="${pageContext.request.contextPath}/entreprise/offer/new" class="btn btn-primary btn-sm rounded-pill px-3">Créer ma première offre</a>
                                </td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
        </div>

    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>