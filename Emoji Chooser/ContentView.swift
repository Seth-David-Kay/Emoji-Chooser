import SwiftUI

struct ContentView: View {
    @State private var sharedEmojis: [String] = []

    var body: some View {
        NavigationView {
            VStack {
                Text("Shared Emojis")
                    .font(.largeTitle)
                    .padding()

                if sharedEmojis.isEmpty {
                    Text("No emojis found.")
                        .foregroundColor(.gray)
                } else {
                    List {
                        ForEach(sharedEmojis, id: \.self) { emoji in
                            EmojiRowView(emoji: emoji)
                        }
                        .onMove(perform: moveEmoji)
                        .onDelete(perform: deleteEmoji)
                    }
                    .listStyle(PlainListStyle())
                }

                HStack {
                    Button("Add Favorite") {
                        addSingleEmoji()
                    }
                    .padding()
                    
                    Button("Add Multiple Favorites") {
                        addMultipleEmojis()
                    }
                    .padding()
                }
            }
            .padding()
            .navigationTitle("Emoji Chooser")
            .navigationBarItems(trailing: EditButton())
            .onAppear {
                loadSharedEmojis()
            }
        }
    }

    func loadSharedEmojis() {
        if let sharedDefaults = UserDefaults(suiteName: "group.boopid"),
           let emojis = sharedDefaults.array(forKey: "sharedEmojis") as? [String] {
            sharedEmojis = emojis
        }
    }

    func saveSharedEmojis(_ emojis: [String]) {
        let sharedDefaults = UserDefaults(suiteName: "group.boopid")
        sharedDefaults?.set(emojis, forKey: "sharedEmojis")
        sharedEmojis = emojis
    }

    func deleteEmoji(at offsets: IndexSet) {
        var emojis = sharedEmojis
        emojis.remove(atOffsets: offsets)
        saveSharedEmojis(emojis)
    }

    func moveEmoji(from source: IndexSet, to destination: Int) {
        var emojis = sharedEmojis
        emojis.move(fromOffsets: source, toOffset: destination)
        saveSharedEmojis(emojis)
    }

    func addSingleEmoji() {
        let alert = UIAlertController(title: "Add Emoji", message: "Enter an emoji to add:", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Emoji"
        }

        let addAction = UIAlertAction(title: "Add", style: .default) { _ in
            if let emoji = alert.textFields?.first?.text, !emoji.isEmpty {
                var emojis = sharedEmojis
                emojis.append(emoji)
                saveSharedEmojis(emojis)
            }
        }
        alert.addAction(addAction)

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(cancelAction)

        // Present alert on the relevant window scene
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let viewController = windowScene.windows.first?.rootViewController {
            viewController.present(alert, animated: true)
        }
    }
    
    func addMultipleEmojis() {
        let alert = UIAlertController(title: "Add Multiple Emojis", message: "Enter a line of emojis to add:", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Emojis"
        }

        let addAction = UIAlertAction(title: "Add", style: .default) { _ in
            if let emojiString = alert.textFields?.first?.text, !emojiString.isEmpty {
                let emojis = emojiString.splitByEmoji()
                var sharedEmojis = self.sharedEmojis
                sharedEmojis.append(contentsOf: emojis)
                saveSharedEmojis(sharedEmojis)
            }
        }
        alert.addAction(addAction)

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(cancelAction)

        // Present alert on the relevant window scene
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let viewController = windowScene.windows.first?.rootViewController {
            viewController.present(alert, animated: true)
        }
    }
}

struct EmojiRowView: View {
    let emoji: String

    var body: some View {
        HStack {
            Text(emoji)
                .font(.largeTitle)
                .padding()

            Spacer()
        }
        .frame(height: 60)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

extension String {
    func splitByEmoji() -> [String] {
        var emojis: [String] = []
        self.forEach { char in
            if char.isEmoji {
                emojis.append(String(char))
            }
        }
        return emojis
    }
}

extension Character {
    var isEmoji: Bool {
        return self.unicodeScalars.first?.properties.isEmojiPresentation ?? false
    }
}
