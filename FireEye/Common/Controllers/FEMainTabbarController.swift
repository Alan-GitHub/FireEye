//
//  FEMainTabbarController.swift
//  FireEye
//
//  Created by Alan on 2019/12/15.
//  Copyright © 2019年 Alan. All rights reserved.
//

import UIKit
import ESTabBarController_swift
import EZSwiftExtensions

class FEMainTabbarController: ESTabBarController {

    fileprivate var lastTapIndexDate:Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.backgroundColor = UIColor.white
        tabBar.barTintColor = .white
        
        tabBar.backgroundImage = UIImage.init()
        let colors = [
            UIColor.init(hexString: "dedede"),
            UIColor.init(hexString: "dedede")
        ]
        tabBar.shadowImage = UIImage.gradientImage(colors: colors as! [UIColor], size: CGSize.init(width: ScreenWidth, height: 0.33))
        
        setupChildViewControllers()
//        setTabBarItemColor()
//        tabBar.clipsToBounds = true
        //验证自动登录
//        VKYLoginTool.checkingAutoLogin(successBlock: {
////            NotificationCenter.default.post(name: NSNotification.Name(rawValue: ChangeUserInfoNotification), object: nil)
////            NotificationCenter.default.post(name: NSNotification.Name(rawValue: UpdateUnreadNotification), object: nil)
//        }, failureBlock: {
//
//        })
        // 检查版本更新
//        VKYClientInfoTool.checkAppVerion(self)
        
        
    }
    
    func setupChildViewControllers() {
        let homeVC = addChildViewController(
            childVC: FEJsNativePostWebViewController(urlStr: "https://www.baidu.com"),
            title: "首页",
            imageName: kImg_tabbar_home_nor,
            selectedImageName:kImg_tabbar_home_sel)
        
        let dynamicVC = addChildViewController(
            childVC: FEJsNativePostWebViewController(urlStr: "https://www.baidu.com"),
            title: "动态信息",
            imageName: kImg_tabbar_dynamic_nor,
            selectedImageName: kImg_tabbar_dynamic_sel)
        
        let mineVC = addChildViewController(
            childVC: FEJsNativePostWebViewController(urlStr: "https://www.baidu.com"),
            title: "我的",
            imageName: kImg_tabbar_mine_nor,
            selectedImageName: kImg_tabbar_mine_sel)
        
        viewControllers = [homeVC, dynamicVC, mineVC]
    }
    
    func addChildViewController(childVC: BaseViewController, title: String, imageName: String, selectedImageName: String) -> PHMainNavigationController {
        let navi = PHMainNavigationController(rootViewController: childVC)
        
//        let image = CCBBSR_IMAGE(imageName)!.withRenderingMode(.alwaysOriginal)
//        let selectedImage = CCBBSR_IMAGE(selectedImageName)!.withRenderingMode(.alwaysOriginal)
        
        let image = UIImage.init(named: imageName)
        let selectedImage = UIImage.init(named: selectedImageName)
        
//        let tabBarItem = UITabBarItem(title: title, image: image, selectedImage: selectedImage)
        navi.tabBarItem = ESTabBarItem.init(BouncesContentView(), title: title, image: image, selectedImage: selectedImage)
        
        return navi
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    open override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        guard let idx = tabBar.items?.index(of: item) else {
            return;
        }
        
        self.lastTapIndexDate = Date.init()
        super.tabBar(tabBar, didSelect: item)
    }

}

class BouncesContentView: ESTabBarItemContentView {
    public var duration = 0.3
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        RGBA(216, 226, 233, 1)   (74, 122, 224, 1)
        textColor = UIColor.init(r: 166, g: 173, b: 178)
       highlightTextColor = UIColor.init(r: 74, g: 122, b: 224)
        //iconColor = UIColor.init(r: 216, g: 226, b: 233)
//       highlightIconColor = UIColor.init(r: 74, g: 122, b: 224)
       
    }
    
    override func selectAnimation(animated: Bool, completion: (() -> ())?) {
        self.bounceAnimation()
        completion?()
    }
    
    override func reselectAnimation(animated: Bool, completion: (() -> ())?) {
        self.bounceAnimation()
        completion?()
    }
    
    func bounceAnimation() {
        let impliesAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        impliesAnimation.values = [1.0 ,1.4, 0.9, 1.15, 0.95, 1.02, 1.0]
        impliesAnimation.duration = duration * 2
        impliesAnimation.calculationMode = CAAnimationCalculationMode.cubic
        imageView.layer.add(impliesAnimation, forKey: nil)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
