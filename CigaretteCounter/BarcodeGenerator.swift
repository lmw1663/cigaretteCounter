import Foundation
import CoreImage
import CoreImage.CIFilterBuiltins
import UIKit

struct BarcodeGenerator {
    
    /// Code128 바코드 이미지 생성
    static func generateCode128Barcode(from string: String) -> UIImage? {
        let data = Data(string.utf8)
        
        if let filter = CIFilter(name: "CICode128BarcodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            
            if let outputImage = filter.outputImage {
                // 바코드 크기 조정 (3배 확대)
                let transform = CGAffineTransform(scaleX: 3, y: 3)
                let scaledImage = outputImage.transformed(by: transform)
                
                // CIImage를 UIImage로 변환
                let context = CIContext()
                if let cgImage = context.createCGImage(scaledImage, from: scaledImage.extent) {
                    return UIImage(cgImage: cgImage)
                }
            }
        }
        
        return nil
    }
    
    /// EAN-13 바코드 이미지 생성 (13자리 숫자)
    static func generateEAN13Barcode(from string: String) -> UIImage? {
        // EAN-13는 정확히 13자리 숫자여야 함
        guard string.count == 13, string.allSatisfy({ $0.isNumber }) else {
            return nil
        }
        
        let data = Data(string.utf8)
        
        if let filter = CIFilter(name: "CIEAN13BarcodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            
            if let outputImage = filter.outputImage {
                let transform = CGAffineTransform(scaleX: 3, y: 3)
                let scaledImage = outputImage.transformed(by: transform)
                
                let context = CIContext()
                if let cgImage = context.createCGImage(scaledImage, from: scaledImage.extent) {
                    return UIImage(cgImage: cgImage)
                }
            }
        }
        
        return nil
    }
    
    /// EAN-8 바코드 이미지 생성 (8자리 숫자)
    static func generateEAN8Barcode(from string: String) -> UIImage? {
        // EAN-8는 정확히 8자리 숫자여야 함
        guard string.count == 8, string.allSatisfy({ $0.isNumber }) else {
            return nil
        }
        
        let data = Data(string.utf8)
        
        if let filter = CIFilter(name: "CIEAN8BarcodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            
            if let outputImage = filter.outputImage {
                let transform = CGAffineTransform(scaleX: 3, y: 3)
                let scaledImage = outputImage.transformed(by: transform)
                
                let context = CIContext()
                if let cgImage = context.createCGImage(scaledImage, from: scaledImage.extent) {
                    return UIImage(cgImage: cgImage)
                }
            }
        }
        
        return nil
    }
    
    /// 자동으로 적절한 바코드 형식 선택하여 생성
    static func generateBarcode(from string: String) -> UIImage? {
        // 숫자만 포함된 경우
        if string.allSatisfy({ $0.isNumber }) {
            if string.count == 13 {
                return generateEAN13Barcode(from: string)
            } else if string.count == 8 {
                return generateEAN8Barcode(from: string)
            }
        }
        
        // 기본적으로 Code128 사용 (문자, 숫자 모두 지원)
        return generateCode128Barcode(from: string)
    }
    
    /// 바코드 이미지를 Data로 변환
    static func barcodeImageData(from string: String) -> Data? {
        guard let image = generateBarcode(from: string) else { return nil }
        return image.pngData()
    }
} 