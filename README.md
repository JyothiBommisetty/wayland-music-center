# 🎵 Wayland Music Center

A customizable music experience for Linux desktops running Wayland, combining Spotify, synchronized lyrics, real-time audio visualization, and dynamic album-art-based colours.

## ✨ Features

- 🎤 **Lyrics Only** – Spotify with synchronized lyrics.
- 🎧 **Lyrics + Visualizer** – Lyrics with real-time audio visualization.
- 🎵 **Audio Only** – Spotify without overlays.
- ⏹️ **Stop Overlays** – Stop lyrics and visualizer without stopping Spotify.
- 🎨 **Dynamic Colours** – Extract prominent colours from Spotify album artwork.
- 🖥️ **Custom Interface** – A graphical music-mode selector built with Quickshell.
- ⚙️ **Background Synchronization** – Automatic colour updates using systemd.

## 🛠️ Tech Stack

| Technology | Purpose |
|---|---|
| Quickshell | Graphical interface |
| Spotify | Music playback |
| playerctl | Playback metadata |
| wshowlyrics | Synchronized lyrics |
| Kwybars | Audio visualization |
| PipeWire | Audio processing |
| Python | Colour extraction |
| Pillow | Album artwork processing |
| systemd | Background service |

## 🏗️ Architecture

```text
                    Spotify
                       |
                   playerctl
                       |
              +--------+--------+
              |                 |
         wshowlyrics         PipeWire
           Lyrics                |
                             Kwybars
                           Visualizer

             Spotify Album Artwork
                       |
                 Python + Pillow
                       |
                Colour Extraction
                       |
                  colors.toml
                       |
                    Kwybars
```

## 📁 Project Structure

```text
wayland-music-center/
│
├── config/
│   ├── colors.toml
│   └── kwybars-config.toml
│
├── music-center/
│   ├── shell.qml
│   └── music-center
│
├── scripts/
│   └── spotify-color-sync.py
│
├── systemd/
│   └── spotify-color-sync.service
│
├── screenshots/
├── docs/
├── .gitignore
└── README.md
```

## 📋 Requirements

- Linux with Wayland
- Quickshell 0.3.2 or compatible
- Spotify (Flatpak)
- playerctl
- wshowlyrics
- Kwybars
- PipeWire
- Python 3
- Pillow

## 🚀 Installation

### 1. Install the Python dependency

```bash
python3 -m pip install Pillow
```

### 2. Create configuration directories

```bash
mkdir -p ~/.config/quickshell/music-center
mkdir -p ~/.config/kwybars
mkdir -p ~/.local/bin
mkdir -p ~/.config/systemd/user
```

### 3. Copy project files

Run from the cloned repository directory:

```bash
cp music-center/shell.qml ~/.config/quickshell/music-center/
cp music-center/music-center ~/.local/bin/
cp scripts/spotify-color-sync.py ~/.local/bin/
cp config/kwybars-config.toml ~/.config/kwybars/config.toml
cp config/colors.toml ~/.config/kwybars/colors.toml
cp systemd/spotify-color-sync.service ~/.config/systemd/user/
```

### 4. Make scripts executable

```bash
chmod +x ~/.local/bin/music-center
chmod +x ~/.local/bin/spotify-color-sync.py
```

### 5. Enable colour synchronization

```bash
systemctl --user daemon-reload
systemctl --user enable --now spotify-color-sync.service
```

### 6. Launch Music Center

```bash
qs -p ~/.config/quickshell/music-center
```

## 🎛️ Command-Line Usage

```bash
music-center lyrics
music-center visualizer
music-center audio
music-center stop
```

| Command | Behaviour |
|---|---|
| `lyrics` | Spotify with lyrics |
| `visualizer` | Spotify with lyrics and visualizer |
| `audio` | Spotify without overlays |
| `stop` | Stops overlays without stopping Spotify |

## 🎨 Dynamic Colour Synchronization

The Python script:

1. Reads the current Spotify artist and track.
2. Retrieves the album artwork URL.
3. Downloads and processes the artwork.
4. Extracts prominent colours using Pillow.
5. Updates the Kwybars colour configuration.

It checks for track changes every three seconds. A small artist-specific colour rule is also included, with artwork colours used by default.

## 🔮 Future Improvements

- More flexible music mood-based palettes.
- Improved error handling and process management.
- Customizable visualizer themes.
- Additional music player integrations.
- Installation automation.

## 🙌 Acknowledgements

This project integrates existing technologies, including Quickshell, Kwybars, wshowlyrics, and playerctl.

Spotify is a third-party service. This project is not affiliated with or endorsed by Spotify.

## 📄 License

License to be selected.
