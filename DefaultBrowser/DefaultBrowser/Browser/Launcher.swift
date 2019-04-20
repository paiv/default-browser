//
//  Launcher.swift
//  DefaultBrowser
//
//  Created by Pavel Ivashkov on 2019-04-20.
//
import Cocoa


class Launcher {
    
    func openUrl(_ url: URL, inBrowser browser: Browser) {
        launch1(url, inBrowser: browser)
    }
}


private extension Launcher {

    func launch1(_ url: URL, inBrowser browser: Browser) {
        let workspace = NSWorkspace.shared
        
        workspace.open([url], withAppBundleIdentifier: browser.bundleId, options: .default, additionalEventParamDescriptor: nil, launchIdentifiers: nil)
    }
    
    func launch2(_ url: URL, inBrowser browser: Browser) {
        let workspace = NSWorkspace.shared
        
        do {
            try workspace.open([url], withApplicationAt: browser.fileUrls.first!, options: .default, configuration: [.arguments : ["--incognito"]])
        }
        catch {
            print(error)
        }
    }

    func launch3(_ url: URL, inBrowser browser: Browser) {
        let task = Process()
        task.executableURL = URL(fileURLWithPath: "/usr/bin/open")
        task.arguments = ["-b", browser.bundleId, url.absoluteString, "--args", "--incognito"]

        do {
            try task.run()
        } catch {
            print(error)
        }
    }
}
