package com.recrutement.model;

import jakarta.persistence.*;

@Entity
@Table(name = "admins")
@PrimaryKeyJoinColumn(name = "id") // Fait le lien avec la table 'users'
public class Admin extends User {

    // On ne garde que nom et prénom, comme demandé
    private String nom;
    private String prenom;

    // Constructeur par défaut
    public Admin() {
        super();
        // On force le rôle et la validation
        this.setRole("ADMIN");
        this.setVerified(true); 
    }

    // Getters et Setters
    public String getNom() {
        return nom;
    }

    public void setNom(String nom) {
        this.nom = nom;
    }

    public String getPrenom() {
        return prenom;
    }

    public void setPrenom(String prenom) {
        this.prenom = prenom;
    }
}