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
    
    @IBOutlet weak var filmButton: UIButton!
    @IBOutlet weak var poseButton: UIButton!
    @IBOutlet weak var flashButton: UIButton!
    var captureDevice : AVCaptureDevice?
    var captureVideoPreviewLayer : AVCaptureVideoPreviewLayer?
    var currentPoseStanding : Bool = true
    var character : UIImageView?
    var photoCaptureOutput : AVCaptureStillImageOutput?
    var rollBadgeCount : UIView?
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        showCamera()
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    func updateBadge(){
        
    }
    
    func showCamera(){
        let session = AVCaptureSession()
        session.sessionPreset = AVCaptureSessionPresetPhoto
        
        let viewLayer = self.view.layer
        
        captureVideoPreviewLayer = AVCaptureVideoPreviewLayer(session: session)
        captureVideoPreviewLayer!.frame = viewLayer.bounds;
        captureVideoPreviewLayer!.videoGravity = AVLayerVideoGravityResize
        viewLayer.insertSublayer(captureVideoPreviewLayer!, atIndex: 0);
        var input : AVCaptureDeviceInput?
        captureDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        do {
            input = try AVCaptureDeviceInput(device: captureDevice)
        }catch _ {
            print("Error With Input")
        }
        
        if (input != nil){
            session.addInput(input)
            photoCaptureOutput = AVCaptureStillImageOutput()
            photoCaptureOutput?.outputSettings = [AVVideoCodecKey: AVVideoCodecJPEG]
            session.addOutput(photoCaptureOutput)
            session.startRunning()
            addCharacter()
            if (captureDevice!.hasFlash && captureDevice!.hasTorch){
                addFlash()
            }
        }
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        if let layer = captureVideoPreviewLayer {
            var frame = layer.frame; frame.size = size
            
            switch UIDevice.currentDevice().orientation {
            case UIDeviceOrientation.Portrait:
                layer.connection.videoOrientation = AVCaptureVideoOrientation.Portrait
            case UIDeviceOrientation.LandscapeLeft:
                layer.connection.videoOrientation = AVCaptureVideoOrientation.LandscapeRight
            case UIDeviceOrientation.LandscapeRight:
                layer.connection.videoOrientation = AVCaptureVideoOrientation.LandscapeLeft
            default:
                layer.connection.videoOrientation = AVCaptureVideoOrientation.Portrait
            }
            coordinator.animateAlongsideTransition({ (UIViewControllerTransitionCoordinatorContext) -> Void in
                layer.frame = frame
                self.character!.center = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds))
                }, completion: { (UIViewControllerTransitionCoordinatorContext) -> Void in
                    
                    
            })
        }
    }
    
    func addCharacter (){
        let width = CGRectGetMaxX(self.view.bounds)*0.8
        character = UIImageView(frame: CGRectMake(0, 0, width, width*(19/10)))
        character!.image = (UIImage(named: "standing"))
        character!.center = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds))
        character?.userInteractionEnabled = true
        character!.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: Selector("handPan:")))
        self.view.addGestureRecognizer(UIPinchGestureRecognizer(target: self, action: Selector("handZoom:")))
        self.view.insertSubview(character!, belowSubview:poseButton)
    }
    
    func handPan(pan: UIPanGestureRecognizer){
        if (pan.state == .Changed){
            let translation = pan.translationInView(self.view)
            var center = character?.center
            center!.x += translation.x; center!.y += translation.y
            character?.center = center!
            pan.setTranslation(CGPointZero, inView: self.view)
        }
    }
    
    func handZoom(pinch: UIPinchGestureRecognizer){
        if (pinch.state == .Changed){
            let scale = pinch.scale
            let transform = CGAffineTransformScale(character!.transform, scale, scale);
            character?.transform = transform
            pinch.scale = 1
        }
    }
    
    func addFlash (){
        flashButton.setImage(UIImage(named: "flash")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate), forState:.Normal)
        flashButton.imageView?.tintColor = .whiteColor()
        flashButton.layer.cornerRadius = 16
        flashButton.layer.borderColor = UIColor.whiteColor().CGColor
        flashButton.layer.borderWidth = 2
        flashButton.hidden = false
    }
    
    @IBAction func togglePose(sender: UIButton) {
        if (currentPoseStanding){
            poseButton.setImage((UIImage(named: "poseStand")), forState:.Normal)
            character!.image =  (UIImage(named: "sitting"))
        }else{
            poseButton.setImage((UIImage(named: "poseSit")), forState:.Normal)
            character!.image =  (UIImage(named: "standing"))
        }
        currentPoseStanding = !currentPoseStanding
    }
    
    @IBAction func toggleTorch(sender: UIButton) {
        do {
            try captureDevice?.lockForConfiguration()
            if (captureDevice!.torchActive) {
                captureDevice?.flashMode = .Off
            }else{
                captureDevice?.flashMode = .On
            }
            
            captureDevice?.unlockForConfiguration()
            
        }catch _ {
            print("Error With Device")
        }
    }
    
    @IBAction func takePicture(sender: AnyObject) {
        if let videoConnection = photoCaptureOutput!.connectionWithMediaType(AVMediaTypeVideo){
            
            photoCaptureOutput!.captureStillImageAsynchronouslyFromConnection(videoConnection, completionHandler: { (buffer:CMSampleBuffer!, error: NSError!) -> Void in
                let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(buffer)
                let image = UIImage(data:imageData)
                var finalRender : UIImage?
                let size = UIScreen.mainScreen().bounds.size
                
                UIGraphicsBeginImageContextWithOptions(size, true, 0.0)
                image?.drawInRect(CGRectMake(0,0,size.width,size.height))
                self.character!.image!.drawInRect(self.character!.frame);
                finalRender = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                Photo.addPhoto(finalRender)
//                UIImageWriteToSavedPhotosAlbum(image!, nil, nil, nil)
                
            })
        }
    }
    
}
