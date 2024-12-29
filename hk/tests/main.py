from PIL import ImageGrab
import numpy as np
import cv2
from color import hex_to_rgb
from mask import extract_binary_circles
from mouse import move_mouse_smoothly

DEV = False

def analyze_and_overlay_screen_region(x1, y1, x2, y2, target_color, tolerance, max_area):
    """
    Analyze a screen region for a target color within a tolerance and overlay matches.

    Args:
        x1, y1, x2, y2 (int): Coordinates of the screen region.
        target_color (tuple): Target color as (R, G, B).
        tolerance (int): Tolerance for color matching.
        max_area (int): Maximum contour area threshold.

    Returns:
        None
    """
    # Capture the region of the screen
    screen = ImageGrab.grab(bbox=(x1, y1, x2, y2))
    screen_np = np.array(screen)  # Convert to NumPy array
    screen_bgr = cv2.cvtColor(screen_np, cv2.COLOR_RGB2BGR)  # Convert to BGR for OpenCV

    # Extract RGB components from target color
    target_r, target_g, target_b = target_color

    # Create a mask for the target color within the tolerance
    lower_bound = np.array([max(0, target_r - tolerance), max(0, target_g - tolerance), max(0, target_b - tolerance)])
    upper_bound = np.array([min(255, target_r + tolerance), min(255, target_g + tolerance), min(255, target_b + tolerance)])
    mask = cv2.inRange(screen_np, lower_bound, upper_bound)

    if DEV:
        # Save the mask as mask.png
        cv2.imwrite('mask.png', mask)

    # Find contours of the matching regions
    contours, _ = cv2.findContours(mask, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)

    # Draw contours on the screen image
    for contour in contours:
        area = cv2.contourArea(contour)
        if area <= max_area:  # Filter contours based on maximum area
            cv2.drawContours(screen_bgr, [contour], -1, (0, 0, 255), 2)  # Draw red contours for visualization

    # Display the result
    #cv2.imshow("Matched Regions with Overlay", screen_bgr)
    #cv2.waitKey(0)
    #cv2.destroyAllWindows()
    if DEV:
        cv2.imwrite('example.png', screen_bgr)

    return mask


# Example usage
if __name__ == "__main__":
    # Define the region and parameters
    #x1, y1, x2, y2 = 1154, 598, 1403, 844  # Coordinates of the screen region
    x1 = 320
    y1 = 284
    x2 = 2326
    y2 = 1069

    target_color = hex_to_rgb('3AD604')  # Lime green
    tolerance = 75  # Tolerance for matching (adjust as needed)
    max_area = 500  # Minimum contour area threshold (in pixels)

    mask = analyze_and_overlay_screen_region(x1, y1, x2, y2, target_color, tolerance, max_area)

    circle_point = extract_binary_circles(mask)
    print(f'Found circle={circle_point}')

    move_mouse_smoothly(circle_point)