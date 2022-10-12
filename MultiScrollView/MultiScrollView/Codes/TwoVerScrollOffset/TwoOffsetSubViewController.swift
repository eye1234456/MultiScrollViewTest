//
//  TwoOffsetSubViewController.swift
//  MultiScrollView
//
//  Created by AAA on 12/10/2022.
//

import UIKit
import JXCategoryView
import MJRefresh

class TwoOffsetSubViewController: UIViewController {

    var isSubCanScroll: Bool = true
    var mainScrollCallback: ((UIScrollView,Bool) -> ())?
    var paramsDict: [String: Any]?
    lazy var dataList: [String] = []

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

extension TwoOffsetSubViewController : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
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

extension TwoOffsetSubViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        print(">>==>> sub offsetY:\(offsetY)")
        // 如果主scrollView可以响应时，子scroll不要响应
        if isSubCanScroll {
            if offsetY <= 0 {
                // 往下拉，且顶部内容已经全部看见的情况，用于触发主scrollVew往下拉，且锁住子scrollView不能滑动
                // 子scroll不应该响应手势了
                
                scrollView.contentOffset.y = 0
                mainScrollCallback?(scrollView,false)
            }else {
                mainScrollCallback?(scrollView,true)
            }
        }else {
            scrollView.contentOffset.y = 0
        }
        
    }
    
}

extension TwoOffsetSubViewController: JXCategoryListContentViewDelegate {
    public func listView() -> UIView! {
        return self.view
    }
}
