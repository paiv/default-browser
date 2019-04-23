//
//  Launcher.swift
//  DefaultBrowser
//
//  Created by Pavel Ivashkov on 2019-04-20.
//
import Cocoa


class Launcher {
    
    func openUrl(_ url: URL, inBrowser browser: Browser) {
        if browser.arguments.count > 0 {
            processRunApplication(browser.executableUrl, arguments: browser.arguments, open: url)
        }
        else {
            workspaceOpen(url, withApplicationAt: browser.executableUrl)
        }
    }
}


private extension Launcher {
    
    func workspaceOpen(_ url: URL, withApplicationAt executableUrl: URL) {
        let workspace = NSWorkspace.shared
        do {
            try workspace.open([url], withApplicationAt: executableUrl, configuration: [:])
        }
        catch {
            print(error)
        }
    }

    func processRunApplication(_ application: URL, arguments: [String], open url: URL) {
        guard let bundle = Bundle(url: application),
            let executableUrl = bundle.executableURL
            else { return }
        
        let task = Process()
        task.executableURL = executableUrl
        task.arguments = arguments + [url.absoluteString]
        
        do {
            try task.run()
        } catch {
            print(error)
        }
    }
}
