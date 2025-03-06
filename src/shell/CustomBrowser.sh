#!/bin/bash

echo "URL received: $@" >> ~/url_log.txt
/Applications/qutebrowser.app/Contents/MacOS/qutebrowser "$1"
#open -a "Safari" "$1"  # Or replace with custom logic
