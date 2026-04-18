import streamlit as st
import os
from src.agent import get_architect_agent

st.set_page_config(page_title="ARCHITECT_ASSIST", layout="wide")

st.title("🏛️ ARCHITECT_ASSIST")
st.markdown("### AI Agent for Automated Architecture Workflows")

# Sidebar for file upload
with st.sidebar:
    st.header("Files")
    uploaded_dxf = st.file_uploader("Upload DXF File", type=["dxf"])
    uploaded_xlsx = st.file_uploader("Upload BOQ Excel", type=["xlsx"])
    
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

# Initialize Agent
agent = get_architect_agent()

# Chat interface
if "messages" not in st.session_state:
    st.session_state.messages = []

# Display chat history
for message in st.session_state.messages:
    with st.chat_message(message["role"]):
        st.markdown(message["content"])

# Input for new chat
if prompt := st.chat_input("How can I help you today?"):
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
        
        # Call the agent
        response = agent.invoke({"messages": [("user", full_prompt)]})
        
        # Get the last message from the agent
        ai_msg = response["messages"][-1].content
        st.markdown(ai_msg)
        st.session_state.messages.append({"role": "assistant", "content": ai_msg})
