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
                    print("✅ Code128 바코드 생성 성공: \(string)")
                    return UIImage(cgImage: cgImage)
                }
            }
        }
        
        print("❌ Code128 바코드 생성 실패: \(string)")
        return nil
    }
    
    /// EAN-13 바코드 이미지 생성 (13자리 숫자) - Fallback 포함
    static func generateEAN13Barcode(from string: String) -> UIImage? {
        // EAN-13는 정확히 13자리 숫자여야 함
        guard string.count == 13, string.allSatisfy({ $0.isNumber }) else {
            print("❌ EAN-13 입력 검증 실패: \(string) (길이: \(string.count))")
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
                    print("✅ EAN-13 바코드 생성 성공: \(string)")
                    return UIImage(cgImage: cgImage)
                }
            }
        }
        
        print("⚠️ EAN-13 바코드 생성 실패, Code128로 대체: \(string)")
        // EAN-13 생성 실패 시 Code128로 대체
        return generateCode128Barcode(from: string)
    }
    
    /// EAN-8 바코드 이미지 생성 (8자리 숫자) - Fallback 포함
    static func generateEAN8Barcode(from string: String) -> UIImage? {
        // EAN-8는 정확히 8자리 숫자여야 함
        guard string.count == 8, string.allSatisfy({ $0.isNumber }) else {
            print("❌ EAN-8 입력 검증 실패: \(string) (길이: \(string.count))")
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
                    print("✅ EAN-8 바코드 생성 성공: \(string)")
                    return UIImage(cgImage: cgImage)
                }
            }
        }
        
        print("⚠️ EAN-8 바코드 생성 실패, Code128로 대체: \(string)")
        // EAN-8 생성 실패 시 Code128로 대체
        return generateCode128Barcode(from: string)
    }
    
    /// 자동으로 적절한 바코드 형식 선택하여 생성 (견고한 Fallback 포함)
    static func generateBarcode(from string: String) -> UIImage? {
        print("🔄 바코드 생성 시도: '\(string)' (길이: \(string.count))")
        
        // 빈 문자열 검사
        guard !string.isEmpty else {
            print("❌ 빈 문자열로 바코드 생성 불가")
            return nil
        }
        
        // 숫자만 포함된 경우 EAN 바코드 시도 (실패 시 자동으로 Code128로 대체됨)
        if string.allSatisfy({ $0.isNumber }) {
            if string.count == 13 {
                print("📋 13자리 숫자 감지, EAN-13 시도")
                return generateEAN13Barcode(from: string)
            } else if string.count == 8 {
                print("📋 8자리 숫자 감지, EAN-8 시도")
                return generateEAN8Barcode(from: string)
            } else {
                print("📋 \(string.count)자리 숫자 감지, Code128 사용")
                return generateCode128Barcode(from: string)
            }
        }
        
        // 문자가 포함된 경우 Code128 사용
        print("📋 문자 포함 감지, Code128 사용")
        return generateCode128Barcode(from: string)
    }
    
    /// 바코드 이미지를 Data로 변환
    static func barcodeImageData(from string: String) -> Data? {
        guard let image = generateBarcode(from: string) else { 
            print("❌ 바코드 이미지 Data 변환 실패: \(string)")
            return nil 
        }
        
        let data = image.pngData()
        print("✅ 바코드 이미지 Data 변환 성공: \(string)")
        return data
    }
    
    /// 실제로 사용된 바코드 형식 반환 (UI 표시용)
    static func getActualBarcodeFormat(from string: String) -> String {
        guard !string.isEmpty else { return "Invalid" }
        
        if string.allSatisfy({ $0.isNumber }) {
            if string.count == 13 {
                // EAN-13 생성을 시도해보고 실패하면 Code128로 표시
                let data = Data(string.utf8)
                if let filter = CIFilter(name: "CIEAN13BarcodeGenerator") {
                    filter.setValue(data, forKey: "inputMessage")
                    if let outputImage = filter.outputImage {
                        let context = CIContext()
                        if context.createCGImage(outputImage, from: outputImage.extent) != nil {
                            return "EAN-13"
                        }
                    }
                }
                return "Code128" // EAN-13 실패 시
            } else if string.count == 8 {
                // EAN-8 생성을 시도해보고 실패하면 Code128로 표시
                let data = Data(string.utf8)
                if let filter = CIFilter(name: "CIEAN8BarcodeGenerator") {
                    filter.setValue(data, forKey: "inputMessage")
                    if let outputImage = filter.outputImage {
                        let context = CIContext()
                        if context.createCGImage(outputImage, from: outputImage.extent) != nil {
                            return "EAN-8"
                        }
                    }
                }
                return "Code128" // EAN-8 실패 시
            }
        }
        
        return "Code128"
    }
} 