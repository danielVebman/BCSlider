//
//  BCSlider.swift
//  BCSlider
//
//  Created by Daniel Vebman on 3/19/20.
//  Copyright © 2020 Daniel Vebman. All rights reserved.
//

import Foundation
import SnapKit
import Tactile
import UIKit

class BCSlider: UIView {
    
    private let contentView = UIView()
    
    let curve = BCBellCurve()
    let label = BCLabel()
    let thumb = UIView()
    
    private var centerConstraints: (
        curve: Constraint?,
        label: Constraint?,
        thumb: Constraint?
    ) = (nil, nil, nil)
    
    override var bounds: CGRect {
        didSet {
            curve.frame.size.width = bounds.width * 2
            curve.setNeedsDisplay()
            setNeedsDisplay()
        }
    }
    
    private var valueChangedHandler: ((CGFloat) -> Void)?
    private var _value: CGFloat = 0.5
    var value: CGFloat {
        get {
            return _value
        }
        set(newValue) {
            let bounded = min(max(0, newValue), 1)
            if _value != bounded {
                _value = bounded
                setNeedsDisplay()
                valueChangedHandler?(value)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.pan(pan)
        
        // Setup appearance
        contentView.clipsToBounds = true
        addSubview(contentView)
        
        contentView.addSubview(curve)
        curve.setNeedsDisplay()
        
        label.textColor = .white
        label.backgroundColor = .darkGray
        label.textAlignment = .center
        label.layer.cornerRadius = 5
        label.clipsToBounds = true
        label.font = .systemFont(ofSize: 13)
        contentView.addSubview(label)
        
        thumb.backgroundColor = .white
        thumb.layer.borderColor = UIColor.black.cgColor
        thumb.layer.borderWidth = 1.5
        contentView.addSubview(thumb)
        
        // Setup constraints
        contentView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        curve.snp.makeConstraints { make in
            make.top.equalTo(label.snp.bottom).offset(10)
            make.height.equalTo(16)
            make.width.equalToSuperview().multipliedBy(2)
            centerConstraints.curve = make.centerX.equalTo(0).constraint
        }
        
        label.snp.makeConstraints { make in
            centerConstraints.label = make.centerX.equalTo(0).priority(1).constraint
            make.top.equalToSuperview()
            make.leading.greaterThanOrEqualToSuperview().priority(2)
            make.trailing.lessThanOrEqualToSuperview().priority(2)
        }
        
        thumb.snp.makeConstraints { make in
            centerConstraints.thumb = make.centerX.equalTo(0).constraint
            make.top.equalTo(curve.snp.bottom).inset(5)
            make.size.equalTo(25)
            make.bottom.equalToSuperview()
        }
    }
    
    convenience init() {
        self.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func onValueChanged(_ handler: @escaping (CGFloat) -> Void) {
        valueChangedHandler = handler
    }
    
    private func pan(_ gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .changed:
            value += gesture.translation(in: self).x / (bounds.width - 40)
            gesture.setTranslation(.zero, in: self)
            setNeedsDisplay()
        default:
            break
        }
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        thumb.layer.cornerRadius = 0.5 * thumb.frame.width
        
        let offset = 20 + value * (bounds.width - 40)
        centerConstraints.thumb?.update(offset: offset)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.025) {
            self.centerConstraints.curve?.update(offset: offset)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            self.centerConstraints.label?.update(offset: offset)
        }
    }
    
}

class BCLabel: UILabel {
    
    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        if size == .zero {
            return .zero
        } else {
            return CGSize(width: size.width + 20, height: size.height + 14)
        }
    }
    
}

class BCBellCurve: UIView {
    
    init() {
        super.init(frame: .zero)
        layer.delegate = self
        backgroundColor = .clear
        tintColor = .lightGray
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setNeedsDisplay() {
        super.setNeedsDisplay()
        layer.setNeedsDisplay()
    }
    
    override func draw(_ layer: CALayer, in ctx: CGContext) {
        let minY: CGFloat = 5
        let maxY = bounds.height - 5
        let humpWidth: CGFloat = 40
        let centerX = bounds.width / 2
        
        ctx.move(to: CGPoint(x: 0, y: maxY))
        ctx.addLine(to: CGPoint(x: centerX - humpWidth / 2, y: maxY))
        
        ctx.addCurve(
            to: CGPoint(x: centerX, y: minY),
            control1: CGPoint(x: centerX - humpWidth / 4, y: maxY),
            control2: CGPoint(x: centerX - humpWidth / 4, y: minY)
        )
        
        ctx.addCurve(
            to: CGPoint(x: centerX + humpWidth / 2, y: maxY),
            control1: CGPoint(x: centerX + humpWidth / 4, y: minY),
            control2: CGPoint(x: centerX + humpWidth / 4, y: maxY)
        )
        
        ctx.addLine(to: CGPoint(x: bounds.width, y: maxY))
        
        ctx.setLineWidth(1.5)
        ctx.setStrokeColor(tintColor.cgColor)
        ctx.strokePath()
    }
    
}
