<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Messagerie | JobRecruit</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    
    <style>
        body { background-color: #f0f2f5; height: 100vh; overflow: hidden; }
        .inbox-container { height: 90vh; margin-top: 20px; background: white; border-radius: 12px; box-shadow: 0 5px 15px rgba(0,0,0,0.1); overflow: hidden; display: flex; }
        
        /* Sidebar gauche (Liste) */
        .sidebar { width: 350px; background: #fff; border-right: 1px solid #e0e0e0; display: flex; flex-direction: column; }
        .sidebar-header { padding: 20px; border-bottom: 1px solid #f0f0f0; background: #f8f9fa; }
        .conv-list { overflow-y: auto; flex-grow: 1; }
        .conv-item { padding: 15px; border-bottom: 1px solid #f0f0f0; cursor: pointer; transition: 0.2s; text-decoration: none; color: inherit; display: block; }
        .conv-item:hover { background-color: #f8f9fa; }
        .conv-item.active { background-color: #e8f0fe; border-left: 4px solid #0d6efd; }
        
        /* Zone de Chat droite */
        .chat-area { flex-grow: 1; display: flex; flex-direction: column; background: #e5ddd5; }
        .chat-header { padding: 15px 20px; background: #fff; border-bottom: 1px solid #e0e0e0; display: flex; justify-content: space-between; align-items: center; }
        .messages-box { flex-grow: 1; padding: 20px; overflow-y: auto; display: flex; flex-direction: column; }
        .input-area { padding: 15px; background: #fff; }

        /* Bulles de messages */
        .message-bubble { max-width: 70%; padding: 10px 14px; border-radius: 18px; margin-bottom: 8px; position: relative; font-size: 0.95rem; line-height: 1.4; box-shadow: 0 1px 2px rgba(0,0,0,0.1); }
        .message-me { align-self: flex-end; background-color: #dcf8c6; color: #000; border-bottom-right-radius: 2px; }
        .message-other { align-self: flex-start; background-color: #fff; color: #000; border-bottom-left-radius: 2px; }
        .deleted-msg { font-style: italic; color: #888; font-size: 0.9rem; display: flex; align-items: center; gap: 5px; }
        .edited-badge { font-size: 0.7rem; color: #666; font-style: italic; margin-left: 5px; }
        
        /* Actions (Modifier/Supprimer) */
        .msg-actions { font-size: 0.8rem; margin-top: 4px; opacity: 0.6; text-align: right; }
        .msg-actions button { background: none; border: none; padding: 0 5px; color: #555; cursor: pointer; }
        .msg-actions button:hover { color: #000; }
        
        /* Navbar simple */
        .top-nav { height: 50px; background: #fff; border-bottom: 1px solid #ddd; padding: 0 20px; display: flex; align-items: center; justify-content: space-between; }
    </style>
</head>
<body>

    <div class="top-nav">
        <div class="fw-bold text-primary">JobRecruit <span class="text-dark">Messagerie</span></div>
        <a href="${sessionScope.user.role == 'ENTREPRISE' ? 'entreprise/dashboard' : 'candidate/dashboard'}" class="btn btn-sm btn-outline-secondary">
            <i class="bi bi-box-arrow-left"></i> Quitter la messagerie
        </a>
    </div>

    <div class="container-fluid px-4">
        <div class="inbox-container">
            
            <div class="sidebar">
                <div class="sidebar-header">
                    <h5 class="m-0 fw-bold">Discussions</h5>
                    <small class="text-muted">Entretiens programmés</small>
                </div>
                
                <div class="conv-list">
                    <c:forEach items="${conversations}" var="conv">
                        <a href="${pageContext.request.contextPath}/chat?appId=${conv.id}" 
                           class="conv-item ${activeApp.id == conv.id ? 'active' : ''}">
                            <div class="d-flex justify-content-between">
                                <span class="fw-bold text-dark">
                                    ${sessionScope.user.role == 'ENTREPRISE' ? conv.candidate.nom : conv.offer.entreprise.nomEntreprise}
                                </span>
                                <small class="text-muted" style="font-size:0.7rem">
                                    ${conv.dateEntretient.toString().replace('T', ' ')}
                                </small>
                            </div>
                            <div class="small text-muted text-truncate">
                                Poste : ${conv.offer.titre}
                            </div>
                        </a>
                    </c:forEach>

                    <c:if test="${empty conversations}">
                        <div class="p-4 text-center text-muted">
                            <i class="bi bi-chat-square-dots fs-1 opacity-25"></i>
                            <p class="mt-2 small">Aucune discussion active.<br>Attendez qu'un entretien soit programmé.</p>
                        </div>
                    </c:if>
                </div>
            </div>

            <div class="chat-area">
                <c:choose>
                    <c:when test="${not empty activeApp}">
                        
                        <div class="chat-header">
                            <div>
                                <h6 class="m-0 fw-bold">
                                    <i class="bi bi-person-circle me-2 text-secondary"></i>
                                    ${sessionScope.user.role == 'ENTREPRISE' ? activeApp.candidate.prenom : activeApp.offer.entreprise.nomEntreprise}
                                </h6>
                                <small class="text-muted">Sujet : ${activeApp.offer.titre}</small>
                            </div>
                            <div class="badge bg-success bg-opacity-10 text-success border border-success">
                                <i class="bi bi-calendar-check me-1"></i> Entretien confirmé
                            </div>
                        </div>

                        <div class="messages-box" id="messagesBox">
                            <c:if test="${empty activeApp.messages}">
                                <div class="text-center mt-5 mb-5">
                                    <span class="badge bg-white text-secondary shadow-sm p-2">
                                        Ceci est le début de votre conversation sécurisée.
                                    </span>
                                </div>
                            </c:if>

                            <c:forEach items="${activeApp.messages}" var="msg">
                                <c:choose>
                                    <c:when test="${msg.senderRole == sessionScope.user.role}">
                                        <div class="message-bubble message-me">
                                            <c:if test="${msg.deleted}">
                                                <span class="deleted-msg"><i class="bi bi-trash"></i> Vous avez supprimé ce message</span>
                                            </c:if>
                                            
                                            <c:if test="${not msg.deleted}">
                                                <span>${msg.contenu}</span>
                                                <c:if test="${msg.edited}">
                                                    <span class="edited-badge">(modifié)</span>
                                                </c:if>
                                                
                                                <div class="msg-actions">
                                                    <small class="me-2">
                                                        ${msg.dateEnvoi.hour}:${msg.dateEnvoi.minute < 10 ? '0' : ''}${msg.dateEnvoi.minute}
                                                    </small>
                                                    
                                                    <button type="button" onclick="openEditModal(${msg.id}, '${msg.contenu}')" title="Modifier">
                                                        <i class="bi bi-pencil"></i>
                                                    </button>
                                                    
                                                    <form action="${pageContext.request.contextPath}/chat" method="post" style="display:inline;" onsubmit="return confirm('Voulez-vous vraiment supprimer ce message ?');">
                                                        <input type="hidden" name="action" value="delete">
                                                        <input type="hidden" name="appId" value="${activeApp.id}">
                                                        <input type="hidden" name="messageId" value="${msg.id}">
                                                        <button type="submit" class="text-danger" title="Supprimer">
                                                            <i class="bi bi-trash"></i>
                                                        </button>
                                                    </form>
                                                </div>
                                            </c:if>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="message-bubble message-other">
                                            <c:if test="${msg.deleted}">
                                                <span class="deleted-msg"><i class="bi bi-trash"></i> Message supprimé</span>
                                            </c:if>
                                            <c:if test="${not msg.deleted}">
                                                ${msg.contenu}
                                                <c:if test="${msg.edited}"><span class="edited-badge">(modifié)</span></c:if>
                                                <div class="text-end" style="font-size:0.65rem; opacity:0.5; margin-top:2px;">
                                                    ${msg.dateEnvoi.hour}:${msg.dateEnvoi.minute < 10 ? '0' : ''}${msg.dateEnvoi.minute}
                                                </div>
                                            </c:if>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </c:forEach>
                        </div>

                        <div class="input-area">
                            <form action="${pageContext.request.contextPath}/chat" method="post" class="d-flex gap-2">
                                <input type="hidden" name="action" value="send">
                                <input type="hidden" name="appId" value="${activeApp.id}">
                                <input type="text" name="message" class="form-control rounded-pill bg-light border-0 py-2 px-3" placeholder="Écrivez un message..." required autocomplete="off">
                                <button type="submit" class="btn btn-primary rounded-circle shadow-sm" style="width: 40px; height: 40px; padding:0;">
                                    <i class="bi bi-send-fill"></i>
                                </button>
                            </form>
                        </div>

                    </c:when>
                    <c:otherwise>
                        <div class="d-flex flex-column align-items-center justify-content-center h-100 text-muted">
                            <i class="bi bi-chat-left-text fs-1 mb-3 opacity-25"></i>
                            <h5>Sélectionnez une discussion</h5>
                            <p>Choisissez un entretien dans la liste de gauche pour discuter.</p>
                        </div>
                    </c:otherwise>
                </c:choose>
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
                        <c:if test="${not empty activeApp}">
                            <input type="hidden" name="appId" value="${activeApp.id}">
                        </c:if>
                        <input type="hidden" name="messageId" id="editMsgId">
                        
                        <div class="mb-3">
                            <label class="form-label">Nouveau texte :</label>
                            <textarea name="message" id="editMsgContent" class="form-control" rows="3" required></textarea>
                        </div>
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
        // Scroll automatique vers le bas
        var msgBox = document.getElementById("messagesBox");
        if(msgBox) {
            msgBox.scrollTop = msgBox.scrollHeight;
        }

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