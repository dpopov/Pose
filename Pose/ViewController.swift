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
    
    var captureDevice : AVCaptureDevice?
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        showCamera()
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    func showCamera(){
        let session = AVCaptureSession()
        session.sessionPreset = AVCaptureSessionPresetPhoto
        
        let viewLayer = self.view.layer
        
        let captureVideoPreviewLayer = AVCaptureVideoPreviewLayer(session: session)
        captureVideoPreviewLayer.frame = viewLayer.bounds;
        captureVideoPreviewLayer.videoGravity = AVLayerVideoGravityResize
        viewLayer.addSublayer(captureVideoPreviewLayer);
        var input : AVCaptureDeviceInput?
        captureDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        do {
            input = try AVCaptureDeviceInput(device: captureDevice)
        }catch _ {
            print("Error With Input")
        }
        
        if (input != nil){
            session.addInput(input)
            let stillImageOutput = AVCaptureStillImageOutput()
            session.addOutput(stillImageOutput)
            session.startRunning()
            if (captureDevice!.hasFlash && captureDevice!.hasTorch){
             addFlash()
            }
            addFilmRoll()
        }
    }
    
    func addFlash (){
        let flash = UIButton(frame: CGRectMake(20, 30, 32, 32))
        flash.setImage(UIImage(named: "flash")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate), forState:.Normal)
        flash.imageView?.tintColor = .whiteColor()
        flash.layer.cornerRadius = 16
        flash.layer.borderColor = UIColor.whiteColor().CGColor
        flash.layer.borderWidth = 2
        flash.addTarget(self, action: Selector("toggleTorch"), forControlEvents:.TouchUpInside)
        self.view.addSubview(flash)
    }
    
    func addFilmRoll (){
        let filmRoll = UIButton(frame: CGRectMake(20, CGRectGetMaxY(self.view.bounds)-80, 50,50))
        filmRoll.setImage(UIImage(named: "film"), forState:.Normal)
//        filmRoll.addTarget(self, action: Selector("toggleTorch"), forControlEvents:.TouchUpInside)
        self.view.addSubview(filmRoll)
    }
    
    
    
    func toggleTorch () {
        do {
            try captureDevice?.lockForConfiguration()
            if (captureDevice!.torchActive) {
                captureDevice?.torchMode = .Off
                captureDevice?.flashMode = .Off
            }else{
                captureDevice?.torchMode = .On
                captureDevice?.flashMode = .On
            }
            
            captureDevice?.unlockForConfiguration()
            
        }catch _ {
            print("Error With Device")
        }
        
        
    }
}

