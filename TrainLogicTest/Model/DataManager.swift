//
//  DataManager.swift
//  LogicTest
//
//  Created by  Tikhomirov on 20.01.2018.
//  Copyright © 2018  Tikhomirov. All rights reserved.
//

import Foundation

final class DataManager {
    static let instance = DataManager()
    private init() { }
    
    private var layers: [LayerPin] = []
    
    private func rightIndex(_ index: Int) -> Int {
        return index < 0 ? layers.count : index % layers.count
    }
    func setLayers(_ layers: [LayerPin]) {
        self.layers = layers
    }
    
    func removeLayers() {
        if !layers.isEmpty {
            layers.removeAll()
        }
    }
    
    func currentStateLayer(by index: Int) -> Bool {
        return layers[rightIndex(index)].statePin
    }
    
    func checkLayer(state: Bool, by index: Int) {
        layers[rightIndex(index)].statePin = state
    }
}
