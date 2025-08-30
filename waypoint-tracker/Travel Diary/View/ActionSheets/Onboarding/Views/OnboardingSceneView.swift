import SwiftUI

struct OnboardingSceneView: View {
    @EnvironmentObject var viewModel: OnboardingViewModel
    @Binding var id: String

    private var slides: [OnboardingSlideView] {
        var result: [OnboardingSlideView] = []
        for topic in viewModel.topics {
            if topic.id == id {
                for slide in topic.slides {
                    let slideView = OnboardingSlideView(title: topic.title, titleColor: viewModel.color.title, slide: slide)
                    result.append(slideView)
                }
                break
            }
        }
        return result
    }

    private var anyViewSlides: [AnyView] { slides.map { AnyView($0) } }

    private var slideColors: [Color] {
        var result: [Color] = []
        for topic in viewModel.topics {
            if topic.id == id {
                for slide in topic.slides {
                    result.append(slide.backgroundColor)
                }
                break
            }
        }
        return result
    }

    var body: some View {
        var isLastPage: Bool {
            onboardingSceneView.currentPageIndex == self.slides.count - 1
        }

        var isFirstPage: Bool {
            onboardingSceneView.currentPageIndex > 0
        }
        var onboardingSceneView = ConcentricOnboardingView(pages: self.slides.map { AnyView($0) }, bgColors: self.slideColors, duration: 0.8)

        onboardingSceneView.insteadOfCyclingToFirstPage = {
            self.id = "" // back to the topics view
        }
        onboardingSceneView.didPressExit = { self.id = "" }
        return onboardingSceneView
            .gesture(
                DragGesture()
                    .onChanged { gesture in
                        if gesture.translation.width < -150, onboardingSceneView.currentPageIndex < self.slides.count - 1 {
                            onboardingSceneView.goToNextPage(animated: true)
                        } else if gesture.translation.width > 150, onboardingSceneView.currentPageIndex > 0 {
                            onboardingSceneView.goToPreviousPage(animated: true)
                        }
                    }
            )
    }
}
