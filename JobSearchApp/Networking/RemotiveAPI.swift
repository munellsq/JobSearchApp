import Foundation

enum APIError: LocalizedError {
    case invalidURL
    case badStatus(Int)
    case decodingFailed
    case emptyResponse

    var errorDescription: String? {
        switch self {
        case .invalidURL: return "Invalid URL."
        case .badStatus(let code): return "Server returned status \(code)."
        case .decodingFailed: return "Failed to decode server response."
        case .emptyResponse: return "No data received."
        }
    }
}

final class RemotiveAPI: JobsAPI {
    private let baseURL = "https://remotive.com/api/remote-jobs"

    func fetchJobs(search: String?) async throws -> [JobDTO] {
        var components = URLComponents(string: baseURL)

        if let search, !search.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            components?.queryItems = [URLQueryItem(name: "search", value: search)]
        }

        guard let url = components?.url else { throw APIError.invalidURL }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = 20

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let http = response as? HTTPURLResponse else { throw APIError.emptyResponse }
        guard (200...299).contains(http.statusCode) else { throw APIError.badStatus(http.statusCode) }

        do {
            let decoded = try JSONDecoder().decode(RemotiveResponseDTO.self, from: data)
            return decoded.jobs
        } catch {
            throw APIError.decodingFailed
        }
    }
}
