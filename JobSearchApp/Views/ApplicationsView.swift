import SwiftUI

struct ApplicationsView: View {
    @EnvironmentObject var applications: ApplicationsStore

    private func items(for status: ApplicationStatus) -> [ApplicationItem] {
        applications.items
            .filter { $0.status == status }
            .sorted { $0.updatedAt > $1.updatedAt }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                AppBackground()

                SheetContainer {
                    sheetContent
                }
            }
            .safeAreaInset(edge: .top) {
                SimpleTopBar(title: "Tracker")
            }
            .toolbar(.hidden, for: .navigationBar)
        }
    }

    @ViewBuilder
    private var sheetContent: some View {
        if applications.items.isEmpty {
            VStack {
                ContentUnavailableView(
                    "No applications yet",
                    systemImage: "checklist",
                    description: Text("Open a job and tap “Add to Tracker”.")
                )
                .padding(.top, 24)
                Spacer()
            }
        } else {
            ScrollView {
                LazyVStack(spacing: 14) {
                    ForEach(ApplicationStatus.allCases) { status in
                        let list = items(for: status)
                        if !list.isEmpty {
                            VStack(alignment: .leading, spacing: 10) {
                                Text(status.rawValue)
                                    .font(.headline)
                                    .padding(.horizontal, 2)

                                ForEach(list) { item in
                                    NavigationLink {
                                        ApplicationDetailView(item: item)
                                    } label: {
                                        JobCard(
                                            title: item.title,
                                            company: item.company,
                                            subtitle: item.location,
                                            badge: status.rawValue
                                        )
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                        }
                    }
                }
                .padding(.top, 14)
                .padding(.bottom, 14)
            }
        }
    }
}
