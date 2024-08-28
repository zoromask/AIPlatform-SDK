import SwiftUI

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        var rgb: UInt64 = 0
        
        // Kiểm tra nếu mã màu có dấu '#'
        if hex.hasPrefix("#") {
            let index = hex.index(hex.startIndex, offsetBy: 1)
            let hexString = String(hex[index...])
            Scanner(string: hexString).scanHexInt64(&rgb)
        } else {
            Scanner(string: hex).scanHexInt64(&rgb)
        }
        
        // Tính toán giá trị màu đỏ, xanh lá cây và xanh dương
        let red = Double((rgb >> 16) & 0xFF) / 255.0
        let green = Double((rgb >> 8) & 0xFF) / 255.0
        let blue = Double(rgb & 0xFF) / 255.0
        self.init(red: red, green: green, blue: blue)
    }
}
