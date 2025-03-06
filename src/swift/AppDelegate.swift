import Cocoa

class AppDelegate: NSObject, NSApplicationDelegate {

    let logFileURL: URL
    
    override init() {
        // Define the log file path (in the user's home directory)
        let homeDirectory = FileManager.default.homeDirectoryForCurrentUser
        logFileURL = homeDirectory.appendingPathComponent("custom_browser.log")
        
        super.init()
    }

    func applicationDidFinishLaunching(_ notification: Notification) {
        // App launched successfully
        logMessage("App has finished launching")
    }

    // Handle incoming URLs
    func application(_ app: NSApplication, open urls: [URL]) {
        logMessage("Received URLs: \(urls)")

        for url in urls {
            logMessage("Processing URL: \(url.absoluteString)")
            // Get the URL string
            let urlString = url.absoluteString
            // Call the shell script with the URL as an argument
            runShellScript(with: urlString)
        }
        
        // After processing all URLs, terminate the app to stop the run loop
        logMessage("All URLs processed. Exiting the app.")
        NSApplication.shared.terminate(self)
    }

    // Run the shell script with URL as argument
    func runShellScript(with urlString: String) {
        logMessage("Running shell script with URL: \(urlString)")
        
        // Define the path to the shell script
        let scriptPath = Bundle.main.resourcePath! + "/CustomBrowser.sh"
        logMessage("Script path: \(scriptPath)")

        // Create the process to run the shell script
        let task = Process()
        task.executableURL = URL(fileURLWithPath: "/bin/bash")
        task.arguments = [scriptPath, urlString]
        
        do {
            logMessage("Attempting to run the shell script...")
            try task.run()
            task.waitUntilExit()
            logMessage("Shell script execution finished with exit code: \(task.terminationStatus)")
        } catch {
            logMessage("Error running shell script: \(error)")
        }
    }

    // Log function to write messages to the log file
    func logMessage(_ message: String) {
        let timestamp = DateFormatter.localizedString(from: Date(), dateStyle: .short, timeStyle: .medium)
        let logMessage = "[\(timestamp)] \(message)\n"
        
        do {
            if !FileManager.default.fileExists(atPath: logFileURL.path) {
                // Create the log file if it doesn't exist
                FileManager.default.createFile(atPath: logFileURL.path, contents: nil, attributes: nil)
            }
            
            // Open the log file and append the new log message
            let fileHandle = try FileHandle(forWritingTo: logFileURL)
            fileHandle.seekToEndOfFile()
            fileHandle.write(logMessage.data(using: .utf8)!)
            fileHandle.closeFile()
        } catch {
            print("Error writing to log file: \(error)")
        }
    }
}

