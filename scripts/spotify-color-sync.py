#!/usr/bin/env python3

import subprocess
import urllib.request
import time
import colorsys
from io import BytesIO
from pathlib import Path
from PIL import Image
from collections import Counter

CONFIG = Path.home() / ".config/kwybars/colors.toml"

def spotify_metadata(field):
    try:
        return subprocess.check_output(
            ["playerctl", "metadata", field],
            text=True, stderr=subprocess.DEVNULL
        ).strip()
    except subprocess.CalledProcessError:
        return ""

def extract_colors(url):
    request = urllib.request.Request(
        url, headers={"User-Agent": "SpotifyColorSync/1.0"}
    )

    with urllib.request.urlopen(request, timeout=15) as response:
        image = Image.open(BytesIO(response.read())).convert("RGB")

    image = image.resize((100, 100))
    quantized = image.quantize(colors=8).convert("RGB")

    colors = Counter(quantized.get_flattened_data())
    selected = [color for color, _ in colors.most_common(5)]

    return selected

def hex_color(rgb):
    return "#{:02X}{:02X}{:02X}".format(*rgb)

def rgba(rgb):
    return f"rgba({rgb[0]}, {rgb[1]}, {rgb[2]}, 1.0)"

def choose_palette(artist, title, colors):
    artist = artist.lower()
    title = title.lower()

    # Custom mood rules can be added here.
    if "taylor swift" in artist and any(
        word in title for word in ["love", "lover", "romantic"]
    ):
        return (255, 105, 180), (255, 182, 193)

    # Default: use the two most prominent artwork colours.
    return colors[0], colors[1]

def update_colors(first, second):
    CONFIG.parent.mkdir(parents=True, exist_ok=True)

    content = f'''[visualizer]
color_rgba = "{rgba(first)}"
color2_rgba = "{rgba(second)}"
'''

    CONFIG.write_text(content)

def main():
    previous_track = ""

    print("Spotify Color Sync started.")

    while True:
        artist = spotify_metadata("artist")
        title = spotify_metadata("title")
        artwork = spotify_metadata("mpris:artUrl")

        track = f"{artist} - {title}"

        if track and artwork and track != previous_track:
            try:
                colors = extract_colors(artwork)
                first, second = choose_palette(artist, title, colors)

                update_colors(first, second)

                print(f"\nTrack: {track}")
                print(f"Palette: {hex_color(first)} → {hex_color(second)}")

                previous_track = track

            except Exception as error:
                print("Color update failed:", error)

        time.sleep(3)

if __name__ == "__main__":
    main()
