//
//  ButtonBarPagerTabViewController.swift
//  Pachi
//
//  Created by Takafumi Ogaito on 2019/02/20.
//  Copyright © 2019 Takafumi Ogaito. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class ButtonBarPagerTabViewController: ButtonBarPagerTabStripViewController {

    var isReload = false
    
    override func viewDidLoad() {
        //バーの色
        settings.style.buttonBarBackgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        //ボタンの色
        settings.style.buttonBarItemBackgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        //セルの文字色
        settings.style.buttonBarItemTitleColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        //セレクトバーの色
        settings.style.selectedBarBackgroundColor = #colorLiteral(red: 0.009, green: 0.5022200942, blue: 0.7994478345, alpha: 1)
        settings.style.selectedBarHeight = 2
        settings.style.buttonBarItemLeftRightMargin = 0
        settings.style.buttonBarItemFont = .systemFont(ofSize: 10)
        super.viewDidLoad()
        buttonBarView.removeFromSuperview()
        navigationController?.navigationBar.addSubview(buttonBarView)
    }
    
    // MARK: - PagerTabStripDataSource
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let sb = UIStoryboard(name: "Tab1", bundle: nil)
        guard let timelineVC = sb.instantiateViewController(withIdentifier: "TimelineVC") as? TimelineVC else { return [] }
        guard let timelineVC2 = sb.instantiateViewController(withIdentifier: "TimelineVC") as? TimelineVC else { return [] }
        guard let timelineVC3 = sb.instantiateViewController(withIdentifier: "TimelineVC") as? TimelineVC else { return [] }
        guard let timelineVC4 = sb.instantiateViewController(withIdentifier: "TimelineVC") as? TimelineVC else { return [] }
        guard let timelineVC5 = sb.instantiateViewController(withIdentifier: "TimelineVC") as? TimelineVC else { return [] }
        
//        guard isReload else {
            return [timelineVC,timelineVC2,timelineVC3,timelineVC4,timelineVC5]
//        }
        
//        var childViewControllers = [timelineVC,timelineVC2,timelineVC3,timelineVC4,timelineVC5]
//        for index in childViewControllers.indices {
//            let nElements = childViewControllers.count - index
//            let n = (Int(arc4random()) % nElements) + index
//            if n != index {
//                childViewControllers.swapAt(index, n)
//            }
//        }
//        let nItems = 1 + (arc4random() % 8)
//        return Array(childViewControllers.prefix(Int(nItems)))
    }
    
    override func reloadPagerTabStripView() {
        isReload = true
        if arc4random() % 2 == 0 {
            pagerBehaviour = .progressive(skipIntermediateViewControllers: arc4random() % 2 == 0, elasticIndicatorLimit: arc4random() % 2 == 0 )
        } else {
            pagerBehaviour = .common(skipIntermediateViewControllers: arc4random() % 2 == 0)
        }
        super.reloadPagerTabStripView()
    }

}
