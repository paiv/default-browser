//
//  BrowserViewController.swift
//  DefaultBrowser
//
//  Created by Pavel Ivashkov on 2019-04-20.
//
import Cocoa


class BrowserViewController: NSViewController {

    @IBOutlet weak var linkTextField: NSTextField!
    @IBOutlet weak var appsButton: NSPopUpButton!
    @IBOutlet weak var openButton: NSButton!
    
    @IBAction func handleOpenButton(_ sender: Any) {
        viewModel.open()
    }
    
    @IBAction func handleCancelButton(_ sender: Any) {
        viewModel.url = nil
    }
    
    @IBAction func handleAppsButton(_ sender: Any) {
        let browser = appsButton.selectedItem?.representedObject as? Browser
        viewModel.selectedBrowser = browser
    }
    
    var viewModel: BrowserViewModel! {
        didSet {
            viewModel?.delegate = self
        }
    }
    
    override var representedObject: Any? {
        didSet {
            viewModel.url = representedObject as? URL
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = BrowserViewModel()
        
        reloadBrowsers()
        reloadModel()
    }
}


extension BrowserViewController : BrowserViewModelDelegate {
    
    func viewModel(_ viewModel: BrowserViewModel, didChangeUrl url: URL?) {
        reloadModel()
    }
}


private extension BrowserViewController {

    func reloadModel() {
        linkTextField.stringValue = viewModel.url?.absoluteString ?? ""
    }
    
    func reloadBrowsers() {
        appsButton.removeAllItems()
        
        let browsers = viewModel.browsers
        let selected = viewModel.selectedBrowser

        let items = browsers.map { browser -> NSMenuItem in
            let item = NSMenuItem()
            item.representedObject = browser
            item.title = browser.title ?? browser.bundleId
            item.image = browser.icon
            return item
        }
        
        for (browser, item) in zip(browsers, items) {
            appsButton.menu?.addItem(item)
            
            if browser.bundleId.lowercased() == selected?.bundleId.lowercased() {
                appsButton.select(item)
            }
        }
    }
}
