//
//  NHImageTakingViewController.swift
//  NotHotdog
//
//  Created by Oded Golden on 18/10/2017.
//  Copyright © 2017 Oded Golden. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
import Photos

class NHImageTakingViewController: UIViewController, AVCapturePhotoCaptureDelegate {
    
    let captureSession = AVCaptureSession()
    var previewLayer : AVCaptureVideoPreviewLayer!
    var activeInput : AVCaptureDeviceInput!
    let photoOutput = AVCapturePhotoOutput()
    
    var focusMatker : UIImageView!
    var exposureMarker : UIImageView!
    var resetMarker : UIImageView!
    private var adjustingExposureContext = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSession()
        setupPreview()
        startSession()
    }
    
    func setupSession()
    {
        captureSession.sessionPreset = .high
        let camera = AVCaptureDevice.default(for: .video)

        do {
            let input = try AVCaptureDeviceInput(device : camera!)
            if captureSession.canAddInput(input){
                captureSession.addInput(input)
                activeInput = input
            }
        }
        catch {
            print("Error settig device input: \(error)")
        }

        let settings = AVCapturePhotoSettings()
//        let previewPixelType = settings.availablePreviewPhotoPixelFormatTypes.first!
//        let previewFormat = [
//            kCVPixelBufferPixelFormatTypeKey as String: previewPixelType,
//            kCVPixelBufferWidthKey as String: 160,
//            kCVPixelBufferHeightKey as String: 160
//        ]
//        settings.previewPhotoFormat = previewFormat
//        photoOutput.capturePhoto(with: settings, delegate: self)
//
//        if captureSession.canAddOutput(photoOutput)
//        {
//            captureSession.addOutput(photoOutput)
//        }
    }
    
    func setupPreview(){
        
    }
    
    func startSession(){
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
