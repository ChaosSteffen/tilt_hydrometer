# Tilt Hydrometer
This software is a replacement for [TiltPi](https://github.com/baronbrew/TILTpi) and posts your Tilt readings straight to [Brewfather](https://brewfather.app/) and/or to a [MQTT](https://en.wikipedia.org/wiki/MQTT) broker.

It is a [Ruby](https://en.wikipedia.org/wiki/Ruby_(programming_language)) based commandline-tool that is easy to install and works effortless on Linux (Raspberry Pi OS).

## Getting Started
Raspberry Pi OS unfortunately ships without Ruby and the `hcidump` utility, so you first need to install both:

```
sudo apt-get update
sudo apt-get install ruby bluez-hcidump
```

Then install the `tilt_hydrometer` executable via:

```
sudo gem install tilt_hydrometer
```

As interacting with the bluetooth device on Raspberry Pi OS requires root-priviliges, start reading and posting to brewfather by using the `tilt_hydrometer` command with `sudo`:

```
sudo tilt_hydrometer -b http://log.brewfather.net/stream?id=abcdefghijkl123
```

In order to receive any BLE beacons you need to start `hcitool` in parallel.

```
hcitool lescan --passive --duplicates
```

*Only if you have both command running at the same time you will receive reading from your Tilt Hydrometer.*

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

## Installation as service
Having to start `tilt_hydrometer` from the commandline is not very convienient and does not restart the software upon crashes or system reboot. So it is recommended to setup `tilt_hydrometer` as a [systemd service](https://www.raspberrypi.org/documentation/linux/usage/systemd.md).

Create a systemd service file in `/etc/systemd/system/tilt_hydrometer.service` with the following contents:
```doc/tilt_hydrometer.service

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

`tilt_hydrometer` relies `hcitool` to be running and scanning for BLE beacons. So you need to start this also as service.

Create a systemd service file in `/etc/systemd/system/tilt_hydrometer_ble_scanner.service` with the following contents:
```doc/tilt_hydrometer_ble_scanner.service
```

## What `tilt_hydromter` does

* Read the bluetooth beacons of your Tilt
* Post the data to Brewfather
* Publish the data to an MQTT broker

## What `tilt_hydromter` does not

* Have a nice Web-GUI to manage your hydrometers (use the great GUI provided by Brewfather)
* Calibrate data (can be done in Brewfather)
* Ready-to-use Raspberry Pi image

## Why not using TiltPi?
The TiltPi Raspberry Pi images are a great for getting started quick with your Tilt Hydrometer, but they require a dedicated Raspberry Pi just to read and post the values to a cloud service.

You can setup TiltPi on any Linux computer, without relying on the image, but it is a quite clunky process. It requires a lot of steps, including monkey-patching 3rd party libraries.

If you are using Brewfather like I do, all you need is forwarding the bluetooth readings to the Brewfather Webhook.

Being able to publish the data to a MQTT broken helps to integrate the Tilt with further automation like heating or cooling.
