--meta-data big forma
--meta-table
DROP TABLE META_TABLES;
CREATE TABLE META_TABLES (
    ID_TABLE INT PRIMARY KEY,
    NOM_TABLE VARCHAR2(50),
    DATE_CREATION DATE,
    NOMBRE_COLONNES INT,
    NOMBRE_LIGNES INT,
    COMMENTAIRES CLOB
);

-- insertion de des tables
insert into META_TABLES (ID_TABLE,NOM_TABLE,COMMENTAIRES) values (1,'ABREVIATIONS','ABREVIATIONS');
insert into META_TABLES (ID_TABLE,NOM_TABLE,COMMENTAIRES) values (2,'Specialitee','Specialitee');
insert into META_TABLES (ID_TABLE,NOM_TABLE,COMMENTAIRES) values (3,'DomaineFormation','DomaineFormation');
insert into META_TABLES (ID_TABLE,NOM_TABLE,COMMENTAIRES) values (4,'SousDomaineFormation','SousDomaineFormation');
insert into META_TABLES (ID_TABLE,NOM_TABLE,COMMENTAIRES) values (5,'SOUSSOUSDomaineFormation','SOUSSOUSDomaineFormation');
insert into META_TABLES (ID_TABLE,NOM_TABLE,COMMENTAIRES) values (6,'OrganismeDeFormation','OrganismeDeFormation');
insert into META_TABLES (ID_TABLE,NOM_TABLE,COMMENTAIRES) values (7,'Formateur','Formateur');
insert into META_TABLES (ID_TABLE,NOM_TABLE,COMMENTAIRES) values (8,'Client_Apprenant','Client_Apprenant');
insert into META_TABLES (ID_TABLE,NOM_TABLE,COMMENTAIRES) values (9,'LaSession','LaSession');
insert into META_TABLES (ID_TABLE,NOM_TABLE,COMMENTAIRES) values (10,'Demander','Demander');
insert into META_TABLES (ID_TABLE,NOM_TABLE,COMMENTAIRES) values (11,'SeDeclarer','SeDeclarer');
insert into META_TABLES (ID_TABLE,NOM_TABLE,COMMENTAIRES) values (12,'Appartenir','Appartenir');
insert into META_TABLES (ID_TABLE,NOM_TABLE,COMMENTAIRES) values (13,'Inscription','Inscription');

--insertion de nombre de lignes
BEGIN
    update META_TABLES set NOMBRE_LIGNES = (select count(*) from ABREVIATIONS) where ID_TABLE = 1;
    update META_TABLES set NOMBRE_LIGNES = (select count(*) from Specialitee) where ID_TABLE = 2;
    update META_TABLES set NOMBRE_LIGNES = (select count(*) from DomaineFormation) where ID_TABLE = 3;
    update META_TABLES set NOMBRE_LIGNES = (select count(*) from SousDomaineFormation) where ID_TABLE = 4;
    update META_TABLES set NOMBRE_LIGNES = (select count(*) from SOUSSOUSDomaineFormation) where ID_TABLE = 5;
    update META_TABLES set NOMBRE_LIGNES = (select count(*) from OrganismeDeFormation) where ID_TABLE = 6;
    update META_TABLES set NOMBRE_LIGNES = (select count(*) from Formateur) where ID_TABLE = 7;
    update META_TABLES set NOMBRE_LIGNES = (select count(*) from Client_Apprenant) where ID_TABLE = 8;
    update META_TABLES set NOMBRE_LIGNES = (select count(*) from LaSession) where ID_TABLE = 9;
    update META_TABLES set NOMBRE_LIGNES = (select count(*) from Demander) where ID_TABLE = 10;
    update META_TABLES set NOMBRE_LIGNES = (select count(*) from SeDeclarer) where ID_TABLE = 11;
    update META_TABLES set NOMBRE_LIGNES = (select count(*) from Appartenir) where ID_TABLE = 12;
    update META_TABLES set NOMBRE_LIGNES = (select count(*) from Inscription) where ID_TABLE = 13;  
END;
/

--insertion date creation
UPDATE META_TABLES SET DATE_CREATION = ( SELECT created FROM all_objects WHERE object_type = 'TABLE' AND object_name = 'DOMAINEFORMATION' ); 

--insertions des nombre de colonne
SELECT COUNT(*) FROM all_tab_columns WHERE table_name = 'DOMAINEFORMATION';
update META_TABLES set NOMBRE_COLONNES = (SELECT COUNT(*) FROM all_tab_columns WHERE table_name = upper('ABREVIATIONS')) where ID_TABLE = 1;
update META_TABLES set NOMBRE_COLONNES = (SELECT COUNT(*) FROM all_tab_columns WHERE table_name = upper('Specialitee')) where ID_TABLE = 2;
update META_TABLES set NOMBRE_COLONNES = (SELECT COUNT(*) FROM all_tab_columns WHERE table_name = upper('DomaineFormation')) where ID_TABLE = 3;
update META_TABLES set NOMBRE_COLONNES = (SELECT COUNT(*) FROM all_tab_columns WHERE table_name = upper('SousDomaineFormation')) where ID_TABLE = 4;
update META_TABLES set NOMBRE_COLONNES = (SELECT COUNT(*) FROM all_tab_columns WHERE table_name = upper('SOUSSOUSDomaineFormation')) where ID_TABLE = 5;
update META_TABLES set NOMBRE_COLONNES = (SELECT COUNT(*) FROM all_tab_columns WHERE table_name = upper('OrganismeDeFormation')) where ID_TABLE = 6;
update META_TABLES set NOMBRE_COLONNES = (SELECT COUNT(*) FROM all_tab_columns WHERE table_name = upper('Formateur')) where ID_TABLE = 7;
update META_TABLES set NOMBRE_COLONNES = (SELECT COUNT(*) FROM all_tab_columns WHERE table_name = upper('Client_Apprenant')) where ID_TABLE = 8;
update META_TABLES set NOMBRE_COLONNES = (SELECT COUNT(*) FROM all_tab_columns WHERE table_name = upper('LaSession')) where ID_TABLE = 9;
update META_TABLES set NOMBRE_COLONNES = (SELECT COUNT(*) FROM all_tab_columns WHERE table_name = upper('Demander')) where ID_TABLE = 10;
update META_TABLES set NOMBRE_COLONNES = (SELECT COUNT(*) FROM all_tab_columns WHERE table_name = upper('SeDeclarer')) where ID_TABLE = 11;
update META_TABLES set NOMBRE_COLONNES = (SELECT COUNT(*) FROM all_tab_columns WHERE table_name = upper('Appartenir')) where ID_TABLE = 12;
update META_TABLES set NOMBRE_COLONNES = (SELECT COUNT(*) FROM all_tab_columns WHERE table_name = upper('Inscription')) where ID_TABLE = 13;

select * from META_TABLES;
--------------------------------------------------------------------------------
-- creation de la table meta-colonnes  
DROP TABLE META_COLONNES; 
create table META_COLONNES(
    ID_COLONNE NUMBER primary key,
    NOM_TABLE varchar(50),
    NOM_COLONNE varchar(50),
    DATE_CREATION DATE,
    DATE_DIAGNOSTIQUE DATE,
    NOMBRE_VAL NUMBER,
    NOMBRE_VM NUMBER,
    --NOMBRE_LIGNES NUMBER,
    NOMBRE_SPE_CHAR NUMBER,
    TYPE_COLONNE VARCHAR(50),
    NOMBRE_ANOMALIES NUMBER,
    OUTLAYER_VALS NUMBER,
    EXPRESSION_REGULIERE VARCHAR(100),
    NEGATIF NUMBER,
    NOMBRE_ESPACES NUMBER,
    TYPE_CLEF VARCHAR(50),
    --FORMAT_RESPECT NUMBER(1) CHECK (FORMAT_RESPECT IN (0, 1)),
    --DEVISE VARCHAR(30),
    EXISTANCE_CHIFFRES NUMBER(1) CHECK (EXISTANCE_CHIFFRES in (0,1)),
    TAILLE_MEMOIRE NUMBER,
    NOMBRE_REPETITION_CHAR NUMBER,
    NOMBRE_VALEUR_UNIQUE NUMBER,
    NOMBRE_DOUBLONS NUMBER,
    PROPORTION_INITCAP NUMBER,
    PROPORTION_UPPER NUMBER,
    PROPORTION_LOWER NUMBER
);


-- creation de la table META_caracteristiques
DROP TABLE meta_caracteristiques;
CREATE TABLE meta_caracteristiques (
    Nom_Car VARCHAR(50),
    Description CLOB
);


-- insertion des meta-donnees des colonnes de table ABREVIATIONS  -----------------------------------------------------------------------------------------------
INSERT INTO META_COLONNES (ID_COLONNE,NOM_TABLE,NOM_COLONNE)values(0,'ABREVIATIONS','ID');
INSERT INTO META_COLONNES (ID_COLONNE,NOM_TABLE,NOM_COLONNE)values(1,'ABREVIATIONS','ORIGINAL_TEXT');
INSERT INTO META_COLONNES (ID_COLONNE,NOM_TABLE,NOM_COLONNE)values(2,'ABREVIATIONS','ABBREVIATION');


-- insertion des meta_donn?es de la table meta_caracterestique
INSERT INTO meta_caracteristiques (Nom_Car, Description) VALUES ('ID_COLONNE', 'Numero de colonne (cl? primaire)');
INSERT INTO meta_caracteristiques (Nom_Car, Description) VALUES ('NOM_TABLE', 'Nom de la table');
INSERT INTO meta_caracteristiques (Nom_Car, Description) VALUES ('NOM_COLONNE', 'Nom de la colonne');
INSERT INTO meta_caracteristiques (Nom_Car, Description) VALUES ('DATE_CREATION', 'Date de cr?aton de la colonne');
INSERT INTO meta_caracteristiques (Nom_Car, Description) VALUES ('DATE_DIAGNOSTIQUE', 'Date de diagnostic de la colonne');
INSERT INTO meta_caracteristiques (Nom_Car, Description) VALUES ('NOMBRE_VAL', 'Nombre de valeurs');
INSERT INTO meta_caracteristiques (Nom_Car, Description) VALUES ('NOMBRE_VM', 'Nombre de valeurs manquantes');
--INSERT INTO meta_caracteristiques (Nom_Car, Description) VALUES ('NOMBRE_LIGNES', 'Nombre de lignes');
INSERT INTO meta_caracteristiques (Nom_Car, Description) VALUES ('NOMBRE_SPE_CHAR', 'Nombre de caract?res sp?ciaux');
INSERT INTO meta_caracteristiques (Nom_Car, Description) VALUES ('TYPE_COLONNE', 'Type de colonne');
INSERT INTO meta_caracteristiques (Nom_Car, Description) VALUES ('NOMBRE_ANOMALIES', 'Nombre d''anomalies');
INSERT INTO meta_caracteristiques (Nom_Car, Description) VALUES ('OUTLAYER_VALS', 'Nombre de valeurs aberrantes');
INSERT INTO meta_caracteristiques (Nom_Car, Description) VALUES ('EXPRESSION_REGULIERE', 'Expression r?guli?re utilis?e');
INSERT INTO meta_caracteristiques (Nom_Car, Description) VALUES ('NEGATIF', 'Nombre de valeurs n?gatives');
INSERT INTO meta_caracteristiques (Nom_Car, Description) VALUES ('NOMBRE_ESPACES', 'Nombre d''espaces inutiles'); --(NOMBRE_ESPACES_INU)
INSERT INTO meta_caracteristiques (Nom_Car, Description) VALUES ('PROP_INIT', 'Proportion de mots initcap');
INSERT INTO meta_caracteristiques (Nom_Car, Description) VALUES ('PROP_MAJ', 'Proportion de mots majuscules');
INSERT INTO meta_caracteristiques (Nom_Car, Description) VALUES ('PROP_MIN', 'Proportion de mots minuscules');
INSERT INTO meta_caracteristiques (Nom_Car, Description) VALUES ('TYPE_CLEF', 'Type de cl? (Primaire, Etrang?re)'); --Mais si la valeur n'est pas un cl? primaire ni etrang?re
INSERT INTO meta_caracteristiques (Nom_Car, Description) VALUES ('FORMAT_RESPECT', 'Respect du format (0 ou 1)');
INSERT INTO meta_caracteristiques (Nom_Car, Description) VALUES ('DEVISE', 'Devise (Euro, Dollar, Dh)');
INSERT INTO meta_caracteristiques (Nom_Car, Description) VALUES ('EXISTANCE_CHIFFRES', 'Existence de chiffres (0 ou 1)');
INSERT INTO meta_caracteristiques (Nom_Car, Description) VALUES ('TAILLE_MEMOIRE', 'Taille en m?moire');
INSERT INTO meta_caracteristiques (Nom_Car, Description) VALUES ('NOMBRE_REPETITION_CHAR', 'Nombre de valeurs qui ont des lettres r?p?t?es plus que deux fois');
INSERT INTO meta_caracteristiques (Nom_Car, Description) VALUES ('NOMBRE_VALEUR_UNIQUE', 'Nombre de valeurs uniques'); 
INSERT INTO meta_caracteristiques (Nom_Car, Description) VALUES ('NOMBRE_DOUBLONS', 'Nombre de doublons');


-- insertion des meta-donnees des colonnes de table Specialitee  -----------------------------------------------------------------------------------------------
INSERT INTO META_COLONNES (ID_COLONNE,NOM_TABLE,NOM_COLONNE)values(3,'Specialitee','NumeroSpecialite');
INSERT INTO META_COLONNES (ID_COLONNE,NOM_TABLE,NOM_COLONNE)values(4,'Specialitee','IntituleSpecialite');
INSERT INTO META_COLONNES (ID_COLONNE,NOM_TABLE,NOM_COLONNE)values(5,'Specialitee','Description');


-- insertion des meta-donnees des colonnes de table DomaineFormation  -----------------------------------------------------------------------------------------------
INSERT INTO META_COLONNES (ID_COLONNE,NOM_TABLE,NOM_COLONNE)values(6,'DomaineFormation','RefDomaine');
INSERT INTO META_COLONNES (ID_COLONNE,NOM_TABLE,NOM_COLONNE)values(7,'DomaineFormation','DomaineDeFormation');
INSERT INTO META_COLONNES (ID_COLONNE,NOM_TABLE,NOM_COLONNE)values(8,'DomaineFormation','MotsCles');
INSERT INTO META_COLONNES (ID_COLONNE,NOM_TABLE,NOM_COLONNE)values(9,'DomaineFormation','DateCreation');


-- insertion des meta-donnees des colonnes de table SousDomaineFormation  -----------------------------------------------------------------------------------------------
INSERT INTO META_COLONNES (ID_COLONNE,NOM_TABLE,NOM_COLONNE)values(10,'SousDomaineFormation','RefSousDomaine');
INSERT INTO META_COLONNES (ID_COLONNE,NOM_TABLE,NOM_COLONNE)values(11,'SousDomaineFormation','RefDomaine');
INSERT INTO META_COLONNES (ID_COLONNE,NOM_TABLE,NOM_COLONNE)values(12,'SousDomaineFormation','SousDomaineDeFormation');
INSERT INTO META_COLONNES (ID_COLONNE,NOM_TABLE,NOM_COLONNE)values(13,'SousDomaineFormation','Description');
INSERT INTO META_COLONNES (ID_COLONNE,NOM_TABLE,NOM_COLONNE)values(14,'SousDomaineFormation','MotsCles');
INSERT INTO META_COLONNES (ID_COLONNE,NOM_TABLE,NOM_COLONNE)values(15,'SousDomaineFormation','FOREIGN');


-- insertion des meta-donnees des colonnes de table SOUSSOUSDomaineFormation;  -----------------------------------------------------------------------------------------------
INSERT INTO META_COLONNES (ID_COLONNE,NOM_TABLE,NOM_COLONNE)values(16,'SOUSSOUSDomaineFormation','RefSOUSSOUSDomaineF');
INSERT INTO META_COLONNES (ID_COLONNE,NOM_TABLE,NOM_COLONNE)values(17,'SOUSSOUSDomaineFormation','RefSOUSDomaineF');
INSERT INTO META_COLONNES (ID_COLONNE,NOM_TABLE,NOM_COLONNE)values(18,'SOUSSOUSDomaineFormation','Le_nom');
INSERT INTO META_COLONNES (ID_COLONNE,NOM_TABLE,NOM_COLONNE)values(19,'SOUSSOUSDomaineFormation','Descriptio');
INSERT INTO META_COLONNES (ID_COLONNE,NOM_TABLE,NOM_COLONNE)values(20,'SOUSSOUSDomaineFormation','Notes');
INSERT INTO META_COLONNES (ID_COLONNE,NOM_TABLE,NOM_COLONNE)values(21,'SOUSSOUSDomaineFormation','Nombre_avis');
INSERT INTO META_COLONNES (ID_COLONNE,NOM_TABLE,NOM_COLONNE)values(22,'SOUSSOUSDomaineFormation','Duree');
INSERT INTO META_COLONNES (ID_COLONNE,NOM_TABLE,NOM_COLONNE)values(23,'SOUSSOUSDomaineFormation','Nombre_participants');
INSERT INTO META_COLONNES (ID_COLONNE,NOM_TABLE,NOM_COLONNE)values(24,'SOUSSOUSDomaineFormation','Niveau');
INSERT INTO META_COLONNES (ID_COLONNE,NOM_TABLE,NOM_COLONNE)values(25,'SOUSSOUSDomaineFormation','Liens');
INSERT INTO META_COLONNES (ID_COLONNE,NOM_TABLE,NOM_COLONNE)values(26,'SOUSSOUSDomaineFormation','Destinataires');
INSERT INTO META_COLONNES (ID_COLONNE,NOM_TABLE,NOM_COLONNE)values(27,'SOUSSOUSDomaineFormation','Chapitre');
INSERT INTO META_COLONNES (ID_COLONNE,NOM_TABLE,NOM_COLONNE)values(28,'SOUSSOUSDomaineFormation','Competences_gagnees');
INSERT INTO META_COLONNES (ID_COLONNE,NOM_TABLE,NOM_COLONNE)values(29,'SOUSSOUSDomaineFormation','Organisation');
INSERT INTO META_COLONNES (ID_COLONNE,NOM_TABLE,NOM_COLONNE)values(30,'SOUSSOUSDomaineFormation','MotsCles');
INSERT INTO META_COLONNES (ID_COLONNE,NOM_TABLE,NOM_COLONNE)values(31,'SOUSSOUSDomaineFormation','FOREIGN');


-- insertion des meta-donnees des colonnes de table OrganismeDeFormation;  -----------------------------------------------------------------------------------------------
INSERT INTO META_COLONNES (ID_COLONNE,NOM_TABLE,NOM_COLONNE)values(32,'OrganismeDeFormation','SIREN');
INSERT INTO META_COLONNES (ID_COLONNE,NOM_TABLE,NOM_COLONNE)values(33,'OrganismeDeFormation','RaisonSocial');
INSERT INTO META_COLONNES (ID_COLONNE,NOM_TABLE,NOM_COLONNE)values(34,'OrganismeDeFormation','Ville');
INSERT INTO META_COLONNES (ID_COLONNE,NOM_TABLE,NOM_COLONNE)values(35,'OrganismeDeFormation','Pays');
INSERT INTO META_COLONNES (ID_COLONNE,NOM_TABLE,NOM_COLONNE)values(36,'OrganismeDeFormation','Adresse');
INSERT INTO META_COLONNES (ID_COLONNE,NOM_TABLE,NOM_COLONNE)values(37,'OrganismeDeFormation','NumDeTelephone');
INSERT INTO META_COLONNES (ID_COLONNE,NOM_TABLE,NOM_COLONNE)values(38,'OrganismeDeFormation','Email');
INSERT INTO META_COLONNES (ID_COLONNE,NOM_TABLE,NOM_COLONNE)values(39,'OrganismeDeFormation','SiteWeb');
INSERT INTO META_COLONNES (ID_COLONNE,NOM_TABLE,NOM_COLONNE)values(40,'OrganismeDeFormation','TypeOrganisme');


-- insertion des meta-donnees des colonnes de table Formateur;  -----------------------------------------------------------------------------------------------
INSERT INTO META_COLONNES (ID_COLONNE,NOM_TABLE,NOM_COLONNE)values(41,'Formateur','IdFormateur');
INSERT INTO META_COLONNES (ID_COLONNE,NOM_TABLE,NOM_COLONNE)values(42,'Formateur','NomFormateur');
INSERT INTO META_COLONNES (ID_COLONNE,NOM_TABLE,NOM_COLONNE)values(43,'Formateur','PrenomFormateur');
INSERT INTO META_COLONNES (ID_COLONNE,NOM_TABLE,NOM_COLONNE)values(44,'Formateur','AdresseEmail');
INSERT INTO META_COLONNES (ID_COLONNE,NOM_TABLE,NOM_COLONNE)values(45,'Formateur','TelephoneFormateur');
INSERT INTO META_COLONNES (ID_COLONNE,NOM_TABLE,NOM_COLONNE)values(46,'Formateur','DateEmbauche');



-- insertion des meta-donnees des colonnes de table Client_Apprenant;  -----------------------------------------------------------------------------------------------
INSERT INTO META_COLONNES (ID_COLONNE,NOM_TABLE,NOM_COLONNE)values(47,'Client_Apprenant','IdClient');
INSERT INTO META_COLONNES (ID_COLONNE,NOM_TABLE,NOM_COLONNE)values(48,'Client_Apprenant','NomClient');
INSERT INTO META_COLONNES (ID_COLONNE,NOM_TABLE,NOM_COLONNE)values(49,'Client_Apprenant','PrenomClient');
INSERT INTO META_COLONNES (ID_COLONNE,NOM_TABLE,NOM_COLONNE)values(50,'Client_Apprenant','GenreContact');
INSERT INTO META_COLONNES (ID_COLONNE,NOM_TABLE,NOM_COLONNE)values(51,'Client_Apprenant','DatePremierContact');
INSERT INTO META_COLONNES (ID_COLONNE,NOM_TABLE,NOM_COLONNE)values(52,'Client_Apprenant','DateNaissance');
INSERT INTO META_COLONNES (ID_COLONNE,NOM_TABLE,NOM_COLONNE)values(53,'Client_Apprenant','AdresseEmail');


-- insertion des meta-donnees des colonnes de table LaSession;  -----------------------------------------------------------------------------------------------
INSERT INTO META_COLONNES (ID_COLONNE,NOM_TABLE,NOM_COLONNE)values(54,'LaSession','IdLaSession');
INSERT INTO META_COLONNES (ID_COLONNE,NOM_TABLE,NOM_COLONNE)values(55,'LaSession','IdFormateur');
INSERT INTO META_COLONNES (ID_COLONNE,NOM_TABLE,NOM_COLONNE)values(56,'LaSession','Date_Debut');
INSERT INTO META_COLONNES (ID_COLONNE,NOM_TABLE,NOM_COLONNE)values(57,'LaSession','Date_Fin');
INSERT INTO META_COLONNES (ID_COLONNE,NOM_TABLE,NOM_COLONNE)values(58,'LaSession','SIRENOrganismeFormation');

-- insertion des meta-donnees des colonnes de table Assurer;  -----------------------------------------------------------------------------------------------
INSERT INTO META_COLONNES (ID_COLONNE,NOM_TABLE,NOM_COLONNE)values(59,'Assurer','organismeformation_SIREN');
INSERT INTO META_COLONNES (ID_COLONNE,NOM_TABLE,NOM_COLONNE)values(60,'Assurer','SOUSSOUSdomaineFormation_Ref');


-- insertion des meta-donnees des colonnes de table Demander;  -----------------------------------------------------------------------------------------------
INSERT INTO META_COLONNES (ID_COLONNE,NOM_TABLE,NOM_COLONNE)values(61,'Demander','ClientApprenant_IdClient');
INSERT INTO META_COLONNES (ID_COLONNE,NOM_TABLE,NOM_COLONNE)values(62,'Demander','SOUSSOUSdomaineFormation_Id');

-- insertion des meta-donnees des colonnes de table SeDeclarer;  -----------------------------------------------------------------------------------------------
INSERT INTO META_COLONNES (ID_COLONNE,NOM_TABLE,NOM_COLONNE)values(63,'SeDeclarer','organismeformation_SIREN');
INSERT INTO META_COLONNES (ID_COLONNE,NOM_TABLE,NOM_COLONNE)values(64,'SeDeclarer','specialite_numero_specialite');

-- insertion des meta-donnees des colonnes de table Appartenir;  -----------------------------------------------------------------------------------------------
INSERT INTO META_COLONNES (ID_COLONNE,NOM_TABLE,NOM_COLONNE)values(65,'Appartenir','formateur_idformateur');
INSERT INTO META_COLONNES (ID_COLONNE,NOM_TABLE,NOM_COLONNE)values(66,'Appartenir','organismeformation_SIREN');


-- insertion des meta-donnees des colonnes de table Inscription;  -----------------------------------------------------------------------------------------------
INSERT INTO META_COLONNES (ID_COLONNE,NOM_TABLE,NOM_COLONNE)values(67,'Inscription','IdClient');
INSERT INTO META_COLONNES (ID_COLONNE,NOM_TABLE,NOM_COLONNE)values(68,'Inscription','IdLaSession');


-- creation meta_special_caract?re
drop table meta_caract_speciaux;
create table meta_caract_speciaux(
    ID_CARACT NUMBER primary key,
    DESC_CARCT VARCHAR(50),
    CARACT VARCHAR(4)
);


-- Inserer les caract?res speciaux --------------------------------------------------------------------------------------------------------------------------
INSERT INTO meta_caract_speciaux  VALUES (0,'Retour ? la ligne', '\n');
INSERT INTO meta_caract_speciaux  VALUES (1,'Retour chariot', '\r');
INSERT INTO meta_caract_speciaux  VALUES (2,'Tabulation horizontale', '\t');
INSERT INTO meta_caract_speciaux  VALUES (3,'Apostrophe', '''');
INSERT INTO meta_caract_speciaux  VALUES (4,'Guillemets doubles', '"');
INSERT INTO meta_caract_speciaux  VALUES (5,'Barre oblique invers?e', '\\');
INSERT INTO meta_caract_speciaux  VALUES (6,'Addition', '+');
INSERT INTO meta_caract_speciaux  VALUES (7,'Soustraction ou signe n?gatif', '-');
INSERT INTO meta_caract_speciaux  VALUES (8,'Virgule', ',');
INSERT INTO meta_caract_speciaux  VALUES (9,'Arobase', '@');
INSERT INTO meta_caract_speciaux  VALUES (10,'hash', '#');
INSERT INTO meta_caract_speciaux  VALUES (11,'Dollar', '$');
INSERT INTO meta_caract_speciaux  VALUES (12,'Esperluette', '&');
INSERT INTO meta_caract_speciaux  VALUES (13,'underscore', '_');
INSERT INTO meta_caract_speciaux  VALUES (14,'Tilde', '~');
INSERT INTO meta_caract_speciaux  VALUES (15,'Accent circonflexe', '^');
INSERT INTO meta_caract_speciaux  VALUES (16,'Barre verticale (pipe)', '|');
INSERT INTO meta_caract_speciaux  VALUES (17,'Symbole degr?', '?');
INSERT INTO meta_caract_speciaux  VALUES (18,'Mu', '?');
INSERT INTO meta_caract_speciaux  VALUES (19,'Euro', '?');


SELECT * FROM META_TABLES
SELECT * FROM meta_caract_speciaux
SELECT * FROM meta_caracteristiques
SELECT * FROM META_COLONNES