# 🏛️ ARCHITECT_ASSIST: Your AI Design Partner

**ARCHITECT_ASSIST** คือผู้ช่วยสถาปนิกอัจฉริยะ (AI Agent) ที่รันบนเครื่องของคุณเอง (Local) เพื่อช่วยจัดการงานถึกๆ (Tedious Tasks) ในการอ่านแบบร่าง CAD (.dxf) และการทำตารางประมาณราคาก่อสร้าง (BOQ) ใน Excel (.xlsx) 

---

## ✨ ฟีเจอร์เด่น
*   **CAD Analysis:** สั่งให้ AI อ่านข้อมูลปริมาณงาน (Quantity Take-off) จากไฟล์ `.dxf` เช่น ความยาวผนัง, จำนวนเสา, หรือพื้นที่ห้อง ได้ทันที
*   **BOQ Automation:** สั่งให้ AI กรอกข้อมูลราคา, ปริมาณวัสดุ หรือแก้ไขรายการในไฟล์ Excel (Bill of Quantities) ผ่านการแชท
*   **Modern LLM Support:** รองรับสมองกลรุ่นล่าสุดจาก Google (Gemini 3.1 Pro/Flash และ Gemma 4)
*   **Privacy First:** ไฟล์แบบร่างและข้อมูลราคาของคุณจะอยู่ในเครื่องคุณเอง (Local Storage) และสื่อสารกับ AI ผ่าน API Key ที่ปลอดภัย
*   **One-Click Experience:** ติดตั้งและเริ่มใช้งานได้ง่ายเหมือนโปรแกรมทั่วไป (ไม่ต้องพิมพ์โค้ด)

---

## 🚀 วิธีติดตั้ง (สำหรับผู้ใช้งานทั่วไป)

1.  ดาวน์โหลดไฟล์ **`INSTALL_WINDOWS.bat`** จาก Repository นี้
2.  ดับเบิลคลิกไฟล์ **`INSTALL_WINDOWS.bat`** เพื่อเริ่มการติดตั้งอัตโนมัติ
    *   *ระบบจะติดตั้ง Python, Git และเครื่องมือที่จำเป็นให้เองจนจบ*
3.  เมื่อติดตั้งเสร็จ จะมีไอคอน **"ARCHITECT_ASSIST"** ปรากฏขึ้นบนหน้าจอ Desktop ของคุณ!

---

## 💻 วิธีใช้งาน
1.  ดับเบิลคลิกไอคอน **"ARCHITECT_ASSIST"** บนหน้าจอ Desktop
2.  ในแถบด้านข้าง (Sidebar) ให้เลือก **"Google AI Studio (API Key)"**
3.  กรอก **API Key** ของคุณ (ขอได้ฟรีที่ [Google AI Studio](https://aistudio.google.com/app/apikey))
4.  อัปโหลดไฟล์ **DXF (แบบร่าง)** และ **Excel (ตาราง BOQ)**
5.  เริ่มพิมพ์แชทสั่งงาน AI ได้เลย! เช่น:
    *   *"ช่วยรวมความยาวเส้นใน Layer 'WALL' จากไฟล์ DXF ให้หน่อย"*
    *   *"เอาความยาวที่ได้ไปกรอกในช่อง Quantity ของรายการผนังอิฐมอญใน Excel"*
6.  กดปุ่ม **"📥 Download Updated BOQ"** เพื่อรับไฟล์ที่ AI แก้ไขให้แล้วไปใช้งานต่อ

---

## 🔄 การอัปเดต (Auto-Update)
โปรแกรมจะทำการตรวจสอบและอัปเดตฟีเจอร์ใหม่ๆ จาก GitHub ของผู้พัฒนาให้โดยอัตโนมัติทุกครั้งที่คุณเปิดโปรแกรม คุณจะได้ใช้ "สมอง" และ "มือ" รุ่นล่าสุดเสมอ!

---

## 🛠️ สำหรับนักพัฒนา (Tech Stack)
*   **AI Framework:** LangGraph / CrewAI
*   **LLM Interface:** LangChain (Google Vertex AI / Google AI Studio)
*   **File Handlers:** `ezdxf`, `pandas`, `openpyxl`
*   **User Interface:** Streamlit

---
*พัฒนาโดย: ARCHITECT_ASSIST Team* 🏛️✨
