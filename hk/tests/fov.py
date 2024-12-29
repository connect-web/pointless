import tkinter as tk
from PIL import ImageGrab
import numpy as np

# Function to draw a rectangle overlay
def start_selection(event):
    global x1, y1
    x1, y1 = event.x, event.y
    rect_id.set(canvas.create_rectangle(x1, y1, x1, y1, outline='red', width=2))

def update_selection(event):
    x2, y2 = event.x, event.y
    canvas.coords(rect_id.get(), x1, y1, x2, y2)

def finish_selection(event):
    global x2, y2
    x2, y2 = event.x, event.y
    root.quit()

# Main GUI
root = tk.Tk()
root.attributes('-fullscreen', True)  # Make the window fullscreen and borderless
root.attributes('-alpha', 0.3)  # Make the window semi-transparent
root.title("Select Screen Region")

canvas = tk.Canvas(root, bg="black")
canvas.pack(fill=tk.BOTH, expand=True)

rect_id = tk.Variable(value=None)
x1 = y1 = x2 = y2 = 0

canvas.bind("<Button-1>", start_selection)
canvas.bind("<B1-Motion>", update_selection)
canvas.bind("<ButtonRelease-1>", finish_selection)

root.mainloop()

# Use the selected region
if x1 and y1 and x2 and y2:
    print(f"Selected region: x1={x1}, y1={y1}, x2={x2}, y2={y2}")

    # Example: Analyze the selected region
    def analyze_screen_region(x1, y1, x2, y2, target_color, tolerance, min_pixels):
        screen = ImageGrab.grab(bbox=(x1, y1, x2, y2))
        screen_np = np.array(screen)
        target_r, target_g, target_b = target_color
        diff = np.abs(screen_np[:, :, 0] - target_r) + \
               np.abs(screen_np[:, :, 1] - target_g) + \
               np.abs(screen_np[:, :, 2] - target_b)
        matching_pixels = np.sum(diff <= (tolerance * 3))
        return matching_pixels >= min_pixels

    # Example usage
    target_color = (255, 0, 0)
    tolerance = 10
    min_pixels = 50
    if analyze_screen_region(x1, y1, x2, y2, target_color, tolerance, min_pixels):
        print("Shape/Threshold detected!")
    else:
        print("No match found.")
else:
    print("No region selected.")
