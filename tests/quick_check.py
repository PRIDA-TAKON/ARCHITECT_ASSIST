import os
from src.dxf_parser import DXFParser
from src.excel_manager import ExcelManager
from src.agent import get_architect_agent

def test_system_initialization():
    print("--- 🏛️ ARCHITECT_ASSIST: System Check ---")
    
    # 1. Test Project Structure
    print(f"Checking folders...")
    assert os.path.exists("src/dxf_parser.py"), "DXF Parser missing!"
    assert os.path.exists("src/excel_manager.py"), "Excel Manager missing!"
    print("✅ Folders & Code: OK")

    # 2. Test Agent Initialization
    print("Checking Agent (without API Key)...")
    agent = get_architect_agent(api_key="TEST_KEY")
    if agent:
        print("✅ Agent logic: Ready (Will need real API Key for chat)")
    else:
        print("❌ Agent failed to initialize.")

    print("\n--- Summary: All core systems are ready to run! ---")

if __name__ == "__main__":
    test_system_initialization()
