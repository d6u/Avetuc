//
//  WebViewController.swift
//  Avetuc
//
//  Created by Daiwei Lu on 7/27/15.
//  Copyright (c) 2015 Daiwei Lu. All rights reserved.
//

import Foundation
import UIKit
import TUSafariActivity

class WebViewController: UIViewController {

    let browser = UIWebView()
    let url: NSURL

    init(url: String) {
        self.url = NSURL(string: url)!

        super.init(nibName: nil, bundle: nil)

        self.browser.frame = self.view.bounds
        self.browser.scrollView.contentInset = UIEdgeInsets(top: 64, left: 0, bottom: 0, right: 0)
        self.browser.loadRequest(NSURLRequest(URL: self.url))

        self.navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Close",
            style: .Plain,
            target: self,
            action: Selector("userDidTapClose"))

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .Action,
            target: self,
            action: Selector("userDidTapAction"))

        let navigationBar: UINavigationBar = {
            let bar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 64))
            bar.items = [self.navigationItem]
            return bar
        }()

        self.view.addSubview(self.browser)
        self.view.addSubview(navigationBar)
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }

    func userDidTapClose() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    func userDidTapAction() {
        let activity = TUSafariActivity()
        let activityViewController = UIActivityViewController(activityItems: [url], applicationActivities: [activity])
        self.presentViewController(activityViewController, animated: true, completion: nil)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
