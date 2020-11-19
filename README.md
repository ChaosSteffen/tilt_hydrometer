# Tilt Hydrometer
This software is a replacement for [TiltPi](https://github.com/baronbrew/TILTpi) and posts your Tilt readings straight to [Brewfather](https://brewfather.app/) and/or to a [MQTT](https://en.wikipedia.org/wiki/MQTT) broker.

It is a [Ruby](https://en.wikipedia.org/wiki/Ruby_(programming_language)) based commandline-tool that is easy to install and works effortless on macOS and Linux (Raspberry Pi OS).

## Getting Started (macOS)
As macOS ships with Ruby and Bluetooth support by default you simply have to install the `tilt_hydrometer` executable via:

```
gem install tilt_hydrometer
```

Then start reading and posting to brewfather by using the `tilt_hydrometer` command:

```
tilt_hydrometer -b http://log.brewfather.net/stream?id=abcdefghijkl123
```

## Getting Started (Raspberry Pi OS)
Raspberry Pi OS unfortunately ships without Ruby and Bluetooth support, so you first need to install it:

```
sudo apt-get install ruby ruby-dev bluetooth bluez libbluetooth-dev
```

Then install the `tilt_hydrometer` executable via:

```
sudo gem install tilt_hydrometer
```

As interacting with the bluetooth device on Raspberry Pi OS requires root-priviliges, start reading and posting to brewfather by using the `tilt_hydrometer` command with `sudo`:

```
sudo tilt_hydrometer -b http://log.brewfather.net/stream?id=abcdefghijkl123
```

## Usage
The `tilt_hydrometer` command supports different operations, that also can be used in combination:

### Posting data to Brewfather
As mentioned before, posting data to Brewfather, works by just using the `-b` option with as [Custom Stream URL](https://docs.brewfather.app/integrations/custom-stream). There is an optional `-i` argument, that can be used to set the reporting interval in seconds, default is `900` (15 minutes).

```
[sudo] tilt_hydrometer -b http://log.brewfather.net/stream?id=abcdefghijkl123 -i 900
```

### Publishing data to a MQTT broker
Publishing the your readings to an MQTT broker works by using the `-m` option with a [MQTT URI](https://github.com/mqtt/mqtt.github.io/wiki/URI-Scheme). Using `-p` to set a MQTT-topic prefix is recommended.

```
[sudo] tilt_hydrometer -m mqtt://192.0.2.1:1883 -p foo/bar/
```

### Logging to file or console
TODO

## Installation as service (Raspberry Pi OS)
Having to start `tilt_hydrometer` from the commandline is not very convienient and does not restart the software upon crashes or system reboot. So it is recommended to setup `tilt_hydrometer` as a [systemd service](https://www.raspberrypi.org/documentation/linux/usage/systemd.md).

Create a systemd service file in `/etc/systemd/system/tilt_hydrometer.service` with the following contents:
```
[Unit]
Description=Tilt Hydrometer
After=network.target

[Service]
ExecStart=/usr/local/bin/tilt_hydrometer  -b http://log.brewfather.net/stream?id=abcdefghijkl123 -i 900 -m mqtt://192.0.2.1:1883 -p foo/bar/
WorkingDirectory=/home/pi
StandardOutput=inherit
StandardError=inherit
Restart=always
User=root

[Install]
WantedBy=multi-user.target
```

Adjust the paramaters in the `ExecStart` command to your needs.

Then start the service:
```
sudo systemctl start tilt_hydrometer
```

And enable it to be reastarted upon failure or reboot:
```
sudo systemctl enable tilt_hydrometer
```

## What `tilt_hydromter` does

* Read the bluetooth beacons of your Tilt
* Post the data to Brewfather
* Publish the data to an MQTT broker

## What `tilt_hydromter` does not

* Have a nice Web-GUI to manage your hydrometers (use the great GUI provided by Brewfather)
* Calibrate data (can be done in Brewfather)
* Ready to use Raspberry Pi image

## Why not using TiltPi?
The TiltPi Raspberry Pi images are a great for getting started quick with your Tilt Hydrometer, but they require a dedicated Raspberry Pi just to read and post the values to a cloud service.

You can setup TiltPi on any Linux computer, without relying on they image, but it is a quite clunky process. It requires a lot of steps, including monkey-patching 3rd party libraries.

If you are using Brewfather like I do, all you need is forwarting the bluetooth readings to the Brewfather Webhook.

Being able to publish the data to a MQTT broken helps to integrate the Tilt with further automation like heting or cooling.
