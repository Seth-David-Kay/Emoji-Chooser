import UIKit

class KeyboardViewController: UIInputViewController {

    var keyboardScrollView: UIScrollView!
    var keyboardStackView: UIStackView!
    var sharedEmojis: [String] = ["␡","😁","😊","🥰","😔","🥺","😠","🫣","🫡","😑","😴","🫰🏻","🫳🏻","👋🏻","🏃🏻","🏃🏻‍➡️","🪡","🐱","🐹","🐨","🐸","🦆","🐶","🐊","🌪️","🌟","🍇","🧄","🌯","🍜","🥟","🥄","🥢","🖲️","💡","🧭","🎚️","🟤","📿"] // Default emojis

    override func viewDidLoad() {
        super.viewDidLoad()

        // Load shared data
        loadSharedData()

        // Create the keyboard view
        setupKeyboardView()

        // Add the keyboard view to the input view
        view.addSubview(keyboardScrollView)

        // Adjust constraints to position the keyboard row at the bottom of the view
        keyboardScrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            keyboardScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            keyboardScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            keyboardScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            keyboardScrollView.heightAnchor.constraint(equalToConstant: 200), // Adjust as needed for emoji size
        ])
    }

    func loadSharedData() {
        if let sharedDefaults = UserDefaults(suiteName: "group.boopid"),
           let emojis = sharedDefaults.array(forKey: "sharedEmojis") as? [String] {
            sharedEmojis = emojis
        }
    }

    func setupKeyboardView() {
        // Create a scroll view to hold the buttons
        keyboardScrollView = UIScrollView()
        keyboardScrollView.backgroundColor = .clear  // Set to clear to remove the top light grey part

        // Stack view to contain buttons in a grid
        keyboardStackView = UIStackView()
        keyboardStackView.axis = .vertical
        keyboardStackView.alignment = .leading
        keyboardStackView.distribution = .fillEqually
        keyboardStackView.spacing = 10
        
        // Calculate button size based on screen width and number of emojis per row
        let screenWidth = UIScreen.main.bounds.width
        let buttonWidth = (screenWidth / 5.0) - 15 // 5 emojis per row, with spacing of 10

        // Add buttons to stack view
        var rowStackView: UIStackView?
        for (index, emoji) in sharedEmojis.enumerated() {
            if index % 5 == 0 { // Start a new row
                rowStackView = UIStackView()
                rowStackView?.axis = .horizontal
                rowStackView?.alignment = .fill
                rowStackView?.distribution = .fill
                rowStackView?.spacing = 10
                keyboardStackView.addArrangedSubview(rowStackView!)
            }

            let button = UIButton(type: .system)
            button.setTitle(emoji, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 50) // Adjust font size for smaller emojis
            button.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
            
            // Optionally adjust button size and spacing using constraints
            button.widthAnchor.constraint(equalToConstant: buttonWidth).isActive = true
            button.heightAnchor.constraint(equalToConstant: buttonWidth).isActive = true

            rowStackView?.addArrangedSubview(button)
        }

        // Add stack view to scroll view
        keyboardScrollView.addSubview(keyboardStackView)

        // Set constraints for stack view to fill the scroll view
        keyboardStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            keyboardStackView.leadingAnchor.constraint(equalTo: keyboardScrollView.leadingAnchor),
            keyboardStackView.trailingAnchor.constraint(equalTo: keyboardScrollView.trailingAnchor),
            keyboardStackView.topAnchor.constraint(equalTo: keyboardScrollView.topAnchor),
            keyboardStackView.bottomAnchor.constraint(equalTo: keyboardScrollView.bottomAnchor),
        ])

        // Enable horizontal scrolling
        keyboardScrollView.showsHorizontalScrollIndicator = true
        keyboardScrollView.isScrollEnabled = true
    }

    @objc func didTapButton(_ sender: UIButton) {
        let proxy = textDocumentProxy as UITextDocumentProxy
        let emoji = sender.title(for: .normal) ?? ""
        if emoji == "␡"{
            proxy.deleteBackward()
        }
        else{
            proxy.insertText(emoji)
        }
    }
}
