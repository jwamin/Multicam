//
//  CameraController.swift
//  Trois-cam
//
//  Created by Joss Manger on 1/19/20.
//  Copyright © 2020 Joss Manger. All rights reserved.
//

import UIKit
import AVFoundation
import Combine

class CameraController {
  
  private var session: AVCaptureMultiCamSession!

  var captureSession: AVCaptureMultiCamSession? {
    return self.session
  }
  
  static func addConnection(session: AVCaptureMultiCamSession,layer: AVCaptureVideoPreviewLayer, index: Int){
    
    layer.videoGravity = .resizeAspectFill
    layer.setSessionWithNoConnection(session)
    
    let videoPort = session.inputs[index].ports.first!
    
    let connection = MyConnection(inputPort: videoPort, videoPreviewLayer: layer)

    session.addConnection(connection)
    
  }
  
  var anyCan:AnyCancellable!
  
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
    
      UIDevice.current.beginGeneratingDeviceOrientationNotifications()
    
      session.addOutput(output)
      session.commitConfiguration()
      
      session.startRunning()
  
    anyCan = NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification).sink { (notification) in
      print(UIDevice.current.orientation)
      
      for connection in self.session.connections{
      
        switch UIDevice.current.orientation{
        case .landscapeLeft:
          connection.videoOrientation = .landscapeRight
        case .landscapeRight:
          connection.videoOrientation = .landscapeLeft
        case .portraitUpsideDown:
          connection.videoOrientation = .portraitUpsideDown
        default:
          connection.videoOrientation = .portrait
        }
      
      }
      
      
      }
      
//      func angleOffsetFromPortraitOrientation(at position: AVCaptureDevice.Position) -> Double {
//        switch self {
//        case .portrait:
//          return position == .front ? .pi : 0
//        case .portraitUpsideDown:
//          return position == .front ? 0 : .pi
//        case .landscapeRight:
//          return -.pi / 2.0
//        case .landscapeLeft:
//          return .pi / 2.0
//        default:
//          return 0
//        }
//      }
      
    
    #endif
    
  }
  
  
  
}


class MyConnection : AVCaptureConnection {
  
  override var videoMaxScaleAndCropFactor: CGFloat {
    return 2.0
  }
  
}
