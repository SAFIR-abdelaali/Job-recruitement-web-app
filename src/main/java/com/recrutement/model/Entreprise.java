package com.recrutement.model;

import jakarta.persistence.*;
import java.util.List;

@Entity
@Table(name = "entreprises")
@PrimaryKeyJoinColumn(name = "id")
public class Entreprise extends User {

    private String nomEntreprise;
    private String adresse;
    private String secteurActivite;
    
    @Column(columnDefinition = "TEXT")
    private String description;
    
    private String logo; // Nom du fichier image

    @OneToMany(mappedBy = "entreprise", cascade = CascadeType.ALL)
    private List<Offer> offers;

    // Getters et Setters
    public String getNomEntreprise() { return nomEntreprise; }
    public void setNomEntreprise(String nomEntreprise) { this.nomEntreprise = nomEntreprise; }

    public String getAdresse() { return adresse; }
    public void setAdresse(String adresse) { this.adresse = adresse; }

    public String getSecteurActivite() { return secteurActivite; }
    public void setSecteurActivite(String secteurActivite) { this.secteurActivite = secteurActivite; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getLogo() { return logo; }
    public void setLogo(String logo) { this.logo = logo; }

    public List<Offer> getOffers() { return offers; }
    public void setOffers(List<Offer> offers) { this.offers = offers; }
}