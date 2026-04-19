import ezdxf
import os
import csv
from typing import List, Dict, Any

class DXFParser:
    def __init__(self, file_path: str):
        if not os.path.exists(file_path):
            raise FileNotFoundError(f"File not found: {file_path}")
        self.file_path = file_path
        self.doc = ezdxf.readfile(file_path)
        self.msp = self.doc.modelspace()

    def get_layers(self) -> List[str]:
        """Returns a list of all layer names in the DXF file."""
        return [layer.dxf.name for layer in self.doc.layers]

    def get_entities_by_layer(self, layer_name: str) -> List[Any]:
        """Returns all entities on a specific layer."""
        return self.msp.query(f'*[layer=="{layer_name}"]')

    def get_line_lengths_by_layer(self, layer_name: str) -> float:
        """Calculates the total length of all lines on a specific layer."""
        entities = self.get_entities_by_layer(layer_name)
        total_length = 0.0
        for e in entities:
            if e.dxftype() == 'LINE':
                start = e.dxf.start
                end = e.dxf.end
                length = ((end[0]-start[0])**2 + (end[1]-start[1])**2 + (end[2]-start[2])**2)**0.5
                total_length += length
            elif e.dxftype() == 'LWPOLYLINE' or e.dxftype() == 'POLYLINE':
                total_length += e.length()
        return total_length

    def count_blocks_by_name(self, block_name: str) -> int:
        """Counts occurrences of a specific block by name."""
        entities = self.msp.query(f'INSERT[name=="{block_name}"]')
        return len(entities)

    def get_summary(self) -> Dict[str, Any]:
        """Returns a basic summary of the DXF content."""
        summary = {
            "filename": os.path.basename(self.file_path),
            "layers": self.get_layers(),
            "entity_count": len(self.msp),
        }
        return summary

    def extract_door_schedule_data(self) -> List[Dict[str, str]]:
        """
        Advanced extraction for door schedules, mapping model space text to layouts/viewports.
        Ported from takon-ai-skills.
        """
        layout_viewports = []
        # Constants from project findings
        SHIFT_X = 15970
        OFFSET_Y = -15551

        # 1. Map Viewports to Layouts
        for l in self.doc.layouts:
            if l.name.lower() == 'model': continue
            for vp in l.query('VIEWPORT'):
                if vp.dxf.id == 1: continue 
                vc = vp.dxf.view_center_point
                vh = vp.dxf.view_height
                aspect = vp.dxf.width / vp.dxf.height
                vw = vh * aspect

                actual_vc_x = vc.x + SHIFT_X
                actual_vc_y = vc.y + OFFSET_Y

                layout_viewports.append({
                    'layout': l.name,
                    'min_x': actual_vc_x - vw/2, 'max_x': actual_vc_x + vw/2,
                    'min_y': actual_vc_y - vh/2, 'max_y': actual_vc_y + vh/2
                })

        # 2. Extract Text from Model Space (Recursive for blocks)
        all_msp_text = []
        blacklist = ['TYPE', 'ADDITIONAL EQUIPMENT', 'AREA:', 'โล่ง', '200X200', '200X300', 'FD.', 'REF.', '-']

        def process_entities(entities):
            for e in entities:
                if e.dxftype() in ['TEXT', 'MTEXT']:
                    text = (e.dxf.text if e.dxftype() == 'TEXT' else e.text).strip()
                    if not text or any(item.upper() in text.upper() for item in blacklist): continue
                    pos = getattr(e.dxf, 'insert', getattr(e.dxf, 'align_point', None))
                    if pos:
                        all_msp_text.append({'text': text, 'pos': (pos.x, pos.y)})
                elif e.dxftype() == 'INSERT':
                    try:
                        process_entities(e.virtual_entities())
                    except: pass

        process_entities(self.msp)

        # 3. Extract Text from Paper Space
        paper_text = []
        for l in self.doc.layouts:
            if l.name.lower() == 'model': continue
            for e in l.query('TEXT MTEXT'):
                t = (e.dxf.text if e.dxftype() == 'TEXT' else e.text).strip()
                if t and not any(item.upper() in t.upper() for item in blacklist):
                    paper_text.append({'Text': t, 'Page Number': l.name})

        # 4. Associate Model Space text with pages
        final_results = []
        for item in all_msp_text:
            px, py = item['pos']
            page = "Unknown"
            for vp in layout_viewports:
                if vp['min_x'] <= px <= vp['max_x'] and vp['min_y'] <= py <= vp['max_y']:
                    page = vp['layout']
                    break
            final_results.append({'Text': item['text'], 'Page Number': page})

        final_results.extend(paper_text)
        return final_results

    def extract_all_entities_summary(self) -> List[Dict[str, Any]]:
        """Ported from dxf-extractor/extractor.py"""
        all_entities = []
        filename = os.path.basename(self.file_path)

        for e in self.msp:
            etype = e.dxftype()
            if etype in ['TEXT', 'MTEXT', 'INSERT', 'LWPOLYLINE', 'POLYLINE']:
                content = ""
                if etype in ['TEXT', 'MTEXT']:
                    content = e.dxf.text if etype == 'TEXT' else e.text
                elif etype == 'INSERT':
                    content = f"Block: {e.dxf.name}"
                elif etype in ['LWPOLYLINE', 'POLYLINE']:
                    content = f"Length: {e.length():.2f}"

                pos = getattr(e.dxf, 'insert', getattr(e.dxf, 'start', (0,0,0)))

                all_entities.append({
                    'Filename': filename,
                    'Type': etype,
                    'Content': content,
                    'Layer': e.dxf.layer,
                    'X': getattr(pos, 'x', 0),
                    'Y': getattr(pos, 'y', 0)
                })
        return all_entities

def get_all_dxf_files(directory: str) -> List[str]:
    """Returns a list of all DXF files in the given directory."""
    if not os.path.exists(directory):
        return []
    return [os.path.join(directory, f) for f in os.listdir(directory) if f.endswith('.dxf')]

