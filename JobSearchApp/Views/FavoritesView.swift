import SwiftUI

struct FavoritesView: View {
    @EnvironmentObject var favorites: FavoritesStore

    var body: some View {
        NavigationStack {
            ZStack {
                AppBackground()

                SheetContainer {
                    sheetContent
                }
            }
            .safeAreaInset(edge: .top) {
                SimpleTopBar(title: "Favorites")
            }
            .toolbar(.hidden, for: .navigationBar)
        }
    }

    @ViewBuilder
    private var sheetContent: some View {
        if favorites.favorites.isEmpty {
            VStack {
                ContentUnavailableView(
                    "No favorites yet",
                    systemImage: "star",
                    description: Text("Save jobs to see them here.")
                )
                .padding(.top, 24)
                Spacer()
            }
        } else {
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(favorites.favorites) { fav in
                        NavigationLink {
                            JobDetailsView(job: fav.asJobDTO)
                        } label: {
                            JobCard(
                                title: fav.title,
                                company: fav.companyName,
                                subtitle: "\(fav.category) • \(fav.candidateRequiredLocation)",
                                badge: "Saved"
                            )
                        }
                        .buttonStyle(.plain)
                        .contextMenu {
                            Button(role: .destructive) {
                                favorites.remove(jobId: fav.id)
                            } label: {
                                Label("Remove from Favorites", systemImage: "trash")
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

private extension FavoriteJob {
    var asJobDTO: JobDTO {
        JobDTO(
            id: id,
            title: title,
            companyName: companyName,
            category: category,
            candidateRequiredLocation: candidateRequiredLocation,
            jobType: jobType,
            publicationDate: publicationDate,
            url: url,
            salary: salary,
            description: description
        )
    }
}
