//
//  MyButton.swift
//  PJ iOS
//
//  Created by Eric Tu on 3/7/22.
//

import Foundation
import UIKit
import CoreGraphics

class MyButton : UIButton {
    
    let borderAlpha : CGFloat = 0.7
    let cornerRadius : CGFloat = 5.0

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setTitleColor(UIColor.white, for: UIControl.State.normal)
        self.backgroundColor = UIColor.clear
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.cornerRadius = cornerRadius
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
