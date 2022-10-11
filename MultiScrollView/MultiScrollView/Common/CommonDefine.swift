//
//  CommonDefine.swift
//  MultiScrollView
//
//  Created by AAA on 11/10/2022.
//

import Foundation
import UIKit
/// 是否iPhoneX系列
public let isIPhoneXSeries = (UIApplication.shared.statusBarFrame.size.height >= 40 ? true : false)
// MARK: - 通用尺寸
/// 屏幕宽度
public let kScreenW = UIScreen.main.bounds.width
/// 屏幕高度
public let kScreenH = UIScreen.main.bounds.height
/// 状态栏高度
public let kStatusBarHeight = UIApplication.shared.statusBarFrame.size.height
/// navBar高度
public let kNavBarHeight: CGFloat = 44
/// tabbar高度
public let kTabBarHeight: CGFloat = 54
/// iPhoneX额外顶部高度
public let kExTForIPX: CGFloat = (isIPhoneXSeries ? (kStatusBarHeight - 20) : 0)
/// iPhoneX额外底部高度
public let kExBForIPX: CGFloat = (isIPhoneXSeries ? 34.0 : 0)
/// iPhoneX额外高度
public let kExHForIPX: CGFloat  = (isIPhoneXSeries ? (kExTForIPX + kExBForIPX): 0)
/// iPhone (navBar高度 + statusBar高度)
public let kTopHeight: CGFloat = kNavBarHeight + kStatusBarHeight
/// iPhone (tabBar高度 + 额外底部高度)
public let kBottomHeight: CGFloat = kTabBarHeight + kExBForIPX
/// iPhone 通用内容高度（总高度-kTopHeight-kBottomHeight）
public let kContentHeight: CGFloat = kScreenH - kTopHeight - kBottomHeight
/// iPhone 通用内容Frame
public let kContentFrame: CGRect = CGRect.init(x: 0, y: 0, width: kScreenW, height: kContentHeight)
