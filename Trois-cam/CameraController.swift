//
//  CameraController.swift
//  Trois-cam
//
//  Created by Joss Manger on 1/19/20.
//  Copyright © 2020 Joss Manger. All rights reserved.
//

import AVFoundation
import Combine

class CameraController {
  
  private var session: AVCaptureMultiCamSession!

  var captureSession: AVCaptureMultiCamSession? {
    return self.session
  }
  
  init() {
    
    #if !targetEnvironment(simulator)
    
    guard AVCaptureMultiCamSession.isMultiCamSupported else {
      print("unsupported")
      return
    }
    
    let sessionDevices:[AVCaptureDevice.DeviceType] = [.builtInWideAngleCamera,.builtInUltraWideCamera,.builtInTrueDepthCamera]
    
      session = AVCaptureMultiCamSession()
      session.beginConfiguration()
        for deviceType in sessionDevices {
          
          let position:AVCaptureDevice.Position = (deviceType == .builtInTrueDepthCamera) ? .front : .back
          
      let device = AVCaptureDevice.default(deviceType, for: .video, position: position)!
      let input = try! AVCaptureDeviceInput(device: device)
      
      session.addInputWithNoConnections(input)
          
    }
      let output = AVCaptureVideoDataOutput()
      //session.sessionPreset = AVCaptureSession.Preset.hd4K3840x2160
      session.addOutput(output)
      session.commitConfiguration()
      
      session.startRunning()
  
    
    #endif
    
  }
  
  
}


class MyConnection : AVCaptureConnection {
  
  override var videoMaxScaleAndCropFactor: CGFloat {
    return 2.0
  }
  
}
