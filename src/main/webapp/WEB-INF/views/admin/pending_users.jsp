<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>

<!DOCTYPE html>
<html>
<head>
    <title>Validations | Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
</head>
<body class="bg-light">

<div class="container mt-5">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h3><i class="bi bi-person-check-fill text-warning me-2"></i>Comptes en attente</h3>
        <a href="${pageContext.request.contextPath}/admin/dashboard" class="btn btn-outline-secondary">Retour au Dashboard</a>
    </div>

    <c:if test="${param.error == 'missing_id'}">
        <div class="alert alert-warning">Erreur : Aucun utilisateur sélectionné.</div>
    </c:if>
    <c:if test="${param.msg == 'validated'}">
        <div class="alert alert-success">Utilisateur validé avec succès !</div>
    </c:if>

    <div class="card shadow-sm">
        <div class="card-body p-0">
            <table class="table table-hover mb-0 align-middle">
                <thead class="table-light">
                    <tr>
                        <th class="ps-4">ID</th>
                        <th>Nom / Entreprise</th>
                        <th>Email</th>
                        <th>Rôle</th>
                        <th class="text-end pe-4">Action</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach items="${pendingUsers}" var="u">
                        <tr>
                            <td class="ps-4">#${u.id}</td>
                            <td class="fw-bold">
                                <c:choose>
                                    <c:when test="${u.role == 'CANDIDATE'}">
                                        ${u.prenom} ${u.nom}
                                    </c:when>
                                    <c:when test="${u.role == 'ENTREPRISE'}">
                                        ${u.nomEntreprise}
                                    </c:when>
                                    <c:otherwise>Utilisateur</c:otherwise>
                                </c:choose>
                            </td>
                            <td>${u.email}</td>
                            <td><span class="badge bg-secondary">${u.role}</span></td>
                            <td class="text-end pe-4">
                                <a href="${pageContext.request.contextPath}/admin/users/validate?userId=${u.id}" 
                                   class="btn btn-success btn-sm text-white fw-bold">
                                    <i class="bi bi-check-lg"></i> Valider
                                </a>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty pendingUsers}">
                        <tr><td colspan="5" class="text-center py-4 text-muted">Aucun compte en attente.</td></tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </div>
</div>

</body>
</html>