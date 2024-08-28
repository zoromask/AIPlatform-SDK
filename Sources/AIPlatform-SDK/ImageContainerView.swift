//
//  ImageContainerView.swift
//  
//
//  Created by Mac on 7/18/24.
//

import Foundation
import SwiftUI

struct ImageContainerView: View {
    @StateObject private var imageContainerModel = ImageContainerModel()
    
    var body: some View {
        VStack {
            Button {
                imageContainerModel.showingPopover.toggle()
            } label: {
                loadImageFromURL(
                    urlImage: "https://trolyao.vpbank.com.vn/images/vp-logo.png",
                    defaultImage: "logo-vp-bubble"
                )
                    .frame(width: 80, height: 80)
                    .foregroundColor(.white)
            }.popover(isPresented: $imageContainerModel.showingPopover) {
                ChatView()
                    .background(Color(hex: "#303642"))
            }
        }
    }
}
