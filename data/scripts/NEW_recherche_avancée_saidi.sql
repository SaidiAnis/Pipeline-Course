CREATE OR REPLACE FUNCTION trouver_ligne_avec_mot_similaire(
    column_value IN VARCHAR2, 
    search_string IN VARCHAR2
) RETURN INTEGER
IS
    word VARCHAR2(100);
    position INTEGER := 1;
    next_space INTEGER;
    similarity_threshold INTEGER := 75; -- Seuil de similarité pour Jaro-Winkler
    levenshtein_threshold INTEGER := 2; -- Seuil pour la distance de Levenshtein pour les mots courts
    highest_similarity INTEGER := 0; -- Plus haut score de similarité trouvé
    current_similarity INTEGER;
    levenshtein_distance INTEGER;
BEGIN
    LOOP
        next_space := INSTR(column_value, ' ', position);
        IF next_space != 0 THEN
            word := SUBSTR(column_value, position, next_space - position);
        ELSE
            word := SUBSTR(column_value, position);
        END IF;

        IF LENGTH(search_string) <= 3 THEN
            levenshtein_distance := UTL_MATCH.EDIT_DISTANCE(UPPER(word), UPPER(search_string));
            IF levenshtein_distance <= levenshtein_threshold THEN
                current_similarity := 100; -- Score maximal pour une correspondance exacte
            ELSE
                current_similarity := 50; -- Score de 50% si le seuil n'est pas atteint
            END IF;
        ELSE
            current_similarity := UTL_MATCH.JARO_WINKLER_SIMILARITY(UPPER(word), UPPER(search_string));
        END IF;

        IF current_similarity > highest_similarity THEN
            highest_similarity := current_similarity;
        END IF;

        position := next_space + 1;
        EXIT WHEN next_space = 0 OR next_space IS NULL;
    END LOOP;

    IF highest_similarity >= similarity_threshold THEN
        RETURN highest_similarity;
    ELSE
        RETURN 0;
    END IF;
END trouver_ligne_avec_mot_similaire;
/

drop table temp_resultats;
CREATE GLOBAL TEMPORARY TABLE temp_resultats (
    RefSOUSSOUSDomaineF VARCHAR2(200),
    RefSOUSDomaineF VARCHAR2(200),
    Le_nom CLOB,
    Descriptio CLOB,
    Notes VARCHAR2(50),
    Nombre_avis VARCHAR2(25),
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
    prix VARCHAR2(30),
    score INTEGER -- Champ supplémentaire pour le score
) ON COMMIT DELETE ROWS;

CREATE OR REPLACE FUNCTION trouver_lignes_avec_mots_similaires(
    search_string IN VARCHAR2
) RETURN SYS_REFCURSOR
IS
    result_cursor SYS_REFCURSOR;
    sum_scores INTEGER;
    count_scores INTEGER;
    avg_score INTEGER;
BEGIN
    DELETE FROM temp_resultats;

    FOR rec IN (SELECT * FROM SOUSSOUSDomaineFormation)
    LOOP
        sum_scores := 0;
        count_scores := 0;

        FOR search_word IN (SELECT REGEXP_SUBSTR(search_string, '[^ ]+', 1, LEVEL) AS word
                            FROM DUAL
                            CONNECT BY REGEXP_SUBSTR(search_string, '[^ ]+', 1, LEVEL) IS NOT NULL)
        LOOP
            sum_scores := sum_scores + trouver_ligne_avec_mot_similaire(rec.MotsCles, search_word.word);
            count_scores := count_scores + 1;
        END LOOP;

        IF count_scores > 0 THEN
            avg_score := sum_scores / count_scores;
        ELSE
            avg_score := NULL;
        END IF;

        IF avg_score IS NOT NULL THEN
            INSERT INTO temp_resultats (
                RefSOUSSOUSDomaineF, RefSOUSDomaineF, Le_nom, Descriptio, Notes, Nombre_avis, Duree,
                Nombre_participants, Niveau, Liens, Destinataires, Formateurs, Chapitre, Competences_gagnees,
                Organisation, MotsCles, prix, score
            ) VALUES (
                rec.RefSOUSSOUSDomaineF, rec.RefSOUSDomaineF, rec.Le_nom, rec.Descriptio, rec.Notes, rec.Nombre_avis,
                rec.Duree, rec.Nombre_participants, rec.Niveau, rec.Liens, rec.Destinataires, rec.Formateurs,
                rec.Chapitre, rec.Competences_gagnees, rec.Organisation, rec.MotsCles, rec.prix, avg_score
            );
        END IF;
    END LOOP;

    OPEN result_cursor FOR SELECT * FROM temp_resultats ORDER BY score DESC;
    RETURN result_cursor;
END trouver_lignes_avec_mots_similaires;
/


------------------------------------------------------------
CREATE OR REPLACE FUNCTION trouver_ligne_avec_mot_similaire(
    column_value IN VARCHAR2, 
    search_string IN VARCHAR2
) RETURN INTEGER
IS
    word VARCHAR2(100);
    position INTEGER := 1;
    next_space INTEGER;
    similarity_threshold INTEGER := 60; -- Seuil de similarité pour Jaro-Winkler
    levenshtein_threshold INTEGER := 1; -- Seuil pour la distance de Levenshtein pour les mots courts
    highest_similarity INTEGER := 0; -- Plus haut score de similarité trouvé
    current_similarity INTEGER;
    levenshtein_distance INTEGER;
BEGIN
    LOOP
        next_space := INSTR(column_value, ' ', position);
        IF next_space != 0 THEN
            word := SUBSTR(column_value, position, next_space - position);
        ELSE
            word := SUBSTR(column_value, position);
        END IF;

        IF LENGTH(search_string) <= 3 THEN
            levenshtein_distance := UTL_MATCH.EDIT_DISTANCE(UPPER(word), UPPER(search_string));
            IF levenshtein_distance <= levenshtein_threshold THEN
                current_similarity := 100; -- Score maximal pour une correspondance exacte
            ELSE
                current_similarity := 50; -- Score de 50% si le seuil n'est pas atteint
            END IF;
        ELSE
            current_similarity := UTL_MATCH.JARO_WINKLER_SIMILARITY(UPPER(word), UPPER(search_string));
        END IF;

        IF current_similarity > highest_similarity THEN
            highest_similarity := current_similarity;
        END IF;

        position := next_space + 1;
        EXIT WHEN next_space = 0 OR next_space IS NULL;
    END LOOP;

    IF highest_similarity >= similarity_threshold THEN
        RETURN highest_similarity;
    ELSE
        RETURN 0;
    END IF;
END trouver_ligne_avec_mot_similaire;
/

CREATE OR REPLACE FUNCTION trouver_lignes_avec_mots_similaires(
    search_string IN VARCHAR2
) RETURN SYS_REFCURSOR
IS
    result_cursor SYS_REFCURSOR;
    sum_scores INTEGER;
    count_scores INTEGER;
    avg_score INTEGER;
    similarity_threshold INTEGER := 40; -- Définir le seuil de similarité à 60%
BEGIN
    DELETE FROM temp_resultats;

    FOR rec IN (SELECT * FROM SOUSSOUSDomaineFormation)
    LOOP
        sum_scores := 0;
        count_scores := 0;

        FOR search_word IN (SELECT REGEXP_SUBSTR(search_string, '[^ ]+', 1, LEVEL) AS word
                            FROM DUAL
                            CONNECT BY REGEXP_SUBSTR(search_string, '[^ ]+', 1, LEVEL) IS NOT NULL)
        LOOP
            sum_scores := sum_scores + trouver_ligne_avec_mot_similaire(rec.MotsCles, search_word.word);
            count_scores := count_scores + 1;
        END LOOP;

        IF count_scores > 0 THEN
            avg_score := sum_scores / count_scores;
        ELSE
            avg_score := NULL;
        END IF;

        -- Insérer seulement si la moyenne des scores est >= seuil de similarité
        IF avg_score IS NOT NULL AND avg_score >= similarity_threshold THEN
            INSERT INTO temp_resultats (
                RefSOUSSOUSDomaineF, RefSOUSDomaineF, Le_nom, Descriptio, Notes, Nombre_avis, Duree,
                Nombre_participants, Niveau, Liens, Destinataires, Formateurs, Chapitre, Competences_gagnees,
                Organisation, MotsCles, prix, score
            ) VALUES (
                rec.RefSOUSSOUSDomaineF, rec.RefSOUSDomaineF, rec.Le_nom, rec.Descriptio, rec.Notes, rec.Nombre_avis,
                rec.Duree, rec.Nombre_participants, rec.Niveau, rec.Liens, rec.Destinataires, rec.Formateurs,
                rec.Chapitre, rec.Competences_gagnees, rec.Organisation, rec.MotsCles, rec.prix, avg_score
            );
        END IF;
    END LOOP;

    OPEN result_cursor FOR SELECT * FROM temp_resultats ORDER BY score DESC;
    RETURN result_cursor;
END trouver_lignes_avec_mots_similaires;
/
