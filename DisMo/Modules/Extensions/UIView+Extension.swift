//
//  UIView+Extension.swift
//  DisMo
//
//  Created by Macbook on 16/12/22.
//

import UIKit

extension UIView {
    func shadowedView(_ view: UIView?, offset: CGSize, radius: CGFloat, alpha: Float) {
        shadowedView(view, color: UIColor.black, offset: offset, radius: radius, alpha: alpha)
    }

    func shadowedView(_ view: UIView?, color: UIColor, offset: CGSize, radius: CGFloat, alpha: Float) {
        let shadowPath = UIBezierPath(roundedRect: view?.bounds ?? CGRect.zero,
                                    cornerRadius: radius)
        let shadowLayer = CAShapeLayer()
        shadowLayer.path = shadowPath.cgPath

        view?.layer.shadowColor = color.cgColor
        view?.layer.shadowOffset = offset
        view?.layer.shadowOpacity = alpha
        view?.layer.shadowPath = shadowPath.cgPath
        view?.layer.shadowRadius = CGFloat(radius)
        view?.layer.masksToBounds = false
    }
}
