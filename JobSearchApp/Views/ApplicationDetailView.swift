import SwiftUI

struct ApplicationDetailView: View {
    let item: ApplicationItem
    @EnvironmentObject var applications: ApplicationsStore

    @State private var note: String = ""
    @State private var status: ApplicationStatus = .planned
    @State private var savedNote: Bool = false

    var body: some View {
        ZStack {
            AppBackground()
            ScrollView {
                VStack(alignment: .leading, spacing: 14) {

                    JobCard(
                        title: item.title,
                        company: item.company,
                        subtitle: item.location,
                        badge: item.status.rawValue
                    )

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Status").font(.headline)

                        Picker("Status", selection: $status) {
                            ForEach(ApplicationStatus.allCases) { s in
                                Text(s.rawValue).tag(s)
                            }
                        }
                        .pickerStyle(.segmented)
                        .onChange(of: status) { _, newValue in
                            applications.updateStatus(jobId: item.id, status: newValue)
                        }
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Note").font(.headline)

                        TextEditor(text: $note)
                            .frame(minHeight: 140)
                            .padding(10)
                            .background(.thinMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                            .overlay(
                                RoundedRectangle(cornerRadius: 16, style: .continuous)
                                    .strokeBorder(Color.primary.opacity(0.08))
                            )
                            .onChange(of: note) { _, _ in
                                savedNote = false
                            }

                        Button(savedNote ? "Saved!" : "Save note") {
                            applications.updateNote(jobId: item.id, note: note)
                            savedNote = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                                savedNote = false
                            }
                        }
                        .buttonStyle(.borderedProminent)
                    }

                    if let url = URL(string: item.url) {
                        Link("Open job page", destination: url)
                            .buttonStyle(.bordered)
                    }

                    Button(role: .destructive) {
                        applications.remove(jobId: item.id)
                    } label: {
                        Label("Remove from Tracker", systemImage: "trash")
                    }
                    .buttonStyle(.bordered)
                }
                .padding()
            }
        }
        .navigationTitle("Application")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            note = item.note
            status = item.status
        }
    }
}
