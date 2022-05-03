//
//  RepeatedImageVUMeter.swift
//  VHS Synth
//
//  Created by Jeff Cooper on 2/14/22.
//

import UIKit
@IBDesignable
public class RepeatedImageVUMeter: SegmentedVUMeter {
    
    @IBInspectable var numberOfLEDs: UInt = 9 {
        didSet {
            resetOnImages()
            resetOffImages()
        }
    }
    
    @IBInspectable var ledOnImage: UIImage? { didSet { resetOnImages() } }
    @IBInspectable var ledOffImage: UIImage? { didSet { resetOnImages() } }
    
    private func resetOnImages() {
        guard let image = getAlteredImage(image: ledOnImage)
        else { return }
        var images = [UIImage]()
        for _ in 0..<numberOfLEDs {
            images.append(image)
        }
        setOnImages(images)
    }
    
    private func resetOffImages() {
        guard let image = getAlteredImage(image: ledOffImage, alpha: 0.3)
        else { return }
        var images = [UIImage]()
        for _ in 0..<numberOfLEDs {
            images.append(image)
        }
        setOffImages(images)
    }
    
    private func getAlteredImage(image: UIImage?, alpha: CGFloat = 1.0) -> UIImage? {
        var ignoreTint = true
        if (image?.isSymbolImage ?? true) {
            ignoreTint = false
        }
        let tintedOnImage = ignoreTint ? image : image?.withTintColor(tintColor)
        return tintedOnImage ?? UIImage(systemName: "rectangle.fill")?.withTintColor(tintColor.withAlphaComponent(alpha))
    }
    
}
