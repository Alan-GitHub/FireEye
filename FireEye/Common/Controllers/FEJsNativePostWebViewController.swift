//
//  PHJsNativePostWebViewController.swift
//  Vankeyi-Swift
//
//  Created by chenzhw on 2017/12/26.
//  Copyright © 2017年 yhb. All rights reserved.

import UIKit
import WebViewJavascriptBridge

class FEJsNativePostWebViewController: FEUIWebViewController {
    
    // 回调
    var finishBlock: ((Bool)->())?
    
    // 注册回调
    var registerFinishBlock: ((Bool)->())?
    
    // 重置密码回调
    var resetPwdFinishBlock: ((Bool)->())?
    
    var bridge:WebViewJavascriptBridge?
    var isFreeBridge = true
    var showStatuBar = false
    var isHideNavBar = false
    
    
    
    // 用户资料维护回调
    var userInfoMaintenanceFinishBlock: ((Bool)->())?
    
    convenience init(urlStr: String, postBodyStr: String) {
        self.init()
        
        guard let url = URL.init(string: urlStr) else {
            return
        }
        self.request = URLRequest.init(url: url)
        self.request?.httpMethod = "POST"
        self.request?.httpBody = postBodyStr.data(using: String.Encoding.utf8)
    }
    
    convenience init(urlStr: String){
        self.init()
        
        //配置属性
        needShowLoading = true
        isFullScreen = true
        hidesBottomBarWhenPushed = false
        showStatuBar = true
        isHideNavBar = false
        
        guard let url = URL.init(string: urlStr) else {
            return
        }
        self.request = URLRequest.init(url: url)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.bridge = WebViewJavascriptBridge(webView)
        self.bridge?.setWebViewDelegate(self)
        
        registerJSHandler()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if self.isHideNavBar == true {
            
            self.navigationController?.navigationBar.isHidden = true
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(true)
        self.navigationController?.navigationBar.isHidden = false
        if self.isFreeBridge == true {
            self.bridge = nil
        }else{
            self.isFreeBridge = true
        }
    }
    
    override func webViewDidStartLoad(_ webView: UIWebView) {
        super.webViewDidStartLoad(webView)
    }
    
    //Mark: 注册函数给js调用，调用签名
    fileprivate func registerJSHandler() {
        //为js提供原生接口请求
        self.bridge?.registerHandler("serverRequest", handler: { (data, responseCallback) in
            /*
             handler: 提供给H5调用的方法
             data：H5调用方法时传递过来的参数
             responseCallback：H5提供的原生回掉方法
             */
        })
    }
}
