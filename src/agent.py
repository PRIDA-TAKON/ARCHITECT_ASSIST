import os
import requests
import json
from typing import Any, List, Optional, Dict
from langchain.tools import tool
from langchain_google_vertexai import ChatVertexAI
from langchain_google_genai import ChatGoogleGenerativeAI
from langchain_core.language_models.chat_models import BaseChatModel
from langchain_core.messages import BaseMessage, AIMessage, HumanMessage, SystemMessage
from langchain_core.outputs import ChatResult, ChatGeneration
from langgraph.prebuilt import create_react_agent
from src.dxf_parser import DXFParser
from src.excel_manager import ExcelManager

# --- Custom LLM for ThaiLLM (Pathumma) ---

class ThaiLLMChat(BaseChatModel):
    """Custom Chat Model for ThaiLLM following sample_thaiLL.md precisely."""
    api_key: str
    model_name: str = "/model"
    endpoint: str = "http://thaillm.or.th/api/pathumma/v1/chat/completions"

    def _generate(
        self,
        messages: List[BaseMessage],
        stop: Optional[List[str]] = None,
        run_manager: Optional[Any] = None,
        **kwargs: Any,
    ) -> ChatResult:
        payload_messages = []
        for m in messages:
            if isinstance(m, HumanMessage):
                payload_messages.append({"role": "user", "content": m.content})
            elif isinstance(m, AIMessage):
                payload_messages.append({"role": "assistant", "content": m.content})
            elif isinstance(m, SystemMessage):
                payload_messages.append({"role": "system", "content": m.content})

        # Payload exactly as in sample_thaiLL.md
        payload = {
            "model": self.model_name,
            "messages": payload_messages,
            "max_tokens": 2048,
            "temperature": 0.3
        }
        
        # Headers exactly as in sample_thaiLL.md
        headers = {
            "Content-Type": "application/json",
            "apikey": self.api_key
        }

        response = requests.post(self.endpoint, headers=headers, json=payload)
        response.raise_for_status()
        data = response.json()
        
        content = data["choices"][0]["message"]["content"]
        message = AIMessage(content=content)
        generation = ChatGeneration(message=message)
        return ChatResult(generations=[generation])

    @property
    def _llm_type(self) -> str:
        return "thaillm-chat"

# --- DXF Tools ---

@tool
def get_dxf_summary(file_path: str):
    """Returns a summary of the DXF file (layers, entity count)."""
    parser = DXFParser(file_path)
    return parser.get_summary()

@tool
def get_total_line_length(file_path: str, layer_name: str):
    """Calculates the total length of lines and polylines on a specific layer in a DXF file."""
    parser = DXFParser(file_path)
    return parser.get_line_lengths_by_layer(layer_name)

@tool
def count_blocks(file_path: str, block_name: str):
    """Counts occurrences of a specific block by name in a DXF file."""
    parser = DXFParser(file_path)
    return parser.count_blocks_by_name(block_name)

# --- Excel Tools ---

@tool
def read_excel_sheet(file_path: str, sheet_name: str = "Sheet1"):
    """Reads an Excel sheet and returns its content as a dictionary."""
    manager = ExcelManager(file_path)
    df = manager.read_sheet(sheet_name)
    return df.to_dict(orient="records")

@tool
def update_boq_cell(file_path: str, sheet_name: str, row: int, col: int, value: str):
    """Updates a specific cell in an Excel sheet (BOQ)."""
    manager = ExcelManager(file_path)
    manager.update_cell(sheet_name, row, col, value)
    return f"Successfully updated cell ({row}, {col}) to {value}."

# --- Agent Setup ---

def get_architect_agent(model_name: str = "gemini-1.5-pro", api_key: str = None, use_vertex: bool = False):
    """
    Initializes the agent. 
    Supports Google AI Studio (API Key), Vertex AI (GCP Credentials), or ThaiLLM.
    """
    if "Pathumma" in model_name:
        # Support for ThaiLLM (Pathumma) via custom class
        llm = ThaiLLMChat(api_key=api_key)
    elif use_vertex:
        llm = ChatVertexAI(model_name=model_name)
    else:
        if not api_key:
            return None
        # Support for Google AI Studio API
        llm = ChatGoogleGenerativeAI(model=model_name, google_api_key=api_key)
    
    tools = [
        get_dxf_summary,
        get_total_line_length,
        count_blocks,
        read_excel_sheet,
        update_boq_cell
    ]
    
    agent = create_react_agent(llm, tools)
    return agent

if __name__ == "__main__":
    print("Architect Agent initialized.")
