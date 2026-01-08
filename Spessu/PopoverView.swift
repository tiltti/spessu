import SwiftUI

struct PopoverView: View {
    @ObservedObject var diskMonitor: DiskMonitor
    @Environment(\.openSettings) private var openSettings

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Otsikko
            HStack {
                Text("Spessu")
                    .font(.headline)
                Spacer()
                Text("Päivitetty: \(timeAgo)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Divider()

            // Kaikki levyt
            ForEach(diskMonitor.volumes) { volume in
                VolumeRowView(volume: volume)
            }

            if diskMonitor.volumes.isEmpty {
                Text("Ei levyjä löytynyt")
                    .foregroundColor(.secondary)
                    .padding()
            }

            Divider()

            // Toiminnot
            HStack {
                Button(action: { diskMonitor.refresh() }) {
                    Label("Päivitä", systemImage: "arrow.clockwise")
                }
                .keyboardShortcut("r", modifiers: [.command, .shift])

                Spacer()

                Button(action: { openSettings() }) {
                    Label("Asetukset", systemImage: "gear")
                }
                .keyboardShortcut(",", modifiers: .command)

                Button(action: { NSApplication.shared.terminate(nil) }) {
                    Label("Lopeta", systemImage: "power")
                }
                .keyboardShortcut("q", modifiers: .command)
            }
            .buttonStyle(.borderless)
        }
        .padding()
        .frame(width: 320)
    }

    private var timeAgo: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: diskMonitor.lastUpdate, relativeTo: Date())
    }
}

struct VolumeRowView: View {
    let volume: VolumeInfo

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            // Levyn nimi ja ikoni
            HStack {
                Image(systemName: volumeIcon)
                    .foregroundColor(statusColor)
                    .font(.title2)

                VStack(alignment: .leading, spacing: 2) {
                    Text(volume.name)
                        .font(.system(.body, design: .default, weight: .medium))

                    Text(volume.mountPoint)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }

                Spacer()

                // Prosentti
                Text(String(format: "%.1f%%", volume.usedPercentage))
                    .font(.system(.body, design: .monospaced, weight: .semibold))
                    .foregroundColor(statusColor)
            }

            // Tilastot
            HStack(spacing: 16) {
                StatView(label: "Yhteensä", value: volume.totalBytes.formattedBytes)
                StatView(label: "Käytetty", value: volume.usedBytes.formattedBytes)
                StatView(label: "Vapaa", value: volume.freeBytes.formattedBytes, highlight: true)
            }
            .font(.caption)

            // Progress bar
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    // Tausta
                    RoundedRectangle(cornerRadius: 3)
                        .fill(Color.gray.opacity(0.2))

                    // Käytetty tila
                    RoundedRectangle(cornerRadius: 3)
                        .fill(progressGradient)
                        .frame(width: geometry.size.width * CGFloat(volume.usedPercentage / 100))
                }
            }
            .frame(height: 8)
        }
        .padding(10)
        .background(Color.gray.opacity(0.05))
        .cornerRadius(8)
    }

    private var volumeIcon: String {
        if volume.mountPoint == "/" {
            return "internaldrive.fill"
        } else if volume.isRemovable {
            return "externaldrive.fill"
        } else if volume.isInternal {
            return "internaldrive.fill"
        } else {
            return "externaldrive.fill"
        }
    }

    private var statusColor: Color {
        switch volume.status {
        case .healthy: return .green
        case .caution: return .yellow
        case .warning: return .orange
        case .critical: return .red
        }
    }

    private var progressGradient: LinearGradient {
        let color = statusColor
        return LinearGradient(
            colors: [color.opacity(0.7), color],
            startPoint: .leading,
            endPoint: .trailing
        )
    }
}

struct StatView: View {
    let label: String
    let value: String
    var highlight: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 1) {
            Text(label)
                .foregroundColor(.secondary)
            Text(value)
                .fontWeight(highlight ? .semibold : .regular)
        }
    }
}

#Preview {
    PopoverView(diskMonitor: DiskMonitor())
}
