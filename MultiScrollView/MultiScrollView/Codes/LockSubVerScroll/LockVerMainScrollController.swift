//
//  LockVerMainScrollController.swift
//  MultiScrollView
//
//  Created by AAA on 11/10/2022.
//

import Foundation
import UIKit
import SnapKit
import JXCategoryView
import MJRefresh

class LockVerMainScrollController : UIViewController {
    
    lazy var mainScrollView = UIScrollView().then{
        $0.delegate = self
        $0.backgroundColor = .clear
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
//        if #available(iOS 11.0, *) {
//            $0.contentInsetAdjustmentBehavior = .always
//        }
        $0.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(loadNewData))
    }
    
    lazy var contentView = UIView()
    
    lazy var categoryTitleView = JXCategoryTitleView().then {
        $0.titleFont = UIFont.systemFont(ofSize: 14, weight: .regular)
        $0.titleSelectedFont = UIFont.systemFont(ofSize: 14, weight: .medium)
        $0.titleColor = UIColor.darkGray
        $0.titleSelectedColor = UIColor.red
        $0.cellSpacing = 20
        $0.contentEdgeInsetLeft = 15
        $0.contentEdgeInsetRight = 15
        $0.listContainer = self.listContainerView
        $0.isTitleLabelStrokeWidthEnabled = true
        $0.isTitleLabelZoomScrollGradientEnabled = true
        $0.delegate = self
        $0.titles = self.titleDictList.map{ ($0["title"] as? String) ?? "" }
        
        $0.isContentScrollViewClickTransitionAnimationEnabled = false
        $0.isAverageCellSpacingEnabled = false
        
        let lineView = JXCategoryIndicatorLineView().then {
            $0.indicatorColor = UIColor.red
            $0.indicatorWidth = 20
            $0.indicatorHeight = 4
            $0.verticalMargin = 2
        }
        $0.indicators = [lineView]
    }

    lazy var listContainerView = JXCategoryListContainerView(type: .collectionView, delegate: self)
    
    var categoryHeight: CGFloat = 40
    var bottomHeight: CGFloat = kScreenH-kTopHeight
    
    lazy var titleDictList:[[String:Any]] = [
        ["title": "综合", "type": 1],
        ["title": "水果", "type": 2],
        ["title": "蔬菜", "type": 3],
    ]
    
    lazy var subVCList: [LockVerSubScrollController] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "text"
        setupUI()
    }
    
    func setupUI() {
        edgesForExtendedLayout = [.bottom]
        view.backgroundColor = .white
        title = "LockVerMainScrollController"
        view.addSubview(mainScrollView)
        mainScrollView.snp.makeConstraints { make in
            make.top.left.right.bottom.equalToSuperview()
        }
        let topView1 = UIView().then{
            $0.backgroundColor = .orange
        }
        contentView.addSubview(topView1)
        topView1.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(100)
        }
        let topView2 = UIView().then{
            $0.backgroundColor = .green
        }
        contentView.addSubview(topView2)
        topView2.snp.makeConstraints { make in
            make.top.equalTo(topView1.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(150)
        }
        
        contentView.addSubview(categoryTitleView)
        categoryTitleView.snp.makeConstraints { make in
            make.top.equalTo(topView2.snp.bottom)
            make.left.right.equalTo(0)
            make.height.equalTo(categoryHeight)
        }
        
        let listView = listContainerView ?? UIView()
        contentView.addSubview(listView)
        listView.snp.makeConstraints({ make in
            make.top.equalTo(categoryTitleView.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(bottomHeight-categoryHeight)
        })
        
        mainScrollView.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.width.equalToSuperview()
            make.bottom.equalTo(listView.snp.bottom)
        }
        
    }
    
    func currentSubVC() -> LockVerSubScrollController? {
        if categoryTitleView.selectedIndex >= subVCList.count {
            return nil
        }
        return subVCList[categoryTitleView.selectedIndex]
    }
    
    @objc func loadNewData() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.mainScrollView.mj_header?.endRefreshing()
        }
        
    }
}

extension LockVerMainScrollController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
            let offsetY = mainScrollView.contentOffset.y
            // 底部悬浮部分的容器内容一般高度是固定的
            let topHeight = mainScrollView.contentSize.height - bottomHeight
            print(">>==>> main offsetY:\(offsetY) topHeight:\(topHeight)")
            if offsetY >= topHeight {
              // 顶部已经滚动到不可见了，该到底部内容滚动的了
                if offsetY > topHeight {
                    mainScrollView.contentOffset.y = topHeight
                }
                currentSubVC()?.collectionView.isScrollEnabled = true
            }
        }
        
        func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
            let offsetY = mainScrollView.contentOffset.y
            let topHeight = mainScrollView.contentSize.height - bottomHeight
            if offsetY < topHeight {
                // 顶部还有部分可见，底部内容不能滚动
                currentSubVC()?.collectionView.isScrollEnabled = false
                currentSubVC()?.collectionView.contentOffset.y = 0
            }
        }
        
        func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
            let offsetY = mainScrollView.contentOffset.y
            let topHeight = mainScrollView.contentSize.height - bottomHeight
            if offsetY < topHeight {
                // 顶部还有部分可见，底部内容不能滚动
                currentSubVC()?.collectionView.isScrollEnabled = false
                currentSubVC()?.collectionView.contentOffset.y = 0
            }
        }
}


extension LockVerMainScrollController: JXCategoryViewDelegate {
    public func categoryView(_ categoryView: JXCategoryBaseView!, didSelectedItemAt index: Int) {
        let offsetY = mainScrollView.contentOffset.y
        let topHeight = mainScrollView.contentSize.height - bottomHeight
        if offsetY < topHeight {
            // 顶部还有部分可见，底部内容不能滚动
            currentSubVC()?.collectionView.isScrollEnabled = false
        }else {
            // 主scrollVie已经到了悬浮位置
            currentSubVC()?.collectionView.isScrollEnabled = true
        }
    }
}

extension LockVerMainScrollController: JXCategoryListContainerViewDelegate {
    
    public func listContainerView(_ listContainerView: JXCategoryListContainerView!, initListFor index: Int) -> JXCategoryListContentViewDelegate! {
        if subVCList.count <= index {
            // 创建好之前的vc
            for i in (0...index) {
                if subVCList.count <= i {
                    let vc = LockVerSubScrollController()
                    vc.paramsDict = titleDictList[i]
                    vc.mainScrollCallback = { [weak self] (scrollView) in
                        let offsetY = scrollView.contentOffset.y
                        let oldOffsetY = self?.mainScrollView.contentOffset.y ?? 0
                        self?.mainScrollView.contentOffset.y = oldOffsetY+offsetY
                    }
                    subVCList.append(vc)
                }
            }
        }
        return subVCList[index]
    }

    public func number(ofListsInlistContainerView listContainerView: JXCategoryListContainerView!) -> Int {
        return titleDictList.count
    }
}
