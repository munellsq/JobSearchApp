import Foundation

protocol JobsAPI {
    func fetchJobs(search: String?) async throws -> [JobDTO]
}
