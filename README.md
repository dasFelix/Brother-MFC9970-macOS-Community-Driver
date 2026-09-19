# Brother MFC-9970CDW macOS Community Driver

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

### Recommended: download the prebuilt installer

Most users do **not** need to build the driver themselves.

Download the latest `.pkg` installer from the
**[GitHub Releases page](https://github.com/dasFelix/Brother-MFC9970-macOS-Community-Driver/releases)**.

For version 0.8, download:

`Brother-MFC9970-macOS-Community-Driver-0.8.pkg`

Then:

1. Make sure the Brother MFC-9970CDW is powered on.
2. Make sure the printer and Mac are connected to the same local network.
3. Open the downloaded `.pkg` file.
4. Follow the macOS Installer.
5. The installer automatically searches for the printer using Bonjour.
6. No printer IP address needs to be entered manually.
7. After installation, open **System Settings → Printers & Scanners** and verify that the printer appears.

## Build from source

Building from source is only necessary if you want to modify, inspect, or develop the driver yourself.

Clone the repository:

```bash
git clone https://github.com/dasFelix/Brother-MFC9970-macOS-Community-Driver.git
cd Brother-MFC9970-macOS-Community-Driver
```

Build the installer:

```bash
./build.sh
```

The build script creates the final macOS installer package:

```text
Brother-MFC9970-macOS-Community-Driver-0.8.pkg
```

The build process uses the macOS tools `pkgbuild` and `productbuild` and generates:

- the driver payload
- the component package
- the Installer Welcome / Read Me / License / Finished pages
- the final Distribution package

Generated build files and `.pkg` files are intentionally excluded from Git.

### Verify your own build

Create a SHA-256 checksum:

```bash
shasum -a 256 Brother-MFC9970-macOS-Community-Driver-0.8.pkg \
  | awk '{print $1 "  Brother-MFC9970-macOS-Community-Driver-0.8.pkg"}' \
  > Brother-MFC9970-macOS-Community-Driver-0.8.pkg.sha256
```

Technical details are documented in:

- [TECHNICAL.md](TECHNICAL.md)
- [HISTORY.md](HISTORY.md)
- [CHANGELOG.md](CHANGELOG.md)


### macOS security warning

The current public-beta package is not yet Developer ID signed or notarized.

Because of this, macOS may display a security warning when opening the installer.

If macOS blocks the package, open:

**System Settings → Privacy & Security**

and use the option provided by macOS to allow the installer.

### Verify the download

Each GitHub release also includes:

`Brother-MFC9970-macOS-Community-Driver-0.8.pkg.sha256`

To verify the installer:

```bash
shasum -a 256 -c Brother-MFC9970-macOS-Community-Driver-0.8.pkg.sha256
```

A successful verification reports:

```text
Brother-MFC9970-macOS-Community-Driver-0.8.pkg: OK
```

## macOS compatibility

| macOS version | Status |
|---|---|
| macOS 27.x | ✅ Tested |
| macOS 26.x | 🧪 Expected to work; community testing wanted |
| macOS 15.x and older | ❓ Not currently tested |
| Future macOS releases | ❓ Not guaranteed |

The current driver uses the traditional PPD-based CUPS printer-driver
architecture.

macOS 27.x is the currently tested platform.

macOS 26.x is expected to work with the same driver architecture, but
additional community testing is wanted before it is listed as fully tested.

Compatibility with future macOS releases cannot be guaranteed because the
traditional PPD-based printer-driver architecture is deprecated and may
eventually be removed from macOS/CUPS.

If you can test the driver on another macOS version, please report both
successful and unsuccessful results through GitHub Issues.

## Requirements

- macOS with the built-in CUPS printing system
- Brother MFC-9970CDW connected to the local network
- Bonjour / mDNS connectivity to the printer
- SNMP enabled on the printer for supply-level reporting

## Driver information

Driver name:

    Brother MFC-9970CDW macOS Community Driver

Project version:

    0.8

macOS may separately display a system driver version such as `10.4`.
That number belongs to Apple's generic PostScript printing infrastructure and is not the version of this project.

## Status

Version 0.8 is currently considered a public beta.

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
