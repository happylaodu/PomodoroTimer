import SwiftUI
import AppKit

struct MacSwitchToggle: NSViewRepresentable {
    @Binding var isOn: Bool

    func makeNSView(context: Context) -> NSSwitch {
        let toggle = NSSwitch()
        toggle.target = context.coordinator
        toggle.action = #selector(Coordinator.toggleChanged(_:))
        return toggle
    }
    
    func updateNSView(_ nsView: NSSwitch, context: Context) {
        nsView.state = isOn ? .on : .off
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject {
        var parent: MacSwitchToggle
        init(_ parent: MacSwitchToggle) { self.parent = parent }
        @objc func toggleChanged(_ sender: NSSwitch) {
            parent.isOn = (sender.state == .on)
        }
    }
}
