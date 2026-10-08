import Foundation
import CoreImage.CIFilterBuiltins
import UIKit
import SwiftUI

struct BarcodeGenerator {
    static func generateCode128(from string: String) -> UIImage? {
        let trimmed = string.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return nil }
        
        // Taiwan carrier code is ASCII
        guard let data = trimmed.data(using: .ascii) else { return nil }
        
        guard let filter = CIFilter(name: "CICode128BarcodeGenerator") else { return nil }
        filter.setValue(data, forKey: "inputMessage")
        filter.setValue(7.0, forKey: "inputQuietSpace")
        
        guard let outputCIImage = filter.outputImage else { return nil }
        
        let scaleTransform = CGAffineTransform(scaleX: 6.0, y: 6.0)
        let scaledImage = outputCIImage.transformed(by: scaleTransform)
        
        let context = CIContext()
        guard let cgImage = context.createCGImage(scaledImage, from: scaledImage.extent) else { return nil }
        return UIImage(cgImage: cgImage)
    }
}
