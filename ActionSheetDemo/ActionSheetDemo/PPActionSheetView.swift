//
//  PPActionSheetView.swift
//  ActionSheetDemo
//
//  Created by swartz01 on 2020/7/28.
//  Copyright © 2020 Mark_J. All rights reserved.
//

import UIKit

class PPActionSheetView: UIView {

    enum PPActionSheetStyle {
        case normal
        case cancel
        case selected
        case warming
    }
    
    let btnHeight: Double = 52.5
    let separatorHeight = 10.0
    let titleHeight = 30.0
    let titleFontSize = 12.0
    let btnTitleFontSize = 17.0
    
    typealias handleBlock = (_ button: UIButton, _ actionSheet: PPActionSheetView) ->()
    
    var btnArr: [UIButton] = []
    var blockDict = [Int: handleBlock]()
    var blockArr: [[Int: handleBlock]] = []
    var actionSheetHeight: Double = 0.0
    var cancelBtn: UIButton!
    var containView = UIView()
    var maskV = UIView()
    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH-20, height: CGFloat(self.titleHeight)))
        titleLabel.backgroundColor = .white
        titleLabel.text = ""
        titleLabel.textColor = .grayHeavyColor
        titleLabel.textAlignment = .center
        titleLabel.font = .systemFont(ofSize: CGFloat(self.titleFontSize))
        return titleLabel
    }()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = CGRect(x: 0, y: SCREEN_WIDTH, width: SCREEN_HEIGHT, height: 0)
        self.backgroundColor = .clear
    }
    
    //MARK: Custom Methods
    func addActionWithButtonParams(title: String, style: PPActionSheetStyle, handleBlock: @escaping handleBlock) {
        switch style {
        case .normal:
            createButtonWithTitle(title: title, titleColor: UIColor.blackCustomColor, handleBlock: handleBlock)
            break
        case .selected:
            createButtonWithTitle(title: title, titleColor: UIColor.themeColor, handleBlock: handleBlock)
            break
        case .warming:
            createButtonWithTitle(title: title, titleColor: UIColor.redColor, handleBlock: handleBlock)
            break
        case .cancel:
            self.cancelBtn = UIButton.init(type: .system)
            self.cancelBtn.setTitle(title, for: .normal)
            self.cancelBtn.setTitleColor(UIColor.blackCustomColor, for: .normal)
            self.cancelBtn.titleLabel?.font = .systemFont(ofSize: CGFloat(self.btnTitleFontSize))
            self.cancelBtn.backgroundColor = .white
            self.cancelBtn.addTarget(self, action: #selector(actionOfBtn(_:)), for: .touchUpInside)
            self.cancelBtn.tag = 99
            break
        }
    }
    
    func showActionSheetWithAnimation(animation: Bool) {
        self.refreshActionSheetAction()
        let rootVC = UIApplication.shared.delegate as! AppDelegate
        rootVC.window!.addSubview(self)
        self.maskV.frame = rootVC.window!.bounds as CGRect
        self.maskV.backgroundColor = .blackCustomColor
        self.maskV.alpha = 0
        rootVC.window?.insertSubview(self.maskV, belowSubview: self)
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(actionOfTap))
        self.maskV.addGestureRecognizer(tap)
        
        var safeAreaInsetsBottom = 0
        if #available(iOS 11.0, *) {
            safeAreaInsetsBottom = Int(rootVC.window!.safeAreaInsets.bottom)
        }
        
        if animation {
            UIView.animate(withDuration: 0.25) {
                self.frame = CGRect(x: 0, y: SCREEN_HEIGHT-self.frame.size.height-CGFloat(safeAreaInsetsBottom), width: SCREEN_WIDTH, height: self.frame.size.height)
                self.maskV.alpha = 0.3
            }
        } else {
            self.frame = CGRect(x: 0, y: SCREEN_HEIGHT-self.frame.size.height-CGFloat(safeAreaInsetsBottom), width: SCREEN_WIDTH, height: self.frame.size.height)
        }
    }
    
    func hideActionSheetWithAnimation(animation: Bool) {
        if animation {
            UIView.animate(withDuration: 0.25, animations: {
                self.frame = CGRect(x: 0, y: SCREEN_HEIGHT, width: SCREEN_WIDTH, height: self.frame.size.height)
                self.maskV.alpha = 0
            }) { (Bool) in
                self.removeFromSuperview()
                self.maskV.removeFromSuperview()
            }
        } else {
            self.removeFromSuperview()
            self.maskV.removeFromSuperview()
        }
    }
    
    func createButtonWithTitle(title: String, titleColor: UIColor, handleBlock: @escaping handleBlock) {
        let button = UIButton.init(type: .system)
        button.setTitle(title, for: .normal)
        button.setTitleColor(titleColor, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: CGFloat(self.btnTitleFontSize))
        button.backgroundColor = .white
        button.addTarget(self, action: #selector(actionOfBtn(_:)), for: .touchUpInside)
        button.tag = 100+self.btnArr.count
        self.btnArr.append(button)
        self.blockDict = [button.tag: handleBlock]
        self.blockArr.append(self.blockDict)
    }
    
    // 刷新ActionSheet布局
    func refreshActionSheetAction() {
        for sview in self.subviews {
            sview.removeFromSuperview()
        }
        self.actionSheetHeight = 0.0
        if self.titleLabel.text?.count != 0 {
            self.containView.addSubview(self.titleLabel)
            self.actionSheetHeight += self.titleHeight
        }
        
        for (index, value) in self.btnArr.enumerated() {
            value.frame = CGRect(x: 0, y: CGFloat(self.actionSheetHeight), width: SCREEN_WIDTH-20, height: CGFloat(self.btnHeight))
            self.containView.addSubview(value)
            self.actionSheetHeight += self.btnHeight
            if index < self.btnArr.count-1 {
                addSeparatorLine()
            }
        }
        
        self.containView.frame = CGRect(x: 10, y: 0, width: SCREEN_WIDTH-20, height: CGFloat(self.actionSheetHeight))
        self.containView.layer.cornerRadius = 8.3
        self.containView.layer.masksToBounds = true
        self.addSubview(self.containView)
        
        if self.cancelBtn != nil {
            self.actionSheetHeight += self.separatorHeight
            self.cancelBtn.frame = CGRect(x: 10, y: CGFloat(self.actionSheetHeight), width: SCREEN_WIDTH-20, height: CGFloat(self.btnHeight))
            self.cancelBtn.layer.cornerRadius = 8.3
            self.cancelBtn.layer.masksToBounds = true
            self.addSubview(self.cancelBtn)
            self.actionSheetHeight += self.btnHeight
        }
        
        self.actionSheetHeight += 10
        self.frame = CGRect(x: 0, y: SCREEN_HEIGHT, width: SCREEN_WIDTH, height: CGFloat(self.actionSheetHeight))
    }
    
    // 添加分割线
    func addSeparatorLine() {
        let layer = CALayer()
        layer.frame = CGRect(x: 0, y: CGFloat(self.actionSheetHeight), width: SCREEN_WIDTH-20, height: 1/UIScreen.main.scale)
        layer.backgroundColor = UIColor.grayLightColor.cgColor
        self.containView.layer.addSublayer(layer)
        self.actionSheetHeight += Double(1/UIScreen.main.scale)
    }
    
    //MARK: touches events
    @objc func actionOfBtn(_ sender: UIButton) {
        if sender.tag == 99 {
            self.hideActionSheetWithAnimation(animation: true)
            return
        }
        self.hideActionSheetWithAnimation(animation: true)
        for handleDic in self.blockArr {
            let handle = handleDic[sender.tag]
            handle?(sender, self)
        }
    }
    
    @objc func actionOfTap() {
        hideActionSheetWithAnimation(animation: true)
    }

}
