//
//  Browsers.swift
//  DefaultBrowser
//
//  Created by Pavel Ivashkov on 2019-04-20.
//
import Cocoa


struct Browser {
    let bundleId: String
    let fileUrls: [URL]
    let title: String?
    let icon: NSImage?
}


struct Browsers {
    
    static func enumerate() -> [Browser] {
        guard let handlers = LSCopyAllHandlersForURLScheme("https" as CFString)
            else { return [] }
        
        let ids = (handlers.takeRetainedValue() as [AnyObject])
            .compactMap { $0 as? String }
        
        let myid = Bundle.main.bundleIdentifier!
        let exclude = [myid.lowercased()]
        
        let workspace = NSWorkspace.shared
        
        let browsers = ids
            .compactMap { bundleId -> Browser? in
                guard !exclude.contains(bundleId.lowercased()),
                    let apps = LSCopyApplicationURLsForBundleIdentifier(bundleId as CFString, nil)
                    else { return nil }
                let urls = (apps.takeRetainedValue() as [AnyObject])
                    .compactMap { $0 as? URL }
                guard let fileUrl = urls.first
                    else { return nil }
                let icon = workspace.icon(forFile: fileUrl.path)
                let bundle = Bundle(url: fileUrl)
                let title = bundle?.infoDictionary?["CFBundleName"] as? String
                
                return Browser(bundleId: bundleId, fileUrls: urls, title: title, icon: icon)
            }
            
        return browsers
            .map { (sortKey: ($0.title ?? $0.bundleId).lowercased(), value: $0) }
            .sorted { $0.sortKey < $1.sortKey }
            .map { $0.value }
    }
}
