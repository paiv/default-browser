//
//  BrowserViewModel.swift
//  DefaultBrowser
//
//  Created by Pavel Ivashkov on 2019-04-20.
//
import Foundation


class BrowserViewModel {

    init() {
        selectedBrowser = browsers.first
    }
    
    weak var delegate: BrowserViewModelDelegate?
    
    let browsers: [Browser] = Browsers.enumerate()
    let launcher = Launcher()

    var selectedBrowser: Browser?
    
    private var _url: URL?
    var url: URL? {
        get {
            return _url
        }
        set {
            _url = newValue
            notifyDidChangeUrl(_url)
        }
    }
    
    var urlTextInput: String? {
        get {
            return _url?.absoluteString
        }
        set {
            _url = newValue.flatMap { URL(string: $0) }
        }
    }
}


protocol BrowserViewModelDelegate : AnyObject {

    func viewModel(_ viewModel: BrowserViewModel, didChangeUrl url: URL?)
}


extension BrowserViewModel {
    
    func open() {
        guard let url = url,
            let browser = selectedBrowser
            else { return }
        
        launcher.openUrl(url, inBrowser: browser)
    }
}

private extension BrowserViewModel {
    
    func notifyDidChangeUrl(_ url: URL?) {
        delegate?.viewModel(self, didChangeUrl: url)
    }
}
