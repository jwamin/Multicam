//
//  CameraView.swift
//  Trois-cam
//
//  Created by Joss Manger on 1/19/20.
//  Copyright © 2020 Joss Manger. All rights reserved.
//

import SwiftUI
import AVFoundation

struct CameraView: View {
  
  let color:Color
  var session: AVCaptureMultiCamSession? = nil
  var index:Int?
  
    var body: some View {
     
      if session != nil && index != nil {
        return AnyView(LayerView(session: session!, index: index!))
      }
      
      return AnyView(Rectangle().fill(color).frame(minWidth: 0, idealWidth: .infinity, maxWidth: .infinity, minHeight: 0, idealHeight: .infinity, maxHeight: .infinity))
      
    }
}

struct CameraView_Previews: PreviewProvider {
    static var previews: some View {
      CameraView(color: .black)
    }
}
