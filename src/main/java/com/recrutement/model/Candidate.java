package com.recrutement.model;

import jakarta.persistence.*;
import java.util.List;

@Entity
@Table(name = "candidates")
@PrimaryKeyJoinColumn(name = "id")
public class Candidate extends User {

    private String nom;
    private String prenom;
    private String titreProfil; // Ex: Développeur Fullstack
    
    @Column(columnDefinition = "TEXT")
    private String bio;
    
    private String photo; // Nom du fichier image

    // === AJOUT DU CHAMP MANQUANT ===
    private String cv; // Nom du fichier CV (ex: "mon_cv.pdf")
    // ==============================

    @OneToMany(mappedBy = "candidate", cascade = CascadeType.ALL)
    private List<Application> applications;

    // Getters et Setters
    public String getNom() { return nom; }
    public void setNom(String nom) { this.nom = nom; }

    public String getPrenom() { return prenom; }
    public void setPrenom(String prenom) { this.prenom = prenom; }

    public String getTitreProfil() { return titreProfil; }
    public void setTitreProfil(String titreProfil) { this.titreProfil = titreProfil; }

    public String getBio() { return bio; }
    public void setBio(String bio) { this.bio = bio; }

    public String getPhoto() { return photo; }
    public void setPhoto(String photo) { this.photo = photo; }

    public List<Application> getApplications() { return applications; }
    public void setApplications(List<Application> applications) { this.applications = applications; }

    // === AJOUT DES GETTERS/SETTERS POUR LE CV ===
    public String getCv() { return cv; }
    public void setCv(String cv) { this.cv = cv; }
}