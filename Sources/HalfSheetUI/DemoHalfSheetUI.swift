//
//  SwiftUIView.swift
//  
//
//  Created by Hau Nguyen on 19/09/2022.
//

import SwiftUI

// 4 - An example of how to use the sheetWithDetents modifier
@available(iOS 13.0, *)
@available(iOS 15.0, *)
struct DemoHalfSheetUI: View {
    @State var isPresented: Bool = false
    @State var state: UISheetPresentationController.Detent.Identifier = .medium
    
    var body: some View {
        ZStack {
            Color.pink
                .ignoresSafeArea()
            Button {
                isPresented.toggle()
            } label: {
                VStack {
                    Text("Tap me!")
                        .padding()
                        .background(Color.white)
                        .cornerRadius(20)
                }
                .onChange(of: self.state) { _ in
                    print("\(self.state.rawValue)")
                }
            }
            .halfSheetUI(isPresented: $isPresented, prefersGrabberVisible: true
                            , detents: [.medium(), .large()], state: $state, onDismiss: onDismiss) {
                VStack {
                    Text("SwiftUI Content ")
                        .bold()
                        .font(.title)
                }
            }
        }
    }
    
    func onDismiss() {
        print("The sheet has been dismissed")
    }
}

@available(iOS 13.0, *)
@available(iOS 15.0, *)
struct DemoHalfSheetUI_Previews: PreviewProvider {
    static var previews: some View {
        DemoHalfSheetUI()
    }
}
