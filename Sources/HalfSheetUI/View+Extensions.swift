//
//  SwiftUIView.swift
//  
//
//  Created by Hau Nguyen on 19/09/2022.
//

import SwiftUI
import UIKit

@available(iOS 13.0, *)
@available(iOS 15.0, *)
extension View {
    func halfSheetUI<Content:View>(isPresented: Binding<Bool>, prefersGrabberVisible: Bool? = false, detents: [UISheetPresentationController.Detent], firstDetent: UISheetPresentationController.Detent.Identifier? = .large, state: Binding<UISheetPresentationController.Detent.Identifier>? = nil, onDismiss: (() -> Void)? = nil, @ViewBuilder content: @escaping () -> Content) -> some View {
        modifier(halfSheetViewModifier(isPresented: isPresented, prefersGrabberVisible: prefersGrabberVisible, detents: detents, firstDetent: firstDetent, state: state, onDismiss: onDismiss, swiftUIContent: content))
    }
}

@available(iOS 13.0, *)
@available(iOS 15.0, *)
// 2 - Create the SwiftUI modifier conforming to the ViewModifier protocol
struct halfSheetViewModifier<SwiftUIContent : View>: ViewModifier {
    
    @Binding var isPresented: Bool
    
    var prefersGrabberVisible: Bool? = false
    
    var detents: [UISheetPresentationController.Detent] = [.medium(), .large()]
    
    var firstDetent: UISheetPresentationController.Detent.Identifier? = .large
    
    var state: Binding<UISheetPresentationController.Detent.Identifier>?
    
    let onDismiss: (() -> Void)?
    
    let swiftUIContent: SwiftUIContent
    
    init(isPresented: Binding<Bool>,
         prefersGrabberVisible: Bool? = nil,
         detents: [UISheetPresentationController.Detent],
         firstDetent: UISheetPresentationController.Detent.Identifier? = .large,
         state: Binding<UISheetPresentationController.Detent.Identifier>? = nil,
         onDismiss: (() -> Void)? = nil,
         @ViewBuilder swiftUIContent: @escaping () -> SwiftUIContent)
    {
        self._isPresented = isPresented
        self.prefersGrabberVisible = prefersGrabberVisible
        self.detents = detents
        self.firstDetent = firstDetent
        self.state = state
        self.onDismiss = onDismiss
        self.swiftUIContent = swiftUIContent()
    }
    
    func body(content: Content) -> some View {
        ZStack {
            HalfSheetUI(isPresented: $isPresented, prefersGrabberVisible: prefersGrabberVisible, detents: detents, firstDetent: firstDetent, state: state, onDismiss: onDismiss) {
                swiftUIContent
            }
            .fixedSize()
            
            content
        }
    }
}
