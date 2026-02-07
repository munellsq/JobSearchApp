import SwiftUI

// MARK: - SOLID BACKGROUND
struct AppBackground: View {
    var body: some View {
        Color(red: 1.0, green: 0.55, blue: 0.20)
            .ignoresSafeArea()
    }
}

// MARK: - REUSABLE WHITE SHEET CONTAINER (единый "лист" для всех экранов)
struct SheetContainer<Content: View>: View {
    let content: Content

    private let corner: CGFloat = 32
    private let sidePadding: CGFloat = 12
    private let topPadding: CGFloat = 8
    private let bottomPadding: CGFloat = 24

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        VStack {
            content
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        }
        .padding(.horizontal, sidePadding)
        .padding(.top, topPadding)
        .padding(.bottom, bottomPadding)
        .background(
            RoundedRectangle(cornerRadius: corner, style: .continuous)
                .fill(Color(.systemBackground))
        )
        .padding(.horizontal, sidePadding)
    }
}

// MARK: - STICKY TOP BAR (Jobs)
struct StickyTopBar: View {
    let title: String

    var searchText: Binding<String>
    var onSearchSubmit: () -> Void

    var categories: [String]
    var selectedCategory: Binding<String>
    var onRefresh: () -> Void

    @State private var showCategorySheet = false

    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Text(title)
                    .font(.largeTitle).bold()
                    .foregroundStyle(.white)

                Spacer()

                Button(action: onRefresh) {
                    Image(systemName: "arrow.clockwise")
                        .foregroundStyle(.white)
                        .padding(10)
                        .background(.white.opacity(0.25))
                        .clipShape(Circle())
                }

                // белая кнопка фильтра
                Button {
                    showCategorySheet = true
                } label: {
                    HStack(spacing: 6) {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                        Text(selectedCategory.wrappedValue).lineLimit(1)
                    }
                    .foregroundStyle(.black)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 10)
                    .background(Color.white, in: Capsule())
                }
            }

            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(.white.opacity(0.9))

                TextField("Search jobs…", text: searchText)
                    .foregroundStyle(.white)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled(true)
                    .submitLabel(.search)
                    .onSubmit(onSearchSubmit)

                if !searchText.wrappedValue.isEmpty {
                    Button {
                        searchText.wrappedValue = ""
                        onSearchSubmit()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(.white.opacity(0.9))
                    }
                }
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 12)
            .background(.white.opacity(0.25))
            .clipShape(RoundedRectangle(cornerRadius: 18))
        }
        .padding(16)
        .background(Color(red: 1.0, green: 0.55, blue: 0.20))
        .shadow(color: .black.opacity(0.25), radius: 10, y: 6)
        .sheet(isPresented: $showCategorySheet) {
            CategoryPickerSheet(categories: categories, selected: selectedCategory)
                .presentationDetents([.medium])
                .presentationDragIndicator(.visible)
                .presentationBackground(.white) // ✅ белый фон шита
        }
    }
}

struct CategoryPickerSheet: View {
    let categories: [String]
    var selected: Binding<String>
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            List {
                ForEach(categories, id: \.self) { cat in
                    Button {
                        selected.wrappedValue = cat
                        dismiss()
                    } label: {
                        HStack {
                            Text(cat)
                            Spacer()
                            if cat == selected.wrappedValue {
                                Image(systemName: "checkmark")
                                    .foregroundStyle(.blue)
                            }
                        }
                    }
                    .foregroundStyle(.primary)
                }
            }
            .scrollContentBackground(.visible)
            .background(Color.white)
            .navigationTitle("Category")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}

// MARK: - JOB CARD
struct JobCard: View {
    let title: String
    let company: String
    let subtitle: String
    let badge: String?

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(title)
                    .font(.headline)
                    .lineLimit(2)

                Spacer()

                if let badge {
                    Text(badge)
                        .font(.caption).bold()
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(badgeColor.opacity(0.15))
                        .clipShape(Capsule())
                }
            }

            Text(company)
                .font(.subheadline)
                .foregroundStyle(.secondary)

            Text(subtitle)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 22).fill(Color.white)
        )
        .shadow(color: .black.opacity(0.12), radius: 12, y: 6)
    }

    private var badgeColor: Color {
        switch badge {
        case "Applied": return .blue
        case "Interview": return .purple
        case "Offer": return .green
        case "Rejected": return .red
        default: return .orange
        }
    }
}

// MARK: - TAGS
enum TagStyle { case category, location, type }

struct Tag: View {
    let text: String
    let style: TagStyle

    var body: some View {
        Text(text)
            .font(.caption).bold()
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .foregroundStyle(.black.opacity(0.85))
            .background(backgroundColor.opacity(0.18))
            .clipShape(Capsule())
    }

    private var backgroundColor: Color {
        switch style {
        case .category: return .orange
        case .location: return .blue
        case .type: return .purple
        }
    }
}

// MARK: - STATUS PILL
struct StatusPill: View {
    let title: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.caption).bold()
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .background(Color.white.opacity(0.95))
                .clipShape(Capsule())
                .shadow(color: .black.opacity(0.08), radius: 8, y: 4)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - SIMPLE TOP BAR (Favorites/Tracker)
struct SimpleTopBar: View {
    let title: String

    var body: some View {
        VStack(spacing: 10) {
            HStack {
                Text(title)
                    .font(.system(size: 32, weight: .bold))
                    .foregroundStyle(.white)
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.top, 10)

            Rectangle()
                .fill(Color.white.opacity(0.12))
                .frame(height: 1)
                .padding(.horizontal, 16)
        }
        .padding(.bottom, 10)
        .background(Color.clear)
    }
}
