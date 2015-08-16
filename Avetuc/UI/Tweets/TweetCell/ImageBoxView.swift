//
//  ImageBoxView.swift
//  Avetuc
//
//  Created by Daiwei Lu on 7/19/15.
//  Copyright (c) 2015 Daiwei Lu. All rights reserved.
//

import Foundation
import UIKit

//class ImageBoxView: UIView {
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//
//        self.layer.cornerRadius = IMAGE_BOX_CORNER_RADIUS
//        self.layer.masksToBounds = true
//    }
//
//    var imageViews = [UIImageView]()
//    weak var imageBoxDelegate: ImageBoxViewDelegate!
//
//    func loadImageUrls(urls: [String]) {
//        self.layoutImageViews(count: urls.count)
//
//        for (i, url) in enumerate(urls) {
//            self.imageViews[i].kf_setImageWithURL(NSURL(string: url)!,
//                placeholderImage: nil)
//        }
//    }
//
//    func layoutImageViews(#count: Int) {
//        self.resetCurrentImageViews()
//
//        for var i = 0; i < count; i++ {
//            let view = createImageView()
//            self.imageViews.append(view)
//            self.addSubview(view)
//        }
//
//        let m = Constants.Dimensions.ImageBoxImageMargin
//
//        switch count {
//        case 1:
//            self.imageViews[0].frame = self.bounds
//        case 2:
//            let width = self.bounds.width / 2 - m
//            self.imageViews[0].frame = CGRect(x: 0,             y: 0, width: width, height: self.bounds.height)
//            self.imageViews[1].frame = CGRect(x: width + m * 2, y: 0, width: width, height: self.bounds.height)
//        case 3:
//            let width = self.bounds.width / 2 - 1
//            let height = self.bounds.height / 2 - 1
//            self.imageViews[0].frame = CGRect(x: 0,             y: 0,              width: width, height: self.bounds.height)
//            self.imageViews[1].frame = CGRect(x: width + m * 2, y: 0,              width: width, height: height)
//            self.imageViews[2].frame = CGRect(x: width + m * 2, y: height + m * 2, width: width, height: height)
//        case 4:
//            let width = self.bounds.width / 2 - 1
//            let height = self.bounds.height / 2 - 1
//            self.imageViews[0].frame = CGRect(x: 0,             y: 0,              width: width, height: height)
//            self.imageViews[1].frame = CGRect(x: width + m * 2, y: 0,              width: width, height: height)
//            self.imageViews[2].frame = CGRect(x: 0,             y: height + m * 2, width: width, height: height)
//            self.imageViews[3].frame = CGRect(x: width + m * 2, y: height + m * 2, width: width, height: height)
//        default:
//            break
//        }
//    }
//
//    func resetCurrentImageViews() {
//        for view in self.imageViews {
//            view.removeFromSuperview()
//        }
//        self.imageViews = []
//    }
//
//    func createImageView() -> UIImageView {
//        let view = UIImageView()
//        view.contentMode = .ScaleAspectFill
//        view.layer.masksToBounds = true
//
//        let recognizer = UITapGestureRecognizer(target: self, action: Selector("imageTapped:"))
//        view.addGestureRecognizer(recognizer)
//        view.userInteractionEnabled = true
//
//        return view
//    }
//
//    func imageTapped(tap: UITapGestureRecognizer) {
//
//        let imageView = tap.view as! UIImageView
//        let index = find(self.imageViews, imageView)!
//
//        self.imageBoxDelegate.imageBoxViewTapped(index, imageViews: imageViews, containerView: self)
//    }
//
//    override func intrinsicContentSize() -> CGSize {
//        return self.frame.size
//    }
//
//    // MARK: - No use
//
//    required init(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//}
