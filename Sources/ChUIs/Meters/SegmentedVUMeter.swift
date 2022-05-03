//
//  SegmentedVUMeter.swift
//  VHS Synth
//
//  Created by Jeff Cooper on 2/11/22.
//

import UIKit

@IBDesignable
public class SegmentedVUMeter: UIView {
    
    @IBInspectable var spacingInPx: CGFloat = 3
    
    func setOnImages(_ onImages: [UIImage]) {
        self.onImages = onImages
    }
    
    func setOffImages(_ offImages: [UIImage]) {
        self.offImages = offImages
    }
    
    public var value: Float = 0.0 {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    private var onImages: [UIImage]?
    private var offImages: [UIImage]?
    private var cachedResizedOnImages = [UIImage]()
    private var cachedResizedOffImages = [UIImage]()
    
    // Cache the images so we don't have to re-compute sizes on every frame
    private func cacheImages() {
        guard let onImages = onImages, let offImages = offImages
        else { return }
        let cachedOnImages = onImages.compactMap({getResizedImage($0, for: frame.size, spacing: spacingInPx, numberOfElements: UInt(onImages.count)) })
        let cachedOffImages = offImages.compactMap({getResizedImage($0, for: frame.size, spacing: spacingInPx, numberOfElements: UInt(onImages.count)) })
        guard cachedOnImages.count > 0, cachedOffImages.count > 0, cachedOnImages.count == cachedOffImages.count
        else { return }
        self.cachedResizedOnImages = cachedOnImages
        self.cachedResizedOffImages = cachedOffImages
    }
    
    private func getResizedImage(_ image: UIImage, for frame: CGSize, spacing: CGFloat, numberOfElements: UInt) -> UIImage? {
        let imageHeight: CGFloat = (frame.height - (spacing * CGFloat(numberOfElements - 1))) / CGFloat(numberOfElements)
        let imageWidth = frame.width
        return try? image.resized(to: CGSize(width: imageWidth, height: imageHeight), with: .uiKit)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        cacheImages()
    }

    public override func draw(_ rect: CGRect) {
        drawVUMeter(frame: CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height), resizing: .aspectFit,
                    value: CGFloat(value),
                    onImages: cachedResizedOnImages, offImages: cachedResizedOffImages, spacing: spacingInPx)
    }
    
    private func drawVUMeter(frame targetFrame: CGRect,
                             resizing: ResizingBehavior = .aspectFit, value: CGFloat = 0.333,
                             onImages: [UIImage], offImages:[UIImage], spacing: CGFloat = 3) {
        guard onImages.count == offImages.count
        else { fatalError("onImages must equal offImages (\(onImages.count) vs \(offImages.count)")}
        
        let numberOfLEDs = onImages.count
        
        //// General Declarations
        let context = UIGraphicsGetCurrentContext()!
       
        let minThreshold = 1.0 / CGFloat(numberOfLEDs + 1)
        
        let sectionHeight: CGFloat = targetFrame.height / CGFloat(numberOfLEDs)
        let capSectionHeight: CGFloat = sectionHeight - (spacing / 2)
        let interiorSectionHeight: CGFloat = (targetFrame.height - (capSectionHeight * 2)) / (CGFloat(numberOfLEDs) - 2.0)
        let imageHeight: CGFloat = (targetFrame.height - (spacing * CGFloat(numberOfLEDs - 1))) / CGFloat(numberOfLEDs)
        let imageWidth = targetFrame.size.width
        
        var y = targetFrame.height - capSectionHeight
        for i in 0..<numberOfLEDs {
            let i = Int(i)
            let threshold = minThreshold * CGFloat(i + 1)
            let image = value > threshold ? onImages[i] : offImages[i]
            var yOffset: CGFloat = 0
            if i == 0 { yOffset = spacing * 0.5 }                        // lowest
            else if i == numberOfLEDs - 1 { yOffset = spacing * 0.5 }    // highest
            else { yOffset = spacing * 0.5 }                             // all others
            let rect = CGRect(x: 0, y: y + yOffset, width: imageWidth, height: imageHeight)
            let mask = UIBezierPath(rect: rect)
            context.saveGState()
            mask.addClip()
            if let cgImage = image.cgImage {
                context.draw(cgImage, in: rect, byTiling: true)
            }
            context.restoreGState()
            y -= interiorSectionHeight
        }
    }
    
    @objc(SegmentedVUMeterResizingBehavior)
    public enum ResizingBehavior: Int {
        case aspectFit /// The content is proportionally resized to fit into the target rectangle.
        case aspectFill /// The content is proportionally resized to completely fill the target rectangle.
        case stretch /// The content is stretched to match the entire target rectangle.
        case center /// The content is centered in the target rectangle, but it is NOT resized.

        public func apply(rect: CGRect, target: CGRect) -> CGRect {
            if rect == target || target == CGRect.zero {
                return rect
            }

            var scales = CGSize.zero
            scales.width = abs(target.width / rect.width)
            scales.height = abs(target.height / rect.height)

            switch self {
                case .aspectFit:
                    scales.width = min(scales.width, scales.height)
                    scales.height = scales.width
                case .aspectFill:
                    scales.width = max(scales.width, scales.height)
                    scales.height = scales.width
                case .stretch:
                    break
                case .center:
                    scales.width = 1
                    scales.height = 1
            }

            var result = rect.standardized
            result.size.width *= scales.width
            result.size.height *= scales.height
            result.origin.x = target.minX + (target.width - result.width) / 2
            result.origin.y = target.minY + (target.height - result.height) / 2
            return result
        }
    }

}
