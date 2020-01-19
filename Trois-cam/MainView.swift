//
//  ContentView.swift
//  Trois-cam
//
//  Created by Joss Manger on 1/19/20.
//  Copyright © 2020 Joss Manger. All rights reserved.
//

import SwiftUI

struct MainView: View {
  
  let cameraSource = CameraController()
  
  @State var selectedIndex:Int? = nil
  
    var body: some View {
      VStack(spacing:0){
        ForEach(Array([Color.red,Color.green,Color.blue].enumerated()),id: \.offset){ (index,value) in
          CameraView(color: value, session: self.cameraSource.captureSession, index: index,selectedIndex:self.selectedIndex).onTapGesture {
            withAnimation(.spring()){
              
              if let selectedIndex = self.selectedIndex{
                self.selectedIndex = nil
              } else {
                self.selectedIndex = index
              }
              print("tap", self.selectedIndex,index)
            }
          }
        }
      }.edgesIgnoringSafeArea(.all)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
