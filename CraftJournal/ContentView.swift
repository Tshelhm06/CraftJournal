import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \CraftEntry.date, ascending: false)],
        animation: .default)
    private var entries: FetchedResults<CraftEntry>
    
    @State private var showingAddEntry = false
    
    var body: some View {
        NavigationStack {
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
                    .environment(\.managedObjectContext, viewContext)
            }
        }
    }
    
    private func deleteEntries(offsets: IndexSet) {
        offsets.map { entries[$0] }.forEach(viewContext.delete)
        do {
            try viewContext.save()
        } catch {
            print("Could not delete: \(error)")
        }
    }
}

struct EntryRow: View {
    @ObservedObject var entry: CraftEntry
    
    var body: some View {
        HStack {
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
            
            VStack(alignment: .leading) {
                Text(entry.title ?? "Untitled")
                    .font(.headline)
                
                Text(entry.craftType ?? "")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

#Preview {
    ContentView()
        .environment(\.managedObjectContext,
PersistenceController.preview.container.viewContext)
}
