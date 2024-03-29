//
//  SplashView.swift
//  toggle
//
//  Created by Omar Darwish on 01/11/2021.
//

import SwiftUI


/// This creates a view with an animated sliding shutter.
/// 
/// - Parameters:
///    - animationType: The Start Direction of the Shutter View.
///    - shutterColor: The Color of the Shutter View.
///    - baseColor: The background Color.

struct ShutterView : View {

   /// Start Direction of shutter animation
    enum ShutterDirection {
        case leftToRight
        case rightToLeft
    }

    /// Type of shutter animation
    var animationDirection : ShutterDirection
    
    /// Color of the Shutter View
    var shutterColor : Color
    
    /// BackgroundColor of the main View
    var baseColor : Color
    
    /// Binding value to start shutter animation
    @Binding var shutterOn : Bool
    
    /// width of the shutter to be set by GeometryReader on runtime
    @State private var width : CGFloat = 0
    
    /// Returns the offset value for the shutter window depending on animation type
    private var offset : CGFloat {
        switch animationDirection {
        case .leftToRight :
            return -width
        case .rightToLeft:
            return width
        }
    }
    
    var body: some View {
        let shutterRect = Rectangle().foregroundColor(shutterColor)
            .offset(x: shutterOn ? 0 : -offset, y: 0)
            .animation(.easeInOut(duration: shutterOn ? 0.4 : 0.2), value: shutterOn)
        HStack {
            GeometryReader { geo in
                ZStack {
                    Rectangle()
                        .foregroundColor(baseColor)
                        .zIndex(0)
                   shutterRect
                        .zIndex(1)
                }.onAppear {
                    width = geo.size.width
                }
            }
        }
    }
    
}


struct ShutterViewPreview : PreviewProvider {
    @State static var on : Bool = false
    static var previews: some View {
        ShutterView(animationDirection: .rightToLeft, shutterColor: .blue, baseColor: .gray, shutterOn: $on)
    }
}
