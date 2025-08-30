//
//  ContentView.swift
//  ConcentricOnboarding
//
//  Created by Alisa Mylnikova on 30/07/2019.
//  Copyright © 2019 Exyte. All rights reserved.
//

import SwiftUI

class ObservableBool: ObservableObject {
    @Published var value: Bool {
        didSet {
            didSet?()
        }
    }

    var didSet: (() -> ())?

    init(_ value: Bool = false) {
        self.value = value
    }
}

class ObservableInt: ObservableObject {
    @Published var value: Int {
        didSet {
            didSet?()
        }
    }

    var didSet: (() -> ())?

    init(_ value: Int = 0) {
        self.value = value
    }
}

public struct ConcentricOnboardingView: View {
    public var animationWillBegin = {}
    public var animationDidEnd = {}
    public var didGoToLastPage = {}
    public var didPressExit = {}

    public var insteadOfCyclingToFirstPage: (() -> ())?
    public var insteadOfCyclingToLastPage: (() -> ())?
    public var didPressNextButton: (() -> ())? // replaces default button action with user's custom closure

    public var currentPageIndex: Int {
        return currentIndex.value
    }

    public var isLastIndex: Bool {
        return currentPageIndex == (pages.count - 1)
    }

    let radius: Double = 30
    let limit: Double = 15

    static let timerStep = 0.02
    let timer = Timer.publish(every: timerStep, on: .current, in: .common).autoconnect()
    var step: Double {
        2 * limit / (duration / ConcentricOnboardingView.timerStep)
    }

    let pages: [AnyView]
    let bgColors: [Color]
    let duration: Double // in seconds

    @ObservedObject var currentIndex = ObservableInt()
    @ObservedObject var nextIndex = ObservableInt(1)
    @ObservedObject var isAnimating = ObservableBool()
    @ObservedObject var isAnimatingForward = ObservableBool(true)

    @State var progress: Double = 0
    @State var bgColor = Color.white
    @State var fgColor = Color.white

    @State var shape = Circle().asAnyView()

    public init(pages: [AnyView], bgColor: Color, duration: Double = 1.0) {
        let backgroundColors = pages.map { _ in bgColor }
        self.init(pages: pages, bgColors: backgroundColors, duration: duration)
    }

    public init(pages: [AnyView], bgColors: [Color], duration: Double = 1.0) {
        self.pages = pages
        self.bgColors = bgColors
        self.duration = duration
    }

    func viewWillAppear() {
        bgColor = bgColors[currentIndex.value]
        fgColor = bgColors[nextIndex.value]

        let diameter = CGFloat(radius * 2)
        shape = Circle()
            .foregroundColor(fgColor)
            .frame(width: diameter, height: diameter, alignment: .center)
            .asAnyView()

        isAnimating.didSet = {
            if self.isAnimating.value, self.pages.count < 2 || self.bgColors.count < 2 {
                self.isAnimating.value = false
            } else {
                self.isAnimating.value ? self.animationWillBegin() : self.animationDidEnd()
            }
        }

        currentIndex.didSet = {
            if self.currentIndex.value == self.pages.count - 1 {
                self.didGoToLastPage()
            }
        }
    }

    public var body: some View {
        ZStack {
            bgColor

            VStack {
                Spacer()
                HStack {
                    //   Spacer()
                    ZStack {
                        Button(action: {
                            if let block = self.didPressNextButton {
                                block()
                            } else {
                                self.goToNextPage(animated: true)
                            }
                        }) { shape }

                        if !isAnimating.value {
                            Image(systemName: self.isLastIndex ? "xmark" : "arrow.right") // "chevron.right")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 18)
                                .foregroundColor(.white)
                        }
                    }
                }
                .padding(.bottom, 50)
            }
            currentPage()

            if !self.isLastIndex {
                VStack {
                    HStack {
                        Spacer()
                        Button(action: {
                            self.didPressExit()
                        }) {
                            Image(systemName: "xmark")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 18)
                                .foregroundColor(.white)
                                .padding()
                        }
                    }
                    Spacer()
                }
            }

            VStack {
                Spacer()
                HStack {
                    ForEach(0..<self.pages.count) { index in
                        Circle()
                            .overlay(
                                Circle()
                                    .stroke(Color.white, lineWidth: 1)
                            )
                            .foregroundColor(self.currentPageIndex != index || self.isAnimating.value ? Color.clear : Color.white)
                            .animation(.easeInOut(duration: 0.3))
                            .frame(width: 8, height: 8)
                            .padding(.vertical, 10)
                            .onTapGesture {
                                if index < self.currentPageIndex {
                                    self.goToPreviousPage(animated: true)

                                } else if index > self.currentPageIndex {
                                    self.goToNextPage(animated: true)
                                }
                            }
                    }
                }
                .padding(8)
            }
        }
        .onReceive(timer) { _ in
            if !self.isAnimating.value {
                return
            }
            self.isAnimatingForward.value ? self.refreshAnimatingViewsForward() : self.refreshAnimatingViewsBackward()
        }

        .onAppear {
            self.viewWillAppear()
        }
    }

    func createGrowingShape(_ progress: Double) -> AnyView {
        let r = CGFloat(radius + pow(2, progress))
        let d = r * 2
        let delta = CGFloat((1 - progress / limit) * radius)
        if progress > 10 {
            return AnyView(Path { b in
                b.addArc(center: CGPoint(x: UIScreen.main.bounds.width / 2 + r + CGFloat(radius) - delta, y: UIScreen.main.bounds.height / 2), radius: r, startAngle: Angle(radians: -.pi / 2), endAngle: Angle(radians: .pi / 2), clockwise: true)
            }.foregroundColor(fgColor))
        } else {
            return AnyView(Circle().foregroundColor(fgColor).position(x: d - delta, y: r).frame(width: d, height: d))
        }
    }

    func createShrinkingShape(_ progress: Double) -> AnyView {
        let r = CGFloat(radius + pow(2, limit - progress))
        let d = r * 2
        let delta = CGFloat(progress / limit * radius)
        if progress < limit - 10 {
            return AnyView(Path { b in
                b.addArc(center: CGPoint(x: UIScreen.main.bounds.width / 2 - r + CGFloat(radius) + delta, y: UIScreen.main.bounds.height / 2), radius: r, startAngle: Angle(radians: -.pi / 2), endAngle: Angle(radians: .pi / 2), clockwise: false)
            }.foregroundColor(fgColor))
        } else {
            return AnyView(Circle().foregroundColor(fgColor).position(x: delta, y: r).frame(width: d, height: d))
        }
    }

    func refreshAnimatingViewsForward() {
        progress += step
        if progress < limit {
            bgColor = bgColors[currentIndex.value]
            fgColor = bgColors[nextIndex.value]
            shape = createGrowingShape(progress)
        } else if progress < 2 * limit {
            bgColor = bgColors[nextIndex.value]
            fgColor = bgColors[currentIndex.value]
            shape = createShrinkingShape(progress - limit)
        } else {
            isAnimating.value = false
            progress = 0
            goToNextPage(animated: false)
        }
    }

    func refreshAnimatingViewsBackward() {
        progress += step
        let backwardProgress = 2 * limit - progress
        if progress < limit {
            bgColor = bgColors[currentIndex.value]
            fgColor = bgColors[nextIndex.value]
            shape = createShrinkingShape(backwardProgress - limit)
        } else if progress < 2 * limit {
            bgColor = bgColors[nextIndex.value]
            fgColor = bgColors[currentIndex.value]
            shape = createGrowingShape(backwardProgress)
        } else {
            isAnimating.value = false
            progress = 0
            goToPrevPageUnanimated()
        }
    }

    func currentPage() -> some View {
        let maxXOffset = 600.0
        let maxYOffset = 40.0
        let currentPageOffset = easingOutProgressFor(time: progress / limit / 2)
        let nextPageOffset = easingInProgressFor(time: 1 - progress / limit / 2)
        let coeff: CGFloat = isAnimatingForward.value ? -1 : 1

        var reverseScaleFactor = 1 - nextPageOffset / 3
        if reverseScaleFactor == 0 {
            reverseScaleFactor = 1
        }

        return ZStack {
            if pages.count > 0 { pages[currentIndex.value]
                // swap effects order to create another animation
                .scaleEffect(CGFloat(1 - currentPageOffset / 3))
                .offset(x: coeff * CGFloat(maxXOffset * currentPageOffset),
                        y: CGFloat(maxYOffset * currentPageOffset))
            }

            if pages.count > 1 { pages[nextIndex.value]
                .scaleEffect(CGFloat(reverseScaleFactor))
                .offset(x: -coeff * CGFloat(maxXOffset * nextPageOffset),
                        y: CGFloat(maxYOffset * nextPageOffset))
            }
        }
    }

    func updateColors() {
        let diameter = CGFloat(radius * 2)

        bgColor = bgColors[currentIndex.value]
        fgColor = bgColors[nextIndex.value]
        shape = AnyView(
            Circle()
                .foregroundColor(fgColor)
                .frame(width: diameter, height: diameter)
        )
    }

    func goToNextPageAnimated() {
        isAnimatingForward.value = true
        nextIndex.value = moveIndexForward(currentIndex.value)
        isAnimating.value = true
    }

    func goToNextPageUnanimated() {
        isAnimatingForward.value = true
        currentIndex.value = moveIndexForward(currentIndex.value)
        nextIndex.value = moveIndexForward(currentIndex.value)
        updateColors()
    }

    func goToPrevPageAnimated() {
        isAnimatingForward.value = false
        nextIndex.value = moveIndexBackward(currentIndex.value)
        isAnimating.value = true
    }

    func goToPrevPageUnanimated() {
        isAnimatingForward.value = false
        currentIndex.value = moveIndexBackward(currentIndex.value)
        nextIndex.value = moveIndexBackward(currentIndex.value)
        updateColors()
    }

    public func goToNextPage(animated: Bool = true) {
        if currentIndex.value == pages.count - 1, let block = insteadOfCyclingToFirstPage {
            block()
        } else {
            animated ? goToNextPageAnimated() : goToNextPageUnanimated()
        }
    }

    public func goToPreviousPage(animated: Bool = true) {
        if currentIndex.value == 0, let block = insteadOfCyclingToLastPage {
            block()
        } else {
            animated ? goToPrevPageAnimated() : goToPrevPageUnanimated()
        }
    }

    // helpers

    func easingInProgressFor(time t: Double) -> Double {
        return t * t
    }

    func easingOutProgressFor(time t: Double) -> Double {
        return -(t * (t - 2))
    }

    func moveIndexForward(_ index: Int) -> Int {
        if index + 1 < pages.count {
            return index + 1
        } else {
            return 0
        }
    }

    func moveIndexBackward(_ index: Int) -> Int {
        if index - 1 >= 0 {
            return index - 1
        } else {
            return pages.count - 1
        }
    }
}

extension View {
    func asAnyView() -> AnyView {
        return AnyView(self)
    }
}
