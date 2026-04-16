# SAE 1.04 - Création d'une Base de Données (Qualité des Eaux de Baignade)

![PostgreSQL](https://img.shields.io/badge/PostgreSQL-316192?style=for-the-badge&logo=postgresql&logoColor=white)
![SQL](https://img.shields.io/badge/SQL-00000F?style=for-the-badge&logo=sql&logoColor=white)

## 📝 Description du Projet
Ce projet a été réalisé dans le cadre de la **SAE 1.04 du BUT Informatique (1ère année)**. L'objectif était de concevoir, modéliser et implémenter une base de données relationnelle complète à partir de jeux de données bruts (Open Data) concernant la qualité des eaux de baignade en France.

Le projet met en évidence tout le cycle de vie d'une base de données : de la modélisation conceptuelle au peuplement via un processus de type ETL (Extract, Transform, Load), en passant par le nettoyage des données.

## 🛠️ Technologies Utilisées
* **SGBD :** PostgreSQL
* **Outil de Modélisation (AGL) :** SQL Power Architect
* **Langage :** SQL
* **Données :** Fichiers CSV (Open Data)

## ⚙️ Fonctionnalités et Réalisations
1. **Modélisation (MCD & MPD) :** * Conception du schéma relationnel (tables, types de données, clés primaires et clés étrangères).
   * Utilisation de l'outil SQL Power Architect pour générer le Modèle Physique de Données.
2. **Création de la structure (DDL) :**
   * Écriture d'un script SQL manuel optimisé.
   * Comparaison critique avec le script généré automatiquement par l'AGL.
3. **Peuplement et Nettoyage des données (ETL) :**
   * Importation de fichiers CSV hétérogènes.
   * Utilisation de tables temporaires (`Staging`) pour éviter les erreurs d'import.
   * Traitement et nettoyage des données à la volée.
  
