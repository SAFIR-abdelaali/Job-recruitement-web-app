# 🚀 JobRecruit - Plateforme de Recrutement JEE

**JobRecruit** est une application web complète de gestion de recrutement développée en **Java (Jakarta EE)**. Elle connecte les candidats et les entreprises tout en offrant aux administrateurs des outils puissants pour gérer les processus d'embauche.

---

## 📋 Table des Matières
- [Fonctionnalités](#-fonctionnalités)
- [Stack Technique](#-stack-technique)
- [Prérequis](#-prérequis)
- [Installation et Configuration](#-installation-et-configuration)
- [Sécurité et Variables d'Environnement](#-sécurité-et-variables-denvironnement)
- [Auteurs](#-auteurs)

---

## ✨ Fonctionnalités

### 👨‍💼 Espace Administrateur
- **Dashboard Analytique :** Vue d'ensemble des stats (Candidats, Entreprises, Offres).
- **Validation des Comptes :** Système de vérification des nouveaux inscrits avec notification par email.
- **Gestion des Candidatures :**
  - Planification d'entretiens via **Google Meet**.
  - Sauvegarde des liens de replay d'entretien.
  - **Suppression en cascade (Deep Clean) :** Suppression intelligente des utilisateurs et de toutes leurs données liées (Messages, Offres, Candidatures) pour maintenir l'intégrité de la BDD.
- **Gestion des Utilisateurs :** Suppression et modération.

### 👨‍🎓 Espace Candidat
- **Profil Riche :** Gestion de photo de profil et bio.
- **Candidature Avancée :**
  - Upload de **fichiers multiples** (CV, Lettre, Diplômes...) via Drag & Drop.
  - Limite intelligente (Max 10 fichiers, contrôle de taille et format).
- **Suivi en Temps Réel :** Statut des candidatures (En attente, Entretien programmé, etc.).

### 🏢 Espace Entreprise
- Publication et gestion des offres d'emploi.
- Réception des candidatures et accès aux CVs.

---

## 🛠 Stack Technique

* **Backend :** Java 17+, Jakarta EE (Servlets, JSP), Hibernate (JPA).
* **Base de Données :** MySQL 8.0.
* **Frontend :** Bootstrap 5, JSTL, JavaScript (ES6).
* **Build Tool :** Apache Maven.
* **Services Tiers :** JavaMail API (SMTP Gmail), File Upload API.

---

## ⚙️ Prérequis

Avant de commencer, assurez-vous d'avoir :
* Java JDK 21.
* Apache Tomcat 11.
* MySQL Server.
* Maven.

---

## 🚀 Installation et Configuration

### 1. Cloner le projet
```bash
git clone [https://github.com/SAFIR-abdelaali/job-recrutement-web-app.git](https://github.com/SAFIR-abdelaali/job-recrutement-web-app.git)
cd job-recrutement-web-app
