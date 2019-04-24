//
//  Emitter.swift
//  DefaultBrowser
//
//  Created by Pavel Ivashkov on 2019-04-23.
//

protocol Emitter : class {
    var bundleId: String { get }
    func emit(_ template: Browser) -> [Browser]
}
