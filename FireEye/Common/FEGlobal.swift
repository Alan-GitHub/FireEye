//
//  PHGlobal.swift
//  ccbpuhui
//
//  Created by liuym on 2018/7/5.
//  Copyright © 2018年 yhb. All rights reserved.
//

import UIKit

//缩放常量
let SCALE_WIDTH = ScreenWidth / 375.0
var SCALE_HEIGHT = SCALE_WIDTH
//let SCALE_HEIGHT = ScreenHeight / 667.0

// 安全区顶部高度
let kSafeAreaTop: CGFloat = is_iPhoneX == true ? 24.0 : 0.0
// 安全区底部高度
let kSafeAreaBottom: CGFloat = is_iPhoneX == true ? 34.0 : 0.0

//MARK:- 屏幕适配
let ScreenWidth = UIScreen.main.bounds.width //屏幕宽度

let ScreenHeight = UIScreen.main.bounds.height //屏幕高度

let StatusBarHeight = UIApplication.shared.statusBarFrame.size.height //状态栏高度(刘海屏会包含安全区域)

let NavigationBarHeight = 44  //导航栏高度

let TabbarHeight =  49       //底部Tabbar高度

let SafeAreaTopHeight = CGFloat( NavigationBarHeight + Int(StatusBarHeight))  //导航栏加状态栏

let SafeAreaBottomHeight = CGFloat(ScreenHeight >= 812 ? TabbarHeight + 34 : TabbarHeight ) //底部区域高度

//方法
// 是否iOS11
let is_iOS11: Bool = {
    if #available(iOS 11.0, *) {
        return true
    }
    return false
}()

// 是否iPhone X
let is_iPhoneX: Bool = {
    return is_iphoneXService
}()

// iphoneX 系列
let is_iphoneXService : Bool = {
    if UIDevice.current.userInterfaceIdiom != UIUserInterfaceIdiom.phone{
        return false
    }
    if #available(iOS 11.0, *){
        let bottomInset = UIApplication.shared.keyWindow?.safeAreaInsets.bottom;
        if bottomInset != nil{
            if bottomInset! > CGFloat(0){
                return true
            }
        }
    }
    
    return false
}()

let FEHost: String = "http://www.e4ting.cn"
let PHStaticWeb: String = FEHost + "/host/hostServer/execute"
