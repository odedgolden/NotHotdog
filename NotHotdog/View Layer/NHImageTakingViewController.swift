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
    
    var previewLayer : AVCaptureVideoPreviewLayer!
    var activeInput : AVCaptureDeviceInput!
    let photoOutput = AVCapturePhotoOutput()
    
    var focusMatker : UIImageView!
    var exposureMarker : UIImageView!
    var resetMarker : UIImageView!
    private var adjustingExposureContext = ""
    
    @IBOutlet weak var cameraPreview: UIView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        cameraManager.delegate = self

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
