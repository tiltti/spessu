import SwiftUI

struct SettingsView: View {
    @ObservedObject var diskMonitor: DiskMonitor
    @AppStorage("updateInterval") private var updateInterval: Double = 30
    @AppStorage("warningThreshold") private var warningThreshold: Double = 10
    @AppStorage("criticalThreshold") private var criticalThreshold: Double = 5
    @AppStorage("showTextInMenuBar") private var showTextInMenuBar: Bool = true
    @AppStorage("launchAtLogin") private var launchAtLogin: Bool = false

    var body: some View {
        TabView {
            GeneralSettingsView(
                updateInterval: $updateInterval,
                showTextInMenuBar: $showTextInMenuBar,
                launchAtLogin: $launchAtLogin
            )
            .tabItem {
                Label("Yleiset", systemImage: "gear")
            }

            ThresholdSettingsView(
                warningThreshold: $warningThreshold,
                criticalThreshold: $criticalThreshold
            )
            .tabItem {
                Label("Hälytykset", systemImage: "bell")
            }

            AboutView()
            .tabItem {
                Label("Tietoja", systemImage: "info.circle")
            }
        }
        .frame(width: 450, height: 250)
    }
}

struct GeneralSettingsView: View {
    @Binding var updateInterval: Double
    @Binding var showTextInMenuBar: Bool
    @Binding var launchAtLogin: Bool

    var body: some View {
        Form {
            Picker("Päivitysväli:", selection: $updateInterval) {
                Text("10 sekuntia").tag(10.0)
                Text("30 sekuntia").tag(30.0)
                Text("1 minuutti").tag(60.0)
                Text("5 minuuttia").tag(300.0)
            }

            Toggle("Näytä vapaa tila menu barissa", isOn: $showTextInMenuBar)

            Toggle("Käynnistä kirjautuessa", isOn: $launchAtLogin)
                .disabled(true) // TODO: Toteuta ServiceManagement-frameworkilla
        }
        .padding()
    }
}

struct ThresholdSettingsView: View {
    @Binding var warningThreshold: Double
    @Binding var criticalThreshold: Double

    var body: some View {
        Form {
            VStack(alignment: .leading, spacing: 16) {
                VStack(alignment: .leading) {
                    Text("Varoitusraja (keltainen): \(Int(warningThreshold))% vapaata")
                    Slider(value: $warningThreshold, in: 5...30, step: 1)
                }

                VStack(alignment: .leading) {
                    Text("Kriittinen raja (punainen): \(Int(criticalThreshold))% vapaata")
                    Slider(value: $criticalThreshold, in: 1...15, step: 1)
                }

                Text("Kun vapaa tila laskee näiden rajojen alle, menu barin väri muuttuu.")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
    }
}

struct AboutView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "internaldrive.fill")
                .font(.system(size: 48))
                .foregroundColor(.green)

            Text("Spessu")
                .font(.title)
                .fontWeight(.bold)

            Text("Versio 1.0.0")
                .foregroundColor(.secondary)

            Text("Levytilan seurantasovellus macOS:lle")
                .multilineTextAlignment(.center)

            Spacer()
        }
        .padding()
    }
}

#Preview {
    SettingsView(diskMonitor: DiskMonitor())
}
