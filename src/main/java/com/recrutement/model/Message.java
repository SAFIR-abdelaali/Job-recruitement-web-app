package com.recrutement.model;

import java.time.LocalDateTime;
import jakarta.persistence.*;

@Entity
@Table(name = "messages")
public class Message {
	@Column(nullable = false)
	private boolean isRead = false;
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(columnDefinition = "TEXT")
    private String contenu;

    private LocalDateTime dateEnvoi;

    private String senderRole; 

    @ManyToOne
    @JoinColumn(name = "application_id", nullable = false)
    private Application application;
    public boolean isRead() { return isRead; }
    public void setRead(boolean read) { isRead = read; }

    // === NOUVEAUX CHAMPS ===
    private boolean isDeleted = false; // Par défaut, non supprimé
    private boolean isEdited = false;  // Par défaut, non modifié
    // =======================

    public Message() {}

    public Message(String contenu, String senderRole, Application application) {
        this.contenu = contenu;
        this.senderRole = senderRole;
        this.application = application;
        this.dateEnvoi = LocalDateTime.now();
    }

    // Getters et Setters existants...
    public Long getId() { return id; }
    public String getContenu() { return contenu; }
    public void setContenu(String contenu) { this.contenu = contenu; } // Setter nécessaire pour l'édition
    public LocalDateTime getDateEnvoi() { return dateEnvoi; }
    public String getSenderRole() { return senderRole; }
    public Application getApplication() { return application; }

    // === NOUVEAUX GETTERS/SETTERS ===
    public boolean isDeleted() { return isDeleted; }
    public void setDeleted(boolean deleted) { isDeleted = deleted; }

    public boolean isEdited() { return isEdited; }
    public void setEdited(boolean edited) { isEdited = edited; }
    // ================================
}