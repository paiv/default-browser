//
//  GoogleChrome.swift
//  DefaultBrowser
//
//  Created by Pavel Ivashkov on 2019-04-23.
//
import Foundation


class GoogleChromeEmitter : Emitter {
    let bundleId = "com.google.chrome"
    
    func emit(_ template: Browser) -> [Browser] {
        guard profiles.count > 1 else {
            return flavors
                .map { (title, args) in
                    var t = template
                    t.arguments = args
                    t.title = t.title.map { $0 + (title ?? "") }
                    return t
            }
        }
        
        return profiles
            .flatMap { profile in
                flavors
                    .map { (title, args) in
                        var t = template
                        t.arguments = ["--profile-directory=\(profile.path)"] + args
                        t.title = t.title.map { "\($0) \(profile.name)\(title ?? "")" }
                        return t
            }
        }
    }

    private let flavors = [
        (title: nil, args: []),
        (title: " (incognito)", args: ["--incognito"]),
    ]
    
    private let profiles = GoogleChromeEmitter.loadProfiles()
}


private extension GoogleChromeEmitter {
    
    class func loadProfiles() -> [(name: String, path: String)] {
        let fileManager = FileManager.default
        let dirs = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask)
        
        guard let url = dirs.first
            else { return [] }
        
        let dir = url.appendingPathComponent("Google/Chrome", isDirectory: true)
        let fileUrl = dir.appendingPathComponent("Local State", isDirectory: false)
        
        guard fileManager.fileExists(atPath: fileUrl.path)
            else { return [] }
        
        guard let data = try? Data(contentsOf: fileUrl),
            let state = try? JSONDecoder().decode(LocalState.self, from: data)
            else { return [] }
        
        return state.profile.info_cache
            .filter { $0.value.is_omitted_from_profile_list != true }
            .map { item in
                (name: item.value.name, path: item.key)
            }
    }
}


private struct LocalState : Decodable {
    let profile: ProfileCache
    
    struct ProfileCache: Decodable {
        let info_cache: [String: Profile]
    }
    
    struct Profile : Decodable {
        let name: String
        let user_name: String?
        let is_omitted_from_profile_list: Bool?
    }
}
