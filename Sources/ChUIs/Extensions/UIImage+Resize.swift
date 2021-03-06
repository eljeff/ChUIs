// From https://gist.githubusercontent.com/eugenebokhan/5e62a0155754ae6aa6c3c13cf1744930/raw/85ebd805d174f2c0865199734be23f29adda734c/CGImage+Resize.swift

import UIKit
import CoreGraphics
import Accelerate

public extension UIImage {

    enum Error: Swift.Error {
        case cgImageCreationFailed
        case imageResizingFailed
    }

    /// Resize image from given size.
    ///
    /// - Parameter maxPixels: Max pixels in the output image. If input image pixel count is less than maxPixels value then it won'n be risezed.
    /// - Parameter resizeTechnique: Technique for image resizing: UIKit / CoreImage / CoreGraphics / ImageIO / Accelerate.
    /// - Returns: Resized image.
    func resized(maxPixels: Int,
                       with resizeTechnique: CGImage.ResizeTechnique) throws -> UIImage {
        let maxPixels = CGFloat(maxPixels)
        let pixelCount = self.size.width
                       * self.size.height
        if pixelCount > maxPixels {
            let sizeRatio = sqrt(maxPixels / pixelCount)
            let newWidth = self.size.width
                         * sizeRatio
            let newHeight = self.size.height
                          * sizeRatio
            let newSize = CGSize(width: newWidth,
                                 height: newHeight)
            return try self.resized(to: newSize,
                                    with: resizeTechnique)
        }
        return self
    }
    
    /// Resize image from given size.
    ///
    /// - Parameter newSize: Size of the image output.
    /// - Parameter resizeTechnique: Technique for image resizing: UIKit / CoreImage / CoreGraphics / ImageIO / Accelerate.
    /// - Returns: Resized image.
    func resized(to newSize: CGSize,
                       with resizeTechnique: CGImage.ResizeTechnique) throws -> UIImage {
        if resizeTechnique == .uiKit {
            return try self.resizeWithUIKit(to: newSize)
        } else {
            guard let cgImage = self.cgImage
            else { throw Error.cgImageCreationFailed }

            return try .init(cgImage: cgImage.resized(to: newSize,
                                                      with: resizeTechnique))
        }
    }
    
    // MARK: - UIKit

    private func resizeWithUIKit(to newSize: CGSize) throws -> UIImage {
        UIGraphicsBeginImageContextWithOptions(newSize,
                                               true,
                                               1.0)
        self.draw(in: .init(origin: .zero,
                            size: newSize))
        guard let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        else { throw Error.imageResizingFailed }
        UIGraphicsEndImageContext()
        
        return resizedImage
    }

}
