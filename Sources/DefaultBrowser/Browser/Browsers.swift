//
//  Browsers.swift
//  DefaultBrowser
//
//  Created by Pavel Ivashkov on 2019-04-20.
//
import Cocoa


struct Browser {
    let bundleId: String
    let executableUrl: URL
    var arguments: [String]
    var title: String?
    var icon: NSImage?
}


extension Browser : Equatable {
    
    static func == (a: Browser, b: Browser) -> Bool {
        return a.bundleId.lowercased() == b.bundleId.lowercased()
            && a.executableUrl == b.executableUrl
            && a.arguments == b.arguments
    }
}


struct Browsers {
    
    private let emitters = Dictionary(uniqueKeysWithValues: ([
        BraveBrowserEmitter(),
        GoogleChromeEmitter(),
        MozillaFirefoxEmitter(),
        ] as [Emitter]).map { ($0.bundleId, $0) })
}


extension Browsers {
    
    static func enumerate() -> [Browser] {
        return Browsers().enumerate()
    }
}


private extension Browsers {
    
    func enumerate() -> [Browser] {
        guard let handlers = LSCopyAllHandlersForURLScheme("https" as CFString)
            else { return [] }
        
        let ids = (handlers.takeRetainedValue() as [AnyObject])
            .compactMap { $0 as? String }
        
        let myid = Bundle.main.bundleIdentifier!
        let exclude = [myid.lowercased()]
        
        let browsers = ids
            .filter { !exclude.contains($0.lowercased()) }
            .flatMap(browsersForBundle)
        
        return browsers
            .map { (sortKey: ($0.title ?? $0.bundleId).lowercased(), value: $0) }
            .sorted { $0.sortKey < $1.sortKey }
            .map { $0.value }
    }
    
    func browsersForBundle(_ bundleId: String) -> [Browser] {
        guard let apps = LSCopyApplicationURLsForBundleIdentifier(bundleId as CFString, nil)
            else { return [] }

        let urls = (apps.takeRetainedValue() as [AnyObject])
            .compactMap { $0 as? URL }

        guard let fileUrl = urls.first
            else { return [] }

        let workspace = NSWorkspace.shared

        let icon = workspace.icon(forFile: fileUrl.path)
        let bundle = Bundle(url: fileUrl)
        let title = bundle?.infoDictionary?["CFBundleName"] as? String
        
        return urls
            .flatMap { url -> [Browser] in
                let title = urls.count > 1 ? "\(title ?? "") – \(url.path)" : title
                let browser = Browser(bundleId: bundleId, executableUrl: url, arguments: [], title: title, icon: icon)
                return emit(browser)
        }
    }
    
    func emit(_ template: Browser) -> [Browser] {
        guard let emitter = emitters[template.bundleId.lowercased()]
            else { return [template] }
        
        return emitter.emit(template)
    }
}
