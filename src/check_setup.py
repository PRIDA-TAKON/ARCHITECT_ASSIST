import sys
import subprocess

def check_setup():
    print("============================================================")
    print("      🏛️ ARCHITECT_ASSIST: System Health Check")
    print("============================================================\n")

    # 1. Check Python Version
    print(f"[1/3] Checking Python Version...")
    print(f"Current version: {sys.version}")
    if sys.version_info.major == 3 and sys.version_info.minor >= 14:
        print("⚠️ Warning: Python 3.14 is very new and experimental.")
        print("   Many Google Cloud libraries are NOT yet compatible with 3.14.")
        print("   >>> RECOMMENDATION: Use Python 3.11 or 3.12 for stability.\n")
    else:
        print("✅ Python version is compatible.\n")

    # 2. Check Critical Libraries
    libraries = [
        "streamlit",
        "ezdxf",
        "google.cloud.aiplatform",
        "google.cloud.location",
        "langchain_google_vertexai"
    ]
    
    print("[2/3] Checking Required Libraries...")
    missing = []
    for lib in libraries:
        try:
            __import__(lib)
            print(f"✅ {lib}: Installed")
        except ImportError:
            print(f"❌ {lib}: MISSING")
            missing.append(lib)
    
    if missing:
        print("\n>>> Some libraries are missing. Please run INSTALL_WINDOWS.bat again.")
        print(f">>> Missing: {', '.join(missing)}\n")
    else:
        print("✅ All libraries are present.\n")

    # 3. Check Google Cloud Auth (Optional)
    print("[3/3] Checking Google Cloud Authentication...")
    try:
        from google.auth import default
        credentials, project = default()
        if project:
            print(f"✅ Auth found! Project ID: {project}")
        else:
            print("⚠️ Credentials found, but no default project is set.")
    except Exception:
        print("❌ No Google Cloud credentials found.")
        print("   >>> Run: gcloud auth application-default login\n")

    print("============================================================")
    print("   Check complete!")

if __name__ == "__main__":
    check_setup()
