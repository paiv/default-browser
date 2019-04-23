//
//  Launcher.swift
//  DefaultBrowser
//
//  Created by Pavel Ivashkov on 2019-04-20.
//
import Cocoa


class Launcher {
    
    func openUrl(_ url: URL, inBrowser browser: Browser) {
        launch(browser, open: url)
    }
}


private extension Launcher {

    func launch(_ browser: Browser, open url: URL) {
        guard let bundle = Bundle(identifier: browser.bundleId),
            let executable = bundle.executableURL
            else { return }
        
        let task = Process()
        task.executableURL = executable
        task.arguments = browser.arguments + [url.absoluteString]
        
        do {
            try task.run()
        } catch {
            print(error)
        }
    }
}
