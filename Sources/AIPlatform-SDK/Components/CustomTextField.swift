import SwiftUI
import UIKit

struct CustomTextField: UIViewRepresentable {
    @Binding var text: String
    var placeholder: String
    var placeholderColor: UIColor
    var padding: CGFloat = 10
    var borderColor: UIColor
    var borderWidth: CGFloat = 1
    var cornerRadius: CGFloat = 10
    var width: CGFloat = .infinity
    var height: CGFloat = 40
    var onSubmit: () -> Void

    func makeUIView(context: Context) -> UITextField {
        let textField = UITextField()
        textField.delegate = context.coordinator
        textField.textColor = .white
        textField.backgroundColor = .clear
        textField.layer.cornerRadius = 50
        textField.clipsToBounds = true
        textField.frame = CGRect(x: 0, y: 0, width: width, height: height)
        textField.returnKeyType = .done
//        textField.lineBreakMode = .byTruncatingTail
        textField.adjustsFontSizeToFitWidth = true

        // Thiết lập placeholder với màu sắc
        textField.attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [NSAttributedString.Key.foregroundColor: placeholderColor]
        )

        // Thêm padding bên trong
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: padding, height: height))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        
        // Thiết lập border và corner radius
        textField.layer.borderColor = borderColor.cgColor
        textField.layer.borderWidth = borderWidth
        textField.layer.cornerRadius = cornerRadius
        textField.clipsToBounds = true

        return textField
    }

    func updateUIView(_ uiView: UITextField, context: Context) {
        uiView.text = text
        uiView.attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [NSAttributedString.Key.foregroundColor: placeholderColor]
        )
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(text: $text, onSubmit: onSubmit)
    }

    class Coordinator: NSObject, UITextFieldDelegate {
        @Binding var text: String
        var onSubmit: () -> Void

        init(text: Binding<String>, onSubmit: @escaping () -> Void) {
            _text = text
            self.onSubmit = onSubmit
        }

        func textFieldDidChangeSelection(_ textField: UITextField) {
            text = textField.text ?? ""
        }

        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            if string == "\n" {
//                textField.resignFirstResponder()
                onSubmit()
                return false
            }
            return true
        }
    }
}
