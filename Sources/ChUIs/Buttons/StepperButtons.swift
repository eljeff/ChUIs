//
//  OctaveStepper.swift
//  
//
//  Created by Jeff Cooper on 8/4/21.
//

import UIKit

@IBDesignable
open class StepperButtons: UIView {

    public var delegate: StepperDelegate?
    @IBInspectable public var upOnImage: UIImage? = nil
    @IBInspectable public var upOffImage: UIImage? = nil
    @IBInspectable public var downOnImage: UIImage? = nil
    @IBInspectable public var downOffImage: UIImage? = nil
    @IBInspectable public var buttonOnColor: UIColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
    @IBInspectable public var buttonOffColor: UIColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
    @IBInspectable public var textBackgroundColor: UIColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
    @IBInspectable public var textColor: UIColor = .white
    @IBInspectable public var fontScale: CGFloat = 0.6
    public var dnButton: MomentaryButton!
    public var upButton: MomentaryButton!
    private var textLabel: ScaledLabel!
    private var currentValue: Int = 0
    private var minValue: Int = -3
    private var maxValue: Int = 3

    private var usableWidth: CGFloat {
        return round(frame.width - layer.borderWidth)
    }
    
    private var buttonWidth: CGFloat {
        return ceil((usableWidth - layer.borderWidth) / 3)
    }

    private var labelWidth: CGFloat {
        return usableWidth - (buttonWidth * 2)
    }
    
    private func initButtons() {
        dnButton = MomentaryButton(frame: CGRect(x: 0, y: 0,
                                                 width: buttonWidth, height: frame.height))
        textLabel = ScaledLabel(frame: CGRect(x: buttonWidth, y: 0,
                                              width: labelWidth, height: frame.height))
        upButton = MomentaryButton(frame: CGRect(x: buttonWidth + labelWidth, y: 0,
                                                 width: buttonWidth, height: frame.height))
    }

    override public init(frame: CGRect) {
        super.init(frame: frame)
        initButtons()
        addAllViews()
        initFunctions()
    }

    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        initButtons()
        addAllViews()
        initFunctions()
    }

    public override func layoutSubviews() {
        updateIBVars()
        super.layoutSubviews()
        resizeSubViews()
    }

    private func refreshUI() {
        textLabel.text = "\(currentValue)"
        resizeSubViews()
    }

    private func resizeSubViews() {
        dnButton.frame = CGRect(x: 0, y: 0,
                                width: buttonWidth, height: frame.height)
        textLabel.frame = CGRect(x: buttonWidth, y: 0,
                                 width: labelWidth, height: frame.height)
        upButton.frame = CGRect(x: buttonWidth + labelWidth, y: 0,
                                width: buttonWidth, height: frame.height)
        setNeedsDisplay()
    }

    private func addAllViews() {
        addSubview(dnButton)
        addSubview(textLabel)
        addSubview(upButton)
    }

    private func initFunctions() {
        textLabel.text = "0"
        textLabel.textAlignment = .center
        dnButton.callback = { [weak self] isPressed in
            if isPressed {
                self?.stepDownValue()
            }
        }
        upButton.callback = { [weak self] isPressed in
            if isPressed {
                self?.stepUpValue()
            }
        }
    }

    private func updateIBVars() {
        textLabel.backgroundColor = textBackgroundColor
        textLabel.textColor = textColor
        dnButton.onColor = buttonOnColor
        dnButton.offColor = buttonOffColor
        dnButton.onImage = downOnImage
        dnButton.offImage = downOffImage
        upButton.onImage = upOnImage
        upButton.offImage = upOffImage
        upButton.onColor = buttonOnColor
        upButton.offColor = buttonOffColor
        textLabel.fontScale = fontScale
    }

    private func stepDownValue() {
        currentValue = max(minValue, currentValue - 1)
        delegate?.stepperValueChanged(stepper: self, currentValue: currentValue)
        refreshUI()
    }

    private func stepUpValue() {
        currentValue = min(maxValue, currentValue + 1)
        delegate?.stepperValueChanged(stepper: self, currentValue: currentValue)
        refreshUI()
    }
}

public protocol StepperDelegate {
    func stepperValueChanged(stepper: StepperButtons, currentValue: Int)
}

