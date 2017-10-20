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

class NHImageTakingViewController: UIViewController, NHCameraManagerDelegate {

    let cameraManager = NHCameraManager()
    let predictionManager = NHPredictionManager()
    
    let cameraSession = AVCaptureSession()
    var previewLayer : AVCaptureVideoPreviewLayer!
    var activeInput : AVCaptureDeviceInput!
    let photoOutput = AVCapturePhotoOutput()
    
    @IBOutlet weak var cameraPreview: UIView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        cameraManager.delegate = self
        
        setupSession()
        setupPreview()
        self.cameraSession.startRunning()
    }
    
    private func setupSession(){
        cameraSession.sessionPreset = .high
        let camera = AVCaptureDevice.default(for: .video)
        if camera != nil {
            do {
                let input = try AVCaptureDeviceInput(device: camera!)
                if cameraSession.canAddInput(input){
                    cameraSession.addInput(input)
                    activeInput = input
                }
                if cameraSession.canAddOutput(photoOutput){
                    cameraSession.addOutput(photoOutput)
                }
            }
            catch
            {
                print("Error setting input: \(error)")
            }
            
        }
    }
    
    private func setupPreview()
    {
        previewLayer = AVCaptureVideoPreviewLayer(session: cameraSession)
        previewLayer.frame = cameraPreview.bounds
        previewLayer.videoGravity = .resizeAspectFill
        cameraPreview.layer.addSublayer(previewLayer)
    }
    
    func imageCaptured(image: UIImage)
    {
        print("Captured Image")
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
