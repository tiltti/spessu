import SwiftUI

struct MenuBarView: View {
    @ObservedObject var diskMonitor: DiskMonitor

    var body: some View {
        HStack(spacing: 4) {
            // Ikoni - käytetään eri ikonia statuksen mukaan
            Image(systemName: iconName)

            // Vapaa tila tekstinä
            if let primary = diskMonitor.primaryVolume {
                Text(primary.freeBytes.formattedBytesShort)
                    .monospacedDigit()
            } else {
                Text("--")
            }
        }
    }

    private var iconName: String {
        guard let primary = diskMonitor.primaryVolume else {
            return "internaldrive"
        }

        switch primary.status {
        case .critical:
            return "externaldrive.badge.xmark"
        case .warning:
            return "externaldrive.badge.exclamationmark"
        case .caution:
            return "externaldrive.badge.minus"
        case .healthy:
            return "internaldrive"
        }
    }
}
