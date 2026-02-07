import SwiftUI

struct JobDetailsView: View {
    let job: JobDTO

    @EnvironmentObject var favorites: FavoritesStore
    @EnvironmentObject var applications: ApplicationsStore

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 14) {
                header
                meta
                actions

                Divider().opacity(0.35)

                descriptionBlock
            }
            .padding()
        }
        .navigationTitle("Details")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var isTracked: Bool {
        applications.isTracked(jobId: job.id)
    }

    private var trackerButtonTitle: String {
        if let s = applications.statusFor(jobId: job.id) {
            return "In Tracker: \(s.rawValue)"
        }
        return "Add to Tracker"
    }

    // MARK: - UI parts
    private var header: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .top) {
                Text(job.title)
                    .font(.title2).bold()

                Spacer()

                Button {
                    favorites.toggle(job: job)
                } label: {
                    Image(systemName: favorites.isFavorite(jobId: job.id) ? "star.fill" : "star")
                        .font(.title3)
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(.yellow, .secondary)
                }
            }

            Text(job.companyName)
                .font(.headline)
                .foregroundStyle(.secondary)
        }
    }

    private var meta: some View {
        HStack(spacing: 8) {
            Tag(text: job.category, style: .category)
            Tag(text: job.candidateRequiredLocation, style: .location)
            if let type = job.jobType, !type.isEmpty {
                Tag(text: type, style: .type)
            }
        }
    }

    private var actions: some View {
        VStack(spacing: 10) {

            HStack(spacing: 10) {
                if let url = URL(string: job.url) {
                    Link(destination: url) {
                        Label("Open", systemImage: "safari")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(BorderedProminentButtonStyle())
                }

                if isTracked {
                    Button {
                        applications.addOrUpdate(from: job, status: .planned)
                    } label: {
                        Label(trackerButtonTitle, systemImage: "checkmark.circle.fill")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(BorderedProminentButtonStyle())
                } else {
                    Button {
                        applications.addOrUpdate(from: job, status: .planned)
                    } label: {
                        Label(trackerButtonTitle, systemImage: "plus.circle.fill")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(BorderedButtonStyle())
                }
            }

            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    StatusPill(title: "Applied") {
                        applications.addOrUpdate(from: job, status: .applied)
                    }
                    StatusPill(title: "Interview") {
                        applications.addOrUpdate(from: job, status: .interview)
                    }
                    StatusPill(title: "Offer") {
                        applications.addOrUpdate(from: job, status: .offer)
                    }
                    StatusPill(title: "Rejected") {
                        applications.addOrUpdate(from: job, status: .rejected)
                    }
                }
            }
        }
    }

    private var descriptionBlock: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Description").font(.headline)
            Text((job.description ?? "No description")
                .replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression))
        }
    }
}
