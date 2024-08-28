import Foundation

func getCurrentTimeFormatted() -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
    dateFormatter.locale = Locale(identifier: "en_US_POSIX")
    let currentDate = Date()
    return dateFormatter.string(from: currentDate)
}   
