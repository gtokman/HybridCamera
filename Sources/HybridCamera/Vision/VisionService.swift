//
//  SwiftUIView.swift
//  
//
//  Created by Gary Tokman on 1/2/21.
//

import Foundation
import Vision

public class VisionService {
    
    static public let shared = VisionService()
    
    lazy var detectBarcodeRequest = VNDetectBarcodesRequest { request, error in
        guard error == nil else {
            Swift.print("ERROR: creating barcode request: \(error?.localizedDescription).")
            return
        }
        self.processClassification(request)
    }
    
    func processClassification(_ request: VNRequest) {
        // 1
        guard let barcodes = request.results else { return }
        DispatchQueue.main.async { [self] in
            for barcode in barcodes {
                guard
                    // TODO: Check for QR Code symbology and confidence score
                    let potentialQRCode = barcode as? VNBarcodeObservation
                else { return }
                
                //              // 3
                //              showAlert(
                //                withTitle: potentialQRCode.symbology.rawValue,
                //                // TODO: Check the confidence score
                //                message: potentialQRCode.payloadStringValue ?? "" )
                //            }
                Swift.print("Code: \(potentialQRCode.symbology.rawValue)")
                Swift.print("Value: \(potentialQRCode.payloadStringValue ?? "none")")
            }
        }
    }
}
