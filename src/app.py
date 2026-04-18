import streamlit as st
import os
from src.agent import get_architect_agent

st.set_page_config(page_title="ARCHITECT_ASSIST", layout="wide")

st.title("🏛️ ARCHITECT_ASSIST")
st.markdown("### AI Agent for Automated Architecture Workflows")

# Sidebar for configuration and file upload
with st.sidebar:
    st.header("⚙️ Configuration")
    
    # Selection of API Provider
    provider = st.radio("API Provider", ["Google AI Studio (API Key)", "Vertex AI (Google Cloud)"])
    
    if provider == "Google AI Studio (API Key)":
        api_key = st.text_input("Google API Key", type="password", help="Get your key from https://aistudio.google.com/app/apikey")
        model_name = st.selectbox("Model", [
            "gemini-3.1-flash",
            "gemini-3.1-pro",
            "gemini-2.5-flash",
            "gemini-2.5-pro",
            "gemma-4-31b",
            "gemma-3-27b"
        ])
        use_vertex = False
    else:
        project_id = st.text_input("Google Cloud Project ID", placeholder="e.g. my-architect-project")
        location = st.text_input("Location", value="us-central1")
        model_name = st.selectbox("Model", ["gemini-3.1-pro", "gemini-3.1-flash"])
        if project_id:
            os.environ["GOOGLE_CLOUD_PROJECT"] = project_id
        use_vertex = True
        api_key = None

    st.divider()
    
    st.header("📁 Files")
    uploaded_dxf = st.file_uploader("Upload DXF File (Drawing)", type=["dxf"])
    uploaded_xlsx = st.file_uploader("Upload BOQ Excel (Template)", type=["xlsx"])
    
    if uploaded_dxf:
        dxf_path = os.path.join("data", uploaded_dxf.name)
        with open(dxf_path, "wb") as f:
            f.write(uploaded_dxf.getbuffer())
        st.success(f"Loaded: {uploaded_dxf.name}")

    if uploaded_xlsx:
        xlsx_path = os.path.join("data", uploaded_xlsx.name)
        with open(xlsx_path, "wb") as f:
            f.write(uploaded_xlsx.getbuffer())
        st.success(f"Loaded: {uploaded_xlsx.name}")
        
        # Add a download button for the modified file
        with open(xlsx_path, "rb") as f:
            st.download_button(
                label="📥 Download Updated BOQ",
                data=f,
                file_name=f"updated_{uploaded_xlsx.name}",
                mime="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
            )

# Initialize Agent
agent = None
if use_vertex or api_key:
    agent = get_architect_agent(model_name=model_name, api_key=api_key, use_vertex=use_vertex)

# Chat interface
if "messages" not in st.session_state:
    st.session_state.messages = []

# Display chat history
for message in st.session_state.messages:
    with st.chat_message(message["role"]):
        st.markdown(message["content"])

# Input for new chat
if prompt := st.chat_input("How can I help you today?"):
    if not agent:
        st.error("Please provide an API Key or Project ID in the sidebar first.")
    else:
        st.session_state.messages.append({"role": "user", "content": prompt})
        with st.chat_message("user"):
            st.markdown(prompt)

        with st.chat_message("assistant"):
            # We need to pass the context of the files if they exist
            context = ""
            if uploaded_dxf:
                context += f" Current DXF file: data/{uploaded_dxf.name}."
            if uploaded_xlsx:
                context += f" Current Excel file: data/{uploaded_xlsx.name}."
            
            full_prompt = prompt + context
            
            try:
                # Call the agent
                response = agent.invoke({"messages": [("user", full_prompt)]})
                
                # Get the last message from the agent
                ai_msg = response["messages"][-1].content
                st.markdown(ai_msg)
                st.session_state.messages.append({"role": "assistant", "content": ai_msg})
            except Exception as e:
                st.error(f"An error occurred: {str(e)}")
