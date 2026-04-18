from PIL import Image, ImageDraw, ImageFont
import os

def create_icon():
    # Size for high quality icon
    size = 256
    image = Image.new('RGB', (size, size), color=(0, 0, 0))
    draw = ImageDraw.Draw(image)
    
    # Try to find a font, fallback to default
    try:
        # Common font paths on Linux
        font_paths = [
            "/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf",
            "/usr/share/fonts/truetype/liberation/LiberationSans-Bold.ttf",
            "/usr/share/fonts/TTF/DejaVuSans-Bold.ttf"
        ]
        font = None
        for path in font_paths:
            if os.path.exists(path):
                font = ImageFont.truetype(path, 160)
                break
        if not font:
            font = ImageFont.load_default()
    except:
        font = ImageFont.load_default()

    # Draw "AA"
    text = "AA"
    color = (0, 162, 232) # Blue color
    
    # Position text in center
    if hasattr(draw, 'textbbox'):
        bbox = draw.textbbox((0, 0), text, font=font)
        w, h = bbox[2] - bbox[0], bbox[3] - bbox[1]
    else:
        # Fallback for older Pillow
        w, h = draw.textsize(text, font=font)
        
    draw.text(((size-w)/2, (size-h)/2 - 20), text, fill=color, font=font)

    # Save as ICO in assets folder
    os.makedirs('assets', exist_ok=True)
    image.save('assets/icon.ico', format='ICO', sizes=[(256, 256), (128, 128), (64, 64), (32, 32), (16, 16)])
    print("Icon generated at assets/icon.ico")

if __name__ == "__main__":
    create_icon()
