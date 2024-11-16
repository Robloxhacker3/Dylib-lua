import Foundation

// Function to sign the .dylib file with your developer certificate
func signDylib(dylibPath: String, certificateIdentifier: String) {
    // Create a new Process instance to run the `codesign` command
    let process = Process()
    let pipe = Pipe()

    // Set the executable URL to `codesign`
    process.executableURL = URL(fileURLWithPath: "/usr/bin/codesign")
    
    // Provide the arguments for the `codesign` command
    process.arguments = ["--sign", certificateIdentifier, dylibPath]
    
    // Set the standard output and error to the pipe for capturing
    process.standardOutput = pipe
    process.standardError = pipe

    do {
        // Run the process (the codesign command)
        try process.run()
        
        // Wait for the process to complete
        process.waitUntilExit()
        
        // Check if the command was successful (exit code 0)
        if process.terminationStatus == 0 {
            print("Successfully signed the .dylib file.")
        } else {
            print("Failed to sign the .dylib file. Please check the error output.")
        }
    } catch {
        print("Error running codesign: \(error.localizedDescription)")
    }
}

// Main entry point
func main() {
    // Specify the path to the .dylib file you want to sign
    let dylibPath = "/path/to/your/file.dylib"  // Update this path with your .dylib file's location
    
    // Specify your Developer ID Application certificate identifier
    // You can find this in your Keychain under Certificates or use Xcode to find the identifier
    let certificateIdentifier = "Developer ID Application: YourName (XXXXXXXXXX)"  // Replace with your certificate identifier

    // Call the signDylib function
    signDylib(dylibPath: dylibPath, certificateIdentifier: certificateIdentifier)
}

// Execute the main function
main()
