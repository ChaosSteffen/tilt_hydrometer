# Tilt Hydrometer
Read your Tilt Hydrometers beacons and post to Brewfather. Without the hassle.

This works on macOS and Linux (Raspberry Pi OS).

## Installation (macOS)
On macOS simply install via:

```
gem install tilt_hydrometer
```

## Installation (Linux)
Raspberry PI OS ships without Ruby and the BlueZ bluetooth library, so you have to install it first.

```
sudo apt-get install ruby ruby-dev bluetooth bluez libbluetooth-dev
```

Then install via:

```
sudo gem install tilt_hydrometer
```

## Usage (macOS)
Run the tilt_hydrometer command and provide a Brewfather Custom Stream URL:

```
tilt_hydrometer http://log.brewfather.net/stream?id=abcdefghijkl123
```

## Usage (Linux)
Run the tilt_hydrometer command and provide a Brewfather Custom Stream URL:

```
sudo tilt_hydrometer http://log.brewfather.net/stream?id=abcdefghijkl123
```
