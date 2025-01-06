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
   - [http://theos.local](http://theos.local)
5. If you are using THEOS for the first time, you may encounter the following red error message: `Klipper reports: ERROR: mcu 'mcu': Unable to connect`. That's okay, follow the instructions in the **Flashing Firmware** chapter to resolve this issue.

## Flashing Firmware

In THEOS, **Managed Devices** streamline the integration and maintenance of hardware components such as MCUs by automating firmware updates and ensuring compatibility with Klipper updates. This chapter guides you through the process of registering a 3D printer controller board, using the BTT Kraken as an example of a Managed Device. By following this process, you will enable seamless firmware management and enhance overall system stability.

Additionally, if you are using other MCU devices, such as an input shaper board, the main steps of this guide will remain the same. However, certain hardware parameters in Step X may differ. Please refer to the manufacturer's firmware flashing guide to obtain the specific hardware parameters required for your device.

1. **SSH into THEOS**
Use the following credentials to establish an SSH connection:
   - **Hostname:** `pi@theos.local`
   - **Password:** `armbian` *(or `raspberry` if you're using an RPI based SoC)*

   On MacOS / Unix: 
   - `ssh pi@theos.local`

   On Windows:
   - use Putty to establish a ssh connection

2. **Start Klipper Firmware Configurator:**
   ```plaintext
   cd ~/klipper
   make menuconfig
3. **Configure Klipper Firmware Settings:**

    - [**\***] Tick: Enable extra low-level configuration options
    - Micro-controller Architecture: **STMicroelectronics STM32**
    - Processor model: **STM32H723**
    - Bootloader offset: **128KiB bootloader**
    - Clock Reference: **25 MHz crystal**
    - Communication interface: **USB (on PA11/PA12)**
    - In USB ids
       - Let vendor ID and device ID unchanged (should be 0x1d50 an 0x614e)
       - \[] Untick: USB serial number from CHIPID
       - Set USB serial number to: **btt-kraken**
    - GPIO pins to set at micro-controller startup: **PA0**

   Exit the Configurator by pressing **q** to quit and confirming with **y** to save and exit.

4. **Get the serial id of your board:**
   
    Ensure that your board is correctly connected by listing the serial devices.

        ls -la /dev/serial/by-id/*

   You should see an entry similar to: `/dev/serial/by-id/usb-Klipper_stm32h723xx_426456267152334-if00 -> ../../ttyACM0`. 
   
   If the expected device is not listed, there may be a connection problem between your SoC and the 3D Printer Board. Ensure all cables are connected also check the board manufacturer's troubleshooting documentation for further assistance.

6. **Flashing the Firmware**

    Flash the Klipper firmware onto your board using the `make flash` command with the serial ID of your board as the `FLASH_DEVICE` parameter.

        sudo service klipper stop
        sudo make flash FLASH_DEVICE="/dev/serial/by-id/usb-Klipper_stm32h723xx_426456267152334-if00"
        sudo service klipper start

    Ensure you replace `/dev/serial/by-id/usb-Klipper_stm32h723xx_426456267152334-if00` with your boards's unique serial ID obtained from Step 4.

    You will be prompted to enter your password to execute these commands with sudo privileges. The flashing process typically takes about **30 seconds**. If the process exits with a `255` error, do not worry. This is a known bug in the `dfu-util` tool that Klipper uses to flash STM32 devices and does not affect the flashing process. 

    After flashing, verify that the firmware was successfully flashed by checking for the device:

        ls -la /dev/btt*

    You should see a device `/dev/btt-kraken` as output. Once you have confirmed that your board was flashed sucessfully close your ssh connection and navigate back to your THEOS Web-Interface using your web browser. The previous red error message should now be gone. Your printer should now be ready to use!




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
