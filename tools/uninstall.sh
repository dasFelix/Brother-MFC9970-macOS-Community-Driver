#!/bin/bash

set -e

QUEUE="Brother_MFC_9970CDW_Community"
BASE="/Library/Printers/CommunityProject/BrotherMFC9970"

if [ "$(id -u)" -ne 0 ]; then
    exec sudo "$0" "$@"
fi

echo "Brother MFC-9970CDW Community-Project Driver"
echo "Uninstaller"
echo

echo "Removing Community-Project printer queue..."
/usr/sbin/lpadmin -x "$QUEUE" 2>/dev/null || true

echo "Removing Community-Project driver files..."
/bin/rm -rf "$BASE"

echo
echo "Uninstallation completed."
echo
echo "Other Brother printers and printer queues were not modified."

exit 0
