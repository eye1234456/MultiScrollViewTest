//
//  LockVerMainTableController.swift
//  MultiScrollView
//
//  Created by AAA on 12/10/2022.
//

import UIKit
import JXCategoryView
import MJRefresh

class LockVerMainTableController: UIViewController {

    lazy var tableView = UITableView(frame: .zero, style: .plain).then {
        $0.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.reuseId)
        $0.register(SubControllerTableViewCell.self, forCellReuseIdentifier: SubControllerTableViewCell.reuseId)
        $0.dataSource = self
        $0.delegate = self
        $0.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(loadNewData))
    }
    
    var dataList: [String] = []
    lazy var titleDictList:[[String:Any]] = [
        ["title": "综合", "type": 1],
        ["title": "水果", "type": 2],
        ["title": "蔬菜", "type": 3],
    ]
    lazy var subVCList: [LockVerSubScrollController] = []
    var categoryHeight: CGFloat = 40
    var bottomHeight: CGFloat = kScreenH-kTopHeight
    
    var contentCell: SubControllerTableViewCell?
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    func setupUI() {
        edgesForExtendedLayout = [.bottom]
        title = "LockVerMainTableController"
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.left.right.bottom.equalToSuperview()
        }
        for _ in (0..<2) {
            dataList.append("")
        }
        tableView.reloadData()
    }
    
    func currentSubVC() -> LockVerSubScrollController? {
        if categoryTitleView.selectedIndex >= subVCList.count {
            return nil
        }
        return subVCList[categoryTitleView.selectedIndex]
    }
    
    @objc func loadNewData() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.tableView.mj_header?.endRefreshing()
        }
        
    }
}

// MARK: - UITableViewDataSource,UITableViewDelegate
extension LockVerMainTableController: UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count+1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row < dataList.count {
            // 普通业务行
            return 100
        }else {
            return bottomHeight
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row < dataList.count {
            // 普通业务行
            let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.reuseId, for: indexPath)
            cell.backgroundColor = .randomColor
            return cell
        }else {
            // 最后一行
            let cell = tableView.dequeueReusableCell(withIdentifier: SubControllerTableViewCell.reuseId, for: indexPath)
            if let subCell = cell as? SubControllerTableViewCell {
                contentCell = subCell
                
                subCell.contentView.addSubview(categoryTitleView)
                categoryTitleView.snp.makeConstraints { make in
                    make.top.left.right.equalTo(0)
                    make.height.equalTo(categoryHeight)
                }
                
                let listView = listContainerView ?? UIView()
                subCell.contentView.addSubview(listView)
                listView.snp.makeConstraints({ make in
                    make.top.equalTo(categoryTitleView.snp.bottom)
                    make.left.right.equalToSuperview()
                    make.height.equalTo(bottomHeight-categoryHeight)
                })
            }
            return cell
        }
        
    }
}

// MARK: - UITableViewDataSource,UITableViewDelegate
extension LockVerMainTableController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
            let offsetY = tableView.contentOffset.y
            // 底部悬浮部分的容器内容一般高度是固定的
            let topHeight = tableView.contentSize.height - bottomHeight
            print(">>==>> main offsetY:\(offsetY) topHeight:\(topHeight)")
            if offsetY >= topHeight {
              // 顶部已经滚动到不可见了，该到底部内容滚动的了
                if offsetY > topHeight {
                    tableView.contentOffset.y = topHeight
                }
                currentSubVC()?.collectionView.isScrollEnabled = true
            }
        }
        
//        func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//            let offsetY = tableView.contentOffset.y
//            let topHeight = tableView.contentSize.height - bottomHeight
//            if offsetY < topHeight {
//                // 顶部还有部分可见，底部内容不能滚动
//                currentSubVC()?.collectionView.isScrollEnabled = false
//                currentSubVC()?.collectionView.contentOffset.y = 0
//            }
//        }
//        
//        func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//            let offsetY = tableView.contentOffset.y
//            let topHeight = tableView.contentSize.height - bottomHeight
//            if offsetY < topHeight {
//                // 顶部还有部分可见，底部内容不能滚动
//                currentSubVC()?.collectionView.isScrollEnabled = false
//                currentSubVC()?.collectionView.contentOffset.y = 0
//            }
//        }
}


// MARK: - JXCategoryViewDelegate
extension LockVerMainTableController: JXCategoryViewDelegate {
    public func categoryView(_ categoryView: JXCategoryBaseView!, didSelectedItemAt index: Int) {
        let offsetY = tableView.contentOffset.y
        let topHeight = tableView.contentSize.height - bottomHeight
        if offsetY < topHeight {
            // 顶部还有部分可见，底部内容不能滚动
            currentSubVC()?.collectionView.isScrollEnabled = false
        }else {
            // 主scrollVie已经到了悬浮位置
            currentSubVC()?.collectionView.isScrollEnabled = true
        }
    }
}

// MARK: - JXCategoryListContainerViewDelegate
extension LockVerMainTableController: JXCategoryListContainerViewDelegate {
    
    public func listContainerView(_ listContainerView: JXCategoryListContainerView!, initListFor index: Int) -> JXCategoryListContentViewDelegate! {
        if subVCList.count <= index {
            // 创建好之前的vc
            for i in (0...index) {
                if subVCList.count <= i {
                    let vc = LockVerSubScrollController()
                    vc.paramsDict = titleDictList[i]
                    vc.mainScrollCallback = { [weak self] (scrollView) in
                        let offsetY = scrollView.contentOffset.y
                        let oldOffsetY = self?.tableView.contentOffset.y ?? 0
                        self?.tableView.contentOffset.y = oldOffsetY+offsetY
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

