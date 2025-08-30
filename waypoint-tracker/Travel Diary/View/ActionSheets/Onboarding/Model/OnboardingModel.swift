//
//  OnboardingModel.swift
//  Onboarding
//
//  Created by Ingo Böhme on 23.06.20.
//  Copyright © 2020 Ingo Böhme. All rights reserved.
//

import Foundation
import SwiftUI

// MARK: - Onboarding

struct OnboardingModel: Codable {
    
    var title: String = "Error"
    var topics: [OnboardingTopicModel] = []
    var colorIndex: Int = 0


    init() {
        if let url = Bundle.main.url(forResource: "Onboarding", withExtension: "json") {
            do {
                let jsonData = try Data(contentsOf: url)
                let modelData = try JSONDecoder().decode(OnboardingModel.self, from: jsonData)
                self.topics = modelData.topics
                self.title = modelData.title
                self.colorIndex = modelData.colorIndex
                return

            } catch let DecodingError.dataCorrupted(context) {
                print(context)
            } catch let DecodingError.keyNotFound(key, context) {
                print("Key '\(key)' not found:", context.debugDescription)
                print("codingPath:", context.codingPath)
            } catch let DecodingError.valueNotFound(value, context) {
                print("Value '\(value)' not found:", context.debugDescription)
                print("codingPath:", context.codingPath)
            } catch let DecodingError.typeMismatch(type, context) {
                print("Type '\(type)' mismatch:", context.debugDescription)
                print("codingPath:", context.codingPath)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}


// MARK: - OnboardingTopic

struct OnboardingTopicModel: Codable {
    let title, text, icon: String
    let slides: [OnboardingSlideModel]
}

// MARK: - Slide

struct OnboardingSlideModel: Codable {
    let version, title, text, image: String
    var colorIndex: Int = 0

}

