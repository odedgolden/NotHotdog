//
//  NHCameraManager.swift
//  NotHotdog
//
//  Created by Oded Golden on 20/10/2017.
//  Copyright © 2017 Oded Golden. All rights reserved.
//

import UIKit
import AVFoundation

protocol NHCameraManagerDelegate : class {
    
    func imageCaptured(image: UIImage)
}

class NHCameraManager: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    private let devicePosition : AVCaptureDevice.Position = .front
    private let sessionQuality : AVCaptureSession.Preset = .medium
    
    private var permissionGranted = false
    private let sessionQueue = DispatchQueue(label: "camera_session_queue")
    private let cameraSession = AVCaptureSession()
    private let context = CIContext()
    
    weak var delegate : NHCameraManagerDelegate?

    override init()
    {
        super.init()
        verifyPremission()
        sessionQueue.async { [unowned self] in
            self.setupSession()
            self.cameraSession.startRunning()
        }
    }
    
    private func verifyPremission()
    {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            permissionGranted = true
        case .notDetermined:
            requestPermission()
        default:
            permissionGranted = false
        }
    }
    
    private func requestPermission()
    {
        sessionQueue.suspend()
        AVCaptureDevice.requestAccess(for: .video) {[unowned self] (permissionGranted) in
            self.permissionGranted = permissionGranted
            self.sessionQueue.resume()
        }
    }
    
    private func setupSession()
    {
        guard permissionGranted else {return}
        cameraSession.sessionPreset = sessionQuality
        guard let captureDevice = selectCaptureDevice() else {return}
        guard let captureDeviceInput = try? AVCaptureDeviceInput(device: captureDevice) else {return}
        guard cameraSession.canAddInput(captureDeviceInput) else {return}
        let videoOutput = AVCaptureVideoDataOutput()
        videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label : "sample_buffer"))
        videoOutput.alwaysDiscardsLateVideoFrames = true
        videoOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA]
        cameraSession.sessionPreset = .high
        guard cameraSession.canAddOutput(videoOutput) else {return}
        cameraSession.addOutput(videoOutput)
        guard let connection = videoOutput.connection(with: .video) else {return}
        guard connection.isVideoOrientationSupported else {return}
        guard connection.isVideoMirroringSupported else {return}
        connection.videoOrientation = .portrait
        connection.isVideoMirrored = devicePosition == .front
    }
    
    private func selectCaptureDevice() -> AVCaptureDevice?
    {
        return AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: .video, position: .front).devices.first
    }
    
    private func imageFromSampleBuffer(sampleBuffer: CMSampleBuffer) -> UIImage?
    {
        guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {return nil}
        let ciImage = CIImage(cvPixelBuffer: imageBuffer)
        guard let cgImage = context.createCGImage(ciImage, from: ciImage.extent) else {return nil}
        return UIImage(cgImage : cgImage)
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let uiImage = imageFromSampleBuffer(sampleBuffer: sampleBuffer) else {return}
        DispatchQueue.main.async{
            self.delegate?.imageCaptured(image: uiImage)
        }
    }
}
