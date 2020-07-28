//
//  ViewController.swift
//  ActionSheetDemo
//
//  Created by swartz01 on 2020/7/28.
//  Copyright © 2020 Mark_J. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    lazy var buttonOne: UIButton = {
        let button = UIButton.init(type: .custom)
        button.frame = CGRect(x: self.view.bounds.midX-100/2, y: 200, width: 100, height: 40)
        button.setTitle("带标题", for: .normal)
        button.setTitleColor(.grayHeavyColor, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18)
        button.layer.borderWidth = 0.5
        button.layer.borderColor = UIColor.grayLightColor.cgColor
        button.addTarget(self, action: #selector(actionOfBtn(_:)), for: .touchUpInside )
        return button
    }()
    
    lazy var buttonTwo: UIButton = {
        let button = UIButton.init(type: .custom)
        button.frame = CGRect(x: self.view.bounds.midX-100/2, y: 300, width: 100, height: 40)
        button.setTitle("不带标题", for: .normal)
        button.setTitleColor(.grayHeavyColor, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18)
        button.layer.borderWidth = 0.5
        button.layer.borderColor = UIColor.grayLightColor.cgColor
        button.addTarget(self, action: #selector(actionOfBtn(_:)), for: .touchUpInside )
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.view.addSubview(self.buttonOne)
        self.view.addSubview(self.buttonTwo)
    }

    //MARK: touches events
    @objc func actionOfBtn(_ sender: UIButton) {
        if sender == self.buttonOne {
            let operationSheet = PPActionSheetView()
            operationSheet.titleLabel.text = "温馨提示"
            operationSheet.addActionWithButtonParams(title: "action1", style: .normal) { (button: UIButton, actionSheet: PPActionSheetView) in
                print("点击了'action1'")
            }
            operationSheet.addActionWithButtonParams(title: "action2", style: .normal) { (button: UIButton, actionSheet: PPActionSheetView) in
                print("点击了'action2'")
            }
            operationSheet.addActionWithButtonParams(title: "action3", style: .normal) { (button: UIButton, actionSheet: PPActionSheetView) in
                print("点击了'action3'")
            }
            operationSheet.addActionWithButtonParams(title: "取消", style: .cancel) { (button: UIButton, actionSheet: PPActionSheetView) in
                
            }
            operationSheet.showActionSheetWithAnimation(animation: true)
        } else {
            let operationSheet = PPActionSheetView()
            operationSheet.addActionWithButtonParams(title: "action1", style: .normal) { (button: UIButton, actionSheet: PPActionSheetView) in
                print("点击了'action1'")
            }
            operationSheet.addActionWithButtonParams(title: "action2", style: .normal) { (button: UIButton, actionSheet: PPActionSheetView) in
                print("点击了'action2'")
            }
            operationSheet.addActionWithButtonParams(title: "取消", style: .cancel) { (button: UIButton, actionSheet: PPActionSheetView) in
                
            }
            operationSheet.showActionSheetWithAnimation(animation: true)
        }
    }
    

}

