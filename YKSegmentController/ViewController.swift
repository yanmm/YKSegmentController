//
//  ViewController.swift
//  YKSegmentController
//
//  Created by Yuki on 16/8/19.
//  Copyright © 2016年 Yuki. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let vc = YKSegmentController()
        self.addChildViewController(vc)
        self.view.addSubview(vc.view)
        vc.view.snp_makeConstraints { (make) in
            make.left.right.bottom.equalTo(0)
            make.top.equalTo(64)
        }
        
//        vc.topConfig.btnMinWidth = 80
//        vc.topConfig.bottomLineWidth = 60
        
        let vc0 = UIViewController()
        vc0.view.backgroundColor = UIColor.blueColor()
        vc.addChildVC(vc0, title: "vc0")
        
        let vc1 = UIViewController()
        vc1.view.backgroundColor = UIColor.redColor()
        vc.addChildVC(vc1, title: "vc1")
        
        let vc2 = UIViewController()
        vc2.view.backgroundColor = UIColor.yellowColor()
        vc.addChildVC(vc2, title: "vc2")
        
        let vc3 = UIViewController()
        vc3.view.backgroundColor = UIColor.brownColor()
        vc.addChildVC(vc3, title: "vc3")
        
        let vc4 = UIViewController()
        vc4.view.backgroundColor = UIColor.darkGrayColor()
        vc.addChildVC(vc4, title: "vc4")
        
        let vc5 = UIViewController()
        vc5.view.backgroundColor = UIColor.whiteColor()
        vc.addChildVC(vc5, title: "vc5")
    }
}

