import ezdxf
import os
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
                # length = sqrt((x2-x1)^2 + (y2-y1)^2 + (z2-z1)^2)
                start = e.dxf.start
                end = e.dxf.end
                length = ((end[0]-start[0])**2 + (end[1]-start[1])**2 + (end[2]-start[2])**2)**0.5
                total_length += length
            elif e.dxftype() == 'LWPOLYLINE':
                # LWPOLYLINE length calculation
                total_length += e.length()
            elif e.dxftype() == 'POLYLINE':
                # POLYLINE length calculation
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

if __name__ == "__main__":
    # Example usage (requires a sample dxf file)
    print("DXF Parser module initialized.")
