import SwiftUI
import CoreData

struct EditEntryView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss

    let entry: CraftEntry

    @State private var title: String
    @State private var craftType: String
    @State private var artisanName: String
    @State private var notes: String

    init(entry: CraftEntry) {
        self.entry = entry

        _title = State(initialValue: entry.title ?? "")
        _craftType = State(initialValue: entry.craftType ?? "")
        _artisanName = State(initialValue: entry.artisanName ?? "")
        _notes = State(initialValue: entry.notes ?? "")
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Craft Information") {
                    TextField("Title", text: $title)

                    TextField("Craft Type", text: $craftType)

                    TextField("Artisan Name", text: $artisanName)

                    TextField(
                        "Notes",
                        text: $notes,
                        axis: .vertical
                    )
                }
            }
            .navigationTitle("Edit Entry")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        updateEntry()
                    }
                }

                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }

    private func updateEntry() {
        entry.title = title
        entry.craftType = craftType
        entry.artisanName = artisanName
        entry.notes = notes

        do {
            try viewContext.save()
            dismiss()
        } catch {
            print("Error updating entry: \(error)")
        }
    }
}
