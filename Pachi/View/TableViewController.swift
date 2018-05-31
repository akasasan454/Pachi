//
//  TableViewController.swift
//  Pachi
//
//  Created by 大垣内　貴文 on 2018/05/31.
//  Copyright © 2018年 Takafumi Ogaito. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  //ラベル数
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  //セル数
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return  10
  }
  
  //テキスト
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
    cell.textLabel?.text = "aaa"
    return cell
  }
  
}
