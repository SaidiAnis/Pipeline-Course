import streamlit as st

def app(): 
    st.markdown("""
    <style>
    [data-testid="stAppViewContainer"] > .main {
        background: linear-gradient(45deg, #fffbf0, #ffe6d9);
    }
    .icon {
        font-size: 1.5em;
        vertical-align: middle;
        margin-right: 10px;
    }
    </style>
    """, unsafe_allow_html=True)
    
    # Add the logo
    logo_image = st.image("logo.jpg", width=200)
    
    # Set the title with the platform name
    st.title("Welcome to Digital Courses 🎓")

    st.write(
        """
        Welcome to Digital Courses, your personalized platform for discovering online courses from various platforms. Here is everything you need to know about Digital Courses:
        """
    )

    # Section: What is Digital Courses
    st.header("🤔 What is Digital Courses?")
    st.write(
        """
        Digital Courses is an AI-powered platform designed to help you find online courses that match your interests and learning goals. Simply enter the course you're searching for, and Digital Courses will recommend similar courses from a variety of online learning platforms.
        """
    )

    # Rest of your content...
