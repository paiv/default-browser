//
//  AppDelegate.swift
//  DefaultBrowser
//
//  Created by Pavel Ivashkov on 2019-04-20.
//
import Cocoa


@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    func applicationWillFinishLaunching(_ notification: Notification) {
        let manager = NSAppleEventManager.shared()
        manager.setEventHandler(self, andSelector: #selector(handleAppleEvent), forEventClass: AEEventClass(kInternetEventClass), andEventID: AEEventID(kAEGetURL))
    }
    
    func application(_ sender: NSApplication, openFiles filenames: [String]) {
        guard let path = filenames.first
            else { return }
        let url = URL(fileURLWithPath: path)
        viewController?.representedObject = url
    }
}


private extension AppDelegate {

    @objc func handleAppleEvent(_ event: NSAppleEventDescriptor, withReplyEvent replyEvent: NSAppleEventDescriptor?) {
        guard let param = event.paramDescriptor(forKeyword: keyDirectObject),
            let value = param.stringValue,
            let url = URL(string: value)
            else { return }
        viewController?.representedObject = url
    }

    var viewController: NSViewController? {
        let application = NSApplication.shared
        let window = application.windows.first
        return window?.contentViewController
    }
}
