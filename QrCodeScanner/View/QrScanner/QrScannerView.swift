//
//  QrScannerView.swift
//  QrCodeScanner
//
//  Created by Роман Мошковцев on 30.06.2021.
//

import SwiftUI
import AVFoundation

struct QrScannerView: UIViewControllerRepresentable {
    
    let scanInterval: Double
    let codeTypes: [AVMetadataObject.ObjectType]
    var completion: (Result<String, ScanError>) -> Void

     init(
        scanInterval: Double = 2.0,
        codeTypes: [AVMetadataObject.ObjectType],
        completion: @escaping (Result<String, ScanError>) -> Void)
     {
        self.scanInterval = scanInterval
        self.codeTypes = codeTypes
        self.completion = completion
    }

     func makeCoordinator() -> QrScannerCoordinator {
        return QrScannerCoordinator(parent: self)
    }

     func makeUIViewController(context: Context) -> QrScannerViewController {
        let viewController = QrScannerViewController()
        viewController.delegate = context.coordinator
        return viewController
    }

     func updateUIViewController(_ vc: QrScannerViewController, context: Context) { }
}
