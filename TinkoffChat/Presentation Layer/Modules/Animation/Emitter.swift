//
//  Emitter.swift
//  TinkoffChat
//
//  Created by Daniil on 02/12/2018.
//  Copyright © 2018 pokhachevskiy. All rights reserved.
//

import Foundation
import UIKit

class Emitter {
    private weak var superView: UIView?
    private var emitter = CAEmitterLayer()

    private var longPressRecognizer = UILongPressGestureRecognizer()

    init(view: UIView) {
        superView = view
        longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(performLongPressAnimations))
        superView?.addGestureRecognizer(longPressRecognizer)
    }

    private func generateEmitterCells() {
        superView?.endEditing(true)

        emitter.emitterPosition = longPressRecognizer.location(in: superView)
        emitter.emitterShape = CAEmitterLayerEmitterShape.circle
        emitter.emitterSize = CGSize(width: 30, height: 30)

        let cell = CAEmitterCell()

        cell.contents = UIImage(named: "TinkoffFlake")?.cgImage
        cell.birthRate = 8
        cell.lifetime = 2
        cell.velocity = CGFloat(55)
        cell.contentsScale = 10
        cell.velocityRange = 20
        cell.yAcceleration = -70.0
        cell.xAcceleration = -20
        cell.emissionRange = .pi / 6

        emitter.emitterCells = [cell]
        superView?.layer.addSublayer(emitter)
    }

    @objc private func performLongPressAnimations(_ sender: UILongPressGestureRecognizer) {
        switch longPressRecognizer.state {
        case .began:
            generateEmitterCells()
        case .ended:
            emitter.removeFromSuperlayer()
        case .changed:
            emitter.emitterPosition = sender.location(in: superView)
        default:
            break
        }
    }
}
