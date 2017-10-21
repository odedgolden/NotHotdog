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

class NHImageTakingViewController: UIViewController, NHCameraManagerDelegate, AVCaptureVideoDataOutputSampleBufferDelegate {

//    let cameraManager = NHCameraManager()
    let predictionManager = NHPredictionManager()
    
    let cameraSession = AVCaptureSession()
    private let sampleBufferQueue = DispatchQueue(label : "sample_buffer")
    var previewLayer : AVCaptureVideoPreviewLayer!
    var activeInput : AVCaptureDeviceInput!
    let photoOutput = AVCapturePhotoOutput()
    let videoOutput = AVCaptureVideoDataOutput()
    
    @IBOutlet weak var cameraPreview: UIView!

    
    override func viewDidLoad()
    {
        super.viewDidLoad()
//        cameraManager.delegate = self
        
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
                    videoOutput.setSampleBufferDelegate(self, queue: sampleBufferQueue)
                    videoOutput.alwaysDiscardsLateVideoFrames = true
                    videoOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA]
                    cameraSession.addOutput(photoOutput)
                    cameraSession.addOutput(videoOutput)

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
   
    @IBAction func captureImagePressed(_ sender: UIButton) {
        capturePhoto()
    }
    
    private func capturePhoto()
    {
        let connection = photoOutput.connection(with: .video)
//        photoOutput.capturePhoto(with: <#T##AVCapturePhotoSettings#>, delegate: <#T##AVCapturePhotoCaptureDelegate#>)
    }
    
    func imageCaptured(image: UIImage)
    {
        print("Captured Image")
    }
    
    public func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection)
    {
        print("yay1")
//        guard let uiImage = imageFromSampleBuffer(sampleBuffer: sampleBuffer) else {return}
//        DispatchQueue.main.async{
//            self.delegate?.imageCaptured(image: uiImage)
//        }
    }
    
    public func captureOutput(_ output: AVCaptureOutput, didDrop sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection){
        print("yay2")
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
