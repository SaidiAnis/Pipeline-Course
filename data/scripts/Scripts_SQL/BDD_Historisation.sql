------------------------------------------------------ Historisation de la BDD -------------------------------------
-- L'historisation des données est le processus de stockage des données dans un format qui permet de les retrouver et de les analyser ultérieurement. Elle est importante pour de nombreuses raisons, notamment :

-- 1) L'historisation des données est une obligation réglementaire pour de nombreuses industries.
-- 2) Elle permet de résoudre les problèmes en retraçant l'évolution des données au fil du temps.
-- 3) Elle permet de réaliser des analyses approfondies des données ( Dans Notre cas Faire un Rapport de Bord ).
------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------- Table Historisation ABREVIATIONS ------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------
DROP TABLE ABREVIATIONS_History;
CREATE TABLE ABREVIATIONS_History (
    HistoryID INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    ID INT,
    ORIGINAL_TEXT VARCHAR(255),
    ABBREVIATION VARCHAR(255),
    StartDate TIMESTAMP,
    EndDate TIMESTAMP,
    ChangeType VARCHAR2(20),
    ModifiedBy VARCHAR2(50),
    ModifiedAt TIMESTAMP
);

 ----------------------------- Abbreviations_History_Trigger ----------------------------------
 
CREATE OR REPLACE TRIGGER Abbreviations_History_Trigger
BEFORE INSERT OR UPDATE OR DELETE ON ABREVIATIONS
FOR EACH ROW
DECLARE
    v_user VARCHAR2(50);
BEGIN
    SELECT USER INTO v_user FROM DUAL; -- Capture the user who is making the change

    IF INSERTING THEN
        INSERT INTO ABREVIATIONS_History (ID, ORIGINAL_TEXT, ABBREVIATION, StartDate, EndDate, ChangeType, ModifiedBy, ModifiedAt)
        VALUES (:NEW.ID, :NEW.ORIGINAL_TEXT, :NEW.ABBREVIATION, SYSTIMESTAMP, NULL, 'Insert', v_user, SYSTIMESTAMP);
    ELSIF UPDATING THEN
        INSERT INTO ABREVIATIONS_History (ID, ORIGINAL_TEXT, ABBREVIATION, StartDate, EndDate, ChangeType, ModifiedBy, ModifiedAt)
        VALUES (:NEW.ID, :NEW.ORIGINAL_TEXT, :NEW.ABBREVIATION, SYSTIMESTAMP, NULL, 'Update', v_user, SYSTIMESTAMP);
    ELSIF DELETING THEN
        INSERT INTO ABREVIATIONS_History (ID, ORIGINAL_TEXT, ABBREVIATION, StartDate, EndDate, ChangeType, ModifiedBy, ModifiedAt)
        VALUES (:OLD.ID, :OLD.ORIGINAL_TEXT, :OLD.ABBREVIATION, SYSTIMESTAMP, NULL, 'Delete', v_user, SYSTIMESTAMP);
    END IF;
END;
/

------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------- Table Historisation ABREVIATIONS ------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------
DROP TABLE Specialitee_History;
CREATE TABLE Specialitee_History (
    HistoryID INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    NumeroSpecialite VARCHAR(20),
    IntituleSpecialite VARCHAR(50),
    Description CLOB,
    StartDate TIMESTAMP,
    EndDate TIMESTAMP,
    ChangeType VARCHAR2(20),
    ModifiedBy VARCHAR2(50),
    ModifiedAt TIMESTAMP
);


------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------- Specialitee_History_Trigger -----------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE OR REPLACE TRIGGER Specialitee_History_Trigger
BEFORE INSERT OR UPDATE OR DELETE ON Specialitee
FOR EACH ROW
DECLARE
    v_user VARCHAR2(50);
BEGIN
    SELECT USER INTO v_user FROM DUAL; -- Capture the user who is making the change

    IF INSERTING THEN
        INSERT INTO Specialitee_History (NumeroSpecialite, IntituleSpecialite, Description, StartDate, EndDate, ChangeType, ModifiedBy, ModifiedAt)
        VALUES (:NEW.NumeroSpecialite, :NEW.IntituleSpecialite, :NEW.Description, SYSTIMESTAMP, NULL, 'Insert', v_user, SYSTIMESTAMP);
    ELSIF UPDATING THEN
        INSERT INTO Specialitee_History (NumeroSpecialite, IntituleSpecialite, Description, StartDate, EndDate, ChangeType, ModifiedBy, ModifiedAt)
        VALUES (:NEW.NumeroSpecialite, :NEW.IntituleSpecialite, :NEW.Description, SYSTIMESTAMP, NULL, 'Update', v_user, SYSTIMESTAMP);
    ELSIF DELETING THEN
        INSERT INTO Specialitee_History (NumeroSpecialite, IntituleSpecialite, Description, StartDate, EndDate, ChangeType, ModifiedBy, ModifiedAt)
        VALUES (:OLD.NumeroSpecialite, :OLD.IntituleSpecialite, :OLD.Description, SYSTIMESTAMP, NULL, 'Delete', v_user, SYSTIMESTAMP);
    END IF;
END;
/

------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------  Table DomaineFormation_History -----------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------
DROP TABLE DomaineFormation_History;
CREATE TABLE DomaineFormation_History (
    HistoryID INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    RefDomaine VARCHAR(200),
    DomaineDeFormation VARCHAR2(50),
    MotsCles VARCHAR2(300),
    DateCreation DATE,
    StartDate TIMESTAMP,
    EndDate TIMESTAMP,
    ChangeType VARCHAR2(20),
    ModifiedBy VARCHAR2(50),
    ModifiedAt TIMESTAMP
);


------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------  Trigger  DomaineFormation_History_Trigger --------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------

CREATE OR REPLACE TRIGGER DomaineFormation_History_Trigger
BEFORE INSERT OR UPDATE OR DELETE ON DomaineFormation
FOR EACH ROW
DECLARE
    v_user VARCHAR2(50);
BEGIN
    SELECT USER INTO v_user FROM DUAL; -- Capture the user who is making the change

    IF INSERTING THEN
        INSERT INTO DomaineFormation_History (RefDomaine, DomaineDeFormation, MotsCles, DateCreation, StartDate, EndDate, ChangeType, ModifiedBy, ModifiedAt)
        VALUES (:NEW.RefDomaine, :NEW.DomaineDeFormation, :NEW.MotsCles, :NEW.DateCreation, SYSTIMESTAMP, NULL, 'Insert', v_user, SYSTIMESTAMP);
    ELSIF UPDATING THEN
        INSERT INTO DomaineFormation_History (RefDomaine, DomaineDeFormation, MotsCles, DateCreation, StartDate, EndDate, ChangeType, ModifiedBy, ModifiedAt)
        VALUES (:NEW.RefDomaine, :NEW.DomaineDeFormation, :NEW.MotsCles, :NEW.DateCreation, SYSTIMESTAMP, NULL, 'Update', v_user, SYSTIMESTAMP);
    ELSIF DELETING THEN
        INSERT INTO DomaineFormation_History (RefDomaine, DomaineDeFormation, MotsCles, DateCreation, StartDate, EndDate, ChangeType, ModifiedBy, ModifiedAt)
        VALUES (:OLD.RefDomaine, :OLD.DomaineDeFormation, :OLD.MotsCles, :OLD.DateCreation, SYSTIMESTAMP, NULL, 'Delete', v_user, SYSTIMESTAMP);
    END IF;
END;
/



------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------  Table SousDomaineFormation_History ---------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------
DROP TABLE SousDomaineFormation_History;
CREATE TABLE SousDomaineFormation_History (
    HistoryID INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    RefSousDomaine VARCHAR(200),
    RefDomaine VARCHAR(200),
    SousDomaineDeFormation VARCHAR(200),
    Description CLOB,
    MotsCles VARCHAR2(300),
    StartDate TIMESTAMP,
    EndDate TIMESTAMP,
    ChangeType VARCHAR2(20),
    ModifiedBy VARCHAR2(50),
    ModifiedAt TIMESTAMP
);
------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------  Trigger SousDomaineFormation_History_Trigger ---------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE OR REPLACE TRIGGER SousDomaineFormation_History_Trigger
BEFORE INSERT OR UPDATE OR DELETE ON SousDomaineFormation
FOR EACH ROW
DECLARE
    v_user VARCHAR2(50);
BEGIN
    SELECT USER INTO v_user FROM DUAL; -- Capture the user who is making the change

    IF INSERTING THEN
        INSERT INTO SousDomaineFormation_History (RefSousDomaine, RefDomaine, SousDomaineDeFormation, Description, MotsCles, StartDate, EndDate, ChangeType, ModifiedBy, ModifiedAt)
        VALUES (:NEW.RefSousDomaine, :NEW.RefDomaine, :NEW.SousDomaineDeFormation, :NEW.Description, :NEW.MotsCles, SYSTIMESTAMP, NULL, 'Insert', v_user, SYSTIMESTAMP);
    ELSIF UPDATING THEN
        INSERT INTO SousDomaineFormation_History (RefSousDomaine, RefDomaine, SousDomaineDeFormation, Description, MotsCles, StartDate, EndDate, ChangeType, ModifiedBy, ModifiedAt)
        VALUES (:NEW.RefSousDomaine, :NEW.RefDomaine, :NEW.SousDomaineDeFormation, :NEW.Description, :NEW.MotsCles, SYSTIMESTAMP, NULL, 'Update', v_user, SYSTIMESTAMP);
    ELSIF DELETING THEN
        INSERT INTO SousDomaineFormation_History (RefSousDomaine, RefDomaine, SousDomaineDeFormation, Description, MotsCles, StartDate, EndDate, ChangeType, ModifiedBy, ModifiedAt)
        VALUES (:OLD.RefSousDomaine, :OLD.RefDomaine, :OLD.SousDomaineDeFormation, :OLD.Description, :OLD.MotsCles, SYSTIMESTAMP, NULL, 'Delete', v_user, SYSTIMESTAMP);
    END IF;
END;
/


------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------  Table  SOUSSOUSDomaineFormation_History ---------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------
DROP TABLE SOUSSOUSDomaineFormation_History;
CREATE TABLE SOUSSOUSDomaineFormation_History (
    HistoryID INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    RefSOUSSOUSDomaineF VARCHAR2(200),
    RefSOUSDomaineF VARCHAR2(200),
    Le_nom CLOB,
    Descriptio CLOB,
    Notes VARCHAR2(50),
    Nombre_avis VARCHAR2(50),
    Duree VARCHAR2(50),
    Nombre_participants INTEGER,
    Niveau VARCHAR2(50),
    Liens CLOB,
    Destinataires CLOB,
    Formateurs CLOB,
    Chapitre CLOB,
    Competences_gagnees CLOB,
    Organisation CLOB,
    MotsCles VARCHAR2(300),
    prix VARCHAR2(50),
    StartDate TIMESTAMP,
    EndDate TIMESTAMP,
    ChangeType VARCHAR2(20),
    ModifiedBy VARCHAR2(50),
    ModifiedAt TIMESTAMP
);

------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------  Trigger SOUSSOUSDomaineFormation_History_Trigger ---------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE OR REPLACE TRIGGER SOUSSOUSDomaineFormation_History_Trigger
BEFORE INSERT OR UPDATE OR DELETE ON SOUSSOUSDomaineFormation
FOR EACH ROW
DECLARE
    v_user VARCHAR2(50);
BEGIN
    SELECT USER INTO v_user FROM DUAL; -- Capture the user who is making the change

    IF INSERTING THEN
        INSERT INTO SOUSSOUSDomaineFormation_History (
            RefSOUSSOUSDomaineF, RefSOUSDomaineF, Le_nom, Descriptio, Notes, Nombre_avis, Duree,
            Nombre_participants, Niveau, Liens, Destinataires, Formateurs, Chapitre, Competences_gagnees,
            Organisation, MotsCles, prix, StartDate, EndDate, ChangeType, ModifiedBy, ModifiedAt
        )
        VALUES (
            :NEW.RefSOUSSOUSDomaineF, :NEW.RefSOUSDomaineF, :NEW.Le_nom, :NEW.Descriptio, :NEW.Notes,
            :NEW.Nombre_avis, :NEW.Duree, :NEW.Nombre_participants, :NEW.Niveau, :NEW.Liens,
            :NEW.Destinataires, :NEW.Formateurs, :NEW.Chapitre, :NEW.Competences_gagnees,
            :NEW.Organisation, :NEW.MotsCles, :NEW.prix, SYSTIMESTAMP, NULL, 'Insert', v_user, SYSTIMESTAMP
        );
    ELSIF UPDATING THEN
        INSERT INTO SOUSSOUSDomaineFormation_History (
            RefSOUSSOUSDomaineF, RefSOUSDomaineF, Le_nom, Descriptio, Notes, Nombre_avis, Duree,
            Nombre_participants, Niveau, Liens, Destinataires, Formateurs, Chapitre, Competences_gagnees,
            Organisation, MotsCles, prix, StartDate, EndDate, ChangeType, ModifiedBy, ModifiedAt
        )
        VALUES (
            :NEW.RefSOUSSOUSDomaineF, :NEW.RefSOUSDomaineF, :NEW.Le_nom, :NEW.Descriptio, :NEW.Notes,
            :NEW.Nombre_avis, :NEW.Duree, :NEW.Nombre_participants, :NEW.Niveau, :NEW.Liens,
            :NEW.Destinataires, :NEW.Formateurs, :NEW.Chapitre, :NEW.Competences_gagnees,
            :NEW.Organisation, :NEW.MotsCles, :NEW.prix, SYSTIMESTAMP, NULL, 'Update', v_user, SYSTIMESTAMP
        );
    ELSIF DELETING THEN
        INSERT INTO SOUSSOUSDomaineFormation_History (
            RefSOUSSOUSDomaineF, RefSOUSDomaineF, Le_nom, Descriptio, Notes, Nombre_avis, Duree,
            Nombre_participants, Niveau, Liens, Destinataires, Formateurs, Chapitre, Competences_gagnees,
            Organisation, MotsCles, prix, StartDate, EndDate, ChangeType, ModifiedBy, ModifiedAt
        )
        VALUES (
            :OLD.RefSOUSSOUSDomaineF, :OLD.RefSOUSDomaineF, :OLD.Le_nom, :OLD.Descriptio, :OLD.Notes,
            :OLD.Nombre_avis, :OLD.Duree, :OLD.Nombre_participants, :OLD.Niveau, :OLD.Liens,
            :OLD.Destinataires, :OLD.Formateurs, :OLD.Chapitre, :OLD.Competences_gagnees,
            :OLD.Organisation, :OLD.MotsCles, :OLD.prix, SYSTIMESTAMP, NULL, 'Delete', v_user, SYSTIMESTAMP
        );
    END IF;
END;
/

------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------  Table OrganismeDeFormation_History ---------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------
DROP TABLE SousDomaineFormation_History;
CREATE TABLE OrganismeDeFormation_History (
    HistoryID INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    SIREN VARCHAR(20),
    RaisonSocial VARCHAR(20),
    Ville VARCHAR(50),
    Pays VARCHAR(50),
    Adresse VARCHAR(50),
    NumDeTelephone VARCHAR(20),
    Email VARCHAR(50),
    SiteWeb VARCHAR(50),
    TypeOrganisme VARCHAR(50),
    StartDate TIMESTAMP,
    EndDate TIMESTAMP,
    ChangeType VARCHAR2(20),
    ModifiedBy VARCHAR2(50),
    ModifiedAt TIMESTAMP
);

------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------  Trigger  OrganismeDeFormation_History_Trigger ----------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE OR REPLACE TRIGGER OrganismeDeFormation_History_Trigger
BEFORE INSERT OR UPDATE OR DELETE ON OrganismeDeFormation
FOR EACH ROW
DECLARE
    v_user VARCHAR2(50);
BEGIN
    SELECT USER INTO v_user FROM DUAL; -- Capture the user who is making the change

    IF INSERTING THEN
        INSERT INTO OrganismeDeFormation_History (
            SIREN, RaisonSocial, Ville, Pays, Adresse, NumDeTelephone, Email, SiteWeb, 
            TypeOrganisme, StartDate, EndDate, ChangeType, ModifiedBy, ModifiedAt
        )
        VALUES (
            :NEW.SIREN, :NEW.RaisonSocial, :NEW.Ville, :NEW.Pays, :NEW.Adresse, :NEW.NumDeTelephone, 
            :NEW.Email, :NEW.SiteWeb, :NEW.TypeOrganisme, SYSTIMESTAMP, NULL, 'Insert', 
            v_user, SYSTIMESTAMP
        );
    ELSIF UPDATING THEN
        INSERT INTO OrganismeDeFormation_History (
            SIREN, RaisonSocial, Ville, Pays, Adresse, NumDeTelephone, Email, SiteWeb, 
            TypeOrganisme, StartDate, EndDate, ChangeType, ModifiedBy, ModifiedAt
        )
        VALUES (
            :NEW.SIREN, :NEW.RaisonSocial, :NEW.Ville, :NEW.Pays, :NEW.Adresse, :NEW.NumDeTelephone, 
            :NEW.Email, :NEW.SiteWeb, :NEW.TypeOrganisme, SYSTIMESTAMP, NULL, 'Update', 
            v_user, SYSTIMESTAMP
        );
    ELSIF DELETING THEN
        INSERT INTO OrganismeDeFormation_History (
            SIREN, RaisonSocial, Ville, Pays, Adresse, NumDeTelephone, Email, SiteWeb, 
            TypeOrganisme, StartDate, EndDate, ChangeType, ModifiedBy, ModifiedAt
        )
        VALUES (
            :OLD.SIREN, :OLD.RaisonSocial, :OLD.Ville, :OLD.Pays, :OLD.Adresse, :OLD.NumDeTelephone, 
            :OLD.Email, :OLD.SiteWeb, :OLD.TypeOrganisme, SYSTIMESTAMP, NULL, 'Delete', 
            v_user, SYSTIMESTAMP
        );
    END IF;
END;
/

------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------  Table Formateur_History --------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------
DROP TABLE Formateur_History;
CREATE TABLE Formateur_History (
    HistoryID INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    IdFormateur VARCHAR(20),
    NomFormateur VARCHAR(50),
    PrenomFormateur VARCHAR(50),
    AdresseEmail VARCHAR(50),
    TelephoneFormateur VARCHAR(20),
    DateEmbauche DATE,
    StartDate TIMESTAMP,
    EndDate TIMESTAMP,
    ChangeType VARCHAR2(20),
    ModifiedBy VARCHAR2(50),
    ModifiedAt TIMESTAMP
);

------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------  Trigger Formateur_History_Trigger ----------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE OR REPLACE TRIGGER Formateur_History_Trigger
BEFORE INSERT OR UPDATE OR DELETE ON Formateur
FOR EACH ROW
DECLARE
    v_user VARCHAR2(50);
BEGIN
    SELECT USER INTO v_user FROM DUAL; -- Capture the user who is making the change

    IF INSERTING THEN
        INSERT INTO Formateur_History (
            IdFormateur, NomFormateur, PrenomFormateur, AdresseEmail, TelephoneFormateur, DateEmbauche,
            StartDate, EndDate, ChangeType, ModifiedBy, ModifiedAt
        )
        VALUES (
            :NEW.IdFormateur, :NEW.NomFormateur, :NEW.PrenomFormateur, :NEW.AdresseEmail, :NEW.TelephoneFormateur,
            :NEW.DateEmbauche, SYSTIMESTAMP, NULL, 'Insert', v_user, SYSTIMESTAMP
        );
    ELSIF UPDATING THEN
        INSERT INTO Formateur_History (
            IdFormateur, NomFormateur, PrenomFormateur, AdresseEmail, TelephoneFormateur, DateEmbauche,
            StartDate, EndDate, ChangeType, ModifiedBy, ModifiedAt
        )
        VALUES (
            :NEW.IdFormateur, :NEW.NomFormateur, :NEW.PrenomFormateur, :NEW.AdresseEmail, :NEW.TelephoneFormateur,
            :NEW.DateEmbauche, SYSTIMESTAMP, NULL, 'Update', v_user, SYSTIMESTAMP
        );
    ELSIF DELETING THEN
        INSERT INTO Formateur_History (
            IdFormateur, NomFormateur, PrenomFormateur, AdresseEmail, TelephoneFormateur, DateEmbauche,
            StartDate, EndDate, ChangeType, ModifiedBy, ModifiedAt
        )
        VALUES (
            :OLD.IdFormateur, :OLD.NomFormateur, :OLD.PrenomFormateur, :OLD.AdresseEmail, :OLD.TelephoneFormateur,
            :OLD.DateEmbauche, SYSTIMESTAMP, NULL, 'Delete', v_user, SYSTIMESTAMP
        );
    END IF;
END;
/


------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------  Table Client_Apprenant_History -------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------
DROP TABLE Client_Apprenant_History;
CREATE TABLE Client_Apprenant_History (
    HistoryID INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    IdClient VARCHAR(20),
    NomClient VARCHAR(50),
    PrenomClient VARCHAR(50),
    GenreContact VARCHAR(20),
    DatePremierContact DATE,
    DateNaissance DATE,
    AdresseEmail VARCHAR(50),
    StartDate TIMESTAMP,
    EndDate TIMESTAMP,
    ChangeType VARCHAR2(20),
    ModifiedBy VARCHAR2(50),
    ModifiedAt TIMESTAMP
);

------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------  Trigger Client_Apprenant_History_Trigger ---------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------

CREATE OR REPLACE TRIGGER Client_Apprenant_History_Trigger
BEFORE INSERT OR UPDATE OR DELETE ON Client_Apprenant
FOR EACH ROW
DECLARE
    v_user VARCHAR2(50);
BEGIN
    SELECT USER INTO v_user FROM DUAL; -- Capture the user who is making the change

    IF INSERTING THEN
        INSERT INTO Client_Apprenant_History (
            IdClient, NomClient, PrenomClient, GenreContact, DatePremierContact, DateNaissance, AdresseEmail,
            StartDate, EndDate, ChangeType, ModifiedBy, ModifiedAt
        )
        VALUES (
            :NEW.IdClient, :NEW.NomClient, :NEW.PrenomClient, :NEW.GenreContact, :NEW.DatePremierContact,
            :NEW.DateNaissance, :NEW.AdresseEmail, SYSTIMESTAMP, NULL, 'Insert', v_user, SYSTIMESTAMP
        );
    ELSIF UPDATING THEN
        INSERT INTO Client_Apprenant_History (
            IdClient, NomClient, PrenomClient, GenreContact, DatePremierContact, DateNaissance, AdresseEmail,
            StartDate, EndDate, ChangeType, ModifiedBy, ModifiedAt
        )
        VALUES (
            :NEW.IdClient, :NEW.NomClient, :NEW.PrenomClient, :NEW.GenreContact, :NEW.DatePremierContact,
            :NEW.DateNaissance, :NEW.AdresseEmail, SYSTIMESTAMP, NULL, 'Update', v_user, SYSTIMESTAMP
        );
    ELSIF DELETING THEN
        INSERT INTO Client_Apprenant_History (
            IdClient, NomClient, PrenomClient, GenreContact, DatePremierContact, DateNaissance, AdresseEmail,
            StartDate, EndDate, ChangeType, ModifiedBy, ModifiedAt
        )
        VALUES (
            :OLD.IdClient, :OLD.NomClient, :OLD.PrenomClient, :OLD.GenreContact, :OLD.DatePremierContact,
            :OLD.DateNaissance, :OLD.AdresseEmail, SYSTIMESTAMP, NULL, 'Delete', v_user, SYSTIMESTAMP
        );
    END IF;
END;
/






------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------  Table LaSession_History --------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------


DROP TABLE LaSession_History;
CREATE TABLE LaSession_History (
    HistoryID INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    IdLaSession VARCHAR(20),
    IdFormateur VARCHAR(20),
    Date_Debut DATE,
    Date_Fin DATE,
    SIRENOrganismeFormation VARCHAR(20),
    StartDate TIMESTAMP,
    EndDate TIMESTAMP,
    ChangeType VARCHAR2(20),
    ModifiedBy VARCHAR2(50),
    ModifiedAt TIMESTAMP
);


------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------  Trigger LaSession_History_Trigger --------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE OR REPLACE TRIGGER LaSession_History_Trigger
BEFORE INSERT OR UPDATE OR DELETE ON LaSession
FOR EACH ROW
DECLARE
    v_user VARCHAR2(50);
BEGIN
    SELECT USER INTO v_user FROM DUAL; -- Capture the user who is making the change

    IF INSERTING THEN
        INSERT INTO LaSession_History (
            IdLaSession, IdFormateur, Date_Debut, Date_Fin, SIRENOrganismeFormation,
            StartDate, EndDate, ChangeType, ModifiedBy, ModifiedAt
        )
        VALUES (
            :NEW.IdLaSession, :NEW.IdFormateur, :NEW.Date_Debut, :NEW.Date_Fin, :NEW.SIRENOrganismeFormation,
            SYSTIMESTAMP, NULL, 'Insert', v_user, SYSTIMESTAMP
        );
    ELSIF UPDATING THEN
        INSERT INTO LaSession_History (
            IdLaSession, IdFormateur, Date_Debut, Date_Fin, SIRENOrganismeFormation,
            StartDate, EndDate, ChangeType, ModifiedBy, ModifiedAt
        )
        VALUES (
            :NEW.IdLaSession, :NEW.IdFormateur, :NEW.Date_Debut, :NEW.Date_Fin, :NEW.SIRENOrganismeFormation,
            SYSTIMESTAMP, NULL, 'Update', v_user, SYSTIMESTAMP
        );
    ELSIF DELETING THEN
        INSERT INTO LaSession_History (
            IdLaSession, IdFormateur, Date_Debut, Date_Fin, SIRENOrganismeFormation,
            StartDate, EndDate, ChangeType, ModifiedBy, ModifiedAt
        )
        VALUES (
            :OLD.IdLaSession, :OLD.IdFormateur, :OLD.Date_Debut, :OLD.Date_Fin, :OLD.SIRENOrganismeFormation,
            SYSTIMESTAMP, NULL, 'Delete', v_user, SYSTIMESTAMP
        );
    END IF;
END;
/

------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------  Table Appartenir_History --------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------
DROP TABLE Appartenir_History;
CREATE TABLE Appartenir_History (
    HistoryID INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    formateur_idformateur VARCHAR(20),
    organismeformation_SIREN VARCHAR(20),
    StartDate TIMESTAMP,
    EndDate TIMESTAMP,
    ChangeType VARCHAR2(20),
    ModifiedBy VARCHAR2(50),
    ModifiedAt TIMESTAMP
);


------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------  Trigger  Appartenir_History --------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------


CREATE OR REPLACE TRIGGER Appartenir_History_Trigger
BEFORE INSERT OR UPDATE OR DELETE ON Appartenir
FOR EACH ROW
DECLARE
    v_user VARCHAR2(50);
BEGIN
    SELECT USER INTO v_user FROM DUAL; -- Capture the user who is making the change

    IF INSERTING THEN
        INSERT INTO Appartenir_History (
            formateur_idformateur, organismeformation_SIREN,
            StartDate, EndDate, ChangeType, ModifiedBy, ModifiedAt
        )
        VALUES (
            :NEW.formateur_idformateur, :NEW.organismeformation_SIREN,
            SYSTIMESTAMP, NULL, 'Insert', v_user, SYSTIMESTAMP
        );
    ELSIF UPDATING THEN
        INSERT INTO Appartenir_History (
            formateur_idformateur, organismeformation_SIREN,
            StartDate, EndDate, ChangeType, ModifiedBy, ModifiedAt
        )
        VALUES (
            :NEW.formateur_idformateur, :NEW.organismeformation_SIREN,
            SYSTIMESTAMP, NULL, 'Update', v_user, SYSTIMESTAMP
        );
    ELSIF DELETING THEN
        INSERT INTO Appartenir_History (
            formateur_idformateur, organismeformation_SIREN,
            StartDate, EndDate, ChangeType, ModifiedBy, ModifiedAt
        )
        VALUES (
            :OLD.formateur_idformateur, :OLD.organismeformation_SIREN,
            SYSTIMESTAMP, NULL, 'Delete', v_user, SYSTIMESTAMP
        );
    END IF;
END;
/



------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------  Trigger  Inscription_History --------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------
DROP TABLE Inscription_History;
CREATE TABLE Inscription_History (
    HistoryID INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    IdClient VARCHAR(20),
    IdLaSession VARCHAR(20),
    StartDate TIMESTAMP,
    EndDate TIMESTAMP,
    ChangeType VARCHAR2(20),
    ModifiedBy VARCHAR2(50),
    ModifiedAt TIMESTAMP
);



------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------  Trigger  Inscription_History_Trigger  ------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------

CREATE OR REPLACE TRIGGER Inscription_History_Trigger
BEFORE INSERT OR UPDATE OR DELETE ON Inscription
FOR EACH ROW
DECLARE
    v_user VARCHAR2(50);
BEGIN
    SELECT USER INTO v_user FROM DUAL; -- Capture the user who is making the change

    IF INSERTING THEN
        INSERT INTO Inscription_History (
            IdClient, IdLaSession,
            StartDate, EndDate, ChangeType, ModifiedBy, ModifiedAt
        )
        VALUES (
            :NEW.IdClient, :NEW.IdLaSession,
            SYSTIMESTAMP, NULL, 'Insert', v_user, SYSTIMESTAMP
        );
    ELSIF UPDATING THEN
        INSERT INTO Inscription_History (
            IdClient, IdLaSession,
            StartDate, EndDate, ChangeType, ModifiedBy, ModifiedAt
        )
        VALUES (
            :NEW.IdClient, :NEW.IdLaSession,
            SYSTIMESTAMP, NULL, 'Update', v_user, SYSTIMESTAMP
        );
    ELSIF DELETING THEN
        INSERT INTO Inscription_History (
            IdClient, IdLaSession,
            StartDate, EndDate, ChangeType, ModifiedBy, ModifiedAt
        )
        VALUES (
            :OLD.IdClient, :OLD.IdLaSession,
            SYSTIMESTAMP, NULL, 'Delete', v_user, SYSTIMESTAMP
        );
    END IF;
END;
/



------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------  Test Table Historisation -------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------- Insertion Operation  ------------------------------------------------------------------------------
INSERT INTO DomaineFormation (RefDomaine, DomaineDeFormation,MotsCles) VALUES ('CEGOS_DomaineF-01', 'Achats','achats');
INSERT INTO DomaineFormation (RefDomaine, DomaineDeFormation,MotsCles) VALUES ('CEGOS_DomaineF-02', 'Assistant(e)','assistante');
INSERT INTO DomaineFormation (RefDomaine, DomaineDeFormation,MotsCles) VALUES ('CEGOS_DomaineF-03', 'Banque','banque');
INSERT INTO DomaineFormation (RefDomaine, DomaineDeFormation,MotsCles) VALUES ('CEGOS_DomaineF-04', 'Bureautique - PAO/CAO','bureautique, pao, cao');
INSERT INTO DomaineFormation (RefDomaine, DomaineDeFormation,MotsCles) VALUES ('CEGOS_DomaineF-05', 'Changement','changement');
INSERT INTO DomaineFormation (RefDomaine, DomaineDeFormation,MotsCles) VALUES ('CEGOS_DomaineF-06', 'Coaching','coaching');
INSERT INTO DomaineFormation (RefDomaine, DomaineDeFormation,MotsCles) VALUES ('CEGOS_DomaineF-07', 'Commercial - Ventes','commercial, ventes');
INSERT INTO DomaineFormation (RefDomaine, DomaineDeFormation,MotsCles) VALUES ('CEGOS_DomaineF-08', 'Communication','communication');
INSERT INTO DomaineFormation (RefDomaine, DomaineDeFormation,MotsCles) VALUES ('CEGOS_DomaineF-09', 'Comptabilit? - Fiscalit?','comptabilite, fiscalite');
INSERT INTO DomaineFormation (RefDomaine, DomaineDeFormation,MotsCles) VALUES ('CEGOS_DomaineF-10', 'Contr?le de gestion','controle, gestion');
-------------------------------------------------------- Fin Insertion Operation  ---------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------  Update Operation ----------------------------------------------------------------------------------
UPDATE DomaineFormation  SET MotsCles = 'finance, banque'  WHERE RefDomaine = 'CEGOS_DomaineF-03';
UPDATE DomaineFormation  SET DomaineDeFormation = 'Stratégie d''Achats'  WHERE RefDomaine = 'CEGOS_DomaineF-01';
UPDATE DomaineFormation  SET MotsCles = 'bureautique, pao, dao, cao'  WHERE RefDomaine = 'CEGOS_DomaineF-04';
UPDATE DomaineFormation  SET DomaineDeFormation = 'Coaching Professionnel'  WHERE RefDomaine = 'CEGOS_DomaineF-06';
UPDATE DomaineFormation  SET MotsCles = 'communication, relations publiques, médias'  WHERE RefDomaine = 'CEGOS_DomaineF-08';
--------------------------------------------------------- Fin Update Operation ------------------------------------------------------------------------------
--------------------------------------------------------  Delete Operation ----------------------------------------------------------------------------------
DELETE FROM DomaineFormation  WHERE RefDomaine = 'CEGOS_DomaineF-01';
DELETE FROM DomaineFormation  WHERE RefDomaine = 'CEGOS_DomaineF-03';
DELETE FROM DomaineFormation  WHERE RefDomaine = 'CEGOS_DomaineF-05';
DELETE FROM DomaineFormation  WHERE RefDomaine = 'CEGOS_DomaineF-09';
DELETE FROM DomaineFormation  WHERE RefDomaine = 'CEGOS_DomaineF-07';
--------------------------------------------------------- Fin Delete  Operation ------------------------------------------------------------------------------

--------------------- Testing -----------------
select * from DomaineFormation;
select * from DomaineFormation_History;


SELECT *
FROM DomaineFormation d
JOIN DomaineFormation_History h
ON d.RefDomaine = h.RefDomaine
WHERE SYSDATE BETWEEN h.StartDate AND NVL(h.EndDate, SYSTIMESTAMP);
