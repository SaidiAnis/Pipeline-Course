import streamlit as st
import firebase_admin
from firebase_admin import credentials
from firebase_admin import auth

# Initialize Firebase
cred = credentials.Certificate("secrets.json")
firebase_admin.initialize_app(cred)

def app():
    st.title('Digital Courses User Portal')
    # Custom Styles including button styles
    st.markdown("""
        <style>
        /* Background and Text Styles */
        [data-testid="stAppViewContainer"] > .main {
            background: linear-gradient(90deg, #212E53 30%, #4A919E 90%);
        }

        /* Text color set to white for all elements except input fields */
        .stTextInput > div > div > input, h1, h2, h3, h4, h5, h6, label, body, span, p, a, .st-bb, .st-at, .st-cx {
            color: white !important;
        }

        /* Input field text color */
        .stTextInput > div > div > input {
            color: black !important;
        }

        /* Password field text color */
        .stTextInput input[type=password] {
            color: black !important;
        }

        /* Button Styles */
        .stButton > button {
            background-color: #4CAF50; /* Green background */
            color: white; /* White text */
            padding: 10px 24px; /* Padding */
            border: none;
            border-radius: 8px; /* Rounded corners */
            cursor: pointer;
            font-size: 16px; /* Font size */
            transition: background-color 0.3s, box-shadow 0.3s; /* Hover effect transition */
        }

        .stButton > button:hover {
            background-color: #45a049; /* Darker shade on hover */
            box-shadow: 0 4px 8px 0 rgba(0,0,0,0.2); /* Shadow on hover */
        }

        /* User Icon Style */
        .icon {
            font-size: 1.5em;
            vertical-align: middle;
            margin-right: 10px;
            color: white;
        }

        /* Radio Button Style */
        div.row-widget.stRadio > div {
            flex-direction: row;
            align-items: stretch;
        }

        div.row-widget.stRadio > div[role="radiogroup"] > label[data-baseweb="radio"] {
            background-color: #9AC5F4;
            padding-right: 10px;
            padding-left: 4px;
            padding-bottom: 3px;
            margin: 4px;
            color: black !important;
        }
        </style>
    """, unsafe_allow_html=True)


    # User icon at the top center
    st.markdown("""
        <div style="text-align: center; margin-bottom: 20px;">
            <i class="fas fa-user-circle" style="font-size: 4em; color: #f1c40f;"></i>
        </div>
    """, unsafe_allow_html=True)

    # Initialize session state variables
    if 'username' not in st.session_state:
        st.session_state.username = ''
    if 'useremail' not in st.session_state:
        st.session_state.useremail = ''
    if "signedout" not in st.session_state:
        st.session_state["signedout"] = False
    if 'signout' not in st.session_state:
        st.session_state['signout'] = False

    # Functions to handle login and logout
    def handle_login(): 
        try:
            user = auth.get_user_by_email(email)
            st.session_state.username = user.uid
            st.session_state.useremail = user.email
            st.session_state.signedout = True
            st.session_state.signout = True    
        except: 
            st.warning('Login Failed')

    def handle_logout():
        st.session_state.signout = False
        st.session_state.signedout = False   
        st.session_state.username = ''

    # User authentication fields with icons
    email = st.text_input('Email Address', placeholder="Email Address")
    password = st.text_input('Password', type='password', placeholder="**********")

    # Account login and creation
    if not st.session_state["signedout"]:
        choice = st.radio('Choose an option:', ['Login', 'Sign up'])

        if choice == 'Sign up':
            username = st.text_input("Enter your unique username")
            
            if st.button('Create my account'):
                user = auth.create_user(email=email, password=password, uid=username)
                st.success('Account created successfully!')
                st.markdown('Please login using your email and password')
                st.balloons()
        else:
            st.button('Login', on_click=handle_login)
    
    # Account dashboard
    if st.session_state.signout:
        st.markdown(f'<div style="color: white;">Name: {st.session_state.username}</div>', unsafe_allow_html=True)
        st.markdown(f'<div style="color: white;">Email ID: {st.session_state.useremail}</div>', unsafe_allow_html=True)
        st.button('Sign out', on_click=handle_logout)

# Run the app
if __name__ == "__main__":
    app()
