<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Gestion des Candidatures | Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    
    <style>
        body { background-color: #f8f9fa; padding-top: 20px; }
        .table-hover tbody tr:hover { background-color: white; }
        .avatar-initial { width: 40px; height: 40px; background-color: #e9ecef; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-weight: bold; color: #495057; }
    </style>
</head>
<body>

    <div class="container-fluid px-4">
        
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h3 class="fw-bold text-dark m-0">Gestion des Candidatures</h3>
            <div>
                <a href="${pageContext.request.contextPath}/admin/dashboard" class="btn btn-outline-secondary me-2">
                    <i class="bi bi-arrow-left"></i> Retour
                </a>
                <span class="badge bg-secondary rounded-pill px-3 py-2 fs-6">${applications.size()} dossiers</span>
            </div>
        </div>

        <c:if test="${param.msg == 'scheduled'}">
            <div class="alert alert-success alert-dismissible fade show">Entretien programmé avec succès !<button type="button" class="btn-close" data-bs-dismiss="alert"></button></div>
        </c:if>
        <c:if test="${param.msg == 'saved'}">
            <div class="alert alert-success alert-dismissible fade show">Enregistrement vidéo sauvegardé !<button type="button" class="btn-close" data-bs-dismiss="alert"></button></div>
        </c:if>
        <c:if test="${param.msg == 'deleted'}">
            <div class="alert alert-success alert-dismissible fade show">Candidature supprimée définitivement.<button type="button" class="btn-close" data-bs-dismiss="alert"></button></div>
        </c:if>

        <div class="card border-0 shadow-sm rounded-3 overflow-hidden">
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="bg-light text-secondary small text-uppercase fw-bold">
                            <tr>
                                <th class="ps-4" style="width: 25%;">Candidat</th>
                                <th style="width: 30%;">Poste & Entreprise</th>
                                <th style="width: 25%;">Statut / Date RDV</th>
                                <th class="text-end pe-4" style="width: 20%;">Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${applications}" var="app">
                                <tr>
                                    <td class="ps-4">
                                        <div class="d-flex align-items-center">
                                            <div class="avatar-initial me-3">
                                                ${app.candidate.nom.substring(0,1)}${app.candidate.prenom.substring(0,1)}
                                            </div>
                                            <div>
                                                <div class="fw-bold text-dark">${app.candidate.nom} ${app.candidate.prenom}</div>
                                                <div class="small text-muted">${app.candidate.email}</div>
                                                <div class="small text-muted"><i class="bi bi-clock me-1"></i>Reçu le: ${app.datePostulation.toString().substring(0,10)}</div>
                                            </div>
                                        </div>
                                    </td>

                                    <td>
                                        <div class="fw-bold text-primary">${app.offer.titre}</div>
                                        <div class="fw-bold text-dark small">${app.offer.entreprise.nomEntreprise}</div>
                                        <div class="small text-muted"><i class="bi bi-geo-alt me-1"></i>${app.offer.localisation}</div>
                                    </td>

                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty app.dateEntretient}">
                                                <span class="badge bg-success bg-opacity-10 text-success border border-success mb-1">
                                                    <i class="bi bi-check-circle-fill me-1"></i>Confirmé
                                                </span>
                                                <div class="fw-bold small">${app.dateEntretient.toString().replace('T', ' à ')}</div>
                                                <div class="small text-muted text-truncate" style="max-width: 200px;">
                                                    <i class="bi bi-pin-map-fill text-danger me-1"></i>${app.lieuEntretient}
                                                </div>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-warning text-dark">En attente</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>

                                    <td class="text-end pe-4">
                                        <div class="d-flex justify-content-end gap-1">
                                            
                                            <button type="button" class="btn btn-outline-primary btn-sm rounded-pill" 
                                                    data-bs-toggle="modal" data-bs-target="#modalSchedule${app.id}">
                                                <i class="bi bi-calendar-event"></i> Modifier
                                            </button>

                                            <c:if test="${not empty app.dateEntretient}">
                                                <button type="button" class="btn btn-outline-danger btn-sm rounded-pill" 
                                                        data-bs-toggle="modal" data-bs-target="#modalRec${app.id}" title="Ajouter Enregistrement">
                                                    <i class="bi bi-camera-reels"></i> Rec
                                                </button>
                                            </c:if>

                                            <a href="${pageContext.request.contextPath}/admin/applications/delete?id=${app.id}" 
                                               class="btn btn-outline-dark btn-sm rounded-pill"
                                               onclick="return confirm('⚠️ Êtes-vous sûr de vouloir supprimer cette candidature ?');"
                                               title="Supprimer la candidature">
                                                <i class="bi bi-trash"></i>
                                            </a>

                                        </div>

                                        <div class="modal fade text-start" id="modalSchedule${app.id}" tabindex="-1">
                                            <div class="modal-dialog">
                                                <div class="modal-content">
                                                    <form action="${pageContext.request.contextPath}/admin/application/schedule" method="post">
                                                        <div class="modal-header">
                                                            <h5 class="modal-title">Planifier Entretien</h5>
                                                            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                                        </div>
                                                        <div class="modal-body">
                                                            <input type="hidden" name="appId" value="${app.id}">
                                                            <div class="mb-3">
                                                                <label class="fw-bold">Date et Heure</label>
                                                                <input type="datetime-local" class="form-control" name="dateEntretient" required value="${app.dateEntretient}">
                                                            </div>
                                                            <div class="mb-3">
                                                                <label class="fw-bold text-primary">Lien Google Meet</label>
                                                                <input type="url" class="form-control" name="meetingLink" placeholder="https://meet.google.com/..." value="${app.meetingLink}" required>
                                                            </div>
                                                        </div>
                                                        <div class="modal-footer">
                                                            <button type="submit" class="btn btn-primary">Enregistrer</button>
                                                        </div>
                                                    </form>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="modal fade text-start" id="modalRec${app.id}" tabindex="-1">
                                            <div class="modal-dialog">
                                                <div class="modal-content">
                                                    <form action="${pageContext.request.contextPath}/admin/application/saveRecording" method="post">
                                                        <div class="modal-header">
                                                            <h5 class="modal-title">Sauvegarder Replay</h5>
                                                            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                                        </div>
                                                        <div class="modal-body">
                                                            <input type="hidden" name="appId" value="${app.id}">
                                                            <div class="mb-3">
                                                                <label class="fw-bold text-danger">Lien du Replay (Drive/YouTube)</label>
                                                                <input type="url" class="form-control" name="recordingLink" placeholder="https://..." value="${app.recordingLink}" required>
                                                            </div>
                                                        </div>
                                                        <div class="modal-footer">
                                                            <button type="submit" class="btn btn-danger">Sauvegarder</button>
                                                        </div>
                                                    </form>
                                                </div>
                                            </div>
                                        </div>

                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>