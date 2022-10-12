//
//  LockVerSubScrollController.swift
//  MultiScrollView
//
//  Created by AAA on 11/10/2022.
//

import UIKit
import JXCategoryView
import MJRefresh

class LockVerSubScrollController: UIViewController {

    var paramsDict: [String: Any]?
    var mainScrollCallback: ((UIScrollView) -> ())?
    lazy var dataList: [String] = []
//    {
//        var list: [String] = []
//        for _ in (0...10) {
//            list.append("")
//        }
//        return list
//    }

    lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        let width = floor(CGFloat(kScreenW-15.0*2-10.0)/2)
        let height = floor(CGFloat(width*(140.0/168.0)))
        // 168*140
        flowLayout.itemSize = CGSize(width: width, height: height)
        flowLayout.minimumInteritemSpacing = 10.0
        flowLayout.minimumLineSpacing = 10.0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.contentInset = UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isScrollEnabled = false
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: UICollectionViewCell.reuseId)
        collectionView.mj_footer = MJRefreshBackNormalFooter(refreshingTarget: self, refreshingAction: #selector(loadMoreData)).then({
            $0.setTitle("已经到底了", for: .noMoreData)
            $0.isAutomaticallyChangeAlpha = true
        })
        return collectionView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets.zero)
        }
        for _ in (0...10) {
            self.dataList.append("")
        }
        collectionView.reloadData()
    }

    @objc func loadMoreData() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            for _ in (0...10) {
                self.dataList.append("")
            }
            self.collectionView.mj_footer?.endRefreshing()
            self.collectionView.reloadData()
        }
    }
}

extension LockVerSubScrollController : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataList.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UICollectionViewCell.reuseId, for: indexPath)
        cell.backgroundColor = .randomColor
        return cell
    }
    
    
}

extension LockVerSubScrollController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        print(">>==>> sub offsetY:\(offsetY)")
        if offsetY <= 0 {
            // 往下拉，且顶部内容已经全部看见的情况，用于触发主scrollVew往下拉，且锁住子scrollView不能滑动
            if let callback = mainScrollCallback {
                scrollView.contentOffset.y = 0
                scrollView.isScrollEnabled = false
                callback(scrollView)
            }
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetY = scrollView.contentOffset.y
        if offsetY < 0 {
            // 往下拉，且顶部内容已经全部看见的情况，用于触发主scrollVew往下拉，且锁住子scrollView不能滑动
            
            if let callback = mainScrollCallback {
                scrollView.contentOffset.y = 0
                scrollView.isScrollEnabled = false
                callback(scrollView)
            }
            
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        if offsetY < 0 {
            // 往下拉，且顶部内容已经全部看见的情况，用于触发主scrollVew往下拉，且锁住子scrollView不能滑动
            if let callback = mainScrollCallback {
                scrollView.contentOffset.y = 0
                scrollView.isScrollEnabled = false
                callback(scrollView)
            }
        }
    }
}

extension LockVerSubScrollController: JXCategoryListContentViewDelegate {
    public func listView() -> UIView! {
        return self.view
    }
}
