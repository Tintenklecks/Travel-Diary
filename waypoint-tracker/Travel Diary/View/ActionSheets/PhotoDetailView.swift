//import SwiftUI
//
//struct PhotoDetailView: View {
//    @Binding var imageId: String
//    
//    @State private var viewModel: PhotoDetailViewModel = PhotoDetailViewModel()
//    @State private var scale: CGFloat = 1
//    var body: some View {
//        VStack(spacing: 0) {
//            HStack {
//                Spacer()
//                Text(viewModel.imageId)
//                Spacer()
//                
//            }.background(Color.highlightInvers)
//            ScrollView([.horizontal, .vertical]) {
//                viewModel.image.resizable().scaleEffect(scale)
//            }
//        }
//        .onAppear {
//            self.viewModel.loadImage(with: self.imageId)
//        }
//    }
//}
