-------------------Homogenisation de notes | format : '4.5' toujours sur 5
UPDATE SOUSSOUSDomaineFormation
SET notes = 
    TO_CHAR(
        CASE 
            WHEN REGEXP_LIKE(notes, '^\d+([,.]\d+)?$') THEN 
                -- Convertit directement si c'est déjà un nombre
                TO_NUMBER(REPLACE(notes, ',', '.'))
            ELSE
                -- Extrait le nombre d'une chaîne plus complexe
                TO_NUMBER(
                    REPLACE(
                        REGEXP_SUBSTR(notes, '\d+([,.]\d+)?'), 
                        ',', 
                        '.'
                    )
                )
        END, 'FM999D9'
    )
WHERE NOT REGEXP_LIKE(notes, '^\d+([,.]\d+)?$');


-------------------------------------------------------------------------------
-------------------Homogenisation de nombre_avis | format : '23400' juste le nombre d'avis
UPDATE SOUSSOUSDomaineFormation
SET nombre_avis = 
    TO_CHAR(
        CASE
            WHEN REGEXP_LIKE(nombre_avis, 'k', 'i') THEN
                -- Convertir les valeurs avec 'k' en nombres complets
                TO_NUMBER(REGEXP_SUBSTR(nombre_avis, '\d+\.?\d*')) * 1000
            WHEN REGEXP_LIKE(nombre_avis, 'M', 'i') THEN
                -- Convertir les valeurs avec 'M' en nombres complets
                TO_NUMBER(REGEXP_SUBSTR(nombre_avis, '\d+\.?\d*')) * 1000000
            ELSE
                -- Convertir directement en nombre
                TO_NUMBER(REGEXP_SUBSTR(nombre_avis, '\d+'))
        END
    );
-------------------------------------------------------------------------------
-------------------Homogenisation de Duree | format : '255' juste le nombre d'heures, coursera n'a pas encore été traité car beaucoup plus complexe
UPDATE SOUSSOUSDomaineFormation
SET Duree = 
    CASE 
        WHEN REGEXP_LIKE(Duree, '\d+\s+heures? au total') THEN
            -- Pour 'X heures au total', extrait 'X'
            TO_NUMBER(REGEXP_SUBSTR(Duree, '\d+'))
        WHEN REGEXP_LIKE(Duree, '\d+\s+jours? \(\d+\s+heures?\)') THEN
            -- Pour 'Y jours (Z heures)', extrait 'Z'
            TO_NUMBER(REGEXP_SUBSTR(Duree, '\d+', INSTR(Duree, '(')))
    END
WHERE REGEXP_LIKE(Duree, '\d+\s+heures? au total') OR 
      REGEXP_LIKE(Duree, '\d+\s+jours? \(\d+\s+heures?\)');
