import SwiftUI

struct JobsListView: View {
    @StateObject private var vm = JobsViewModel()

    var body: some View {
        NavigationStack {
            ZStack {
                AppBackground()

                SheetContainer {
                    sheetContent
                }
            }
            .safeAreaInset(edge: .top) {
                StickyTopBar(
                    title: "Jobs",
                    searchText: $vm.searchText,
                    onSearchSubmit: { Task { await vm.search() } },
                    categories: vm.categories,
                    selectedCategory: $vm.selectedCategory,
                    onRefresh: { Task { await vm.refresh() } } // простой refresh
                )
            }
            .toolbar(.hidden, for: .navigationBar)
            .onAppear {
                if vm.jobs.isEmpty && !vm.isLoading {
                    vm.loadInitial()
                }
            }
        }
    }

    @ViewBuilder
    private var sheetContent: some View {
        if vm.isLoading {
            VStack {
                ProgressView("Loading jobs...")
                    .padding(.top, 40)
                Spacer()
            }

        } else if let error = vm.errorMessage {
            VStack(spacing: 12) {
                Text("Error").font(.title2).bold()
                Text(error).multilineTextAlignment(.center)

                Button("Retry") {
                    Task { await vm.search() }
                }
                .buttonStyle(.borderedProminent)

                Spacer()
            }
            .padding(.top, 24)

        } else if vm.filteredJobs.isEmpty {
            VStack {
                ContentUnavailableView(
                    "No jobs found",
                    systemImage: "magnifyingglass",
                    description: Text("Try another keyword or category.")
                )
                .padding(.top, 24)
                Spacer()
            }

        } else {
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(vm.filteredJobs) { job in
                        NavigationLink {
                            JobDetailsView(job: job)
                        } label: {
                            JobCard(
                                title: job.title,
                                company: job.companyName,
                                subtitle: "\(job.category) • \(job.candidateRequiredLocation)",
                                badge: vm.selectedCategory == "All" ? nil : vm.selectedCategory
                            )
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.top, 14)
                .padding(.bottom, 14)
            }
            .refreshable { await vm.refresh() }
        }
    }
}
