import SwiftUI
import AppKit

@main
struct DiskTrendApp: App {
    @StateObject private var diskMonitor = DiskMonitor()
    @AppStorage("appearanceMode") private var appearanceMode: Int = 0

    init() {
        print("[DiskTrend] Starting...")
        updateAppearance()
    }

    private func updateAppearance() {
        let mode = AppearanceMode(rawValue: appearanceMode) ?? .system
        switch mode {
        case .system:
            NSApp.appearance = nil
        case .light:
            NSApp.appearance = NSAppearance(named: .aqua)
        case .dark:
            NSApp.appearance = NSAppearance(named: .darkAqua)
        }
    }

    var body: some Scene {
        MenuBarExtra {
            PopoverView(diskMonitor: diskMonitor)
                .onChange(of: appearanceMode) { _, _ in
                    updateAppearance()
                }
        } label: {
            MenuBarView(diskMonitor: diskMonitor)
        }
        .menuBarExtraStyle(.window)

        Settings {
            SettingsView(diskMonitor: diskMonitor)
        }
    }
}
