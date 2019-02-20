//
//  TabBarController.swift
//  Pachi
//
//  Created by Takafumi Ogaito on 2019/02/20.
//  Copyright © 2019 Takafumi Ogaito. All rights reserved.
//

import UIKit
import TransitionableTab

class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
    }
}

extension TabBarController: TransitionableTab {
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        return animateTransition(tabBarController, shouldSelect: viewController)
    }
}
