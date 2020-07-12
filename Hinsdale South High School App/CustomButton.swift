//
//  3DButton.swift
//  Hinsdale South High School App
//
//  Created by Sagar Natekar on 3/26/16.
//  Copyright © 2016 Hornet App Development. All rights reserved.
//

import UIKit

@IBDesignable
class CustomButton: UIButton {
    @IBInspectable var buttonColor: UIColor = UIColor.clear {
        didSet {
            setNeedsDisplay()
        }
    }

    fileprivate var isPressed: Bool = false

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    func commonInit() {
        observeTouchEvents()
    }

    func observeTouchEvents() {
        addTarget(self, action: #selector(touchDown(_:)), for: .touchDown)
        addTarget(self, action: #selector(touchUp(_:)), for: [.touchUpInside, .touchUpOutside])
    }

    @objc func touchDown(_ sender: UIButton) {
        isPressed = true
        setNeedsDisplay()
    }

    @objc func touchUp(_ sender: UIButton) {
        isPressed = false
        setNeedsDisplay()
    }

    override func draw(_ rect: CGRect) {
        titleEdgeInsets = isPressed ? UIEdgeInsetsMake(5.0, 5.0, 0, 0) : UIEdgeInsets.zero

        draw3DButtonWithColor(buttonColor, buttonSize: bounds.size, cornerRadius: 3.0, isPressed: isPressed)
    }

    fileprivate func draw3DButtonWithColor(_ color: UIColor, buttonSize: CGSize, cornerRadius: CGFloat, isPressed: Bool) {
        layer.borderWidth = 0.0

        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0
        color.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)

        let color2 = UIColor(hue: hue, saturation: saturation, brightness: 0.4, alpha: alpha)

        let downY = buttonSize.height * 0.1
        let mainSectionSize = CGSize(width: buttonSize.width, height: buttonSize.height - downY)
        let upY = !isPressed ? 0 : downY * 0.75

        let rect2 = CGRect(x: 0, y: downY, width: mainSectionSize.width, height: mainSectionSize.height)
        let rectangle2Path = UIBezierPath(roundedRect: rect2, cornerRadius: cornerRadius)
        color2.setFill()
        rectangle2Path.fill()

        let rect = CGRect(x: 0, y: upY, width: mainSectionSize.width, height: mainSectionSize.height)
        let rectanglePath = UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius)
        color.setFill()
        rectanglePath.fill()
    }
}
