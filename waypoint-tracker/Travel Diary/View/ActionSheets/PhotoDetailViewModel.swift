//import SwiftUI
//
//
//enum PhotoDetailViewModelState {
//    case loading
//    case loaded
//}
//
//class PhotoDetailViewModel: ObservableObject {
//    @Published var imageId: String = ""
//    @Published var image = Image(systemName: "rays")
//    @Published var state: PhotoDetailViewModelState = .loading
//    func loadImage(with id: String) {
//        self.state = .loading
//        UIImage.photoroll(with: [id], width: 2000, height: 2000) { [weak self] _, image, _, _, _ in
//            self?.image = Image(uiImage: image)
//            self?.state = .loaded
//            self?.imageId = id
//        }
//    }
//}
//
//extension PhotoDetailViewModel: Equatable {
//    static func == (lhs: PhotoDetailViewModel, rhs: PhotoDetailViewModel) -> Bool {
//        return lhs.imageId == rhs.imageId
//    }
//}
//
