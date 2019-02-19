//
//  TimelineVC.swift
//  Pachi
//
//  Created by Takafumi Ogaito on 2019/02/19.
//  Copyright © 2019 Takafumi Ogaito. All rights reserved.
//

import UIKit
import Pring

class TimelineVC: UIViewController {
    
    var dataSource: DataSource<User>?
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
//        let user = User()
//        user.name = "てすと"
//        user.save()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "PostViewCell", bundle: nil), forCellReuseIdentifier: "PostViewCell")
        self.dataSource = User.order(by: \User.createdAt).limit(to: 30).dataSource()
            .on({ [weak self] (snapshot, changes) in
                guard let tableView = self?.tableView else { return }
                switch changes {
                case .initial:
                    tableView.reloadData()
                case .update(let deletions, let insertions, let modifications):
                    tableView.beginUpdates()
                    tableView.insertRows(at: insertions.map { IndexPath(row: $0, section: 0) }, with: .automatic)
                    tableView.deleteRows(at: deletions.map { IndexPath(row: $0, section: 0) }, with: .automatic)
                    tableView.reloadRows(at: modifications.map { IndexPath(row: $0, section: 0) }, with: .automatic)
                    tableView.endUpdates()
                case .error(let error):
                    print(error)
                }
            }).listen()
    }
}

extension TimelineVC : UITableViewDataSource {
    //セクションの数
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    //セルの数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource?.count ?? 0
    }
    //セル返す
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostViewCell", for: indexPath) as! PostViewCell
        configure(cell, atIndexPath: indexPath)
        return cell
    }
    
    func configure(_ cell: PostViewCell, atIndexPath indexPath: IndexPath) {
        guard let user: User = self.dataSource?[indexPath.item] else { return }
    
        cell.subjectLabel?.text = user.name
        cell.disposer = user.listen { (user, error) in
            cell.subjectLabel?.text = user?.name
        }
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: PostViewCell, forRowAt indexPath: IndexPath) {
        cell.disposer?.dispose()
    }
    
//    func tableView(_ tableView: UITableView, canPerformAction action: Selector, forRowAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
//        return true
//    }
//
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            self.dataSource?.removeDocument(at: indexPath.item)
//        }
//    }
    //セルの高さ
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 430
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        return view
    }
}

extension TimelineVC : UITableViewDelegate {
    // セクションヘッダーの高さを０に
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    // セクションフッターの高さを０に
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }
}


