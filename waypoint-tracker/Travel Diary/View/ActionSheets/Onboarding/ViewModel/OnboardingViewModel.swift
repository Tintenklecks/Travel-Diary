//
//  OnboardingViewModel.swift
//  Onboarding
//
//  Created by Ingo Böhme on 05.08.20.
//  Copyright © 2020 Ingo Böhme. All rights reserved.
//

import Foundation
import SwiftUI

struct OnboardingSlideColor {
    var title: Color
    var text: Color
    var background: Color
    
    init(index: Int) {
        title = Color("\(index)title")
        text = Color("\(index)fg")
        background = Color("\(index)bg")
    }
}

class OnboardingViewModel: ObservableObject {
    static var colors: [OnboardingSlideColor] = []

    let title: String
    let topics: [OnboardingTopicViewModel]
    let color: OnboardingSlideColor

    init() {
        let model = OnboardingModel()
        
        OnboardingViewModel.colors =  (0...9).map {
            OnboardingSlideColor(index: $0)
        }


        self.title = model.title
        self.color = OnboardingViewModel.colors[model.colorIndex]

        self.topics = model.topics.map {
            OnboardingTopicViewModel(model: $0)
        }
    }

    func getNextId(lastId: String) -> String {
        for topic in self.topics {
            if topic.slides.count > 0 {
                for index in 0..<topic.slides.count {
                    if topic.slides[index].id == lastId {
                        if index < topic.slides.count - 1 {
                            return topic.slides[index + 1].id
                        } else {
                            return ""
                        }
                    }
                }
            }
        }
        return ""
    }

    func slide(id: String) -> OnboardingSlideViewModel? {

        for topic in self.topics {
            if topic.slides.count > 0 {
                if topic.id == id {
                    return topic.slides[0]
                }
                for slide in topic.slides {
                    if slide.id == id {
                        return slide
                    }
                }
            }
        }
        return nil
    }
}

// MARK: - OnboardingTopic

struct OnboardingTopicViewModel: Identifiable {
    let id = UUID().uuidString
    let title, text: String
    let icon: Image
    let slides: [OnboardingSlideViewModel]

    init(model: OnboardingTopicModel) {
        self.title = model.title
        self.text = model.text
        self.icon = Image(model.icon)
        self.slides = model.slides.map {
            OnboardingSlideViewModel(model: $0, topicTitle: model.text)
        }
    }
}

// MARK: - Slide

struct OnboardingSlideViewModel: Identifiable {
    let id = UUID().uuidString
    let version, headline, title, text: String
    var image: Image
    var backgroundColor: Color
    var titleColor: Color
    var textColor: Color

    init(model: OnboardingSlideModel, topicTitle: String) {
        self.version = model.version
        self.headline = topicTitle
        self.title = model.title
        self.text = model.text

        self.backgroundColor = OnboardingViewModel.colors[model.colorIndex].background
        self.titleColor = OnboardingViewModel.colors[model.colorIndex].title
        self.textColor = OnboardingViewModel.colors[model.colorIndex].text

        self.image = Image(model.image)
    }
}

