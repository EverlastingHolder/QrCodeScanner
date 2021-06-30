//
//  QrScannerCoordinator.swift
//  QrCodeScanner
//
//  Created by Роман Мошковцев on 30.06.2021.
//

import Foundation
import AVFoundation

class QrScannerCoordinator: NSObject, AVCaptureMetadataOutputObjectsDelegate {
    var parent: QrScannerView
    var codesFound: String
    var isFinishScanning = false
    var lastTime = Date(timeIntervalSince1970: 0)

    init(parent: QrScannerView) {
        self.parent = parent
        self.codesFound = String()
    }

    func metadataOutput(
        _ output: AVCaptureMetadataOutput,
        didOutput metadataObjects: [AVMetadataObject],
        from connection: AVCaptureConnection) {
        
        if let metadataObject = metadataObjects.first {
            guard let readObject = metadataObject as?
                    AVMetadataMachineReadableCodeObject else { return }
            guard let response = readObject.stringValue else { return }
            guard !isFinishScanning else { return }
            found(code: response)
            isFinishScanning = true
        }
    }
    
    func found(code: String) {
        parent.completion(.success(code))
    }

    func didFail(reason: ScanError) {
        parent.completion(.failure(reason))
    }
}
