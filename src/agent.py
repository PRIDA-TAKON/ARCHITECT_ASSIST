import os
from langchain.tools import tool
from langchain_google_vertexai import ChatVertexAI
from langchain_google_genai import ChatGoogleGenerativeAI
from langgraph.prebuilt import create_react_agent
from src.dxf_parser import DXFParser, get_all_dxf_files
from src.excel_manager import ExcelManager

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

@tool
def batch_extract_dxf(directory: str = "data"):
    """Extracts all entities from all DXF files in a directory and saves to a CSV."""
    files = get_all_dxf_files(directory)
    if not files:
        return "No DXF files found in the directory."
    
    all_data = []
    for f in files:
        parser = DXFParser(f)
        all_data.extend(parser.extract_all_entities_summary())
    
    output_path = os.path.join(directory, "master_extraction.csv")
    import csv
    with open(output_path, 'w', newline='', encoding='utf-8-sig') as csvfile:
        if all_data:
            writer = csv.DictWriter(csvfile, fieldnames=all_data[0].keys())
            writer.writeheader()
            writer.writerows(all_data)
    
    return f"Successfully extracted {len(all_data)} items from {len(files)} files to {output_path}."

@tool
def extract_door_schedule(file_path: str):
    """Extracts door schedule data from a DXF file, mapping text to page numbers."""
    parser = DXFParser(file_path)
    data = parser.extract_door_schedule_data()
    
    output_path = file_path.replace(".dxf", "_door_schedule.csv")
    import csv
    with open(output_path, 'w', newline='', encoding='utf-8-sig') as f:
        if data:
            writer = csv.DictWriter(f, fieldnames=data[0].keys())
            writer.writeheader()
            writer.writerows(data)
            
    return f"Successfully extracted {len(data)} door schedule entries to {output_path}."

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

@tool
def generate_construction_report(content: str, filename: str = "daily_report.md"):
    """Generates a professional construction daily report from the provided summary content."""
    report_dir = "reports"
    os.makedirs(report_dir, exist_ok=True)
    file_path = os.path.join(report_dir, filename)
    
    with open(file_path, "w", encoding="utf-8") as f:
        f.write(content)
        
    return f"Report generated successfully at {file_path}."

# --- Agent Setup ---

def get_architect_agent(model_name: str = "gemini-1.5-pro", api_key: str = None, use_vertex: bool = False):
    """
    Initializes the agent. 
    Supports Google AI Studio (API Key) or Vertex AI (GCP Credentials).
    """
    if use_vertex:
        llm = ChatVertexAI(model_name=model_name)
    else:
        if not api_key:
            return None
        # Support for Google AI Studio API (Gemini/Gemma)
        llm = ChatGoogleGenerativeAI(model=model_name, google_api_key=api_key)
    
    tools = [
        get_dxf_summary,
        get_total_line_length,
        count_blocks,
        batch_extract_dxf,
        extract_door_schedule,
        read_excel_sheet,
        update_boq_cell,
        generate_construction_report
    ]
    
    agent = create_react_agent(llm, tools)
    return agent

if __name__ == "__main__":
    print("Architect Agent initialized.")
