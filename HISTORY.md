# Project History

## Why this project exists

The Brother MFC-9970CDW is still a capable color laser multifunction printer,
but its original macOS printer driver is based on legacy software that is no
longer a good fit for current macOS systems.

The goal of this project was to keep the printer usable on modern macOS
without relying on the old Brother x86 printer driver or Rosetta in the
printing path.

## First approach: Linux print server

The project originally started with a small Linux CUPS print server.

Brother's legacy Linux driver was installed on the print server and used to
render jobs for the MFC-9970CDW. macOS printed to that server using a custom
PostScript PPD.

This approach worked well and helped establish the expected behavior for:

- color and grayscale printing
- 600 dpi output
- Brother "Fine" quality mode
- long-edge duplex
- short-edge duplex

Several compatibility issues in the legacy Brother Linux wrapper were also
identified and worked around.

## Supply-level investigation

The original Brother macOS driver was able to display toner levels in macOS,
while a generic PostScript queue could not.

The printer's SNMP data was therefore investigated.

Standard Printer-MIB data exposed some maintenance information, but Brother's
private SNMP data contained the useful percentage values.

The private data was decoded and compared against the printer's own web
interface.

The following values could be identified:

- Black toner
- Cyan toner
- Magenta toner
- Yellow toner
- Drum
- Belt
- Fuser
- Laser
- Paper-feed maintenance counters

The Community-Project Driver currently exposes toner, drum, belt and fuser
levels to macOS.

## Investigating the legacy macOS driver

The legacy Brother macOS driver was examined to understand how macOS requested
supply information.

The old driver used the CUPS `ReportLevels` command mechanism rather than the
generic CUPS SNMP supply implementation.

This project implements its own small `ReportLevels` command filter.

It queries the printer directly via SNMP and returns CUPS marker attributes to
macOS.

No Brother proprietary command-filter binary is required.

## Investigating the printer data stream

The Brother Linux driver was then used as a reference to compare generated
printer jobs.

The generated jobs showed that the printer accepts PJL commands followed by a
printer-language data stream.

Important settings included:

    @PJL SET RENDERMODE=COLOR

or:

    @PJL SET RENDERMODE=GRAYSCALE

and for normal quality:

    @PJL SET RESOLUTION=600
    @PJL SET APTMODE=OFF

while Brother's Fine mode used:

    @PJL SET RESOLUTION=600
    @PJL SET APTMODE=ON4

Further testing showed that the MFC-9970CDW can accept standard PostScript
directly over TCP port 9100.

That discovery made the legacy Brother raster/rendering driver unnecessary
for normal printing.

Duplex printing can be controlled using standard PostScript `setpagedevice`
commands.

## Native macOS implementation

Based on those findings, the Linux print server was removed from the printing
path.

The current driver consists of a small number of components:

- a custom PPD
- a small PostScript/PJL print filter
- a `ReportLevels` command filter
- an installer script
- Bonjour printer discovery

Printing goes directly from macOS to the printer over TCP port 9100.

Supply information is queried directly from the printer using SNMP.

## Automatic discovery

Early development versions used a fixed printer IP address.

Version 0.7 introduced automatic discovery using Bonjour / DNS-SD.

The installer searches for a Brother MFC-9970CDW advertised using:

    _pdl-datastream._tcp

The printer's Bonjour hostname is then used for both printing and supply-level
queries.

This means the driver does not require the printer to have a fixed IP address.

## Reverse engineering

This project was created through behavioral reverse engineering and protocol
observation.

The legacy Brother Linux and macOS drivers were used as references to
understand expected printer behavior and protocol settings.

Generated printer streams, PPD metadata, CUPS command behavior, PJL settings,
PostScript behavior and SNMP responses were examined.

The resulting Community-Project Driver is an independent implementation.

No Brother proprietary driver binaries are included or redistributed.

## Current architecture

Printing:

    macOS application
          |
          v
    macOS CUPS / PostScript
          |
          v
    Community nativefilter
          |
          v
    PJL + PostScript
          |
          v
    TCP port 9100
          |
          v
    Brother MFC-9970CDW

Supply levels:

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

## Project status

The project is experimental community software and is not affiliated with,
endorsed by or supported by Brother Industries, Ltd.

The driver currently depends on the legacy PPD-based macOS/CUPS printer-driver
interface. That interface is deprecated and may disappear from future macOS
or CUPS versions.
