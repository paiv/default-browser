//
//  MozillaFirefox.swift
//  DefaultBrowser
//
//  Created by Pavel Ivashkov on 2019-04-23.
//

class MozillaFirefoxEmitter : Emitter {
    let bundleId = "org.mozilla.firefox"
    
    func emit(_ template: Browser) -> [Browser] {
        return flavors
            .map { (title, args) in
                var t = template
                t.arguments = args
                t.title = t.title.map { $0 + (title ?? "") }
                return t
        }
    }
    
    private let flavors = [
        (title: nil, args: []),
        (title: " (private)", args: ["-private-window"]),
    ]
}
