//
//  MultiStageButton.swift
//
//  This is a button that increments then wraps around every time you click
//  You need to provide elements for each stage of the button
//
//  Created by Jeff Cooper on 9/20/21.
//

import UIKit

@IBDesignable
public class MultiStageButton: ButtonBase {

    public var stageValue: Int = 0
    @IBInspectable public var numberOfStages: Int = 3
    @IBInspectable public var offImage: UIImage?
    @IBInspectable public var offColour: UIColor?
    @IBInspectable public var highlightImage: UIImage?
    @IBInspectable public var highlightColour: UIColor?
    public var stageImages = [UIImage]()
    public var stageBGColours: [UIColor] = [.green, .yellow, .red]
    public var multiStageCallback: (Int) -> Void = { _ in }

    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if let highlightImage = highlightImage {
            updateImage(image: highlightImage)
        }
        if let highlightColour = highlightColour {
            backgroundColor = highlightColour
        }
        setNeedsDisplay()
    }

    override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        let newValue = (stageValue + 1) % numberOfStages
        stageValue = newValue
        multiStageCallback(stageValue)
        refreshUIState()
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        refreshUIState()
    }

    public func refreshUIState() {
        updateButtonVisualState(value: stageValue)
        if let offImage = offImage {
            updateImage(image: offImage)
        }
        if let offColour = offColour {
            backgroundColor = offColour
        }
    }

    public func updateButtonVisualState(value: Int) {
        if value >= numberOfStages {
            print("cannot set stage to \(value), thats greater than \(numberOfStages) stages")
            return
        }
        if value >= stageImages.count && value >= stageBGColours.count {
            print("cannot set stage to \(value), thats greater than images (\(stageImages.count)) or colours (\(stageBGColours.count)) available stages")
            return
        }
        if value < stageImages.count {
            updateImage(image: stageImages[value])
        }
        if value < stageBGColours.count {
            backgroundColor = stageBGColours[value]
        }
    }
}

