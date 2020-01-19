//
//  LayerController.swift
//  Trois-cam
//
//  Created by Joss Manger on 1/19/20.
//  Copyright © 2020 Joss Manger. All rights reserved.
//

import UIKit
import SwiftUI
import Combine
import AVFoundation

class PreviewView: UIView {
  
  let session: AVCaptureMultiCamSession
  let index: Int
  
  init(session:AVCaptureMultiCamSession, index: Int){
    self.session = session
    self.index = index
    super.init(frame: .zero)
    
    session.beginConfiguration()
    videoPreviewLayer.videoGravity = .resizeAspectFill
    videoPreviewLayer.setSessionWithNoConnection(session)
    
    let videoPort = session.inputs[index].ports.first!
    
    let connection = MyConnection(inputPort: videoPort, videoPreviewLayer: videoPreviewLayer)
    
    print(connection,connection.videoMaxScaleAndCropFactor)
    connection.isEnabled = true

    session.addConnection(connection)
    
    print(session.connections)
    session.commitConfiguration()
    
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
    override class var layerClass: AnyClass {
        return AVCaptureVideoPreviewLayer.self
    }
    
    /// Convenience wrapper to get layer as its statically known type.
    var videoPreviewLayer: AVCaptureVideoPreviewLayer {
        return layer as! AVCaptureVideoPreviewLayer
    }
}

struct LayerView : UIViewRepresentable {
  
  var session: AVCaptureMultiCamSession
  var index: Int
  
  func makeUIView(context: UIViewRepresentableContext<LayerView>) -> PreviewView {
    return PreviewView(session: session, index: index)
  }
  
  func updateUIView(_ uiView: PreviewView, context: UIViewRepresentableContext<LayerView>) {
    //
  }
  
  typealias UIViewType = PreviewView
  
}
