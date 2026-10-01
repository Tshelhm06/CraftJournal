import SwiftUI
import CoreData

struct AddEntryView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var title = ""
    @State private var craftType = crafts[0]
    @State private var notes = ""
    @State private var image: UIImage?
    @State private var showingCamera = false
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Title", text: $title)
                Picker("Craft", selection: $craftType) {
                    ForEach(crafts, id: \.self) { craft in
                        Text(craft)
                    }
                }
                
                TextField("Notes", text: $notes, axis: .vertical)
                
                Section("Photo") {
                    if let image {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(maxHeight: 250)
                    }
                    
                    Button("Take Photo") {
                        showingCamera = true
                    }
                    .disabled(!UIImagePickerController.isSourceTypeAvailable(.camera))
                }
            }
            .navigationTitle("New Entry")
            .fullScreenCover(isPresented: $showingCamera) {
                CameraView(image: $image)
                    .ignoresSafeArea()
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { saveEntry() }
                        .disabled(title.isEmpty)
                }
            }
        }
    }
    
    private func saveEntry() {
        let entry = CraftEntry(context: viewContext)
        entry.id = UUID()
        entry.title = title
        entry.craftType = craftType
        entry.date = Date()
        entry.notes = notes
        entry.photo = image?.jpegData(compressionQuality: 0.7)
        
        do {
            try viewContext.save()
            dismiss()
        } catch {
            print("Could not save: \(error)")
        }
    }
}
