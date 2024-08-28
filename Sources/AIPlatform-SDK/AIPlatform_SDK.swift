import SwiftUI

public struct AIPlatform_SDK: View {

    public init() {
    }

    public var body: some View {
        if #available(iOS 15.0, *) {
//            print("15 đổ lên")
            ZStack {
                ImageContainerView().onAppear {
                    print("above 15")
                }
                //            ChatView()
            }
            .clipped()
//            .background(.red)
//            .cornerRadius(5.0)
//            .border(.black, width: 2)
            .frame(width: 90, height: 90, alignment: .center)
            .offset(x: -10, y: -30)
            .edgesIgnoringSafeArea(.all)
        } else {
//            print("dưới 15")
            ZStack {
//                ImageContainerView()
//                ChatView()
            }
            .frame(width: 90, height: 90, alignment: .topTrailing)
            .offset(x: -10, y: -10)
            .edgesIgnoringSafeArea(.all)
        }
    }
}
    
