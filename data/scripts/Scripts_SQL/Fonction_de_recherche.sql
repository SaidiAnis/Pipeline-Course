CREATE OR REPLACE FUNCTION trouver_ligne_avec_mot_similaire(column_value IN VARCHAR2, search_string IN VARCHAR2)
RETURN VARCHAR2
IS
    word VARCHAR2(100);
    position INTEGER := 1;
    next_space INTEGER;
    similarity_threshold INTEGER := 70; -- Seuil de similarit? (70%)
    current_similarity INTEGER;
BEGIN
    LOOP
        next_space := INSTR(column_value, ' ', position);

        -- Extraire le mot
        IF next_space != 0 THEN
            word := SUBSTR(column_value, position, next_space - position);
        ELSE
            word := SUBSTR(column_value, position);
        END IF;

        -- Calculer la similarit? Jaro-Winkler
        current_similarity := UTL_MATCH.JARO_WINKLER_SIMILARITY(UPPER(word), UPPER(search_string));

        -- V?rifier si la similarit? d?passe le seuil
        IF current_similarity >= similarity_threshold THEN
            RETURN column_value; -- Retourner la ligne enti?re si la condition est remplie
        END IF;

        -- Pr?parer la position pour le prochain mot
        position := next_space + 1;

        -- Sortir de la boucle si la fin de la cha?ne est atteinte
        EXIT WHEN next_space = 0 OR next_space IS NULL;
    END LOOP;

    RETURN NULL; -- Retourner NULL si aucun mot similaire n'est trouv?
END trouver_ligne_avec_mot_similaire;
/


CREATE OR REPLACE FUNCTION trouver_lignes_avec_mots_similaires(
    search_string IN VARCHAR2
) RETURN VARCHAR2
IS
    result_lines VARCHAR2(32767); -- Stockera les lignes correspondantes
    column_value_motscles VARCHAR2(4000); -- Valeur de la colonne motscles
    column_value_le_nom VARCHAR2(4000); -- Valeur de la colonne LE_NOM
    word VARCHAR2(100);
    position INTEGER;
    next_space INTEGER;
    all_words_matched BOOLEAN;
    search_words DBMS_SQL.VARCHAR2A;
    i INTEGER;
BEGIN
    -- D?couper la cha?ne de recherche en mots
    search_words := DBMS_SQL.VARCHAR2A();
    i := 1;
    position := 1;

    LOOP
        next_space := INSTR(search_string, ' ', position);
        IF next_space != 0 THEN
            word := SUBSTR(search_string, position, next_space - position);
        ELSE
            word := SUBSTR(search_string, position);
        END IF;
        search_words(i) := word;
        i := i + 1;
        position := next_space + 1;
        EXIT WHEN next_space = 0 OR next_space IS NULL;
    END LOOP;

    FOR rec IN (SELECT motscles, LE_NOM FROM soussousdomaineformation)
    LOOP
        column_value_motscles := rec.motscles;
        column_value_le_nom := rec.LE_NOM;

        -- V?rifier si tous les mots ont un similaire dans la ligne
        all_words_matched := TRUE;
        FOR j IN 1..search_words.COUNT LOOP
            IF trouver_ligne_avec_mot_similaire(column_value_motscles, search_words(j)) IS NULL THEN
                all_words_matched := FALSE;
                EXIT;
            END IF;
        END LOOP;

        IF all_words_matched THEN
            -- Ajouter la valeur de LE_NOM aux r?sultats
            result_lines := result_lines || column_value_le_nom || '; ';
        END IF;
    END LOOP;

    RETURN result_lines; -- Retourner la cha?ne de r?sultats
END trouver_lignes_avec_mots_similaires;
/


SET SERVEROUTPUT ON

DECLARE
    result VARCHAR2(32767);
BEGIN
    -- Replace 'your_search_string' with the actual search string
    result := trouver_lignes_avec_mots_similaires('Achats publics');

    -- Output the result
    DBMS_OUTPUT.PUT_LINE('Matching lines: ' || result);
END;

/

CREATE OR REPLACE PROCEDURE display_matching_lines(search_string IN VARCHAR2) IS
    TYPE result_rec IS RECORD (
        le_nom VARCHAR2(4000)
    );
    TYPE result_table IS TABLE OF result_rec INDEX BY PLS_INTEGER;
    results result_table;
    i INTEGER := 1;
BEGIN
    -- Replace 'your_search_string' with the actual search string
    FOR rec IN (SELECT LE_NOM FROM soussousdomaineformation WHERE trouver_lignes_avec_mots_similaires(search_string) LIKE '%' || LE_NOM || '%') LOOP
        results(i).le_nom := rec.LE_NOM;
        i := i + 1;
    END LOOP;

    -- Output the result in a table format
    DBMS_OUTPUT.PUT_LINE('Matching lines:');
    FOR j IN 1..results.COUNT LOOP
        DBMS_OUTPUT.PUT_LINE('Row ' || j || ': ' || results(j).le_nom);
    END LOOP;
END display_matching_lines;
/

SET SERVEROUTPUT ON


CREATE OR REPLACE PROCEDURE display_matching_lines_python(
    search_string IN VARCHAR2, 
    result_cursor OUT SYS_REFCURSOR
) IS
BEGIN
    OPEN result_cursor FOR
        SELECT LE_NOM, Notes, Duree, Formateurs, Liens 
        FROM soussousdomaineformation
        WHERE trouver_lignes_avec_mots_similaires(search_string) LIKE '%' || LE_NOM || '%';
END display_matching_lines_python;
/

SELECT OBJECT_NAME, STATUS FROM USER_OBJECTS WHERE OBJECT_TYPE = 'PROCEDURE' AND OBJECT_NAME = 'DISPLAY_MATCHING_LINES_PYTHON';


