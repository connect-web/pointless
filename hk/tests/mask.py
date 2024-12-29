import cv2
import numpy as np
import os


def extract_red_circles(image, output_directory=None, size=20):
    """
    Extract red circles from an image and save them as separate 20x20 images.
    Find and print the coordinates of the center of the image and the closest circle.

    Args:
        image (np.ndarray): Input image as a NumPy array.
        output_directory (str): Directory to save the extracted images.
        size (int): Maximum size (width and height) of the output images.
    """
    # Convert the image to HSV color space
    hsv = cv2.cvtColor(image, cv2.COLOR_BGR2HSV)

    # Define red color range in HSV
    lower_red1 = np.array([0, 120, 70])
    upper_red1 = np.array([10, 255, 255])
    lower_red2 = np.array([170, 120, 70])
    upper_red2 = np.array([180, 255, 255])

    # Create masks for red color
    mask1 = cv2.inRange(hsv, lower_red1, upper_red1)
    mask2 = cv2.inRange(hsv, lower_red2, upper_red2)
    mask = cv2.bitwise_or(mask1, mask2)

    # Find contours of the red circles
    contours, _ = cv2.findContours(mask, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)

    # Center of the image
    height, width = image.shape[:2]
    image_center = (width // 2, height // 2)

    closest_circle = None
    min_distance = float('inf')

    index = 0
    for contour in contours:
        # Get the bounding rectangle for each contour
        x, y, w, h = cv2.boundingRect(contour)

        # Ensure the bounding box is small enough for a 20x20 crop
        if w <= size and h <= size:
            # Extract the region of interest
            roi = image[y:y+h, x:x+w]

            # Resize the ROI to 20x20
            roi_resized = cv2.resize(roi, (size, size), interpolation=cv2.INTER_AREA)

            # Save the extracted circle
            if output_directory is not None:
                output_path = f"{output_directory}/circle_{index}.png"
                cv2.imwrite(output_path, roi_resized)
            index += 1

            # Calculate the center of the circle
            circle_center = (x + w // 2, y + h // 2)

            # Calculate the distance to the image center
            distance = np.sqrt((image_center[0] - circle_center[0])**2 + (image_center[1] - circle_center[1])**2)

            # Update the closest circle
            if distance < min_distance:
                min_distance = distance
                closest_circle = circle_center

    # Print the results
    print(f"Image Center: {image_center}")
    if closest_circle:
        print(f"Closest Circle Center: {closest_circle}")
        return closest_circle
    else:
        print("No circles detected.")

    print(f"Extracted {index} red circles.")


def extract_binary_circles(mask):
    """
    Extract circles from a binary mask and return the coordinates of the closest circle to the center.

    Args:
        mask (np.ndarray): Binary mask where circles are detected (single-channel image).

    Returns:
        tuple: Coordinates of the closest circle (x, y), or None if no circle is found.
    """
    # Find contours in the binary mask
    contours, _ = cv2.findContours(mask, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)

    # Center of the mask
    height, width = mask.shape[:2]
    mask_center = (width // 2, height // 2)

    closest_circle = None
    min_distance = float('inf')

    for contour in contours:
        # Get the bounding rectangle for each contour
        x, y, w, h = cv2.boundingRect(contour)

        # Calculate the center of the circle
        circle_center = (x + w // 2, y + h // 2)

        # Calculate the distance to the mask center
        distance = np.sqrt((mask_center[0] - circle_center[0])**2 + (mask_center[1] - circle_center[1])**2)

        # Update the closest circle
        if distance < min_distance:
            min_distance = distance
            closest_circle = circle_center

    return closest_circle



if __name__ == '__main__':
    # Example usage
    input_image_path = "redmask.png"  # Path to the input image
    output_directory = "data/circles"  # Path to save the output images

    # Load the image from file
    image = cv2.imread(input_image_path)

    # Ensure the output directory exists
    os.makedirs(output_directory, exist_ok=True)

    # Call the function with the image
    extract_red_circles(image, output_directory)
