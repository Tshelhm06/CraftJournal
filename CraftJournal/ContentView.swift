import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [
            NSSortDescriptor(
                keyPath: \CraftEntry.date,
                ascending: false
            )
        ],
        animation: .default
    )
    private var entries: FetchedResults<CraftEntry>
    
    @State private var showingAddEntry = false
    
    @State private var selectedCraftType = "All"
    
    var body: some View {
        NavigationStack {
            
            VStack(alignment: .leading, spacing: 0) {
                
                // Entry count
                Text("\(entries.count) \(entries.count == 1 ? "entry" : "entries")")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal)
                    .padding(.top, 8)
                
                // Show a friendly message when there are no entries
                if entries.isEmpty {
                    
                    ContentUnavailableView(
                        "No Craft Entries",
                        systemImage: "book.closed",
                        description: Text(
                            "Add your first Zorig Chusum craft entry."
                        )
                    )
                    
                } else {
                    
                    List {
                        ForEach(entries) { entry in
                            NavigationLink {
                                EntryDetailView(entry: entry)
                            } label: {
                                EntryRow(entry: entry)
                            }
                        }
                        .onDelete(perform: deleteEntries)
                    }
                }
            }
            .navigationTitle("Craft Journal")
            .toolbar {
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showingAddEntry = true
                    } label: {
                        Label("Add", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddEntry) {
                AddEntryView()
                    .environment(
                        \.managedObjectContext,
                        viewContext
                    )
            }
        }
    }
    
    // Delete entries
    private func deleteEntries(offsets: IndexSet) {
        offsets
            .map { entries[$0] }
            .forEach(viewContext.delete)
        
        do {
            try viewContext.save()
        } catch {
            print("Could not delete: \(error)")
        }
    }
}


// MARK: - Entry Row

struct EntryRow: View {
    @ObservedObject var entry: CraftEntry
    
    var body: some View {
        HStack(spacing: 12) {
            
            // Photo thumbnail
            if let data = entry.photo,
               let uiImage = UIImage(data: data) {
                
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 60, height: 60)
                    .clipShape(
                        RoundedRectangle(cornerRadius: 8)
                    )
                
            } else {
                
                Image(systemName: "photo")
                    .frame(width: 60, height: 60)
                    .foregroundStyle(.secondary)
            }
            
            // Entry information
            VStack(alignment: .leading, spacing: 4) {
                
                Text(entry.title ?? "Untitled")
                    .font(.headline)
                
                Text(entry.craftType ?? "")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                
                Text(entry.artisanName ?? "Unknown artisan")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}


// MARK: - Preview

#Preview {
    ContentView()
        .environment(
            \.managedObjectContext,
            PersistenceController.preview.container.viewContext
        )
}
