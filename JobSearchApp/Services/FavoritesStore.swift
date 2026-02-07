import Foundation
import Combine

final class FavoritesStore: ObservableObject {
    private let key = "favorite_jobs"
    @Published private(set) var favorites: [FavoriteJob] = []

    init() { load() }

    func isFavorite(jobId: Int) -> Bool {
        favorites.contains { $0.id == jobId }
    }

    func remove(jobId: Int) {
        favorites.removeAll { $0.id == jobId }
        save()
    }

    func toggle(job: JobDTO) {
        if isFavorite(jobId: job.id) {
            remove(jobId: job.id)
        } else {
            let fav = FavoriteJob(
                id: job.id,
                title: job.title,
                companyName: job.companyName,
                category: job.category,
                candidateRequiredLocation: job.candidateRequiredLocation,
                jobType: job.jobType,
                publicationDate: job.publicationDate,
                url: job.url,
                salary: job.salary,
                description: job.description
            )
            favorites.append(fav)
            save()
        }
    }

    private func save() {
        if let data = try? JSONEncoder().encode(favorites) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }

    private func load() {
        guard
            let data = UserDefaults.standard.data(forKey: key),
            let saved = try? JSONDecoder().decode([FavoriteJob].self, from: data)
        else { return }
        favorites = saved
    }
}
