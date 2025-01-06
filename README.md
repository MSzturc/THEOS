<p align="center">
  <img src=".github/sdcard-logo.png" style="width:40%">
</p>

# What is THEOS?

**THEOS** is a prebuilt image for the **Banana Pi M2 Zero** and the **Orange Pi Zero 3**. It includes essential pre-configurations and software for running **Klipper firmware** with **Mainsail** as the user interface to control your **T100** or **T250** 3D printer.

## Installation Guide

#### What You Need

To install THEOS, you’ll need:
- An **SD card reader**
- An **SD card** with at least **32 GB** of space

#### Flashing THEOS

1. **Download and install the [Raspberry Pi Imager](https://www.raspberrypi.com/software/)**  
   Compatible with Windows, Linux, and MacOS.

2. **Download the latest [THEOS release](https://github.com/MSzturc/THEOS/releases/latest)**  
   Versions are available for both the Banana Pi M2 Zero and the Orange Pi Zero 3.

3. **Prepare the SD Card:**
   - Open **Raspberry Pi Imager**.
   - Click on **"CHOOSE OS"**, scroll to the bottom, select **"Use custom"**, and locate your downloaded THEOS file.
   - Click on **"CHOOSE STORAGE"**, then select your SD card. **Warning:** All data on the card will be erased.
   - Proceed with **"Next"**. When prompted for OS customization, select **"NO"**, and confirm the warning.

4. **Write the Image:**  
   The process will take some time. Once complete, you’ll receive a success message.


## Initial Network Setup

#### For Wired Connections
No additional steps are required. Proceed to the next section.

#### For Wi-Fi Connections
1. After flashing THEOS, unplug and replug your SD card reader. Access the **FAT boot partition** via your file manager.
2. Locate the `headless_nm.txt.template` file. Copy it and rename it to `headless_nm.txt`.
3. Open the `headless_nm.txt` file with a text editor that allows you to save it in a UNIX compabible format (e.g. Visual Studio Code) and follow the instructions in the comments to configure your network. A valid configuration might look like this:

   ```plaintext
    SSID="FRITZ!Box 3280"
    PASSWORD="123456789012345"
    HIDDEN="false"
    REGDOMAIN="DE"
## First Boot

1. Insert the prepared SD card into your 3D printer.
2. Connect necessary peripherals (e.g., network cables, webcams, USB cable to the printer).
3. Power on the device and wait up to **5 minutes** for the boot process to complete.
4. Access THEOS via your browser at:
   - [http://t250.local](http://t250.local) (for T250 printers)
   - [http://t100.local](http://t100.local) (for T100 printers)

## What’s Included?

Here’s a list of preinstalled and integrated software:

- [Klipper](https://www.klipper3d.org/)
- [Moonraker](https://moonraker.readthedocs.io/en/latest/)
- [Mainsail](https://docs.mainsail.xyz/)
- [Shake&Tune](https://github.com/Frix-x/klippain-shaketune/)
- [Crowsnest](https://github.com/mainsail-crew/crowsnest/)
- [Sonar](https://github.com/mainsail-crew/sonar/)
- [Timelapse](https://github.com/mainsail-crew/moonraker-timelapse/)
- [KlipperScreen](https://github.com/KlipperScreen/KlipperScreen/)

## Todo & Features
- [x] Support for Orange Pi Zero3
- [x] Support for Banana Pi BPI-M2 ZERO
- [x] Cleanup build Pipeline
- [x] Use my own Klipper fork for build
- [x] Integrate TMC Driver tuning into Klipper
- [x] Integrate klippain shaketune
- [x] Make Klipper accessable through t250.local / t100.local
- [x] Integrate BDSensor
- [x] Update Landing Page
- [x] create module for T250 config installation
- [ ] create own theme

## Bugs
- [x] Unofficial remote url: https://github.com/MSzturc/klipper.git
- [x] Repo has untracked source files: ['klippy/extras/autotune_tmc.py', 'klippy/extras/motor_constants.py']
- [x] Moonraker: Repo has untracked source files: ['moonraker/components/timelapse.py']
