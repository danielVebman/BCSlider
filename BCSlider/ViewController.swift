//
//  ViewController.swift
//  BCSlider
//
//  Created by Daniel Vebman on 3/19/20.
//  Copyright © 2020 Daniel Vebman. All rights reserved.
//

import SnapKit
import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup appearance
        view.backgroundColor = .white
        
        let alertView = UIView()
        alertView.backgroundColor = .white
        alertView.layer.cornerRadius = 20
        alertView.layer.shadowColor = UIColor.black.cgColor
        alertView.layer.shadowRadius = 10
        alertView.layer.shadowOpacity = 0.1
        alertView.layer.shadowOffset = .zero
        view.addSubview(alertView)
        
        let slider = BCSlider()
        slider.onValueChanged { value in
            slider.label.text = "\(Int(value * 59) + 1) min"
        }
        slider.value = 0.1
        alertView.addSubview(slider)
        
        let label = UILabel()
        let text = NSMutableAttributedString()
        text.append(NSAttributedString(
            string: "Cafe Misto ",
            attributes: [
                .font: UIFont.boldSystemFont(ofSize: 15),
                .foregroundColor: UIColor.gray
            ]
        ))
        text.append(NSAttributedString(
            string: "is 30 min away by car.\nSet a reminder before?",
            attributes: [
                .font: UIFont.systemFont(ofSize: 15),
                .foregroundColor: UIColor.lightGray
            ]
        ))
        label.attributedText = text
        label.numberOfLines = 0
        alertView.addSubview(label)
        
        let yesButton = UIButton(type: .system)
        yesButton.setTitle("Yes", for: .normal)
        yesButton.titleLabel?.font = .boldSystemFont(ofSize: 15)
        alertView.addSubview(yesButton)
        
        let noButton = UIButton(type: .system)
        noButton.setTitle("No", for: .normal)
        noButton.titleLabel?.font = .systemFont(ofSize: 15)
        alertView.addSubview(noButton)
        
        // Setup constraints
        alertView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(40)
            make.trailing.equalToSuperview().inset(40)
            
            make.center.equalToSuperview()
        }
        
        slider.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(40)
            make.trailing.equalToSuperview().inset(40)
            make.top.equalTo(label.snp.bottom).offset(20)
            make.height.equalTo(90)
        }
        
        label.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().inset(20)
        }
        
        yesButton.snp.makeConstraints { make in
            make.top.equalTo(slider.snp.bottom).offset(20)
            make.centerX.equalToSuperview().dividedBy(2)
            make.bottom.equalToSuperview().inset(20)
        }
        
        noButton.snp.makeConstraints { make in
            make.top.equalTo(slider.snp.bottom).offset(20)
            make.centerX.equalToSuperview().multipliedBy(1.5)
        }
    }
    
}
