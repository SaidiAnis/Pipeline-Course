#!/usr/bin/env python
# coding: utf-8

# In[3]:



# In[4]:


def is_valid_sentence(text, word_threshold=3):
    """ Vérifie si le texte ressemble à une phrase valide. """
    words = text.split()
    return len(words) >= word_threshold


# In[5]:


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


# Exemple d'utilisation
sentence = "comment debuter en pozer bi"
result = filter_keywords_spacy(sentence)
print(result)


# In[6]:


import itertools
from nltk.corpus import words
import nltk

# Assurez-vous d'avoir téléchargé la liste des mots en anglais (wordnet)
nltk.download('words')

# Chargez la liste des mots en anglais
word_list = words.words()

# Fonction pour générer des mots possibles à partir d'initiales
def generate_words_from_initials(initials, word_list):
    initials = initials.lower()  # Convertir les initiales en minuscules
    possible_words = set()

    # Générer toutes les combinaisons de trois lettres possibles à partir des initiales
    letter_combinations = itertools.product(initials, repeat=3)

    for combination in letter_combinations:
        prefix = ''.join(combination)
        matching_words = [word for word in word_list if word.startswith(prefix)]
        possible_words.update(matching_words)

    return possible_words

# Exemple d'utilisation
initials = "AI"
matching_words = generate_words_from_initials(initials, word_list)
print("Mots possibles à partir des initiales '{}' :".format(initials))
print(matching_words)


# In[7]:


import nltk
from nltk.corpus import stopwords
from unidecode import unidecode  # Import correct de unidecode
import re  # Assurez-vous d'importer re pour les expressions régulières


def clean_sentence(sentence):
    # Votre liste initiale de mots à exclure
    custom_exclude_words = {
        'et', 'des', 'les', 'de', 'la', 'le', 'en', 'du', 'pour', 'comment',
        'avec', 'sans', 'sous', 'par', 'dans', 'sur', 'entre', 'contre', 'vers',
        'après', 'avant', 'chez', 'pendant', 'depuis', 'jusque', 'jusqu', 'tandis',
        'que', 'comme', 'si', 'lorsque', 'puisque', 'quoique', 'bien', 'ainsi'
    }

    # Stop words en français et en anglais
    stop_words_fr = set(stopwords.words('french'))
    stop_words_en = set(stopwords.words('english'))
    exclude_words = custom_exclude_words.union(stop_words_fr, stop_words_en)

    # Remplacer les caractères accentués
    course_name = unidecode(sentence)  # Utilisation correcte de unidecode

    # Supprimer le caractère avant les guillemets doubles
    course_name = re.sub(r".''", '', sentence)

    # Convertir en minuscules, supprimer les caractères spéciaux (sauf les tirets, les barres obliques)
    course_name = re.sub(r'[^A-Za-z\s/-]', '', sentence.lower())

    # Split sur les espaces, les tirets, et les barres obliques
    words = re.split(r'[\s/-]+', sentence)

    # Filtrer les mots, les mettre au singulier si nécessaire et exclure les mots d'une lettre
    filtered_words = [word for word in words if word not in exclude_words and len(word) > 1]

    return " ".join(filtered_words)


# In[8]:


import cx_Oracle


# Connection parameters
username = "SYS"
password = "2000"
hostname = "localhost"
port = "1521"
sid = "xe"

# Create the DSN string
dsn = cx_Oracle.makedsn(hostname, port, sid=sid)

try:
    # Connect to the database
    connection = cx_Oracle.connect(username, password, dsn, mode=cx_Oracle.SYSDBA)
    print("Successfully connected to the Oracle database")

    # Create a cursor
    cursor = connection.cursor()

    # Activate DBMS_OUTPUT
    cursor.callproc("dbms_output.enable")

    # Original keyword
    keyword = 'java'
    
    corrected_keyword = clean_sentence(keyword)
    print("\nCorrected Keyword: ", corrected_keyword)

    # Execute the stored procedure
    cursor.execute("""
    DECLARE
        result VARCHAR2(32767);
    BEGIN
        result := trouver_lignes_avec_mots_similaires(:keyword);
        DBMS_OUTPUT.PUT_LINE(result);
    END;
    """, keyword=corrected_keyword)
    
    # List to store the results from DBMS_OUTPUT
    results = []

    # Retrieve and add lines from DBMS_OUTPUT to the list
    statusVar = cursor.var(cx_Oracle.NUMBER)
    lineVar = cursor.var(cx_Oracle.STRING)
    while True:
        cursor.callproc("dbms_output.get_line", (lineVar, statusVar))
        if statusVar.getvalue() != 0:
            break
        results.append(lineVar.getvalue())

    # Process results if not empty
    if results:
        # Split the first string using ';' as the separator
        results = results[0].split(';')

        # Remove whitespace and empty strings from the list
        results = [item.strip() for item in results if item.strip()]

        # Remove duplicates
        results = list(set(results))

        # Extract the name and score, then store them in a list of tuples
        extracted_data = []
        for line in results:
            if line and " (Score: " in line:
                name, score_str = line.rsplit(" (Score: ", 1)
                score = int(score_str[:-1])  # Enlever la parenthèse fermante et convertir en entier
                extracted_data.append((name, score))
        
        # Trie la liste de tuples par score en ordre décroissant
        sorted_data = sorted(extracted_data, key=lambda x: x[1], reverse=True)
        
        # Reconstruit la liste triée des noms
        sorted_results = [name for name, score in sorted_data]
        
        # Affichage des résultats triés
        for line in sorted_results:
            print(line)

    else:
        print("No lines found")

    print("\n")
    # Close the cursor
    cursor.close()
    
except cx_Oracle.DatabaseError as e:
    print("Error connecting to the database", e)

finally:
    # Close the connection
    if connection:
        connection.close()
        print("Database connection closed")



# In[9]:


def remove_duplicates_keep_order(seq):
    seen = set()
    seen_add = seen.add
    return [x for x in seq if not (x in seen or seen_add(x))]


# In[76]:


import cx_Oracle

# Connexion à la base de données
username = "SYS"
password = "2000"
hostname = "localhost"
port = "1521"
sid = "xe"

dsn = cx_Oracle.makedsn(hostname, port, sid=sid)

try:
    connection = cx_Oracle.connect(username, password, dsn, mode=cx_Oracle.SYSDBA)
    print("Successfully connected to the Oracle database")

    cursor = connection.cursor()

    # Keyword
    keyword = 'IA'.lower()
    corrected_keyword = clean_sentence(keyword)  # Assurez-vous que cette fonction est définie
    print("\nCorrected Keyword: ", corrected_keyword)

    # Appeler la fonction et récupérer un curseur comme résultat
    result_cursor = cursor.callfunc('trouver_lignes_avec_mots_similaires', cx_Oracle.CURSOR, [corrected_keyword])

    # Récupérer les données du curseur
    result_list = result_cursor.fetchall()
    le_nom = []
    score = []
    x = []
    # Traitement du résultat
    if result_list:
        for line in result_list:
            line_dict = {
                "RefSOUSSOUSDomaineF": line[0],
                "RefSOUSDomaineF": line[1],
                "Le_nom": line[2].read() if line[2] else None,
                "Descriptio": line[3].read() if line[3] else None,
                "Notes": line[4],
                "Nombre_avis": line[5],
                "Duree": line[6],
                "Nombre_participants": line[7],
                "Niveau": line[8],
                "Liens": line[9].read() if line[9] else None,
                "Destinataires": line[10].read() if line[10] else None,
                "Formateurs": line[11].read() if line[11] else None,
                "Chapitre": line[12].read() if line[12] else None,
                "Competences_gagnees": line[13].read() if line[13] else None,
                "Organisation": line[14].read() if line[14] else None,
                "MotsCles": line[15],
                "prix": line[16],
                "Score": line[17]
            }
        
            le_nom.append(line_dict["Le_nom"])
            score.append(line_dict["Score"])
            x.append(line_dict["MotsCles"])
        # Remove duplicates
        le_nom = remove_duplicates_keep_order(le_nom)
         
        for i in range(len(le_nom)):
            print(le_nom[i],'---',score[i],'...',x[i])
    else:
        print("No results found")
    result_cursor.close()
    cursor.close()

except cx_Oracle.DatabaseError as e:
    print("Error connecting to the database", e)

finally:
    if connection:
        connection.close()
        print("Database connection closed")


# In[54]:


import cx_Oracle
import pandas as pd

# Imaginons que cette fonction nettoie votre chaîne en minuscules et supprime la ponctuation
def clean_sentence(sentence):
    # Vérifier si l'entrée est un objet LOB et le convertir en chaîne si nécessaire
    if isinstance(sentence, cx_Oracle.LOB):
        cleaned = sentence.read().lower()  # Lire le contenu LOB et convertir en minuscules
    else:
        cleaned = sentence.lower()  # Conversion en minuscules pour les chaînes normales
    # Ajoutez ici d'autres opérations de nettoyage au besoin
    return cleaned

# Fonction pour filtrer et pondérer les résultats basée sur des mots-clés significatifs
def filter_and_weight_results(df, keywords):
    # Calculer le score de chaque ligne basé sur le nombre de mots-clés qu'elle contient
    def score_row(row):
        description = clean_sentence(row['Descriptio']) if row['Descriptio'] else ""
        score = sum(keyword in description for keyword in keywords)
        return score
    
    df['keyword_score'] = df.apply(score_row, axis=1)
    
    # Filtrer pour ne garder que les lignes avec un score > 0
    filtered_df = df[df['keyword_score'] > 0]
    
    # Trier par score de mots-clés décroissant
    filtered_df = filtered_df.sort_values(by='keyword_score', ascending=False)
    
    return filtered_df

# Connection à la base de données
try:
    connection = cx_Oracle.connect("SYS", "2000", "localhost:1521/xe", mode=cx_Oracle.SYSDBA)
    cursor = connection.cursor()

    print("Successfully connected to the Oracle database")

    # Exécution de la fonction SQL pour récupérer les résultats
    result_cursor = cursor.callfunc('trouver_lignes_avec_mots_similaires', cx_Oracle.CURSOR, ['cours de java pour débutants'])
    result_list = result_cursor.fetchall()

    # Conversion des résultats en DataFrame
    df = pd.DataFrame(result_list, columns=["RefSOUSSOUSDomaineF", "RefSOUSDomaineF", "Le_nom", "Descriptio", "Notes", "Nombre_avis", "Duree", "Nombre_participants", "Niveau", "Liens", "Destinataires", "Formateurs", "Chapitre", "Competences_gagnees", "Organisation", "MotsCles", "prix", "Score"])

    # Nettoyage et extraction des mots-clés de la requête de recherche
    search_query = 'web'
    cleaned_query = clean_sentence(search_query)
    keywords = cleaned_query.split()  # Simple séparation par espace, considérer l'extraction de mots-clés plus sophistiquée si nécessaire

    # Filtrer et pondérer les résultats
    filtered_df = filter_and_weight_results(df, keywords)

    # Afficher les résultats filtrés et pondérés
    # Afficher les résultats filtrés, pondérés et les mots-clés associés
    for index, row in filtered_df.iterrows():
        print(f"Nom de la Formation: {row['Le_nom']} - Score des Mots-clés: {row['keyword_score']} - Mots-clés: {row['MotsCles']}")


except cx_Oracle.DatabaseError as e:
    print("Error connecting to the Oracle database", e)
finally:
    if 'connection' in locals():
        connection.close()
        print("Database connection closed")


# In[ ]:




