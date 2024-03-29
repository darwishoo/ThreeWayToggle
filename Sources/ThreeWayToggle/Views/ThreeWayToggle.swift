//
//  ThreeWayToggle.swift
//  toggle
//
//  Created by Omar Darwish on 01/11/2021.
//

import SwiftUI

public enum TogglePosition : String , Codable{
    case on, off, neutral
}


public struct ThreeWayToggle<Label : View> : View {
    

    
    public init(position: Binding<TogglePosition>, label: @escaping () -> Label, onColor: Color = .green, offColor: Color = .red, baseColor: Color = Color(uiColor: .systemGray5), buttonColor: Color = .white, offTitle: String? = nil, onTitle: String? = nil, maxShutterWidth: CGFloat? = nil) {
        self._position = position
        self.label = label
        self.onColor = onColor
        self.offColor = offColor
        self.baseColor = baseColor
        self.buttonColor = buttonColor
        self.offTitle = offTitle
        self.onTitle = onTitle
        self.maxShutterWidth = maxShutterWidth
    }
    
     @Binding public var position : TogglePosition {
        didSet {
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
            switch position {
            case .on:
                animateRightLabel = true
                
            case .off:
                animateLeftLabel = true
                
            case .neutral:
                animateLeftLabel = false
                animateRightLabel = false
                
            }
        }
    }
    
    @ViewBuilder public let label : () -> Label
    
    @State private var animateLeftLabel : Bool = false //start animating left shutter
    
    @State private var animateRightLabel  : Bool = false //start animating right shutter
    
    private let baseWidth: CGFloat = 60 // width of toggle
    
    private let baseHeight: CGFloat = 30 // height of toggle
    
    private let stroke: CGFloat = 1
    
    private let gap: CGFloat = 1 // gap between the background and foreground
    
    private var offset : CGFloat {
        let edge = CGFloat((baseWidth / 2) - (baseHeight / 2) - gap)
        
        switch position {
        case .on:
            return edge
        case .off:
            return -edge
        case .neutral:
            return CGFloat.zero
        }
    }
    
    private var buttonHeight : CGFloat {
        return baseHeight - gap - stroke
    }
    
    public var onColor : Color = .green
    public var offColor : Color = .red
    public var baseColor : Color = Color(uiColor: .systemGray5)
    public var buttonColor : Color = .white
    public var offTitle : String?
    public var onTitle : String?
    
    
    
    /// - Parameter : use this value to restrict the size of the toggle switch labels on either side
    public var maxShutterWidth : CGFloat?
    
    @State private var buttonWidth : CGFloat = 0
    
    private var fillColor : Color {
        switch position {
        case .on:
            return onColor
        case .off:
            return offColor
        case .neutral:
            return baseColor
        }
    }
    
    @State private var animationOffset : CGFloat = 0 //offset added to keep button inside the parameter when stretched on press
    
    public var body: some View {
        
        
        let button = Capsule()
            .frame(width: buttonWidth > buttonHeight ? buttonWidth : buttonHeight, height: buttonHeight)
            .foregroundColor(buttonColor)
            .offset(x: offset + animationOffset, y: 0)
            .shadow(radius: 1, x: 0 , y: 1)
        
        
        let  toggleSwitch =  Capsule()
            .fill(fillColor)
            .shadow(radius: 0.5)
            .overlay(button)
            .frame(width: baseWidth, height: baseHeight)
            .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local).onChanged { value in
                
                let x = value.translation.width
                
                withAnimation {
                    buttonWidth = 35
                    switch position {
                    case .on:
                        animationOffset = -buttonWidth / 10
                    case .off:
                        animationOffset = buttonWidth / 10
                    case .neutral:
                        animationOffset = 0
                    }
                    
                    if x > 0  && position != .on {
                        position = .neutral
                        if (10...(baseWidth * 0.3)).contains(x) {
                            animationOffset = 0
                        }else if x > (baseWidth * 0.3) {
                            position = .on
                            animationOffset = -buttonWidth / 10
                        }
                    }else if x < 0  && position != .off {
                        position = .neutral
                        if ((-baseWidth * 0.3)...(-10)).contains(x) {
                           
                            animationOffset = 0
                        }else if x < (baseWidth * -0.3) {
                            position = .off
                            animationOffset = buttonWidth / 10
                        }
                    }
                }
            }.onEnded({ value in
    
                withAnimation {
                    self.buttonWidth = 0
                    animationOffset = 0
                    
                }
            }))
        
        HStack {
            label().padding(.leading)
            Spacer()
            HStack{
                if let offTitle = offTitle {

                    ShutterView(animationDirection: .leftToRight, shutterColor: offColor, baseColor:  baseColor, shutterOn: $animateLeftLabel)
                        .frame(maxWidth: maxShutterWidth)
                        .mask {
                            Text(offTitle).bold()
                                .multilineTextAlignment(.center)
                                .fixedSize(horizontal: true, vertical: false)
                        }
                }
                
                toggleSwitch
                    .zIndex(.infinity)// to keep toggle on top of labels
                
                if let onTitle = onTitle {

                    ShutterView(animationDirection: .rightToLeft, shutterColor: onColor, baseColor:  baseColor, shutterOn: $animateRightLabel)
                        .frame(maxWidth: maxShutterWidth)
                        .mask {
                            Text(onTitle).bold()
                                .multilineTextAlignment(.center)
                                .fixedSize(horizontal: true, vertical: false)
                        }
                }
            }
            
        }
    }
}


struct ThreeWayTogglePreview : PreviewProvider {
    
    @State static var position = TogglePosition.on
    
    static var previews: some View {

        ThreeWayToggle(position: $position, label: {
            Text("Hello Again")
        }, onColor: .red, offColor: .green, baseColor: .gray, offTitle: "off", onTitle: "on")
 
    }
}
