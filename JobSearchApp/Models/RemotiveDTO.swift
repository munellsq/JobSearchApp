import Foundation

struct RemotiveResponseDTO: Decodable {
    let jobs: [JobDTO]
}

struct JobDTO: Decodable, Identifiable {
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

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case companyName = "company_name"
        case category
        case candidateRequiredLocation = "candidate_required_location"
        case jobType = "job_type"
        case publicationDate = "publication_date"
        case url
        case salary
        case description
    }
}
