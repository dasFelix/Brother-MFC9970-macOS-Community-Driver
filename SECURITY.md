# Security Policy

## Reporting a vulnerability

If you discover a security issue in the Brother MFC-9970CDW macOS Community Driver,
please do not publish sensitive details in a public issue.

Please contact the maintainer through GitHub and include:

- affected driver version
- macOS version
- description of the issue
- steps to reproduce
- potential impact

This project is maintained on a best-effort community basis.

## Scope

This project contains:

- shell-based CUPS filters
- a modified PPD
- macOS package installer scripts
- Bonjour / DNS-SD discovery
- SNMP supply-level queries

The installer requires administrative privileges because it installs printer
components and creates a system printer queue.
