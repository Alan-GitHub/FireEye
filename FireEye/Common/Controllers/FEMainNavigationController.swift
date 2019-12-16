//
//  VKYMainNavigationController.swift
//  Vankeyi-Swift
//
//  Created by SimonYHB on 2016/12/6.
//  Copyright © 2016年 yhb. All rights reserved.
//

import UIKit

class PHMainNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.black]
        navigationBar.tintColor = UIColor.black
        self.navigationBar.isTranslucent = true
//        setNavigationBar()

        // Do any additional setup after loading the view.
    }
    
//    func setNavigationBar() {
//        // 1、设置导航栏标题属性：设置标题颜色
//        navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]
//        // 2、设置导航栏前景色：设置item指示色
//        navigationBar.tintColor = UIColor.white
//        
//        // 3、设置导航栏半透明
//        navigationBar.isTranslucent = true
//        
//        // 4、设置导航栏背景图片
//        navigationBar.setBackgroundImage(UIImage(), for: .default)
//        
//        // 5、设置导航栏阴影图片
//        navigationBar.shadowImage = UIImage()
//    }
    
//    override func show(_ vc: UIViewController, sender: Any?) {
//        vc.hidesBottomBarWhenPushed = true
//        super.showDetailViewController(vc, sender: sender)
//    }
}
