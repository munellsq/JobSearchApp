import Foundation
import Combine

final class ApplicationsStore: ObservableObject {
    private let key = "applications_tracker"

    @Published private(set) var items: [ApplicationItem] = []

    init() { load() }

    // MARK: - Read helpers (для UI фидбека)
    func isTracked(jobId: Int) -> Bool {
        items.contains { $0.id == jobId }
    }

    func statusFor(jobId: Int) -> ApplicationStatus? {
        items.first(where: { $0.id == jobId })?.status
    }

    // MARK: - Write
    func addOrUpdate(from job: JobDTO, status: ApplicationStatus) {
        if let idx = items.firstIndex(where: { $0.id == job.id }) {
            items[idx].status = status
            items[idx].updatedAt = Date()
        } else {
            let new = ApplicationItem(
                id: job.id,
                title: job.title,
                company: job.companyName,
                location: job.candidateRequiredLocation,
                url: job.url,
                status: status,
                note: "",
                updatedAt: Date()
            )
            items.append(new)
        }
        save()
    }

    func updateNote(jobId: Int, note: String) {
        guard let idx = items.firstIndex(where: { $0.id == jobId }) else { return }
        items[idx].note = note
        items[idx].updatedAt = Date()
        save()
    }

    func updateStatus(jobId: Int, status: ApplicationStatus) {
        guard let idx = items.firstIndex(where: { $0.id == jobId }) else { return }
        items[idx].status = status
        items[idx].updatedAt = Date()
        save()
    }

    func remove(jobId: Int) {
        items.removeAll { $0.id == jobId }
        save()
    }

    // MARK: - Persistence
    private func save() {
        if let data = try? JSONEncoder().encode(items) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }

    private func load() {
        guard
            let data = UserDefaults.standard.data(forKey: key),
            let saved = try? JSONDecoder().decode([ApplicationItem].self, from: data)
        else { return }
        items = saved
    }
}
