//
//  LayerPin.swift
//  LogicTest
//
//  Created by  Tikhomirov on 19.01.2018.
//  Copyright © 2018  Tikhomirov. All rights reserved.
//

import UIKit

class LayerPin: CALayer {
    
    var trueColor = UIColor.green.cgColor
    var falseColor = UIColor.red.cgColor
    var statePin: Bool = false { didSet { setupState() } }
    
    override init(layer: Any) {
        super.init()
        backgroundColor = falseColor
        borderColor = UIColor.black.cgColor
        borderWidth = 2.0
        shadowColor = UIColor.darkGray.cgColor
        shadowOffset = CGSize(width: 5, height: 5)
        shadowOpacity = 0.8
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setupState() {
        self.statePin  ? (self.backgroundColor = self.trueColor) : (self.backgroundColor = self.falseColor)

    }
}
