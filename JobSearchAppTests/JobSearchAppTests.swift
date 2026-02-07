import XCTest
@testable import JobSearchApp

final class JobsViewModelTests: XCTestCase {

    struct MockAPI: JobsAPI {
        let result: Result<[JobDTO], Error>

        func fetchJobs(search: String?) async throws -> [JobDTO] {
            switch result {
            case .success(let jobs): return jobs
            case .failure(let error): throw error
            }
        }
    }

    func testSearchSuccessSetsJobsAndClearsError() async {
        let sampleJobs = [
            JobDTO(
                id: 1,
                title: "iOS Developer",
                companyName: "Test Company",
                category: "Software Development",
                candidateRequiredLocation: "Worldwide",
                jobType: "Full-time",
                publicationDate: "2026-02-01",
                url: "https://example.com",
                salary: nil,
                description: "Test description"
            )
        ]

        let api = MockAPI(result: .success(sampleJobs))

        let vm: JobsViewModel = await MainActor.run {
            JobsViewModel(api: api)
        }

        await vm.search()

        await MainActor.run {
            XCTAssertEqual(vm.jobs.count, 1)
            XCTAssertNil(vm.errorMessage)
            XCTAssertFalse(vm.isLoading)
        }
    }

    func testSearchFailureSetsErrorAndClearsJobs() async {
        enum TestError: Error { case failed }
        let api = MockAPI(result: .failure(TestError.failed))

        let vm: JobsViewModel = await MainActor.run {
            JobsViewModel(api: api)
        }

        await vm.search()

        await MainActor.run {
            XCTAssertTrue(vm.jobs.isEmpty)
            XCTAssertNotNil(vm.errorMessage)
            XCTAssertFalse(vm.isLoading)
        }
    }
}
