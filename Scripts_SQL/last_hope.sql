
def fetch_search_results(search_term):
    corrected_keyword=filter_keywords_spacy(search_term)

    # Oracle database connection string - modify with your details
    dsn_tns = cx_Oracle.makedsn('localhost', '1521', service_name='xe')
    connection = cx_Oracle.connect(user='sys', password='projet_bda',mode=cx_Oracle.SYSDBA, dsn=dsn_tns)

   
    # Create a cursor
    cursor = connection.cursor()
    cursor.callproc("dbms_output.enable")

    # Call the PL/SQL function to retrieve course names
    cursor.execute("""
    DECLARE
        resultat VARCHAR2(32767);
    BEGIN
        resultat := trouver_lignes_avec_mots_similaires(:keyword);
        DBMS_OUTPUT.PUT_LINE(resultat);
    END;
    """, keyword=corrected_keyword)



       # Liste pour stocker les résultats de DBMS_OUTPUT
    results = []

    # Récupérer et ajouter les lignes de DBMS_OUTPUT à la liste
    statusVar = cursor.var(cx_Oracle.NUMBER)
    lineVar = cursor.var(cx_Oracle.STRING)
    while True:
        cursor.callproc("dbms_output.get_line", (lineVar, statusVar))
        if statusVar.getvalue() != 0:
            break
    
        print('aw')
        results.append(lineVar.getvalue())







    all_course_data = pd.DataFrame()

    # Iterate over the course names and fetch detailed information for each
    for course_name in results:
        ref_cursor = cursor.var(cx_Oracle.CURSOR)

        cursor.execute("""
        BEGIN
            :result := getCourseData(:courseKeyword);   
        END;
        """, result=ref_cursor, courseKeyword=course_name)

        # Fetch data for this course
        course_data = ref_cursor.getvalue().fetchall()

        # Create a DataFrame from the fetched data and append it to the all_course_data DataFrame
        if course_data:
            df = pd.DataFrame(course_data, columns=[row[0] for row in cursor.description])
            all_course_data = all_course_data.append(df, ignore_index=True)

    # Close the cursor and connection
















    return results

results = fetch_search_results('big data')
print(results)d

DECLARE
    resultat VARCHAR2(32767);
BEGIN
    resultat := trouver_lignes_avec_mots_similaires('big data');
    DBMS_OUTPUT.PUT_LINE(resultat);
END;
/










