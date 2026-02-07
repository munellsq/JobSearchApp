import Foundation

struct FavoriteJob: Identifiable, Codable, Equatable {
    let id: Int
    let title: String
    let companyName: String
    let category: String
    let candidateRequiredLocation: String
    let jobType: String?
    let publicationDate: String
    let url: String
    let salary: String?
    let description: String?
}
