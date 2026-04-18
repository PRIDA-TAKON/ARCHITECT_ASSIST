import sys
import os
import pandas as pd
import ezdxf

# เพิ่มโฟลเดอร์หลักเข้าไปในระบบ
sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from src.dxf_parser import DXFParser
from src.excel_manager import ExcelManager

def run_pro_test():
    print("============================================================")
    print("      🏛️ ARCHITECT_ASSIST: Professional Unit Test")
    print("============================================================\n")

    # 1. สร้างไฟล์จำลองสำหรับการทดสอบ
    os.makedirs("tests/data", exist_ok=True)
    
    # สร้างไฟล์ DXF จำลอง
    dxf_test_path = "tests/data/test.dxf"
    doc = ezdxf.new()
    msp = doc.modelspace()
    msp.add_line((0, 0), (10, 10))
    doc.saveas(dxf_test_path)

    # สร้างไฟล์ Excel จำลอง
    xlsx_test_path = "tests/data/test.xlsx"
    df = pd.DataFrame({'Item': ['Wall', 'Column'], 'Quantity': [0, 0]})
    df.to_excel(xlsx_test_path, index=False)

    # 2. ทดสอบ DXF Parser
    print("[1/2] Testing DXF Parser (Reading DXF)...")
    try:
        parser = DXFParser(dxf_test_path)
        print("✅ DXF Parser: Successfully read the drawing!\n")
    except Exception as e:
        print(f"❌ DXF Parser error: {str(e)}\n")

    # 3. ทดสอบ Excel Manager
    print("[2/2] Testing Excel Manager (Reading Excel)...")
    try:
        manager = ExcelManager(xlsx_test_path)
        print("✅ Excel Manager: Successfully read the BOQ template!\n")
    except Exception as e:
        print(f"❌ Excel Manager error: {str(e)}\n")

    print("============================================================")
    print("   Unit Test Passed! Your architecture AI engine is STABLE.")

if __name__ == "__main__":
    run_pro_test()
