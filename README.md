# Brother MFC-9970CDW Community-Project Driver for macOS

An unofficial community driver for the Brother MFC-9970CDW on modern macOS systems.

The project is intended to keep the MFC-9970CDW usable without the legacy Brother x86 printer driver and without requiring Rosetta in the printing path.

## Current version

**0.8 Public Beta**

## Features

- Direct network printing to the Brother MFC-9970CDW
- Automatic printer discovery using Bonjour
- No fixed printer IP address required
- Color printing
- Grayscale printing
- 600 dpi mode
- Fine / 2400-dpi-class mode
- Automatic duplex printing
  - Long-edge binding
  - Short-edge binding
- Supply level reporting
  - Cyan toner
  - Magenta toner
  - Yellow toner
  - Black toner
  - Drum
  - Belt
  - Fuser
- Automatic printer queue creation during package installation
- No Brother legacy macOS printer driver required
- No Linux print server required

## How it works

Printing is handled by the built-in macOS printing system.

The driver adds a small PostScript filter that sends the printer-specific PJL commands required by the MFC-9970CDW and then passes the PostScript job directly to the printer.

The printer is discovered using Bonjour / DNS-SD.

Supply levels are queried directly from the printer using SNMP.

Typical data path:

    macOS application
          |
          v
    macOS printing system
          |
          v
    nativefilter
          |
          v
    Brother MFC-9970CDW

Supply reporting:

    macOS ReportLevels
          |
          v
    commandlevels-direct
          |
          v
        SNMP
          |
          v
    Brother MFC-9970CDW

## Installation

Download the installer package and open it with the macOS Installer.

The installer searches the local network for a Brother MFC-9970CDW and automatically creates the printer queue.

No printer IP address needs to be entered manually.

The printer must be powered on and reachable on the same local network during installation.

## Requirements

- macOS with the built-in CUPS printing system
- Brother MFC-9970CDW connected to the local network
- Bonjour / mDNS connectivity to the printer
- SNMP enabled on the printer for supply-level reporting

## Driver information

Driver name:

    Brother MFC-9970CDW Community-Project Driver

Project version:

    0.7

macOS may separately display a system driver version such as `10.4`.
That number belongs to Apple's generic PostScript printing infrastructure and is not the version of this project.

## Status

Version 0.7 is currently considered a public beta.

It has been tested with:

- direct PostScript printing
- color and grayscale output
- 600 dpi and Fine modes
- long-edge and short-edge duplex
- Bonjour printer discovery
- automatic installation
- toner and maintenance supply reporting

## Disclaimer

This is an unofficial community project.

It is not produced, endorsed, supported, or affiliated with Brother Industries, Ltd.

Brother and MFC are trademarks of their respective owners.
