package com.recrutement.model;

import java.time.LocalDateTime;
import jakarta.persistence.*;
import java.util.List;
import java.util.ArrayList;

@Entity
@Table(name = "applications")
public class Application {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "datePostulation")
    private LocalDateTime datePostulation;
    @OneToMany(mappedBy = "application", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @OrderBy("dateEnvoi ASC")
    private List<Message> messages = new ArrayList<>();
    public List<Message> getMessages() { return messages; }
    private String meetingLink; 

    // Lien pour voir le replay (ex: https://drive.google.com/file/d/...)
    private String recordingLink;
    public void setMessages(List<Message> messages) { this.messages = messages; }
    public String getMeetingLink() { return meetingLink; }
    public void setMeetingLink(String meetingLink) { this.meetingLink = meetingLink; }

    public String getRecordingLink() { return recordingLink; }
    public void setRecordingLink(String recordingLink) { this.recordingLink = recordingLink; }

    private String statut; // EN_ATTENTE, ACCEPTE, REFUSE

    // === CES CHAMPS MANQUAIENT ET CAUSAIENT L'ERREUR ===
    private String cv;
    private String lettreMotivation;
    private String bac;
    private String diplome;
    private String cin;
    // ===================================================

    private LocalDateTime dateEntretient;
    private String lieuEntretient;

    // Liens
    @ManyToOne
    @JoinColumn(name = "candidate_id", nullable = false)
    private Candidate candidate;

    @ManyToOne
    @JoinColumn(name = "offer_id", nullable = false)
    private Offer offer;

    public Application() {}

    // --- GETTERS ET SETTERS ---

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public LocalDateTime getDatePostulation() { return datePostulation; }
    public void setDatePostulation(LocalDateTime datePostulation) { this.datePostulation = datePostulation; }

    public String getStatut() { return statut; }
    public void setStatut(String statut) { this.statut = statut; }

    // === Getters/Setters pour les fichiers ===
    public String getCv() { return cv; }
    public void setCv(String cv) { this.cv = cv; }

    public String getLettreMotivation() { return lettreMotivation; }
    public void setLettreMotivation(String lm) { this.lettreMotivation = lm; }

    public String getBac() { return bac; }
    public void setBac(String bac) { this.bac = bac; }

    public String getDiplome() { return diplome; }
    public void setDiplome(String diplome) { this.diplome = diplome; }

    public String getCin() { return cin; }
    public void setCin(String cin) { this.cin = cin; }
    // =========================================

    public LocalDateTime getDateEntretient() { return dateEntretient; }
    public void setDateEntretient(LocalDateTime dateEntretient) { this.dateEntretient = dateEntretient; }

    public String getLieuEntretient() { return lieuEntretient; }
    public void setLieuEntretient(String lieuEntretient) { this.lieuEntretient = lieuEntretient; }

    public Candidate getCandidate() { return candidate; }
    public void setCandidate(Candidate candidate) { this.candidate = candidate; }

    public Offer getOffer() { return offer; }
    public void setOffer(Offer offer) { this.offer = offer; }
}