# EduCompare: Centralization and Comparison of Online Courses

## 📌 What is this project?

EduCompare consolidates and simplifies access to online educational resources by aggregating courses from platforms such as **Coursera, Udemy, and Cegos**. This enables users to **compare and select** the most relevant courses efficiently.

### Key Features:
1. **Aggregating educational resources** from Coursera, Udemy, and Cegos.
2. **Database modeling** to structure and store data efficiently.
3. **Python-based web scraping** to extract course information.
4. **Data cleaning and homogenization** for consistency.
5. **User-friendly web interface** using Streamlit.
6. **Integration with Oracle Database** using cx_Oracle.
7. **Advanced search functionality** implemented in PL/SQL.
8. **Course metadata storage** and analysis.

### 🔎 Advanced Search Functionality
The advanced search is powered by a **PL/SQL function** that processes keyword-based queries efficiently:
1. **Keyword column creation**: Courses are assigned keywords extracted from their titles and descriptions.
2. **Data Cleaning**: Stop-words in French and English are removed, along with special characters.
3. **Segmentation**: Courses are divided into keyword columns for precise analysis.
4. **Similarity Scoring**:
   - If a keyword has **3 characters or fewer**, the **Levenshtein distance** is used:
     - If within a set threshold, the similarity score is **100%** (exact match) or **50%** (partial match).
   - For words with **more than 3 characters**, the **Jaro-Winkler similarity algorithm** is applied, with results filtered using a **60% similarity threshold**.
5. **Final Filtering**:
   - The **average similarity score** for a query is calculated per row.
   - Only rows with a **score above 40%** are retained.
6. **Sorting**: Results are ranked by final similarity score, displaying the most relevant courses first.

---

## 🛠️ How to Use this Repository?

### 🔧 Prerequisites
1. Install all necessary dependencies listed in `requirements.txt`:
   ```bash
   pip install -r requirements.txt
   ```
2. Install Oracle SQL Developer or a compatible tool for managing the database.

### 📂 Database Setup
To initialize the database, follow these steps:
1. Execute `Creation_tables.sql` to create the required tables.
2. Populate the database using the `.sql` files inside `data_scrapped/Insertions/`, in this order:
   - `insert_formation_CEGOS.sql`
   - `insert_sous_formation_CEGOS.sql`
   - `insert_sous_sous_formation_CEGOS.sql`
   - Repeat for **Udemy** and **Coursera** datasets.
3. Run `Homogénisation.sql` to standardize data.
4. Execute `recherche_avancée_saidi.sql` to set up the **advanced search function**.
5. For metadata analysis, run `meta_data.sql`.

### 🚀 Launching the Application
Once the database is set up, start the application with:
```bash
streamlit run main.py
```

### 📸 Architecture Diagram
Make sure to include this image in your repository:
![Project Architecture](image.png)

---

## 📌 Conclusion
EduCompare provides an automated pipeline for aggregating, cleaning, storing, and searching online courses. Its **advanced search function** enables users to quickly find relevant training programs, improving accessibility and course selection.

🔗 **GitHub Repository**: [Your Project Link Here]
