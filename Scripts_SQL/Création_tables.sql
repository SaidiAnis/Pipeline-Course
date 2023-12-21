DROP TABLE Specialitee CASCADE CONSTRAINTS;
DROP TABLE SousDomaineFormation CASCADE CONSTRAINTS;
DROP TABLE SOUSSOUSDomaineFormation CASCADE CONSTRAINTS;
DROP TABLE Client_Apprenant CASCADE CONSTRAINTS;
DROP TABLE Formateur CASCADE CONSTRAINTS;
DROP TABLE Demander CASCADE CONSTRAINTS;
DROP TABLE SeDeclarer CASCADE CONSTRAINTS;
DROP TABLE Appartenir CASCADE CONSTRAINTS;
DROP TABLE Assurer CASCADE CONSTRAINTS;
DROP TABLE DomaineFormation CASCADE CONSTRAINTS;
DROP TABLE OrganismeDeFormation CASCADE CONSTRAINTS;
DROP TABLE Inscription CASCADE CONSTRAINTS;
DROP TABLE LaSession CASCADE CONSTRAINTS;
DROP TABLE ABREVIATIONS CASCADE CONSTRAINTS;

CREATE TABLE ABREVIATIONS (
    ID INT PRIMARY KEY,
    ORIGINAL_TEXT VARCHAR(255),
    ABBREVIATION VARCHAR(255)
);

-- Création de la table Specialitee
CREATE TABLE Specialitee (
    NumeroSpecialite VARCHAR(20) PRIMARY KEY,
    IntituleSpecialite VARCHAR(50),
    Description CLOB
);



-- Création de la table DomaineFormation
drop table DomaineFormation;
CREATE TABLE DomaineFormation (
    RefDomaine VARCHAR(200) PRIMARY KEY,
    DomaineDeFormation VARCHAR2(50),
    MotsCles VARCHAR2(300),  -- Oracle utilise CLOB pour les grands objets textuels
    DateCreation DATE
);

-- Création de la table SousDomaineFormation
drop table SousDomaineFormation;
CREATE TABLE SousDomaineFormation (
    RefSousDomaine VARCHAR(200) PRIMARY KEY,
    RefDomaine VARCHAR(200),
    SousDomaineDeFormation VARCHAR(200),
    Description CLOB,  -- Oracle utilise CLOB pour les grands objets textuels
    MotsCles VARCHAR2(300),
    FOREIGN KEY (RefDomaine) REFERENCES DomaineFormation(RefDomaine)
);


drop table SOUSSOUSDomaineFormation;
CREATE TABLE SOUSSOUSDomaineFormation (
    RefSOUSSOUSDomaineF VARCHAR2(200) PRIMARY KEY,
    RefSOUSDomaineF VARCHAR2(200),
    Le_nom CLOB,
    Descriptio CLOB,
    Notes VARCHAR2(50),
    Nombre_avis VARCHAR2(25),
    Duree VARCHAR2(50),  -- Utiliser VARCHAR2 pour les champs textuels
    Nombre_participants INTEGER,
    Niveau VARCHAR2(50),
    Liens CLOB,
    Destinataires CLOB,
    Formateurs CLOB,
    Chapitre CLOB,
    Competences_gagnees CLOB,
    Organisation CLOB,
    MotsCles VARCHAR2(300),
    prix VARCHAR2(30),
    FOREIGN KEY (RefSOUSDomaineF) REFERENCES SousDomaineFormation(RefSousDomaine)
);




-- Création de la table OrganismeDeFormation
CREATE TABLE OrganismeDeFormation (
    SIREN VARCHAR(20) PRIMARY KEY,
    RaisonSocial VARCHAR(20),
    Ville VARCHAR(50),
    Pays VARCHAR(50),
    Adresse VARCHAR(50),
    NumDeTelephone VARCHAR(20),
    Email VARCHAR(50),
    SiteWeb VARCHAR(50),
    TypeOrganisme VARCHAR(50)
);


-- Contrainte de verification : Regexp
ALTER TABLE OrganismeDeFormation
ADD CONSTRAINT Check_NumDeTelephone CHECK (REGEXP_LIKE (NumDeTelephone, '^[0-9]{10}$'));

-- Création de la table Formateur
CREATE TABLE Formateur (
    IdFormateur VARCHAR(20) PRIMARY KEY,
    NomFormateur VARCHAR(50),
    PrenomFormateur VARCHAR(50),
    AdresseEmail VARCHAR(50),
    TelephoneFormateur VARCHAR(20),
    DateEmbauche DATE
);


-- Contrainte d'Unicité : Unique
ALTER TABLE Formateur
ADD CONSTRAINT Unique_Email_Formateur UNIQUE (AdresseEmail);

-- Contrainte de verification : Regexp

ALTER TABLE Formateur
ADD CONSTRAINT Check_TelephoneFormateur CHECK (REGEXP_LIKE (TelephoneFormateur, '^[0-9]{10}$'));


-- Création de la table Client_Apprenant
CREATE TABLE Client_Apprenant (
    IdClient VARCHAR(20) PRIMARY KEY,
    NomClient VARCHAR(50) NOT NULL,
    PrenomClient VARCHAR(50),
    GenreContact VARCHAR(20),
    DatePremierContact DATE,
    DateNaissance DATE,
    AdresseEmail VARCHAR(50)
);



-- Contrainte d'Unicité : Unique
ALTER TABLE Client_Apprenant
ADD CONSTRAINT Unique_Email_Client UNIQUE (AdresseEmail);

-- Création de la table LaSession
CREATE TABLE LaSession (
    IdLaSession VARCHAR(20) PRIMARY KEY,
    IdFormateur VARCHAR(20),
    Date_Debut DATE,
    Date_Fin DATE,
    SIRENOrganismeFormation VARCHAR(20),
    FOREIGN KEY (IdFormateur) REFERENCES Formateur(IdFormateur),
    FOREIGN KEY (SIRENOrganismeFormation) REFERENCES OrganismeDeFormation(SIREN)
);
-- Contrainte de Validation : CHECK
ALTER TABLE LaSession
ADD CONSTRAINT Check_Dates CHECK (Date_Debut < Date_Fin);


-- Création de la table Assurer
CREATE TABLE Assurer (
    organismeformation_SIREN VARCHAR(20),
    SOUSSOUSdomaineFormation_Ref VARCHAR(20),
    PRIMARY KEY (organismeformation_SIREN, SOUSSOUSdomaineFormation_Ref),
    FOREIGN KEY (organismeformation_SIREN) REFERENCES OrganismeDeFormation(SIREN),
    FOREIGN KEY (SOUSSOUSdomaineFormation_Ref) REFERENCES SOUSSOUSDomaineFormation(RefSOUSSOUSDomaineF)
);

-- Création de la table Demander
CREATE TABLE Demander (
    ClientApprenant_IdClient VARCHAR(20),
    SOUSSOUSdomaineFormation_Id VARCHAR(20),
    PRIMARY KEY (ClientApprenant_IdClient, SOUSSOUSdomaineFormation_Id),
    FOREIGN KEY (ClientApprenant_IdClient) REFERENCES Client_Apprenant(IdClient),
    FOREIGN KEY (SOUSSOUSdomaineFormation_Id) REFERENCES SOUSSOUSDomaineFormation(RefSOUSSOUSDomaineF)
);

-- Création de la table SeDeclarer
CREATE TABLE SeDeclarer (
    organismeformation_SIREN VARCHAR(20),
    specialite_numero_specialite VARCHAR(20),
    PRIMARY KEY (organismeformation_SIREN, specialite_numero_specialite),
    FOREIGN KEY (organismeformation_SIREN) REFERENCES OrganismeDeFormation(SIREN),
    FOREIGN KEY (specialite_numero_specialite) REFERENCES Specialitee(NumeroSpecialite)
);

-- Création de la table Appartenir
CREATE TABLE Appartenir (
    formateur_idformateur VARCHAR(20),
    organismeformation_SIREN VARCHAR(20),
    PRIMARY KEY (formateur_idformateur, organismeformation_SIREN),
    FOREIGN KEY (formateur_idformateur) REFERENCES Formateur(IdFormateur),
    FOREIGN KEY (organismeformation_SIREN) REFERENCES OrganismeDeFormation(SIREN)
);


CREATE TABLE Inscription (
    IdClient VARCHAR(20),
    IdLaSession VARCHAR(20),
    PRIMARY KEY (IdClient, IdLaSession),
    FOREIGN KEY (IdClient) REFERENCES Client_Apprenant(IdClient),
    FOREIGN KEY (IdLaSession) REFERENCES LaSession(IdLaSession)
);


-- Documentation sur les Tables et leurs colonnes 

-- Table Abreviation
COMMENT ON TABLE ABREVIATIONS IS 'Stocke les abréviations et leurs textes originaux.';
COMMENT ON COLUMN ABREVIATIONS.ID IS 'Identifiant unique pour chaque abréviation.';
COMMENT ON COLUMN ABREVIATIONS.ORIGINAL_TEXT IS 'Texte original correspondant à l’abréviation.';
COMMENT ON COLUMN ABREVIATIONS.ABBREVIATION IS 'L’abréviation du texte original.';

-- Table Specialitee

COMMENT ON TABLE Specialitee IS 'Détails des spécialités offertes, incluant leur numéro, intitulé et description.';
COMMENT ON COLUMN Specialitee.NumeroSpecialite IS 'Identifiant unique de la spécialité.';
COMMENT ON COLUMN Specialitee.IntituleSpecialite IS 'Nom de la spécialité.';
COMMENT ON COLUMN Specialitee.Description IS 'Description détaillée de la spécialité.';

-- Table DomaineFormation
COMMENT ON TABLE DomaineFormation IS 'Informations sur les différents domaines de formation.';
COMMENT ON COLUMN DomaineFormation.RefDomaine IS 'Référence unique du domaine de formation.';
COMMENT ON COLUMN DomaineFormation.DomaineDeFormation IS 'Nom du domaine de formation.';
COMMENT ON COLUMN DomaineFormation.MotsCles IS 'Mots-clés associés au domaine de formation.';
COMMENT ON COLUMN DomaineFormation.DateCreation IS 'Date de création du domaine de formation.';

-- Table SousDomaineFormation
COMMENT ON TABLE SousDomaineFormation IS 'Sous-catégories des domaines de formation avec références aux domaines parents.';
COMMENT ON COLUMN SousDomaineFormation.RefSousDomaine IS 'Identifiant unique du sous-domaine de formation.';
COMMENT ON COLUMN SousDomaineFormation.RefDomaine IS 'Référence au domaine de formation parent.';
COMMENT ON COLUMN SousDomaineFormation.SousDomaineDeFormation IS 'Nom du sous-domaine de formation.';
COMMENT ON COLUMN SousDomaineFormation.Description IS 'Description du sous-domaine de formation.';
COMMENT ON COLUMN SousDomaineFormation.MotsCles IS 'Mots-clés associés au sous-domaine de formation.';

-- Table SOUSSOUSDomaineFormation
COMMENT ON TABLE SOUSSOUSDomaineFormation IS 'Détails des sous-sous-domaines de formation, incluant des références aux sous-domaines.';
COMMENT ON COLUMN SOUSSOUSDomaineFormation.RefSOUSSOUSDomaineF IS 'Identifiant unique du sous-sous-domaine de formation.';
COMMENT ON COLUMN SOUSSOUSDomaineFormation.RefSOUSDomaineF IS 'Référence au sous-domaine de formation parent.';
COMMENT ON COLUMN SOUSSOUSDomaineFormation.Le_nom IS 'Nom du sous-sous-domaine de formation.';
COMMENT ON COLUMN SOUSSOUSDomaineFormation.Descriptio IS 'Description du sous-sous-domaine de formation.';
COMMENT ON COLUMN SOUSSOUSDomaineFormation.Notes IS 'Notes ou commentaires sur le sous-sous-domaine.';
COMMENT ON COLUMN SOUSSOUSDomaineFormation.Nombre_avis IS 'Nombre d’avis reçus pour le sous-sous-domaine.';
COMMENT ON COLUMN SOUSSOUSDomaineFormation.Duree IS 'Durée estimée du programme de formation.';
COMMENT ON COLUMN SOUSSOUSDomaineFormation.Nombre_participants IS 'Nombre de participants pour le programme.';
COMMENT ON COLUMN SOUSSOUSDomaineFormation.Niveau IS 'Niveau requis ou ciblé pour la formation.';
COMMENT ON COLUMN SOUSSOUSDomaineFormation.Liens IS 'Liens utiles associés au sous-sous-domaine de formation.';
COMMENT ON COLUMN SOUSSOUSDomaineFormation.Destinataires IS 'Public cible de la formation.';
COMMENT ON COLUMN SOUSSOUSDomaineFormation.Formateurs IS 'Informations sur les formateurs impliqués.';
COMMENT ON COLUMN SOUSSOUSDomaineFormation.Chapitre IS 'Chapitres ou modules de la formation.';
COMMENT ON COLUMN SOUSSOUSDomaineFormation.Competences_gagnees IS 'Compétences acquises à l’issue de la formation.';
COMMENT ON COLUMN SOUSSOUSDomaineFormation.Organisation IS 'Organisation ou structure de la formation.';
COMMENT ON COLUMN SOUSSOUSDomaineFormation.MotsCles IS 'Mots-clés associés au sous-sous-domaine de formation.';

-- Table OrganismeDeFormation
COMMENT ON TABLE OrganismeDeFormation IS 'Informations sur les organismes offrant des formations, incluant des détails comme le SIREN.';
COMMENT ON COLUMN OrganismeDeFormation.SIREN IS 'Numéro SIREN unique de l’organisme de formation.';
COMMENT ON COLUMN OrganismeDeFormation.RaisonSocial IS 'Raison sociale de l’organisme de formation.';
COMMENT ON COLUMN OrganismeDeFormation.Ville IS 'Ville où est situé l’organisme de formation.';
COMMENT ON COLUMN OrganismeDeFormation.Pays IS 'Pays où est situé l’organisme de formation.';
COMMENT ON COLUMN OrganismeDeFormation.Adresse IS 'Adresse postale de l’organisme de formation.';
COMMENT ON COLUMN OrganismeDeFormation.NumDeTelephone IS 'Numéro de téléphone de l’organisme.';
COMMENT ON COLUMN OrganismeDeFormation.Email IS 'Adresse email de l’organisme.';
COMMENT ON COLUMN OrganismeDeFormation.SiteWeb IS 'Site web de l’organisme de formation.';
COMMENT ON COLUMN OrganismeDeFormation.TypeOrganisme IS 'Type de l’organisme de formation (privé, public, etc.).';

-- Table Formateur
COMMENT ON TABLE Formateur IS 'Détails des formateurs, incluant identifiants, noms, et informations de contact.';
COMMENT ON COLUMN Formateur.IdFormateur IS 'Identifiant unique du formateur.';
COMMENT ON COLUMN Formateur.NomFormateur IS 'Nom du formateur.';
COMMENT ON COLUMN Formateur.PrenomFormateur IS 'Prénom du formateur.';
COMMENT ON COLUMN Formateur.AdresseEmail IS 'Adresse email du formateur.';
COMMENT ON COLUMN Formateur.TelephoneFormateur IS 'Numéro de téléphone du formateur.';
COMMENT ON COLUMN Formateur.DateEmbauche IS 'Date d’embauche du formateur.';

-- Table Client_Apprenant
COMMENT ON TABLE Client_Apprenant IS 'Informations sur les clients apprenants, y compris leurs coordonnées et dates importantes.';
COMMENT ON COLUMN Client_Apprenant.IdClient IS 'Identifiant unique du client apprenant.';
COMMENT ON COLUMN Client_Apprenant.NomClient IS 'Nom du client apprenant.';
COMMENT ON COLUMN Client_Apprenant.PrenomClient IS 'Prénom du client apprenant.';
COMMENT ON COLUMN Client_Apprenant.GenreContact IS 'Genre du contact pour le client apprenant.';
COMMENT ON COLUMN Client_Apprenant.DatePremierContact IS 'Date du premier contact avec le client.';
COMMENT ON COLUMN Client_Apprenant.DateNaissance IS 'Date de naissance du client apprenant.';
COMMENT ON COLUMN Client_Apprenant.AdresseEmail IS 'Adresse email du client.';

-- Table LaSession
COMMENT ON TABLE LaSession IS 'Détails des sessions de formation, y compris les formateurs, les organismes de formation, et les dates.';
COMMENT ON COLUMN LaSession.IdLaSession IS 'Identifiant unique de la session.';
COMMENT ON COLUMN LaSession.IdFormateur IS 'Identifiant du formateur responsable de la session.';
COMMENT ON COLUMN LaSession.Date_Debut IS 'Date de début de la session.';
COMMENT ON COLUMN LaSession.Date_Fin IS 'Date de fin de la session.';
COMMENT ON COLUMN LaSession.SIRENOrganismeFormation IS 'SIREN de l’organisme de formation associé à la session.';

-- Table Assurer
COMMENT ON TABLE Assurer IS 'Association entre les organismes de formation et les sous-sous-domaines de formation qu’ils proposent.';
COMMENT ON COLUMN Assurer.organismeformation_SIREN IS 'SIREN de l’organisme de formation.';
COMMENT ON COLUMN Assurer.SOUSSOUSdomaineFormation_Ref IS 'Référence du sous-sous-domaine de formation.';

-- Table Demander
COMMENT ON TABLE Demander IS 'Relation entre les clients apprenants et les sous-sous-domaines de formation qu’ils demandent.';
COMMENT ON COLUMN Demander.ClientApprenant_IdClient IS 'Identifiant du client apprenant.';
COMMENT ON COLUMN Demander.SOUSSOUSdomaineFormation_Id IS 'Identifiant du sous-sous-domaine de formation demandé.';

-- Table SeDeclarer
COMMENT ON TABLE SeDeclarer IS 'Table représentant les déclarations des organismes de formation sur leurs spécialités.';
COMMENT ON COLUMN SeDeclarer.organismeformation_SIREN IS 'Identifiant SIREN de l’organisme de formation.';
COMMENT ON COLUMN SeDeclarer.specialite_numero_specialite IS 'Numéro de la spécialité déclarée par l’organisme de formation.';

-- Table Appartenir
COMMENT ON TABLE Appartenir IS 'Table indiquant l’appartenance des formateurs à différents organismes de formation.';
COMMENT ON COLUMN Appartenir.formateur_idformateur IS 'Identifiant du formateur.';
COMMENT ON COLUMN Appartenir.organismeformation_SIREN IS 'Identifiant SIREN de l’organisme de formation auquel le formateur appartient.';

-- Table Inscription
COMMENT ON TABLE Inscription IS 'Table contenant les inscriptions des clients apprenants aux sessions de formation.';
COMMENT ON COLUMN Inscription.IdClient IS 'Identifiant du client apprenant inscrit à la session.';
COMMENT ON COLUMN Inscription.IdLaSession IS 'Identifiant de la session de formation à laquelle le client est inscrit.';
