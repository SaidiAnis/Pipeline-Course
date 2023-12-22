import streamlit as st  
import cx_Oracle
import pandas as pd
import oracledb

from pandas.api.types import (
    is_categorical_dtype,
    is_datetime64_any_dtype,
    is_numeric_dtype,
    is_object_dtype,
)
import pandas as pd
import streamlit as st


def filter_dataframe(df: pd.DataFrame) -> pd.DataFrame:
    """
    Adds a UI on top of a dataframe to let viewers filter columns

    Args:
        df (pd.DataFrame): Original dataframe

    Returns:
        pd.DataFrame: Filtered dataframe
    """
    modify = st.checkbox("Add filters")

    if not modify:
        return df

    df = df.copy()

    # Try to convert datetimes into a standard format (datetime, no timezone)
    for col in df.columns:
        if is_object_dtype(df[col]):
            try:
                df[col] = pd.to_datetime(df[col])
            except Exception:
                pass

        if is_datetime64_any_dtype(df[col]):
            df[col] = df[col].dt.tz_localize(None)

    modification_container = st.container()

    with modification_container:
        to_filter_columns = st.multiselect("Filter dataframe on", df.columns)
        for column in to_filter_columns:
            left, right = st.columns((1, 20))
            # Treat columns with < 10 unique values as categorical
            if is_categorical_dtype(df[column]) or df[column].nunique() < 10:
                user_cat_input = right.multiselect(
                    f"Values for {column}",
                    df[column].unique(),
                    default=list(df[column].unique()),
                )
                df = df[df[column].isin(user_cat_input)]
            elif is_numeric_dtype(df[column]):
                _min = float(df[column].min())
                _max = float(df[column].max())
                step = (_max - _min) / 100
                user_num_input = right.slider(
                    f"Values for {column}",
                    min_value=_min,
                    max_value=_max,
                    value=(_min, _max),
                    step=step,
                )
                df = df[df[column].between(*user_num_input)]
            elif is_datetime64_any_dtype(df[column]):
                user_date_input = right.date_input(
                    f"Values for {column}",
                    value=(
                        df[column].min(),
                        df[column].max(),
                    ),
                )
                if len(user_date_input) == 2:
                    user_date_input = tuple(map(pd.to_datetime, user_date_input))
                    start_date, end_date = user_date_input
                    df = df.loc[df[column].between(start_date, end_date)]
            else:
                user_text_input = right.text_input(
                    f"Substring or regex in {column}",
                )
                if user_text_input:
                    df = df[df[column].astype(str).str.contains(user_text_input)]

    return df

def make_clickable(link):
    # Return a string with HTML anchor tag with the link
    return f'<a target="_blank" href="{link}">{link}</a>'


import spacy
from spacy.lang.fr.stop_words import STOP_WORDS as fr_stop

# Charger le modèle français
nlp = spacy.load("fr_core_news_sm")

def filter_keywords_spacy(sentence):
    if is_valid_sentence(sentence):
        # Tokeniser la phrase avec Spacy
        doc = nlp(sentence)
    
        # Filtrer les stop words et les mots non significatifs, sauf pour les exceptions
        keywords = [token.text for token in doc if (token.text.lower() not in fr_stop and token.pos_ in ["ADJ", "NOUN", "VERB", "PROPN"])]

        return ' '.join(keywords)
    else:
        # Retourner la phrase originale si elle ne remplit pas les critères de longueur
        return sentence


def is_valid_sentence(text, word_threshold=3):
    """ Vérifie si le texte ressemble à une phrase valide. """
    words = text.split()
    return len(words) >= word_threshold

oracledb.defaults.fetch_lobs = False


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
        print(results)

    # Traiter les résultats si non vides
    if results[0]:
        # Diviser la première chaîne de caractères en utilisant ';' comme séparateur
        results = results[0].split(';')
        
        # Supprimer les espaces blancs et les chaînes vides de la liste
        results = [item.strip() for item in results if item.strip()]

    print(len(results))
    print(type(results))
    print(results)
    





    # Prepare the SQL query with CLOB to VARCHAR2 conversion
    query = """
        SELECT * FROM SOUSSOUSDomaineFormation 
        WHERE DBMS_LOB.SUBSTR(Le_nom, 4000, 1) IN (:course_names)
    """

    dfs=[]
    for course_name in results :
        # Assuming results[4] is a single course name
        
        
        # Execute thse query
        cursor.execute(query, course_names=course_name)


        # Fetch all rows
        rows = cursor.fetchall()

        # Get column names from the cursor description
        columns = [col[0] for col in cursor.description]
    
        # Create DataFrame from the fetched data
        df = pd.DataFrame(rows, columns=columns)

        dfs.append(df)

    final_df = pd.concat(dfs, ignore_index=True)



    return final_df


def get_database_connection():
    # Replace with your Oracle Database connection details

    dsn_tns = cx_Oracle.makedsn('localhost', '1521', service_name='xe')

    try:
        connection = cx_Oracle.connect(user='sys', password='projet_bda',mode=cx_Oracle.SYSDBA, dsn=dsn_tns)
        return connection
    except cx_Oracle.DatabaseError as e:
        st.error(f"Error connecting to the database: {e}")
        return None


# Set the page configuration for title and favicon
def app (): 
    
    #session_state = st.session_state
    # Define custom colors and fonts


    primary_color = "#6C5CE7"
    background_color = "#bbbbbb"
    text_color = "#333333"
    font = "Arial"

    # Apply custom CSS styles
    st.markdown(f"""
        <style>
        [data-testid="stAppViewContainer"] > .main {{
            background: linear-gradient(45deg, #f0f0f0, #dddddd);
        }}
            body {{
                background-color: {background_color};
                font-family: {font}, sans-serif;
            }}
            .stTextInput > label, .stButton > button {{
                color: {text_color};
            }}
            .stTextInput > div > div > input {{
                color: {text_color};
                background-color: #f4f4f4; /* Background color for the input */
                border: 2px solid {primary_color};
                border-radius: 30px; /* Add rounded corners to the input */
                padding: 12px 20px; /* Add padding to the input */
                width: 100%; /* Make the input full-width */
                font-size: 18px; /* Adjust font size */
                box-shadow: 0px 2px 6px rgba(0, 0, 0, 0.1); /* Add a subtle box shadow */
            }}
            .stButton > button {{
                border: 2px solid {primary_color};
                color: {background_color};
                background-color: {primary_color};
                border-radius: 30px; /* Add rounded corners to the button */
                padding: 12px 25px; /* Add padding to the button */
                font-size: 18px; /* Adjust font size */
            }}
            .stButton > button:hover {{
                background-color: {text_color};
                border-color: {text_color};
                color: {primary_color};
            }}
        </style>
        """, unsafe_allow_html=True)

    # Title and description at the top
    st.markdown(f'<h1 style="color:{primary_color}; text-align:center;">Digital Courses Hub</h1>', unsafe_allow_html=True)
    st.markdown("""
        LEARN FROM THE BEST ONLINE COURSES!
        
        Welcome to Digital Courses Hub, your gateway to top-quality education. Explore a curated selection of courses from industry-leading platforms such as Udemy, Coursera, and Cegos, and embark on a journey of learning and growth with the best online courses available.
    """)

    #filter_duree = filter_formateurs = filter_notes = None



    connection = get_database_connection()
    if connection:

        if 'search_results' not in st.session_state:
            st.session_state.search_results = pd.DataFrame()

            # If not, display the search input and button
        search_term = st.text_input("Search for courses", max_chars=50)
        if st.button("Search"):
            # Fetch search results and store the filtered DataFrame in session state
            st.session_state.search_results = fetch_search_results(search_term)

        if not st.session_state.search_results.empty:
            # Apply the filter_dataframe function to the stored search results
            filtered_df = filter_dataframe(st.session_state.search_results)

            values_to_drop = ['REFSOUSSOUSDOMAINEF', 'REFSOUSDOMAINEF']

            filtered_df = filtered_df.drop(columns=values_to_drop)
            # Display the (filtered) DataFrame
            # Convert "NOMBRE_AVIS" and "DUREE" columns to float
            filtered_df["NOMBRE_AVIS"] = filtered_df["NOMBRE_AVIS"].astype(float)
            filtered_df["DUREE"] = filtered_df["DUREE"].astype("str")
            

            print(filtered_df.columns)

            # Convert the other columns to categorical
            categorical_columns = [ "LE_NOM", "DESCRIPTIO", "NOTES",
                                "NOMBRE_PARTICIPANTS", "NIVEAU", "LIENS", "DESTINATAIRES", "FORMATEURS",
                                "CHAPITRE", "COMPETENCES_GAGNEES", "ORGANISATION", "MOTSCLES", "PRIX"]

            filtered_df[categorical_columns] = filtered_df[categorical_columns].astype("str")

            print(filtered_df.dtypes)
            st.dataframe(filtered_df)

           


        # Close the database connection
            
        
        #connection.close()
    else:
        st.error("Failed to connect to the database.")

# Call the app function
if __name__ == "__main__":
    app()