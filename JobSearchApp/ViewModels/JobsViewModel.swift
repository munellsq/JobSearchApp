import Foundation
import Combine

@MainActor
final class JobsViewModel: ObservableObject {
    @Published var jobs: [JobDTO] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil

    @Published var searchText: String = ""
    @Published var selectedCategory: String = "All"

    private let api: JobsAPI = RemotiveAPI()

    var categories: [String] {
        let cats = Set(jobs.map { $0.category })
        return ["All"] + cats.sorted()
    }

    var filteredJobs: [JobDTO] {
        if selectedCategory == "All" { return jobs }
        return jobs.filter { $0.category == selectedCategory }
    }

    func loadInitial() {
        Task { await search() }
    }

    func search() async {
        isLoading = true
        errorMessage = nil

        do {
            jobs = try await api.fetchJobs(search: searchText)
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }

    func refresh() async {
        await search()
    }
}
