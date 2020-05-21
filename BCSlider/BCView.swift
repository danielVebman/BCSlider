//
//  BCView.swift
//  BCSlider
//
//  Created by Daniel Vebman on 4/25/20.
//  Copyright © 2020 Daniel Vebman. All rights reserved.
//

import Foundation
import SABlurImageView
import UIKit

class BCView: UIView {
    
    let contentView = UIView()
    private let shadowImageView = SABlurImageView()

    private var size: CGSize
    override var frame: CGRect {
        didSet {
            if frame.size != size {
                size = frame.size
                setNeedsDisplay()
            } else {
                size = frame.size
            }
        }
    }
    
    override init(frame: CGRect) {
        size = frame.size
        super.init(frame: frame)
        
        addSubview(shadowImageView)
        shadowImageView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(-20)
            make.bottom.trailing.equalToSuperview().offset(20)
        }
        
        contentView.backgroundColor = .white
        addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
    }
    
    convenience init() {
        self.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        let gradient = CAGradientLayer()
        gradient.frame = CGRect(x: 10, y: 10, width: rect.width + 20, height: rect.height + 20)
        gradient.colors = [
            UIColor.white.cgColor,
            UIColor(red: 211 / 255, green: 219 / 255, blue: 230 / 255, alpha: 1).cgColor]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        gradient.mask = maskLayer(from: recticircle(in: gradient.bounds))
        gradient.masksToBounds = true
        
        let containerLayer = CALayer()
        containerLayer.frame = CGRect(x: 0, y: 0, width: rect.width + 2 * 20, height: rect.height + 2 * 20)
        containerLayer.addSublayer(gradient)
        let renderer = UIGraphicsImageRenderer(bounds: containerLayer.bounds)
        let layerSnapshot = renderer.image { context in
            containerLayer.render(in: context.cgContext)
        }
        
        shadowImageView.image = layerSnapshot
        shadowImageView.addBlurEffect(60)
        shadowImageView.alpha = 0.6
        
        contentView.layer.mask = maskLayer(from: recticircle(in: rect))
    }
    
    private func maskLayer(from path: CGPath) -> CAShapeLayer {
        let maskLayer = CAShapeLayer()
        maskLayer.path = path
        return maskLayer
    }
    
    private func recticircle(in frame: CGRect, with radius: CGFloat = 0.1) -> CGPath {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: frame.height / 2))
        path.addCurve(
            to: CGPoint(x: frame.width / 2, y: frame.height),
            controlPoint1: CGPoint(x: 0, y: frame.height * (1 - radius)),
            controlPoint2: CGPoint(x: frame.width * radius, y: frame.height))
        path.addCurve(
            to: CGPoint(x: frame.width, y: frame.height / 2),
            controlPoint1: CGPoint(x: frame.width * (1 - radius), y: frame.height),
            controlPoint2: CGPoint(x: frame.width, y: frame.height * (1 - radius)))
        path.addCurve(
            to: CGPoint(x: frame.width / 2, y: 0),
            controlPoint1: CGPoint(x: frame.width, y: frame.height * radius),
            controlPoint2: CGPoint(x: frame.width * (1 - radius), y: 0))
        path.addCurve(
            to: CGPoint(x: 0, y: frame.height / 2),
            controlPoint1: CGPoint(x: frame.width * radius, y: 0),
            controlPoint2: CGPoint(x: 0, y: frame.height * radius))
        path.close()
        return path.cgPath
    }
    
}
