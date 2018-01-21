//
//  ViewController.swift
//  LogicTest
//
//  Created by  Tikhomirov on 19.01.2018.
//  Copyright © 2018  Tikhomirov. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

    private let radiusPin = CGFloat(20.0)
    private let radiusCentralLayer = CGFloat(150.0)
    
    private var timer = Timer()
    private var countLayers = 0
    private var centralLayer = CALayer()
    private var backgroundLayer = CALayer()
    private var leftCount = 0
    private var rigthCount = 0
    private var routeLeft = true
    private var currentState = false
    private var index = Int(arc4random() % 100)
    private var interval: Double { return 3.0 / Double(countLayers)}

    @IBOutlet private weak var countLabel: UILabel!
    @IBOutlet private weak var startButton: UIButton!
    @IBOutlet private weak var numberButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        view.layer.addSublayer(backgroundLayer)
        view.layer.addSublayer(centralLayer)
        actionNumber(self)
    }
    
    @IBAction private func actionStart(_ sender: Any) {
        runSearch()
    }
    
    @IBAction private func actionNumber(_ sender: Any) {
        let alert = UIAlertController(title: "Set Pins Number", message: nil, preferredStyle: .alert)
        let action0 = UIAlertAction(title: "Cancel", style: .default) { (_) in }
        let action1 = UIAlertAction(title: "OK", style: .default) { [ unowned self] (_) in
            if let countStr = alert.textFields?.first?.text, let count = Int(countStr), count > 2, count < 61 {
                self.countLabel.text = "Count: 00"
                self.centralLayer.sublayers?.removeAll()
                self.countLayers = count
                self.setupView()
            } else {
                alert.dismiss(animated: true, completion: { })
                let newAlert = UIAlertController(title: "ERROR Number", message: nil, preferredStyle: .alert)
                newAlert.addAction(UIAlertAction(title: "OK", style: .cancel))
                self.present(newAlert, animated: true)
            }
        }
        alert.addAction(action0)
        alert.addAction(action1)
        alert.addTextField { (textField) in
            textField.keyboardType = .decimalPad
            textField.placeholder = "Enter the number from 3 to 60"
        }
        self.present(alert, animated: true)
    }
    
    //MARK: - private methods
    @objc private func savePin() {
        if currentState != DataManager.instance.currentStateLayer(by: index) {
            DataManager.instance.checkLayer(state: currentState, by: index)
            if routeLeft {
                leftCount += 1
                index += 1
            } else {
                rigthCount += 1
                index -= 1
            }
        } else {
            if leftCount == rigthCount {
                timer.invalidate()
                countLabel.text = "Count: 0\(leftCount + 1)"
                numberButton.isEnabled = true
                startButton.isEnabled = true
                return
            }
            currentState = !currentState
            DataManager.instance.checkLayer(state: currentState, by: index)
            routeLeft = !routeLeft
            if routeLeft {
                leftCount = 0
                index += 1
            } else {
                rigthCount = 0
                index -= 1
            }
        }
    }
    
    private func setupView() {
        guard countLayers > 2 else { return }
        let alpha = Double(Double.pi * 2.0 / Double(countLayers))
        let frameX = view.bounds.width / 2 - radiusCentralLayer
        let frameY = view.bounds.height / 2 - radiusCentralLayer - 80
        centralLayer.frame = CGRect(x: frameX, y: frameY, width: radiusCentralLayer * 2, height: radiusCentralLayer * 2)
        backgroundLayer.frame = CGRect(x: frameX, y: frameY, width: radiusCentralLayer * 2, height: radiusCentralLayer * 2)
        backgroundLayer.cornerRadius = radiusCentralLayer
        backgroundLayer.borderWidth = 2
        backgroundLayer.borderColor = UIColor.purple.cgColor
        for i in 0..<countLayers {
            let item = LayerPin(layer: CALayer())
            let centralPinX = radiusCentralLayer - radiusPin + radiusCentralLayer * CGFloat(cos(alpha * Double(i)))
            let centralPinY = radiusCentralLayer - radiusPin + radiusCentralLayer * CGFloat(sin(alpha * Double(i)))
            item.frame = CGRect(x: centralPinX, y: centralPinY, width: radiusPin * 2, height: radiusPin * 2)
            item.cornerRadius = radiusPin
            item.statePin = arc4random() % 2 == 0
            centralLayer.addSublayer(item)
        }
        guard let layers = centralLayer.sublayers as? [LayerPin] else { return }
        DataManager.instance.setLayers(layers)
    }
    
    private func runSearch() {
        leftCount = 0
        rigthCount = Int.max
        routeLeft = true
        currentState = DataManager.instance.currentStateLayer(by: index)
        DataManager.instance.checkLayer(state: !currentState, by: index - 1)
        index += 1
        numberButton.isEnabled = false
        startButton.isEnabled = false
        timer = Timer.scheduledTimer(timeInterval: interval, target: self, selector: #selector(savePin), userInfo: nil, repeats: true)
    }
}
