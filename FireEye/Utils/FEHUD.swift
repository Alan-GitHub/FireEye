//
//  PHHUD.swift
//  Vankeyi-Swift
//
//  Created by chenzhw on 2018/1/12.
//  Copyright © 2018年 yhb. All rights reserved.
//

import UIKit
import SVProgressHUD

class FEHUD: NSObject {
    
    class func configHUB(){
        SVProgressHUD.setMinimumDismissTimeInterval(2)
        SVProgressHUD.setDefaultMaskType(.none)
        SVProgressHUD.setDefaultAnimationType(.native)
        SVProgressHUD.setImageViewSize(CGSize(width: 5, height: 5))
        SVProgressHUD.setBackgroundColor(UIColor.clear)
    }
    
    class func isVisible()->Bool{
        return SVProgressHUD.isVisible()
    }
    
    class func show(){
        SVProgressHUD.setBackgroundColor(UIColor.clear)
        SVProgressHUD.setForegroundColor(UIColor.black)
        SVProgressHUD.show()
    }
    
    class func show(status:String?){
        SVProgressHUD.setBackgroundColor(UIColor.clear)
        SVProgressHUD.setForegroundColor(UIColor.black)
        SVProgressHUD.show(withStatus:status)
        
    }
    
    class func dismiss(){
        SVProgressHUD.dismiss()
    }
    
    class func showInfo(_ status:String?){
        
        SVProgressHUD.setBackgroundColor(UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.45))
        SVProgressHUD.setForegroundColor(UIColor.white)
        SVProgressHUD.showInfo(withStatus:status)
    }
    
    class func showError(_ errMsg:String?){

        let msg: String = errMsg ?? ""
        if msg.length < 300 {
            SVProgressHUD.showError(withStatus:msg)
        } else {
            FELog("FEHUD showError")
        }
    }
    
    class func showSuccess(_ successMsg:String?){
        SVProgressHUD.showSuccess(withStatus:successMsg)
    }
}
