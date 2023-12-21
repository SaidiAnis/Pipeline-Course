

CREATE OR REPLACE FUNCTION generate_initials(mots_cle VARCHAR2)
  RETURN VARCHAR2 IS
    mots_cle_local VARCHAR2(32767) := mots_cle || ','; -- Local copy to manipulate
    words_tab DBMS_SQL.VARCHAR2A; -- Associative array for words
    letters_tab DBMS_SQL.VARCHAR2A; -- Associative array for letters
    combinations VARCHAR2(32767);
    cursor_pos INT := 1;
    start_pos INT := 1;
    word_count INT := 0;
    letter_count INT := 0;
BEGIN
    -- Split the mots_cle into words
    LOOP
        cursor_pos := INSTR(mots_cle_local, ',', start_pos);
        EXIT WHEN cursor_pos = 0;
        words_tab(word_count + 1) := TRIM(SUBSTR(mots_cle_local, start_pos, cursor_pos - start_pos)); -- Direct assignment
        word_count := word_count + 1;
        start_pos := cursor_pos + 1;
    END LOOP;

    -- Generate combinations of the first letter of each word
    FOR i IN 1 .. word_count LOOP
        letters_tab(i) := SUBSTR(words_tab(i), 1, 1); -- Take the first letter only
    END LOOP;
    letter_count := word_count; -- Number of letters should match number of words

    -- Generate 2 or 3 letter combinations from the list of first letters
    FOR i IN 1 .. letter_count LOOP
        FOR j IN i + 1 .. letter_count LOOP
            combinations := combinations || letters_tab(i) || letters_tab(j) || ',';
            FOR k IN j + 1 .. letter_count LOOP
                combinations := combinations || letters_tab(i) || letters_tab(j) || letters_tab(k) || ',';
            END LOOP;
        END LOOP;
    END LOOP;

    -- Remove the trailing comma
    IF LENGTH(combinations) > 0 THEN
        combinations := RTRIM(combinations, ',');
    END IF;

    RETURN combinations;
END;
/



CREATE TABLE table_init AS
SELECT RefSOUSSOUSDomaineF, MotsCles, generate_initials(MotsCles) AS initiaux
FROM SOUSSOUSDomaineFormation;


Select * from table_init
