# Tilt Hydrometer
This software is a replacement for TiltPi and posts your Tilt readings straight to [Brewfather](https://brewfather.app/) and/or to a [MQTT](https://en.wikipedia.org/wiki/MQTT) broker.

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

### Posting pata to Brewfather
As mentioned before, posting data to Brewfather, works by just using the `-b` option with as [Custom Stream URL](https://docs.brewfather.app/integrations/custom-stream). There is an optional `-i` argument, that can be used to set the reporting interval in seconds, default is `900` (15 minutes).

```
[sudo] tilt_hydrometer -b http://log.brewfather.net/stream?id=abcdefghijkl123 -i 900
```

### Publishing data to MQTT broker
Publishing the your readings to an MQTT broker works by using the `-m` option with a [MQTT URI](https://github.com/mqtt/mqtt.github.io/wiki/URI-Scheme). Using `-p` to set a MQTT-topic prefix is recommended.

```
[sudo] tilt_hydrometer -m mqtt://192.0.2.1:1883 -p foo/bar/
```

### Logging to file or console
TODO

## Installation as service (Linux)
Having to start `tilt_hydrometer` from the commandline is not very convienient and does not restart the software upon crashes or system reboot. So it is recommended to setup `tilt_hydrometer` as a [systemd service](https://www.raspberrypi.org/documentation/linux/usage/systemd.md).

Create a systemd service file in `/etc/systemd/system/tilt_hydrometer.service`:
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

Adjust the paramaters in the `ExecStart` command to you needs.

Then start the service:
```
sudo systemctl start tilt_hydrometer.service
```

And enable it to be reastarted upon failure or reboot:
```
sudo systemctl enable tilt_hydrometer.service
```

## Why not using TiltPi?
The TiltPi Raspberry Pi images are a great for getting started quick with your Tilt Hydrometer, but they require a dedicated Raspberry Pi just to read and post the values to a cloud service.

Setting up TiltPi without using the image is a quite clunky process.

If you are using Brewfather like I do, all you need is forwarting the bluetooth readings to the Brewfather Webhook.

Being able to publish the data to a MQTT broken helps to integrate the Tilt with further automation like heting or cooling.
