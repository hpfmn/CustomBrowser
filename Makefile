all:
	mkdir -p ./CustomBrowser.app/Contents/MacOS
	mkdir -p ./CustomBrowser.app/Contents/Resources
	swiftc -o ./CustomBrowser.app/Contents/MacOS/CustomBrowser ./src/swift/main.swift ./src/swift/AppDelegate.swift
	cp ./src/shell/CustomBrowser.sh ./CustomBrowser.app/Contents/Resources/CustomBrowser.sh
