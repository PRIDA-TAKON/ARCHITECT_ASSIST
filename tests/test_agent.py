import os
import sys
from dotenv import load_dotenv

# เพิ่มโฟลเดอร์หลักเข้าไปในระบบ
sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from src.agent import get_architect_agent

def test_ai_agent_interaction():
    print("============================================================")
    print("      🏛️ ARCHITECT_ASSIST: AI Agent Integration Test")
    print("============================================================\n")

    # 1. โหลด API Key จาก .env
    load_dotenv()
    api_key = os.getenv("GOOGLE_API_KEY")
    
    if not api_key:
        print("❌ Error: GOOGLE_API_KEY not found in .env")
        return

    # 2. เริ่มต้น Agent (ใช้รุ่น gemini-1.5-flash เพื่อความเร็วในการทดสอบ)
    print("[1/2] Initializing AI Agent...")
    agent = get_architect_agent(model_name="gemma-4-31b-it", api_key=api_key)
    
    if not agent:
        print("❌ Error: Failed to initialize agent.")
        return
    print("✅ Agent is ready!\n")

    # 3. ส่งคำสั่งให้ AI วิเคราะห์ไฟล์จำลองที่สร้างไว้คราวก่อน
    print("[2/2] Sending task to AI: 'Analyze the DXF file'...")
    dxf_path = "tests/data/test.dxf"
    
    if not os.path.exists(dxf_path):
        print("❌ Error: Mock DXF file not found. Please run quick_check.py first.")
        return

    prompt = f"ช่วยสรุปข้อมูลจากไฟล์ DXF นี้หน่อย: {dxf_path}"
    
    try:
        response = agent.invoke({"messages": [("user", prompt)]})
        ai_msg = response["messages"][-1].content
        print(f"\n🤖 AI Response:\n{ai_msg}\n")
        print("✅ Integration Test Success!")
    except Exception as e:
        print(f"❌ Integration Test Error: {str(e)}")

    print("\n============================================================")

if __name__ == "__main__":
    test_ai_agent_interaction()
