# ARCHITECT_ASSIST

**ARCHITECT_ASSIST** is an AI-powered local assistant designed for architects to automate design-to-data workflows.

## Features
*   **CAD Analysis:** Extract quantities and geometric data from `.dxf` files.
*   **BOQ Automation:** Automatically update Excel-based Bill of Quantities and cost estimations.
*   **Agentic Workflow:** Powered by LangGraph/CrewAI for complex architectural reasoning.
*   **Local Interface:** Easy-to-use Streamlit chat interface for file manipulation.

## Tech Stack
*   **AI:** Google Gemini (Vertex AI), LangGraph / CrewAI
*   **CAD:** `ezdxf`
*   **Excel:** `pandas`, `openpyxl`
*   **UI:** Streamlit

## Installation
1.  Clone the repository:
    ```bash
    git clone https://github.com/PRIDA-TAKON/ARCHITECT_ASSIST.git
    cd ARCHITECT_ASSIST
    ```
2.  Install dependencies:
    ```bash
    pip install -r requirements.txt
    ```
3.  Run the application:
    ```bash
    streamlit run src/app.py
    ```
