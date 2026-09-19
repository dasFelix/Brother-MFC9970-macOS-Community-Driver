# Changelog

## 0.7 - Public Beta

First public-beta release.

### Added

- Automatic Brother MFC-9970CDW discovery using Bonjour
- Automatic printer queue creation
- Direct PostScript printing over TCP port 9100
- Color and grayscale modes
- 600 dpi mode
- Fine / 2400-dpi-class mode
- Long-edge duplex
- Short-edge duplex
- Direct SNMP supply reporting
- Toner level reporting for Cyan, Magenta, Yellow and Black
- Drum level reporting
- Belt level reporting
- Fuser level reporting
- Community-project driver metadata

### Removed dependencies

- Legacy Brother macOS x86 printer driver
- Rosetta from the printing path
- External Linux/CUPS print server
- Fixed printer IP address

### Known limitations

- Uses the legacy PPD-based macOS/CUPS driver interface, which Apple/CUPS considers deprecated.
- Automatic installation currently expects one discoverable MFC-9970CDW on the local network.
- The installer package is not yet Developer ID signed or notarized.
