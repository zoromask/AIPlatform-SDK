import SwiftUI

struct loadImageFromURL: View {
    let urlImage: String
    let defaultImage: String

    var body: some View {
        if let imageUrl = URL(string: urlImage) {
            if #available(iOS 15.0, *) {
                AsyncImage(url: imageUrl) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    case .failure:
                        Image(defaultImage)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    @unknown default:
                        Image(defaultImage)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    }
                }
            } else {
                Image(defaultImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
        } else {
            Image(defaultImage)
                .resizable()
                .aspectRatio(contentMode: .fit)
        }
    }
}
