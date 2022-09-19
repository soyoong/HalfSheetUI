import SwiftUI
import UIKit

@available(iOS 13.0, *)
@available(iOS 15.0, *)
// 1 - Create a UISheetPresentationController that can be used in a SwiftUI interface
public struct HalfSheetUI<Content: View>: UIViewRepresentable {
    
    @Binding public var isPresented: Bool
    var firstDetent: UISheetPresentationController.Detent.Identifier? = .large
    let detents: [UISheetPresentationController.Detent]
    var prefersGrabberVisible: Bool? = false
    var state: Binding<UISheetPresentationController.Detent.Identifier>?
    let onDismiss: (() -> Void)?
    let content: Content
    @State private var getState: UISheetPresentationController.Detent.Identifier = .large
    
    public init(isPresented: Binding<Bool>,
         prefersGrabberVisible: Bool? = nil,
         detents: [UISheetPresentationController.Detent] = [.medium()],
         firstDetent: UISheetPresentationController.Detent.Identifier? = .large,
         state: Binding<UISheetPresentationController.Detent.Identifier>? = nil,
         onDismiss: (() -> Void)? = nil,
         @ViewBuilder content: @escaping () -> Content)
    {
        self._isPresented = isPresented
        self.prefersGrabberVisible = prefersGrabberVisible
        self.detents = detents
        self.firstDetent = firstDetent
        self.state = state
        self.onDismiss = onDismiss
        self.content = content()
    }
    
    public func makeUIView(context: Context) -> UIView {
        let view = UIView()
        return view
    }
    
    public func updateUIView(_ uiView: UIView, context: Context) {
        
        // Create the UIViewController that will be presented by the UIButton
        let vc = UIViewController()
        
        
        // Create the UIHostingController that will embed the SwiftUI View
        let host = UIHostingController(rootView: content)
        
        // Add the UIHostingController to the UIViewController
        vc.addChild(host)
        vc.view.addSubview(host.view)
        // Set constraints
        host.view.translatesAutoresizingMaskIntoConstraints = false
        host.view.leftAnchor.constraint(equalTo: vc.view.leftAnchor).isActive = true
        host.view.topAnchor.constraint(equalTo: vc.view.topAnchor).isActive = true
        host.view.rightAnchor.constraint(equalTo: vc.view.rightAnchor).isActive = true
        host.view.bottomAnchor.constraint(equalTo: vc.view.bottomAnchor).isActive = true
        host.didMove(toParent: vc)
        
        // Set the presentationController as a UISheetPresentationController
        if let sheet = vc.presentationController as? UISheetPresentationController {
            sheet.detents = detents
            sheet.prefersGrabberVisible = self.prefersGrabberVisible!
            sheet.prefersScrollingExpandsWhenScrolledToEdge = true
            sheet.largestUndimmedDetentIdentifier = .medium
            sheet.selectedDetentIdentifier = self.firstDetent
        }
        
        // Set the coordinator (delegate)
        // We need the delegate to use the presentationControllerDidDismiss function
        vc.presentationController?.delegate = context.coordinator
        
        
        if isPresented {
            // Present the viewController
            uiView.window?.rootViewController?.present(vc, animated: true)
        } else {
            // Dismiss the viewController
            uiView.window?.rootViewController?.dismiss(animated: true)
        }
        
    }
    
    /* Creates the custom instance that you use to communicate changes
     from your view controller to other parts of your SwiftUI interface.
     */
    public func makeCoordinator() -> Coordinator {
        Coordinator(isPresented: $isPresented, state: state, onDismiss: onDismiss)
    }
    
    public class Coordinator: NSObject, UISheetPresentationControllerDelegate {
        @Binding var isPresented: Bool
        let onDismiss: (() -> Void)?
        var state: Binding<UISheetPresentationController.Detent.Identifier>?
        
        public init(isPresented: Binding<Bool>,
             state: Binding<UISheetPresentationController.Detent.Identifier>? = nil,
             onDismiss: (() -> Void)? = nil)
        {
            self._isPresented = isPresented
            self.state = state
            self.onDismiss = onDismiss
        }
        
        public func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
            self.isPresented = false
            self.onDismiss?()
        }
        
        public func sheetPresentationControllerDidChangeSelectedDetentIdentifier(_ sheetPresentationController: UISheetPresentationController) {
            self.state?.wrappedValue = sheetPresentationController.selectedDetentIdentifier ?? .large
        }
    }
}
