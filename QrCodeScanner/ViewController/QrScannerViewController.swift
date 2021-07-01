//
//  QrScannerViewController.swift
//  QrCodeScanner
//
//  Created by Роман Мошковцев on 30.06.2021.
//

import Foundation
import UIKit
import AVFoundation

class QrScannerViewController: UIViewController {
    var delegate: QrScannerCoordinator?
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    let videoCaptureDevice = AVCaptureDevice.default(for: .video)
    let metadataOutput: AVCaptureMetadataOutput = AVCaptureMetadataOutput()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.black
        captureSession = AVCaptureSession()

        guard let videoCaptureDevice = videoCaptureDevice else { return }

        guard let videoInput = try? AVCaptureDeviceInput(device: videoCaptureDevice) else { return }

        if captureSession.canAddInput(videoInput) {
            captureSession.addInput(videoInput)
        } else {
            delegate?.didFail(reason: .badInput)
            return
        }

        if captureSession.canAddOutput(metadataOutput) {
            captureSession.addOutput(metadataOutput)

            metadataOutput.setMetadataObjectsDelegate(delegate, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = delegate?.parent.codeTypes
        } else {
            delegate?.didFail(reason: .badOutput)
            return
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if previewLayer == nil {
            previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        }
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
        
        if (captureSession?.isRunning == false) {
            captureSession.startRunning()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        if (captureSession?.isRunning == true) {
            captureSession.stopRunning()
        }
    }
}
