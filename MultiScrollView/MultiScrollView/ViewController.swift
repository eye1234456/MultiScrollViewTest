//
//  ViewController.swift
//  MultiScrollView
//
//  Created by AAA on 11/10/2022.
//

import UIKit

class ViewController: UIViewController {
    
    lazy var tableView = UITableView(frame: view.bounds, style: .plain).then {
        $0.dataSource = self
        $0.delegate = self
        $0.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.reuseId)
    }
    
    lazy var dataList: [[String:Any]] = [
        [
            "title":"Normal 锁住竖直方向子scrollView的滚动",
            "clz":LockVerMainScrollController.self
        ],
        [
            "title":"Normal 锁住竖直方向子tableView的滚动",
            "clz":LockVerMainTableController.self
        ],
        [
            "title":"响应2个手势tableView的滚动",
            "clz":TwoOffsetMainViewController.self
        ]
        
        
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        title = "Home"
    }
}


extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.reuseId, for: indexPath)
        cell.accessoryType = .disclosureIndicator
        if let title = dataList[indexPath.row]["title"] as? String {
            cell.textLabel?.text = title
        }
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let clz = dataList[indexPath.row]["clz"] as? UIViewController.Type {
            let vc = clz.init()
            navigationController?.pushViewController(vc, animated: true)
        }
        DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
}
