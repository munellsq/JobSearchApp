import Foundation

enum ApplicationStatus: String, Codable, CaseIterable, Identifiable {
    case planned = "Planned"
    case applied = "Applied"
    case interview = "Interview"
    case offer = "Offer"
    case rejected = "Rejected"

    var id: String { rawValue }
}

struct ApplicationItem: Identifiable, Codable, Equatable {
    let id: Int
    var title: String
    var company: String
    var location: String
    var url: String

    var status: ApplicationStatus
    var note: String
    var updatedAt: Date
}
