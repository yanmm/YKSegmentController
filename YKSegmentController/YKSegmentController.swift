//
//  YKSegmentController.swift
//  YKSegmentController
//
//  Created by Yuki on 16/8/19.
//  Copyright © 2016年 Yuki. All rights reserved.
//

import UIKit

class YKTopViewConfig {
    /// 标题栏高度
    lazy var height:CGFloat = 44.0
    /// 标题栏按钮最小宽度（不设置的话按钮宽度为屏幕等分，总宽度不超过屏幕也会等分）
    lazy var btnMinWidth: CGFloat = 0
    /// 标题栏背景色
    lazy var BGColor = UIColor.whiteColor()
    /// 标题栏按钮选中背景颜色
    lazy var selectedBtnColor = UIColor.clearColor()
    /// 标题栏按钮默认背景颜色
    lazy var normalBtnColor = UIColor.clearColor()
    /// 标题栏按钮选中Title颜色
    lazy var selectedBtnTitleColor = UIColor.redColor()
    /// 标题栏按钮默认Title颜色
    lazy var normalBtnTitleColor = UIColor.blackColor()
    /// 标题栏按钮选中Title大小
    lazy var selectedBtnTitleFont: CGFloat = 20.0
    /// 标题栏按钮默认Title大小
    lazy var normalBtnTitleFont: CGFloat = 17.0
    /// 标题栏下划线显示
    lazy var bottomLineHidden = false
    /// 标题栏下划线颜色
    lazy var bottomLineColor = UIColor.redColor()
    /// 标题栏下划线高度
    lazy var bottomLineHeight: CGFloat = 2.0
    /// 标题栏下划线宽度(默认和按钮宽度一致，可设置比按钮宽度小的值)
    lazy var bottomLineWidth: CGFloat? = nil
    /// 标题栏分割线颜色
    lazy var divideLineColor = UIColor(white: 0.5, alpha: 0.5)
    
    init(height: CGFloat? = nil,
         btnMinWidth: CGFloat? = nil,
         BGColor: UIColor? = nil,
         selectedBtnColor: UIColor? = nil,
         normalBtnColor: UIColor? = nil,
         selectedBtnTitleColor: UIColor? = nil,
         normalBtnTitleColor: UIColor? = nil,
         selectedBtnTitleFont: CGFloat? = nil,
         normalBtnTitleFont: CGFloat? = nil,
         bottomLineHidden: Bool? = nil,
         bottomLineColor: UIColor? = nil,
         bottomLineHeight: CGFloat? = nil,
         divideLineColor: UIColor? = nil,
         bottomLineWidth: CGFloat? = nil) {
        if let height = height {
            self.height = height
        }
        if let btnMinWidth = btnMinWidth {
            self.btnMinWidth = btnMinWidth
        }
        if let BGColor = BGColor {
            self.BGColor = BGColor
        }
        if let selectedBtnColor = selectedBtnColor {
            self.selectedBtnColor = selectedBtnColor
        }
        if let normalBtnColor = normalBtnColor {
            self.normalBtnColor = normalBtnColor
        }
        if let selectedBtnTitleColor = selectedBtnTitleColor {
            self.selectedBtnTitleColor = selectedBtnTitleColor
        }
        if let normalBtnTitleColor = normalBtnTitleColor {
            self.normalBtnTitleColor = normalBtnTitleColor
        }
        if let selectedBtnTitleFont = selectedBtnTitleFont {
            self.selectedBtnTitleFont = selectedBtnTitleFont
        }
        if let normalBtnTitleFont = normalBtnTitleFont {
            self.normalBtnTitleFont = normalBtnTitleFont
        }
        if let bottomLineHidden = bottomLineHidden {
            self.bottomLineHidden = bottomLineHidden
        }
        if let bottomLineColor = bottomLineColor {
            self.bottomLineColor = bottomLineColor
        }
        if let bottomLineHeight = bottomLineHeight {
            self.bottomLineHeight = bottomLineHeight
        }
        if let divideLineColor = divideLineColor {
            self.divideLineColor = divideLineColor
        }
        if let bottomLineWidth = bottomLineWidth {
            self.bottomLineWidth = bottomLineWidth
        }
    }
}

class YKSegmentController: UIViewController,UIScrollViewDelegate {
    /**** -----------  私有属性  -------------- *****/
    /// 标题栏视图
    private let topView = UIScrollView()
    /// 标题栏底部分割线
    private let topViewDivideLine = UIView()
    /// 标题栏底部下划线
    private let topViewBottomLine = UIView()
    /// 内容视图
    private let showView = UIScrollView()
    /// 标题栏按钮title
    private var btnTitles: [String] = []
    /// 标题栏按钮
    private var btns: [UIButton] = []
    /// 手机屏幕宽
    private let kScreenWidth  = UIScreen.mainScreen().bounds.width
    /// 动画时间
    private var animationTime = 0.3
    /// 标题栏按钮长度
    private var topViewBtnWidth: CGFloat = 0
    /// 是否第一次加载视图
    private var isFirstLoad = true
    
    /***** -----------  公开属性  -------------- ****/
    /// 标题栏配置
    var topConfig = YKTopViewConfig()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // 第一次加载视图
        if isFirstLoad {
            // 计算按钮宽度
            topViewBtnWidth = kScreenWidth / CGFloat(self.childViewControllers.count)
            if topViewBtnWidth < topConfig.btnMinWidth {
                topViewBtnWidth = topConfig.btnMinWidth
                self.topView.contentSize = CGSizeMake(topConfig.btnMinWidth * CGFloat(self.childViewControllers.count), topConfig.height)
            } else {
                self.topView.contentSize = CGSizeMake(kScreenWidth, topConfig.height)
            }
            // 添加按钮
            for (i,btnTitle) in self.btnTitles.enumerate() {
                let btn = UIButton()
                self.btns.append(btn)
                btn.setTitle(btnTitle, forState: UIControlState.Normal)
                btn.setTitleColor(UIColor.redColor(), forState: UIControlState.Normal)
                btn.tag = i
                self.topView.addSubview(btn)
                btn.addTarget(self, action: #selector(topViewBtnClick), forControlEvents: UIControlEvents.TouchUpInside)
                btn.snp_makeConstraints(closure: { (make) in
                    make.left.equalTo(CGFloat(i) * topViewBtnWidth)
                    make.width.equalTo(topViewBtnWidth)
                    make.height.equalTo(topConfig.height - 0.5)
                    make.top.equalTo(0)
                })
            }
            // 添加分割线
            self.topView.addSubview(topViewDivideLine)
            topViewDivideLine.backgroundColor = self.topConfig.divideLineColor
            topViewDivideLine.snp_makeConstraints(closure: { (make) in
                make.top.equalTo(topConfig.height - 0.5)
                make.height.equalTo(0.5)
                make.width.equalTo(topViewBtnWidth * CGFloat(self.btnTitles.count))
            })
            // 添加下划线
            self.topView.addSubview(topViewBottomLine)
            var newWith: CGFloat = 0
            if let bottomLineWidth = self.topConfig.bottomLineWidth {
                newWith = bottomLineWidth
            } else {
                newWith = topViewBtnWidth
            }
            topViewBottomLine.backgroundColor = self.topConfig.bottomLineColor
            topViewBottomLine.snp_makeConstraints(closure: { (make) in
                make.top.equalTo(topConfig.height - topConfig.bottomLineHeight)
                make.height.equalTo(topConfig.bottomLineHeight)
                make.left.equalTo(abs(newWith - topViewBtnWidth) / 2.0)
                make.width.equalTo(newWith)
            })
            topViewBottomLine.hidden = self.topConfig.bottomLineHidden
            
            topViewBtnChange(0)
            isFirstLoad = false
        }
    }
    
    /// 初始化视图
    private func setupView() {
        self.view.addSubview(topView)
        topView.delegate = self
        topView.bounces = false
        topView.showsVerticalScrollIndicator = false
        topView.showsHorizontalScrollIndicator = false
        topView.snp_makeConstraints { (make) in
            make.top.left.right.equalTo(0)
            make.height.equalTo(topConfig.height)
        }
        
        self.view.addSubview(showView)
        showView.delegate = self
        showView.showsVerticalScrollIndicator = false
        showView.showsHorizontalScrollIndicator = false
        showView.pagingEnabled = true
        showView.bounces = false
        showView.snp_makeConstraints { (make) in
            make.top.equalTo(self.topView.snp_bottom)
            make.left.right.bottom.equalTo(0)
        }
    }
    
    /// 添加控制器
    func addChildVC(vc: UIViewController, title: String) {
        self.btnTitles.append(title)
        self.addChildViewController(vc)
        self.showView.addSubview(vc.view)
        let left = CGFloat(self.childViewControllers.count - 1) * self.view.frame.width
        self.showView.contentSize = CGSizeMake(left + self.view.frame.width, self.showView.frame.height)
        vc.view.snp_makeConstraints { (make) in
            make.size.equalTo(self.showView.snp_size)
            make.centerY.equalTo(self.showView)
            make.left.equalTo(left)
        }
    }
    
    /// 标题栏按钮点击
    func topViewBtnClick(btn: UIButton) {
        UIView.animateWithDuration(animationTime, animations: {
            self.showView.contentOffset = CGPointMake(CGFloat(btn.tag) * self.kScreenWidth, 0)
        })
        self.topViewBtnChange(btn.tag)
    }
    
    /// 标题栏按钮变化
    func topViewBtnChange(tag: Int) {
        UIView.animateWithDuration(animationTime, animations: {
            var setX = CGFloat(tag) * self.topViewBtnWidth
            if setX < (self.kScreenWidth - self.topViewBtnWidth) / 2 {
                setX = 0
            } else {
                setX = setX - (self.kScreenWidth - self.topViewBtnWidth) / 2
            }
            if setX > self.topView.contentSize.width - self.kScreenWidth {
                setX = self.topView.contentSize.width - self.kScreenWidth
            }
            self.topView.contentOffset = CGPointMake(setX, self.topView.contentOffset.y)
            self.topViewBottomLine.transform = CGAffineTransformMakeTranslation(CGFloat(tag) * self.topViewBtnWidth, 0)
            
            for (btn) in self.btns {
                if btn.tag == tag {
                    btn.backgroundColor = self.topConfig.selectedBtnColor
                    btn.setTitleColor(self.topConfig.selectedBtnTitleColor, forState: UIControlState.Normal)
                    btn.titleLabel?.font = UIFont.systemFontOfSize(self.topConfig.selectedBtnTitleFont)
                } else {
                    btn.backgroundColor = self.topConfig.normalBtnColor
                    btn.setTitleColor(self.topConfig.normalBtnTitleColor, forState: UIControlState.Normal)
                    btn.titleLabel?.font = UIFont.systemFontOfSize(self.topConfig.normalBtnTitleFont)
                }
            }
        })
    }
    
    // UIScrollViewDelegate
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollView == self.topView {
            scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x, 0)
        }
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        if scrollView == self.showView {
            let x = scrollView.contentOffset.x
            let width = scrollView.frame.size.width
            if x >= 0.0 || x <= width {
                if width == 0 {
                    return
                }
                let i = x / width
                topViewBtnChange(Int(i))
            }
        }
    }
}
