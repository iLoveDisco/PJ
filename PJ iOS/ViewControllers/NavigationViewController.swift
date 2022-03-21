//
//  NavigationViewController.swift
//  PJ iOS
//
//  Created by Eric Tu on 3/18/22.
//

import Foundation
import UIKit

class MyNavViewController : UINavigationController {
    
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
        
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "background")
        backgroundImage.contentMode = .scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
