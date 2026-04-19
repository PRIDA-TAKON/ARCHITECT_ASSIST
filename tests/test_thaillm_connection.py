import os
import sys
from dotenv import load_dotenv

# Add the project root to sys.path to import src
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))

from src.agent import get_architect_agent

def test_thaillm():
    load_dotenv()
    api_key = os.getenv("THAI_LLM_KEY")
    model_name = "Pathumma-ThaiLLM-qwen3-8b-think-3.0.0"
    
    if not api_key:
        print("❌ Error: THAI_LLM_KEY not found in .env file.")
        return

    print(f"Testing ThaiLLM with model: {model_name}...")
    
    try:
        agent = get_architect_agent(model_name=model_name, api_key=api_key)
        
        if not agent:
            print("❌ Error: Failed to initialize agent.")
            return

        print("Agent initialized. Sending test message...")
        
        # Simple test message
        response = agent.invoke({"messages": [("user", "สวัสดี คุณเป็นใคร?") ]})
        
        ai_msg = response["messages"][-1].content
        print("\n--- AI Response ---")
        print(ai_msg)
        print("-------------------\n")
        print("✅ Connection test successful!")
        
    except Exception as e:
        print(f"❌ An error occurred during testing: {str(e)}")

if __name__ == "__main__":
    test_thaillm()
