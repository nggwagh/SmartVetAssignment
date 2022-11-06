//
//  PetDetailsViewController.swift
//  SmartVetAssignment
//
//  Created by NWagh on 06/11/22.
//

import UIKit
import WebKit

class PetDetailsViewController: UIViewController {
    
    //MARK: - Properties
    var pet: Pet?
    let webView = WKWebView()
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        webView.frame = view.bounds
    }
    
    //MARK: - custom methods
    func setupUI() {
        self.title = pet?.title
        view.addSubview(webView)
        guard let url = URL(string: pet!.contentURL) else { return }
        webView.load(URLRequest(url: url))
    }
    
    deinit {
        webView.stopLoading()
        webView.configuration.userContentController.removeScriptMessageHandler(forName: "...")
        webView.navigationDelegate = nil
        webView.scrollView.delegate = nil
    }
}
