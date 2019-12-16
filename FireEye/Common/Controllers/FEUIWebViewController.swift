//
//  VKYUIWebViewController.swift
//  Vankeyi-Swift
//
//  Created by SimonYHB on 2017/3/7.
//  Copyright © 2017年 yhb. All rights reserved.

import UIKit
//import SwiftyJSON
import NJKWebViewProgress

class FEUIWebViewController: BaseViewController {
    
    fileprivate var hasDisappered : Bool = false
    fileprivate var hasOwnTitle : Bool = false
    
    //add Liuym 支持全屏webView
    var isFullScreen : Bool = false
    
    lazy var progressView: NJKWebViewProgressView = {
        let progressBarHeight:CGFloat = 1.5
        let navigationBarBounds = self.navigationController?.navigationBar.bounds
        
        let progressY = navigationBarBounds!.size.height - progressBarHeight
        
        let barFrame = CGRect.init(x: 0, y: progressY, w: navigationBarBounds!.size.width, h: progressBarHeight)
        let progressView = NJKWebViewProgressView.init(frame: barFrame)
        progressView.autoresizingMask = [.flexibleWidth,.flexibleTopMargin]
        progressView.setProgress(0, animated: false)
        return progressView
    }()
    
    lazy var progressProxy: NJKWebViewProgress = {
        let proxy = NJKWebViewProgress()
        proxy.webViewProxyDelegate = self
        proxy.progressDelegate = self
        return proxy
    }()
    
    //传入cover,加载完成消失
    public var coverImage: UIImage?{
        didSet{
            coverView.image = coverImage
            view.addSubview(coverView)
        }
    }
    
    lazy var coverView: UIImageView = UIImageView.init(frame: CGRect.init(x: 0, y: 0, w: ScreenWidth, h: 300 * SCALE_HEIGHT))
    
    //2017-10-16 czw
    private var htmlContent: String?
    public var needShowLoading : Bool = false
    
    public var loadTimeout : TimeInterval = 60
    fileprivate var loadTimer : Timer?
    
    var request: URLRequest?
    
    fileprivate var parameters: [String : String] = [:]
    
    convenience init(urlStr: String){
        self.init()
        guard let url = URL.init(string: urlStr) else {
            return
        }
        self.request = URLRequest.init(url: url)
    }

    //创建webView
    lazy var webView :UIWebView = {
        let webView = UIWebView.init()
        webView.delegate = self.progressProxy
        webView.scrollView.showsHorizontalScrollIndicator = false
        webView.scrollView.bounces = false
        webView.scrollView.showsVerticalScrollIndicator = false
   
        //UserAgent字段追加字符串"/csyversion"
        var userAgent: String = webView.stringByEvaluatingJavaScript(from: "navigator.userAgent") ?? ""
        if !userAgent.contains("/csyversion") {
            userAgent += "/csyversion"
            let dic: [String:Any] =  ["UserAgent" : userAgent]
            UserDefaults.standard.register(defaults: dic)
        }
   
        if self.isFullScreen {
            if #available(iOS 11.0, *) {
                webView.scrollView.contentInsetAdjustmentBehavior = .never;
            }
        }
        
        return webView
    }()
    
    override func loadView(){
        self.automaticallyAdjustsScrollViewInsets = false
        view = webView
        if self.request != nil{
            webView.loadRequest(self.request!)
        }else if self.htmlContent != nil{ //2017-10-16 czw
            webView.loadHTMLString(self.htmlContent!, baseURL: nil)
        }
    }
    
    deinit {
        self.loadTimer?.invalidate()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.title != nil && (self.title?.length)! > 0{
            self.hasOwnTitle = true
        }
        if self.isFullScreen == false {
            self.edgesForExtendedLayout = []
        }
        
        // 设定网页加载超时时间为60s
        self.loadTimeout = 60
        addBackAndCloseItem()
    }
    
    fileprivate func addBackAndCloseItem() {
        let backItem = UIBarButtonItem.init(image: UIImage.init(named: "login_back"), style: .plain, target: self, action: #selector(backVC))
        var leftBarButtonItems = [backItem]
        
        if is_iOS11 == true{
            
            backItem.imageInsets = UIEdgeInsets(top: 0, left: -15, bottom: 0, right: 0);
            
            self.navigationItem.leftBarButtonItem = backItem;
        }else{
            
            let nagetiveSpacer = UIBarButtonItem.init(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
            nagetiveSpacer.width = -10 * SCALE_WIDTH
            leftBarButtonItems.insert(nagetiveSpacer, at: 0)
        }
        self.navigationItem.leftBarButtonItems = leftBarButtonItems
    }
    
    @objc fileprivate func backVC() {
        FEHUD.dismiss()
        self.loadTimer?.invalidate()
        if self.webView.canGoBack {
            self.webView.goBack()
        } else {
            if (self.navigationController?.viewControllers.count)! <= 1 {
                self.navigationController?.dismiss(animated: true, completion: nil)
            } else {
                _ = self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    func setClarityNavigationBar() {
        // 1、设置导航栏标题属性：设置标题颜色
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        // 2、设置导航栏前景色：设置item指示色
        navigationController?.navigationBar.tintColor = UIColor.white
        
        // 3、设置导航栏半透明
        navigationController?.navigationBar.isTranslucent = true
        
        //navigationController?.navigationBar.backgroundColor = UIColor.init(hexString: "6990D5")
        // 4、设置导航栏背景图片
        //navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        
        // 5、设置导航栏阴影图片
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.addSubview(progressView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if self.isFullScreen {
            setClarityNavigationBar()
        }else{
            self.navigationController?.navigationBar.barStyle = .black
            navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
            navigationController?.navigationBar.tintColor = UIColor.white
            
            let size = CGSize.init(width: ScreenWidth, height: SafeAreaTopHeight)
            let colors = [UIColor.init(hexString: "6990D5"), UIColor.init(hexString: "5789CC")]
            let image = UIImage.gradientImage(colors: colors as! [UIColor], size: size)
            navigationController?.navigationBar.setBackgroundImage(image, for: .default)
            
            navigationController?.navigationBar.shadowImage = UIImage()
            navigationController?.navigationBar.isHidden = false
            navigationController?.navigationBar.addSubview(progressView)
        }
        
        progressProxy.progressDelegate = self
        progressProxy.webViewProxyDelegate = self
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.hasDisappered = true
        progressProxy.progressDelegate = nil
        progressProxy.webViewProxyDelegate = nil
        progressView.removeFromSuperview()
        
        FEHUD.dismiss()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension FEUIWebViewController: UIWebViewDelegate,NJKWebViewProgressDelegate {
    
    func webViewProgress(_ webViewProgress: NJKWebViewProgress!, updateProgress progress: Float) {
        progressView.setProgress(progress, animated: true)
        loadHtmlTitle(webView)
    }
    
    @objc private func loadTimeoutAction(){
        self.loadTimer?.invalidate()
        if needShowLoading == true{
            FEHUD.dismiss()
            if self.hasDisappered == false{
                FEHUD.showError("加载超时")
            }
        }
        self.webView.stopLoading()
    }
    
    func loadHtmlTitle(_ webView: UIWebView){
        if self.hasOwnTitle == false{
            self.title = webView.stringByEvaluatingJavaScript(from: "document.title")
        }
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        
        if needShowLoading == true{
            if loadTimeout > 0{
                self.loadTimer?.invalidate()
                self.loadTimer = Timer.scheduledTimer(timeInterval: loadTimeout, target: self, selector: #selector(loadTimeoutAction), userInfo: nil, repeats: true)
            }
            FEHUD.show(status: "正在加载...")
            //30秒后自动隐藏, add liuym
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 30) {
                FEHUD.dismiss()
            }
        }
        loadHtmlTitle(webView)
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        
        self.loadTimer?.invalidate()
        FELog(error.localizedDescription)
        if (error as NSError).code == -999{ // 任务取消不进行失败回调
            return
        }
        if needShowLoading == true{
            FEHUD.dismiss()
        }
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        
        self.loadTimer?.invalidate()
        if needShowLoading == true{
            FEHUD.dismiss()
        }
        
        loadHtmlTitle(webView)
        
        if coverImage != nil {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                self.removeCoverView()
            }
        }
        
    }
    
    @objc func removeCoverView() {
        UIView.animate(withDuration: 0.25, animations: {
            self.coverView.alpha = 0
        }, completion: { (_) in
            self.coverView.removeFromSuperview()
        })
    }
    
}
