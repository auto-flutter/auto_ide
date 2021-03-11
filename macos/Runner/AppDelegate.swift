import Cocoa
import FlutterMacOS

@NSApplicationMain
class AppDelegate: FlutterAppDelegate {
  override func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
    return true
  }
    
   override func applicationDidFinishLaunching(_ aNotification: Notification) {
        self.mainFlutterWindow.titlebarAppearsTransparent = true
        self.mainFlutterWindow.backgroundColor = NSColor.init(deviceRed: 51/255, green: 51/255, blue: 51/255, alpha: 1.0)
    }
}
