def hex_to_rgb(hex_color):
    """
    Convert a hex color string to an RGB tuple.

    Args:
        hex_color (str): Hex color string, e.g., 'DF00FF'.

    Returns:
        tuple: Corresponding RGB tuple, e.g., (223, 0, 255).
    """
    hex_color = hex_color.lstrip('#')  # Remove the '#' if present
    return tuple(int(hex_color[i:i + 2], 16) for i in (0, 2, 4))