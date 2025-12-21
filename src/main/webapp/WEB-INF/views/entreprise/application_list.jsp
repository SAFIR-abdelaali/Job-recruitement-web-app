<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Candidatures Recruteur</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    
    <style>
        body { background-color: #f3f2ef; }
        .recruiter-header { background: white; border-bottom: 1px solid #e0e0e0; padding: 20px 0; margin-bottom: 30px; }
        .candidate-card { background: white; border: 1px solid #e0e0e0; border-radius: 8px; padding: 24px; margin-bottom: 20px; transition: box-shadow 0.2s; }
        .candidate-card:hover { box-shadow: 0 4px 12px rgba(0,0,0,0.08); border-color: #6f42c1; }
        .motivation-box { background-color: #f8f9fa; border-left: 4px solid #6f42c1; padding: 15px; border-radius: 4px; font-size: 0.95rem; color: #555; margin: 20px 0; font-style: italic; }
        .doc-btn { font-size: 0.85rem; margin-right: 5px; margin-bottom: 5px; }
        .interview-box { background-color: #d1e7dd; border: 1px solid #badbcc; color: #0f5132; border-radius: 6px; padding: 15px; margin-top: 20px; }
        .locked-docs { background-color: #f8f9fa; border: 1px dashed #dee2e6; color: #6c757d; padding: 20px; border-radius: 6px; text-align: center; margin-top: 20px; }
    </style>
</head>
<body>

    <nav class="navbar navbar-expand-lg navbar-light bg-white border-bottom fixed-top">
        <div class="container">
            <a class="navbar-brand fw-bold" href="#" style="color:#6f42c1;">
                JobRecruit<span class="text-dark"> Recruiter</span>
            </a>
            <div class="d-flex">
                 <a href="${pageContext.request.contextPath}/auth?action=logout" class="btn btn-outline-secondary btn-sm rounded-pill">Déconnexion</a>
            </div>
        </div>
    </nav>

    <div class="recruiter-header" style="margin-top: 56px;">
        <div class="container">
            <a href="${pageContext.request.contextPath}/entreprise/dashboard" class="text-decoration-none fw-bold text-secondary mb-2 d-inline-block">
                ← RETOUR AUX OFFRES
            </a>
            <div class="d-flex justify-content-between align-items-center mt-2">
                <div>
                    <h2 class="h4 mb-0 fw-bold">
                        Candidatures
                        <c:if test="${not empty applications}">
                            : <span style="color:#6f42c1;">${applications[0].offer.titre}</span>
                        </c:if>
                    </h2>
                    <p class="text-muted small mb-0">Analyse anonyme des profils.</p>
                </div>
                <div>
                    <span class="badge rounded-pill bg-dark py-2 px-3" style="font-size: 0.9rem;">
                        ${applications != null ? applications.size() : 0} Candidat(s)
                    </span>
                </div>
            </div>
        </div>
    </div>

    <div class="container pb-5">
        <div class="row">
            <div class="col-lg-10 mx-auto">
                
                <c:forEach items="${applications}" var="app">
                    <div class="candidate-card">
                        <div class="d-flex align-items-center justify-content-between mb-3">
                            <div class="d-flex align-items-center">
                                <div class="bg-light rounded-circle d-flex align-items-center justify-content-center border me-3" style="width: 60px; height: 60px;">
                                    <i class="bi bi-person-fill text-secondary fs-3"></i>
                                </div>
                                <div>
                                    <h5 class="mb-1 fw-bold text-dark">Candidat #${app.candidate.id}</h5>
                                    <span class="badge bg-secondary">Profil Anonyme</span>
                                    
                                    <c:if test="${app.statut == 'ENTRETIEN_PROGRAMME' or not empty app.dateEntretient}">
                                        <span class="badge bg-success ms-2">✅ Entretien Programmé</span>
                                    </c:if>
                                </div>
                            </div>
                            <div class="text-end text-muted small">
                                <i class="bi bi-clock"></i> Reçu le : ${app.datePostulation}
                            </div>
                        </div>

                        <h6 class="text-secondary fw-bold text-uppercase small ls-1">Lettre de motivation</h6>
                        <div class="motivation-box">"${app.lettreMotivation}"</div>

                        <c:choose>
                            <c:when test="${not empty app.dateEntretient}">
                                <h6 class="text-secondary fw-bold text-uppercase small ls-1 mt-4 mb-2">Documents du dossier</h6>
                                <div class="d-flex flex-wrap">
                                    <c:if test="${not empty app.cv}">
                                        <a href="${pageContext.request.contextPath}/uploads/documents/${app.cv}" target="_blank" class="btn btn-outline-dark btn-sm rounded-pill doc-btn">
                                            <i class="bi bi-file-earmark-pdf-fill text-danger"></i> CV
                                        </a>
                                    </c:if>
                                    <c:if test="${not empty app.bac}">
                                        <a href="${pageContext.request.contextPath}/uploads/documents/${app.bac}" target="_blank" class="btn btn-outline-secondary btn-sm rounded-pill doc-btn">
                                            <i class="bi bi-mortarboard-fill"></i> Bac: ${app.bac}
                                        </a>
                                    </c:if>
                                    <c:if test="${not empty app.diplome}">
                                        <a href="${pageContext.request.contextPath}/uploads/documents/${app.diplome}" target="_blank" class="btn btn-outline-secondary btn-sm rounded-pill doc-btn">
                                            <i class="bi bi-award-fill"></i> Diplôme: ${app.diplome}
                                        </a>
                                    </c:if>
                                    <c:if test="${not empty app.cin}">
                                        <a href="${pageContext.request.contextPath}/uploads/documents/${app.cin}" target="_blank" class="btn btn-outline-secondary btn-sm rounded-pill doc-btn">
                                            <i class="bi bi-person-badge-fill"></i> CIN: ${app.cin}
                                        </a>
                                    </c:if>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="locked-docs">
                                    <i class="bi bi-lock-fill fs-3 d-block mb-2 text-secondary"></i>
                                    <strong>Documents protégés</strong><br>
                                    <small>Les documents (CV, Diplômes...) seront accessibles une fois l'entretien validé par l'administrateur.</small>
                                </div>
                            </c:otherwise>
                        </c:choose>
                        <c:choose>
                            <c:when test="${not empty app.dateEntretient}">
                                <div class="interview-box">
                                    <div class="d-flex align-items-center mb-2">
                                        <i class="bi bi-calendar-check-fill fs-4 me-2"></i>
                                        <h6 class="fw-bold mb-0">Entretien confirmé par l'administrateur</h6>
                                    </div>
                                    <div class="row mt-3 ps-1">
                                        <div class="col-md-6">
                                            <small class="text-uppercase opacity-75 fw-bold" style="font-size:0.75rem;">Date et Heure</small>
                                            <p class="fw-bold fs-5 mb-0">${app.dateEntretient}</p>
                                        </div>
                                        <div class="col-md-6 border-start border-success">
                                            <small class="text-uppercase opacity-75 fw-bold" style="font-size:0.75rem;">Lieu / Lien</small>
                                            <p class="fw-bold mb-0"><i class="bi bi-geo-alt-fill me-1"></i> ${app.lieuEntretient}</p>
                                        </div>
                                    </div>
                                    
                                    <div class="mt-3 pt-3 border-top border-success-subtle">
                                        <a href="${pageContext.request.contextPath}/chat?appId=${app.id}" class="btn btn-outline-primary btn-sm w-100 bg-white">
                                            <i class="bi bi-chat-dots-fill me-1"></i> Ouvrir le Chat avec le Candidat
                                        </a>
                                    </div>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="alert alert-info mt-3 mb-0 small border-0">
                                    <i class="bi bi-info-circle-fill me-1"></i> 
                                    Pour voir les documents et recruter ce candidat, contactez l'administrateur.
                                </div>
                            </c:otherwise>
                        </c:choose>

                    </div>
                </c:forEach>

                <c:if test="${empty applications}">
                    <div class="text-center p-5 bg-white rounded border">
                        <i class="bi bi-inbox fs-1 text-muted opacity-25"></i>
                        <h4 class="text-muted fw-light mt-3">Aucune candidature reçue</h4>
                        <p class="text-secondary small">Les dossiers apparaîtront ici de façon anonyme.</p>
                        <a href="${pageContext.request.contextPath}/entreprise/dashboard" class="btn btn-primary">Retour au Dashboard</a>
                    </div>
                </c:if>

            </div>
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>