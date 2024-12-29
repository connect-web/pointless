import pyautogui
x1, y1, x2, y2 = pyautogui.size().width // 4, pyautogui.size().height // 4, 3 * pyautogui.size().width // 4, 3 * pyautogui.size().height // 4

# print(f'({x1},{y1},{x2},{y2})')

x1, y1, x2, y2 = (x2 // 4, y2 // 4, 3 * x2 // 4, 3 * y2 // 4)  # Assuming a 1920x1080 screen resolution

def get_center_coordinates():
    print(f'({x1},{y1},{x2},{y2})')
    return (x1 + x2, y1 + y2)