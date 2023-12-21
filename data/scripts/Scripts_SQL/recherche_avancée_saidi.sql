-- Define the Global Temporary Table with all necessary fields
DROP TABLE temp_resultats;
CREATE GLOBAL TEMPORARY TABLE temp_resultats (
    RefSOUSSOUSDomaineF VARCHAR2(200),
    RefSOUSDomaineF VARCHAR2(200),
    Le_nom VARCHAR2(4000),
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
    Prix VARCHAR2(30),
    Score INTEGER
) ON COMMIT DELETE ROWS;

-- Function to find lines with similar words
CREATE OR REPLACE FUNCTION trouver_lignes_avec_mots_similaires_1600(
    search_string IN VARCHAR2
) RETURN CLOB
IS
    result_lines CLOB;
    current_score INTEGER;
BEGIN
    DELETE FROM temp_resultats;

    FOR rec IN (SELECT * FROM soussousdomaineformation)
    LOOP
        current_score := trouver_ligne_avec_mot_similaire(rec.motscles, search_string);

        IF current_score IS NOT NULL THEN
            INSERT INTO temp_resultats VALUES (
                rec.RefSOUSSOUSDomaineF,
                rec.RefSOUSDomaineF,
                rec.Le_nom,
                rec.Descriptio,
                rec.Notes,
                rec.Nombre_avis,
                rec.Duree,
                rec.Nombre_participants,
                rec.Niveau,
                rec.Liens,
                rec.Destinataires,
                rec.Formateurs,
                rec.Chapitre,
                rec.Competences_gagnees,
                rec.Organisation,
                rec.MotsCles,
                rec.Prix,
                current_score
            );
        END IF;
    END LOOP;

    FOR rec IN (SELECT * FROM temp_resultats ORDER BY Score DESC)
    LOOP
        result_lines := result_lines || 'RefSOUSSOUSDomaineF: ' || rec.RefSOUSSOUSDomaineF || ', ' ||
                        'RefSOUSDomaineF: ' || rec.RefSOUSDomaineF || ', ' ||
                        'Name: ' || rec.Le_nom || ', ' ||
                        'Description: ' || DBMS_LOB.SUBSTR(rec.Descriptio, 4000, 1) || ', ' ||
                        'Notes: ' || rec.Notes || ', ' ||
                        'Number of Reviews: ' || rec.Nombre_avis || ', ' ||
                        'Duration: ' || rec.Duree || ', ' ||
                        'Number of Participants: ' || TO_CHAR(rec.Nombre_participants) || ', ' ||
                        'Level: ' || rec.Niveau || ', ' ||
                        'Links: ' || DBMS_LOB.SUBSTR(rec.Liens, 4000, 1) || ', ' ||
                        'Recipients: ' || DBMS_LOB.SUBSTR(rec.Destinataires, 4000, 1) || ', ' ||
                        'Trainers: ' || DBMS_LOB.SUBSTR(rec.Formateurs, 4000, 1) || ', ' ||
                        'Chapter: ' || DBMS_LOB.SUBSTR(rec.Chapitre, 4000, 1) || ', ' ||
                        'Gained Skills: ' || DBMS_LOB.SUBSTR(rec.Competences_gagnees, 4000, 1) || ', ' ||
                        'Organization: ' || DBMS_LOB.SUBSTR(rec.Organisation, 4000, 1) || ', ' ||
                        'Keywords: ' || rec.MotsCles || ', ' ||
                        'Price: ' || rec.Prix || ', ' ||
                        'Score: ' || rec.Score || '; ';
    END LOOP;

    RETURN result_lines;
END trouver_lignes_avec_mots_similaires_1600;
/

-- Procedure to display matching lines
CREATE OR REPLACE PROCEDURE display_matching_lines_python_zz(
    search_string IN VARCHAR2, 
    result_cursor OUT SYS_REFCURSOR
) IS
BEGIN
    OPEN result_cursor FOR
        SELECT *
        FROM soussousdomaineformation
        WHERE DBMS_LOB.INSTR(trouver_lignes_avec_mots_similaires_1600(search_string), LE_NOM) > 0;
END display_matching_lines_python_zz;
/


-- Call the function with the search term 'big data' and store the results
DECLARE
    result_clob CLOB;
BEGIN
    result_clob := trouver_lignes_avec_mots_similaires_1600('big data');
    DBMS_OUTPUT.PUT_LINE(result_clob);
END;
/


CREATE OR REPLACE FUNCTION getCourseData(courseName IN VARCHAR2)
RETURN SYS_REFCURSOR
IS
    courseCursor SYS_REFCURSOR;
BEGIN
    OPEN courseCursor FOR
        SELECT * 
        FROM SOUSSOUSDomaineFormation
        WHERE Le_nom LIKE '%' || courseName || '%';

    RETURN courseCursor;
END;
/

