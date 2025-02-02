import streamlit as st


def app():
    st.markdown("""
    <style>
    [data-testid="stAppViewContainer"] > .main {
        background: linear-gradient(45deg, #00008B, #ffe6d9);
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
        Welcome to **Digital Courses**, your one-stop platform for discovering and accessing a wide range of online educational resources. Whether you're looking for courses from major platforms like Coursera and Udemy or content from independent trainers and YouTube creators, Digital Courses simplifies the process of finding the right learning materials for you.
        """
    )

    # Section: What is Digital Courses
    st.header("🤔 What is Digital Courses?")
    st.write(
        """
        **Digital Courses** is an AI-powered platform designed to consolidate and simplify access to online educational resources. It aggregates courses and training materials from various platforms, independent trainers, and YouTube creators, providing a unified and user-friendly interface for learners. With advanced search functionality and a clean, intuitive design, Digital Courses helps you find the perfect course to match your learning goals.
        """
    )

    # Section: Project Objective
    st.header("🎯 Project Objective")
    st.write(
        """
        The primary objective of this project is to create a centralized platform that:
        - **Aggregates** educational resources from multiple sources.
        - **Simplifies** the process of discovering and accessing high-quality learning materials.
        - **Enhances** the user experience with advanced search capabilities and a clean, intuitive interface.
        - **Ensures** data consistency and reliability through robust data cleaning and homogenization processes.
        """
    )

    # Section: Steps Involved in the Project
    st.header("🚀 Steps Involved in the Project")
    st.write(
        """
        Here’s a breakdown of the key steps we took to build Digital Courses:
        1. **Resource Aggregation**: Collected educational resources from platforms like Coursera, Udemy, and independent trainers.
        2. **Database Modeling**: Designed an efficient database schema to store and organize the collected data.
        3. **Data Scraping**: Developed Python scripts to extract and gather data from various sources.
        4. **Data Cleaning and Homogenization**: Ensured consistency and uniformity in the collected data for seamless integration.
        5. **Web Application Development**: Built a user-friendly web interface using Streamlit for easy navigation and interaction.
        6. **Database Integration**: Connected the application to an Oracle database using the `cx_Oracle` library.
        7. **Advanced Search Functionality**: Implemented modern search algorithms to enable users to find resources quickly and accurately.
        8. **Metadata Management**: Created a dedicated database for metadata and drafted a comprehensive project specification.
        """
    )

    # Section: How to Use Digital Courses
    st.header("📖 How to Use Digital Courses")
    st.write(
        """
        Using Digital Courses is simple and intuitive:
        1. **Search for Courses**: Enter keywords related to the course you’re looking for.
        2. **Explore Recommendations**: Browse through the recommended courses from various platforms.
        3. **Access Resources**: Click on a course to view details and access the learning materials.
        4. **Advanced Search**: Use the advanced search feature to filter courses by platform, duration, or topic.
        """
    )

    # Section: Future Enhancements
    st.header("🔮 Future Enhancements")
    st.write(
        """
        We’re constantly working to improve Digital Courses. Here are some planned enhancements:
        - **Personalized Recommendations**: Use AI to recommend courses based on your learning history and preferences.
        - **User Accounts**: Allow users to create accounts, save favorite courses, and track progress.
        - **Mobile App**: Develop a mobile version of Digital Courses for on-the-go learning.
        - **Integration with More Platforms**: Add support for additional educational platforms and resources.
        """
    )

    # Footer
    st.write("---")
    st.write(
        """
        **Digital Courses** is your gateway to a world of knowledge. Start exploring today and take the next step in your learning journey! 🚀
        """
    )


# Run the app
if __name__ == "__main__":
    app()