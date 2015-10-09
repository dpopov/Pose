//
//  ViewController.swift
//  Pose
//
//  Created by Daniel Popov on 10/8/15.
//  Copyright © 2015 Crusoe Ventures. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
import Foundation

class ViewController : UIViewController {
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        showCamera()
    }

    func showCamera(){
        let session = AVCaptureSession.init()
        session.sessionPreset = AVCaptureSessionPresetPhoto
        
        let viewLayer = self.view.layer
        
        let captureVideoPreviewLayer = AVCaptureVideoPreviewLayer.init(session: session)
        NSLog("%@", NSStringFromCGRect(viewLayer.bounds))
        captureVideoPreviewLayer.frame = viewLayer.bounds;
        viewLayer.addSublayer(captureVideoPreviewLayer);
        
        let captureDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        
        let input = try! AVCaptureDeviceInput.init(device:captureDevice);
        
        session.addInput(input)
        
        let stillImageOutput = AVCaptureStillImageOutput.init()
        session.addOutput(stillImageOutput)
        session.startRunning()
    }
    
}

