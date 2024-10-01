import SwiftUI

// Helper to show UIAlertController in SwiftUI
struct WeightInputAlert {
    static func show(title: String, message: String?, onAdd: @escaping (Float) -> Void) {
        guard let topController = UIViewController.topViewController() else { return }

        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.placeholder = "Enter weight"
            textField.keyboardType = .decimalPad
        }

        let addAction = UIAlertAction(title: "Add", style: .default) { _ in
            if let textField = alert.textFields?.first, let weightText = textField.text, let weight = Float(weightText) {
                onAdd(weight)
            }
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        alert.addAction(cancelAction)
        alert.addAction(addAction)

        topController.present(alert, animated: true, completion: nil)
    }
}
