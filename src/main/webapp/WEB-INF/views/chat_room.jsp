<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>Discussion | JobRecruit</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <style>
        body { background-color: #f0f2f5; }
        .chat-container { max-width: 800px; margin: 30px auto; background: white; border-radius: 10px; overflow: hidden; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        .chat-header { background: #6f42c1; color: white; padding: 15px; }
        .chat-box { height: 450px; overflow-y: auto; padding: 20px; background: #e5ddd5; display: flex; flex-direction: column; }
        
        .message-bubble { max-width: 75%; padding: 8px 12px; border-radius: 15px; margin-bottom: 8px; position: relative; font-size: 0.95rem; line-height: 1.4; }
        
        .message-me { align-self: flex-end; background-color: #dcf8c6; color: #303030; border-bottom-right-radius: 2px; }
        .message-other { align-self: flex-start; background-color: #ffffff; color: #303030; border-bottom-left-radius: 2px; }
        
        .message-time { font-size: 0.7rem; float: right; margin-left: 10px; margin-top: 5px; opacity: 0.6; }
        .deleted-msg { font-style: italic; color: #888; display: flex; align-items: center; gap: 5px; }
        
        /* Menu options (3 points) */
        .msg-options { position: absolute; top: 5px; right: 5px; opacity: 0; transition: opacity 0.2s; cursor: pointer; }
        .message-bubble:hover .msg-options { opacity: 1; }
        
        .edited-badge { font-size: 0.65rem; color: #888; margin-left: 5px; font-style: italic; }
    </style>
</head>
<body>

<div class="container">
    <div class="chat-container">
        <div class="chat-header d-flex justify-content-between align-items-center">
            <h5 class="m-0"><i class="bi bi-chat-dots me-2"></i>${application.offer.titre}</h5>
            <c:if test="${sessionScope.user.role == 'ENTREPRISE'}">
                <a href="${pageContext.request.contextPath}/entreprise/applications?offerId=${application.offer.id}" class="btn btn-sm btn-light text-primary">Retour</a>
            </c:if>
            <c:if test="${sessionScope.user.role == 'CANDIDATE'}">
                <a href="${pageContext.request.contextPath}/candidate/dashboard" class="btn btn-sm btn-light text-primary">Retour</a>
            </c:if>
        </div>

        <div class="chat-box" id="chatBox">
            <c:if test="${empty application.messages}">
                <div class="text-center text-muted mt-5 badge bg-light text-dark mx-auto p-2">Début de la conversation sécurisée.</div>
            </c:if>

            <c:forEach items="${application.messages}" var="msg">
                <c:choose>
                    <c:when test="${msg.senderRole == sessionScope.user.role}">
                        <div class="message-bubble message-me shadow-sm">
                            <c:choose>
                                <c:when test="${msg.deleted}">
                                    <span class="deleted-msg"><i class="bi bi-slash-circle"></i> Vous avez supprimé ce message</span>
                                </c:when>
                                <c:otherwise>
                                    ${msg.contenu}
                                    <c:if test="${msg.edited}"><span class="edited-badge">(modifié)</span></c:if>
                                    
                                    <div class="dropdown d-inline-block msg-options">
                                        <i class="bi bi-three-dots-vertical" data-bs-toggle="dropdown"></i>
                                        <ul class="dropdown-menu dropdown-menu-end shadow-sm" style="min-width: 120px;">
                                            <li><a class="dropdown-item small" href="#" onclick="openEditModal(${msg.id}, '${msg.contenu}')"><i class="bi bi-pencil me-2"></i>Modifier</a></li>
                                            <li><hr class="dropdown-divider"></li>
                                            <li>
                                                <form action="${pageContext.request.contextPath}/chat" method="post" style="display:inline;">
                                                    <input type="hidden" name="action" value="delete">
                                                    <input type="hidden" name="appId" value="${application.id}">
                                                    <input type="hidden" name="messageId" value="${msg.id}">
                                                    <button type="submit" class="dropdown-item small text-danger" onclick="return confirm('Supprimer ce message ?')"><i class="bi bi-trash me-2"></i>Supprimer</button>
                                                </form>
                                            </li>
                                        </ul>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                            <span class="message-time">${msg.dateEnvoi.hour}:${msg.dateEnvoi.minute < 10 ? '0' : ''}${msg.dateEnvoi.minute}</span>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="message-bubble message-other shadow-sm">
                            <small class="fw-bold d-block text-primary mb-1">${msg.senderRole == 'ENTREPRISE' ? 'Recruteur' : 'Candidat'}</small>
                            <c:choose>
                                <c:when test="${msg.deleted}">
                                    <span class="deleted-msg"><i class="bi bi-slash-circle"></i> Ce message a été supprimé</span>
                                </c:when>
                                <c:otherwise>
                                    ${msg.contenu}
                                    <c:if test="${msg.edited}"><span class="edited-badge">(modifié)</span></c:if>
                                </c:otherwise>
                            </c:choose>
                            <span class="message-time">${msg.dateEnvoi.hour}:${msg.dateEnvoi.minute < 10 ? '0' : ''}${msg.dateEnvoi.minute}</span>
                        </div>
                    </c:otherwise>
                </c:choose>
            </c:forEach>
        </div>

        <div class="p-3 bg-white border-top">
            <form action="${pageContext.request.contextPath}/chat" method="post" class="d-flex gap-2">
                <input type="hidden" name="action" value="send">
                <input type="hidden" name="appId" value="${application.id}">
                <input type="text" name="message" class="form-control rounded-pill bg-light" placeholder="Écrivez votre message..." required autocomplete="off">
                <button type="submit" class="btn btn-primary rounded-circle" style="width:40px; height:40px; padding:0;"><i class="bi bi-send-fill"></i></button>
            </form>
        </div>
    </div>
</div>

<div class="modal fade" id="editModal" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <form action="${pageContext.request.contextPath}/chat" method="post">
                <div class="modal-header">
                    <h5 class="modal-title">Modifier le message</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <input type="hidden" name="action" value="edit">
                    <input type="hidden" name="appId" value="${application.id}">
                    <input type="hidden" name="messageId" id="editMsgId">
                    <textarea name="message" id="editMsgContent" class="form-control" rows="3" required></textarea>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Annuler</button>
                    <button type="submit" class="btn btn-primary">Enregistrer</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // Scroll auto
    var chatBox = document.getElementById("chatBox");
    chatBox.scrollTop = chatBox.scrollHeight;

    // Fonction pour ouvrir la modale d'édition
    function openEditModal(id, content) {
        document.getElementById('editMsgId').value = id;
        document.getElementById('editMsgContent').value = content;
        var myModal = new bootstrap.Modal(document.getElementById('editModal'));
        myModal.show();
    }
</script>

</body>
</html>