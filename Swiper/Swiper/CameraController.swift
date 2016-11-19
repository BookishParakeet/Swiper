//
//  ViewController.swift
//  Swiper
//
//  Created by 李秦琦 on 11/13/16.
//  Copyright © 2016 BookishParakeet. All rights reserved.
//

import UIKit
import Social
import MessageUI
import AVFoundation

class CameraController: UIViewController {
    var stillImageOutput : AVCaptureStillImageOutput?
    var captureSession : AVCaptureSession?
    var previewLayer : AVCaptureVideoPreviewLayer?
    var firstTime: Bool = true
    
    @IBOutlet var cameraView: UIView!
    
    @IBOutlet var pictureImage: UIImageView!

    @IBOutlet var takeAnother: UIButton!
    @IBOutlet var imagePicker: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        let rect = CGRect(origin: CGPoint(x: 50,y :300), size: CGSize(width: 100, height: 100))

//        previewLayer?.frame = cameraView.bounds
//          previewLayer?.frame = self.view.bounds
//        previewLayer?.frame = rect
    }
    
    override func viewDidLayoutSubviews() {
        print ("got into viewdid layout subviews")
        previewLayer?.frame = self.view.bounds;
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        super.viewWillAppear(animated)
        
        captureSession = AVCaptureSession()
        captureSession?.sessionPreset = AVCaptureSessionPreset1920x1080
        
        let backCamera = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        
        var error : NSError?
        var input: AVCaptureDeviceInput!
        do {
            input = try AVCaptureDeviceInput(device: backCamera)
        } catch let error1 as NSError {
            error = error1
            input = nil
        }
        
        if (error == nil && captureSession?.canAddInput(input) != nil){
            
            captureSession?.addInput(input)
            
            stillImageOutput = AVCaptureStillImageOutput()
            stillImageOutput?.outputSettings = [AVVideoCodecKey : AVVideoCodecJPEG]
            
            if (captureSession?.canAddOutput(stillImageOutput) != nil){
                captureSession?.addOutput(stillImageOutput)
                
                previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
                
                previewLayer?.videoGravity = AVLayerVideoGravityResizeAspect
                
                previewLayer?.connection.videoOrientation = AVCaptureVideoOrientation.portrait
                
                          
                cameraView.layer.addSublayer(previewLayer!)
                captureSession?.startRunning()
                
            }
        }
    }
    
    
    func didPressTakePhoto(){
        if let videoConnection = stillImageOutput?.connection(withMediaType: AVMediaTypeVideo){
            videoConnection.videoOrientation = AVCaptureVideoOrientation.portrait
            stillImageOutput?.captureStillImageAsynchronously(from: videoConnection, completionHandler: {
                (sampleBuffer, error) in
                
                if sampleBuffer != nil {
                    
                    
                    let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(sampleBuffer)
                    let dataProvider  = CGDataProvider(data: imageData as! CFData)
                    let cgImageRef = CGImage(jpegDataProviderSource: dataProvider!, decode: nil, shouldInterpolate: true, intent: .defaultIntent )
                    let image = UIImage(cgImage: cgImageRef!, scale: 1.0, orientation: UIImageOrientation.right)
                    
                    self.pictureImage.image = image
                    self.view.bringSubview(toFront: self.imagePicker)
                    self.view.bringSubview(toFront: self.takeAnother)
                }
            })
        }
        self.view.bringSubview(toFront: pictureImage)
    }
    
    var didTakePhoto = Bool()
    func didPressTakeAnother(){
        if didTakePhoto == true{
            didTakePhoto = false
            self.view.sendSubview(toBack: pictureImage)
        }
        else{
            captureSession?.startRunning()
            didTakePhoto = true
            didPressTakePhoto()
        }
    }

    @IBAction func takePhoto(_ sender: AnyObject) {
        if firstTime {
            didPressTakeAnother()
            firstTime = false
        }
    }
   
    @IBAction func takeAnotherPhoto(_ sender: AnyObject) {
        self.pictureImage.image = nil
        didPressTakeAnother()
        firstTime = true
    }
}

