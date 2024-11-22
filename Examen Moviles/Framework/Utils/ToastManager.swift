import SwiftUI
import Combine

/// `ToastManager` is a class that manages the display of toast messages in the app.
/// It implements the logic to show a message and automatically hide it after a set time.
class ToastManager: ObservableObject {
    /// Indicates if the toast is being displayed.
    @Published var isShowing = false
    
    /// Message to be displayed in the toast.
    @Published var message = ""
    
    /// Type of toast, which can change its visual style.
    @Published var type: ToastType = .info
    
    /// Shared instance for global access.
    static let shared = ToastManager()
    
    /// Controls the auto-dismiss timer.
    private var cancellable: AnyCancellable?
    
    /// Private initializer to prevent multiple instances.
    /// Sets up a `sink` that hides the toast after a 3-second delay when `isShowing` becomes `true`.
    private init() {
        cancellable = $isShowing
            .filter { $0 }
            .delay(for: 3, scheduler: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.dismiss()
            }
    }
    
    /// Displays a message in the toast.
    /// - Parameters:
    ///   - message: The message to display.
    ///   - type: The type of message (defaults to `.info`).
    func show(message: String, type: ToastType = .info) {
        self.message = message
        self.type = type
        self.isShowing = true
        
        // Cancel any existing timer.
        cancellable?.cancel()
        
        // Start a new timer for auto-dismiss after 3 seconds.
        cancellable = Just(())
            .delay(for: .seconds(3), scheduler: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.dismiss()
            }
    }
    
    /// Hides the toast with an animation.
    func dismiss() {
        withAnimation {
            isShowing = false
        }
    }
}

/// `ToastModifier` is a view modifier that adds a `ToastView` above the main view.
/// This modifier allows any view to display a toast when needed.
struct ToastModifier: ViewModifier {
    @StateObject private var toastManager = ToastManager.shared
    
    /// Defines the view content, adding `ToastView` above the main content.
    /// - Parameter content: The main content view.
    /// - Returns: A view that includes a toast if needed.
    func body(content: Content) -> some View {
        ZStack(alignment: .top) {
            content
            
            ToastView(
                message: toastManager.message,
                type: toastManager.type,
                show: toastManager.isShowing,
                onDismiss: toastManager.dismiss
            )
        }
    }
}

extension View {
    /// View extension that applies the toast modifier.
    /// This method makes it easy to use `ToastModifier` on any view.
    /// - Returns: A view with a toast overlay.
    func toast() -> some View {
        modifier(ToastModifier())
    }
}
