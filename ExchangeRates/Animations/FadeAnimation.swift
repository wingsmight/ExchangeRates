//
//  FadeAnimation.swift
//  ExchangeRates
//
//  Created by Igoryok
//  

import UIKit

extension UIView {
    func fadeTransition(_ duration: CFTimeInterval) {
        let fadeOut = CABasicAnimation(keyPath: "opacity")
        fadeOut.fromValue = 1
        fadeOut.toValue = 0
        fadeOut.duration = duration / 2
        fadeOut.timingFunction = CAMediaTimingFunction(name: .easeIn)

        let fadeIn = CABasicAnimation(keyPath: "opacity")
        fadeIn.fromValue = 0
        fadeIn.toValue = 1
        fadeIn.duration = duration / 2
        fadeIn.timingFunction = CAMediaTimingFunction(name: .easeOut)

        let animationGroup = CAAnimationGroup()
        animationGroup.animations = [fadeOut, fadeIn]
        animationGroup.duration = duration
        animationGroup.fillMode = .forwards
        animationGroup.isRemovedOnCompletion = false

        layer.add(animationGroup, forKey: "fadeOutAndIn")
    }
}
