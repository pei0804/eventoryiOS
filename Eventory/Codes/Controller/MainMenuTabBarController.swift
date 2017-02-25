//
//  MainMenuTabBarController.swift
//  Eventory
//
//  Created by jumpei on 2016/09/11.
//  Copyright © 2016年 jumpei. All rights reserved.
//

import UIKit
import BFPaperTabBarController

class MainMenuTabBarController: BFPaperTabBarController {
    
//    var newEvent: Int = 0 {
//        didSet {
//            if newEvent > 0 {
//                self.tabBar.items![0].badgeValue = nil
//            } else {
//                self.tabBar.items![0].badgeValue = nil
//            }
//        }
//    }

    
    let tabBarImages: [String] = ["new", "keep", "noKeep", "setting"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.selectedIndex = 0
        self.tabBar.tintColor = UIColor.white
        self.tabBar.backgroundColor = UIColor.white
//        self.updateBadge(EventManager.sharedInstance.getSelectNewEventAll().count)

        guard let items = self.tabBar.items else {
            return
        }

        if items.count != self.tabBarImages.count {
            fatalError("assets tabbarmenu not match count")
        }

        self.rippleFromTapLocation = false
        self.usesSmartColor = true
        self.underlineColor = Colors.main2
        self.underlineThickness = tabBar.frame.height
        
        for (i,item) in items.enumerated() {
            item.image = UIImage(named: "\(tabBarImages[i])Off.png")!.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
            item.selectedImage = UIImage(named: "\(tabBarImages[i])On.png")!.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
            item.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "Avenir-Medium", size: 9)!], for: UIControlState())
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
//    override func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
//        self.updateBadge(EventManager.sharedInstance.getSelectNewEventAll().count)
//    }

//    func updateBadge(newEvent: Int) {
//        self.newEvent = newEvent
//    }
}
