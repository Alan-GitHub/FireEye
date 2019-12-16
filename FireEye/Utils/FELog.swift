//
//  VKYLog.swift
//  Vankeyi-Swift
//
//  Created by chenzhw on 2017/10/21.
//  Copyright © 2017年 yhb. All rights reserved.
//

import Foundation

// 全局函数
func FELog<T>(_ message:T) {
    #if DEBUG
    print(message)
    #endif
    return
}


