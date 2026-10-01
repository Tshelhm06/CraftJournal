import SwiftUI

struct EntryDetailView: View {

    @ObservedObject var entry: CraftEntry

    // Gets the Core Data context from the app
    @Environment(\.managedObjectContext) private var viewContext

    // Controls whether the Edit screen is shown
    @State private var showingEditSheet = false

    var body: some View {

        ScrollView {

            VStack(alignment: .leading, spacing: 12) {

                // Show the saved photo if one exists
                if let data = entry.photo,
                   let uiImage = UIImage(data: data) {

                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity)
                        .clipShape(
                            RoundedRectangle(cornerRadius: 12)
                        )
                }

                // Entry title
                Text(entry.title ?? "Untitled")
                    .font(.largeTitle)
                    .bold()

                // Craft type
                Text(entry.craftType ?? "")
                    .font(.title3)
                    .foregroundStyle(.secondary)

                // Date
                if let date = entry.date {
                    Text(date, style: .date)
                }

                // Artisan name
                Text("Artisan")
                    .font(.headline)

                Text(entry.artisanName ?? "Unknown artisan")
                    .font(.body)

                // Notes
                Text("Notes")
                    .font(.headline)

                Text(entry.notes ?? "No notes added.")
                    .font(.body)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
        }

        // Edit button
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Edit") {
                    showingEditSheet = true
                }
            }
        }

        // Open EditEntryView
        .sheet(isPresented: $showingEditSheet) {
            EditEntryView(entry: entry)
                .environment(
                    \.managedObjectContext,
                    viewContext
                )
        }

        .navigationBarTitleDisplayMode(.inline)
    }
}
