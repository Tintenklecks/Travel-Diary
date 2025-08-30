//

import ClockKit
import Combine

class ComplicationController: NSObject, CLKComplicationDataSource {
    // MARK: - Timeline Configuration

//    static var heading: Double = 0
//    static var bearing: Double = 0
//
//    let headingPublisher: AnyCancellable = LocationPublisher.shared.headingPublisher.sink { heading in
//        ComplicationController.heading = heading.trueHeading
//        let destination = Settings.lastDestination.1
//        let bearing = Settings.lastLocation.bearing(to: destination)
//        ComplicationController.bearing = bearing - heading.trueHeading
//    }
//

    enum Directions {
        case west
        case northwest
        case north
        case northeast
        case east
        case southeast
        case south
        case southwest

        var sign: String {
            switch self {
            case .west: return " ⃪←"
            case .northwest: return "⬉↖︎"
            case .north: return "↑⇧⬆︎"
            case .northeast: return "➚↗︎⬈͢"
            case .east: return "→➞"
            case .southeast: return "➘⬊↘︎"
            case .south: return "↓⬇︎"
            case .southwest: return "↙︎⬋"
            }
        }
    }

    func getSupportedTimeTravelDirections(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimeTravelDirections) -> Void) {
        handler([.forward, .backward])
    }

    func getTimelineStartDate(for complication: CLKComplication, withHandler handler: @escaping (Date?) -> Void) {
        handler(nil)
    }

    func getTimelineEndDate(for complication: CLKComplication, withHandler handler: @escaping (Date?) -> Void) {
        handler(nil)
    }

    func getPrivacyBehavior(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationPrivacyBehavior) -> Void) {
        handler(.showOnLockScreen)
    }

    // MARK: - Timeline Population

    func getCurrentTimelineEntry(for complication: CLKComplication,
                                 withHandler handler: @escaping (CLKComplicationTimelineEntry?) -> Void) {
        let date = Date()
        var template: CLKComplicationTemplate!

//        var rotatedImage: UIImage {
//            if let image = UIImage(named: "CompassArrow Graphic Circular"),
//                let rotated = image.rotate(angle: CGFloat(ComplicationController.bearing)) {
//                return rotated
//            }
//            return UIImage()
//        }

        switch complication.family {
        case .circularSmall:
            handler(nil)
            return
//            template = CLKComplicationTemplateCircularSmallStackText()
//            template = CLKComplicationTemplateCircularSmallStackImage()
//
//            template = CLKComplicationTemplateCircularSmallSimpleText()
//            template = CLKComplicationTemplateCircularSmallSimpleImage()
//
//            template = CLKComplicationTemplateCircularSmallRingText()
//            template = CLKComplicationTemplateCircularSmallRingImage()

        case .extraLarge:
            handler(nil)
            return
//                template = CLKComplicationTemplateExtraLargeStackText()
//            template = CLKComplicationTemplateExtraLargeStackImage()
//
//            template = CLKComplicationTemplateExtraLargeSimpleText()
//            template = CLKComplicationTemplateExtraLargeSimpleImage()
//
//            template = CLKComplicationTemplateExtraLargeRingText()
//            template = CLKComplicationTemplateExtraLargeRingImage()
//
//            template = CLKComplicationTemplateExtraLargeColumnsText()
        case .modularSmall:
            handler(nil)
            return
//                template = CLKComplicationTemplateModularSmallStackText()
//            template = CLKComplicationTemplateModularSmallStackImage()
//
//            template = CLKComplicationTemplateModularSmallSimpleText()
//            template = CLKComplicationTemplateModularSmallSimpleImage()
//
//            template = CLKComplicationTemplateModularSmallRingText()
//            template = CLKComplicationTemplateModularSmallRingImage()
//
//            template = CLKComplicationTemplateModularSmallColumnsText()
        case .modularLarge:
            handler(nil)
            return
//                template = CLKComplicationTemplateModularLargeTable()
//            template = CLKComplicationTemplateModularLargeColumns()
//            template = CLKComplicationTemplateModularLargeTallBody()
//            template = CLKComplicationTemplateModularLargeStandardBody()
        case .utilitarianSmall:
            handler(nil)
            return
//                template = CLKComplicationTemplateUtilitarianSmallFlat()
//            template = CLKComplicationTemplateUtilitarianSmallSquare()
//            template = CLKComplicationTemplateUtilitarianSmallRingText()
//            template = CLKComplicationTemplateUtilitarianSmallRingImage()
        case .utilitarianSmallFlat:
            handler(nil)
            return
//                template = CLKComplicationTemplateUtilitarianSmallFlat()
        case .utilitarianLarge:
            handler(nil)
            return
//                template = CLKComplicationTemplateUtilitarianLargeFlat()
        case .graphicCorner:
            handler(nil)
            return
//                template = CLKComplicationTemplateGraphicCornerCircularImage()
//            template = CLKComplicationTemplateGraphicCornerGaugeText()
//            template = CLKComplicationTemplateGraphicCornerGaugeImage()
//            template = CLKComplicationTemplateGraphicCornerStackText()
//            template = CLKComplicationTemplateGraphicCornerTextImage()
        case .graphicCircular:
//            let graphicCircular = CLKComplicationTemplateGraphicCircularOpenGaugeRangeText()
//            graphicCircular.centerTextProvider = CLKSimpleTextProvider(text: "60")
//            graphicCircular.leadingTextProvider = CLKSimpleTextProvider(text: "ll")
//            graphicCircular.trailingTextProvider = CLKSimpleTextProvider(text: "tt")
//            graphicCircular.gaugeProvider = CLKTimeIntervalGaugeProvider(
//                style: .ring,
//                gaugeColors: [UIColor.red,UIColor.yellow],
//                gaugeColorLocations: [0.5, 0.5], start: Date(), end: Date().addingTimeInterval(1))
//            template = graphicCircular

            let tmp = CLKComplicationTemplateGraphicCircularImage()

            tmp.imageProvider = CLKFullColorImageProvider(fullColorImage: UIImage(named: "Graphic Circular") ?? UIImage())

            template = tmp

//            template = CLKComplicationTemplateGraphicCircularImage()
//            template = CLKComplicationTemplateGraphicCircularOpenGaugeImage()
//            template = CLKComplicationTemplateGraphicCircularOpenGaugeRangeText()
//            template = CLKComplicationTemplateGraphicCircularOpenGaugeSimpleText()
//            template = CLKComplicationTemplateGraphicCircularClosedGaugeText()
//            template = CLKComplicationTemplateGraphicCircularClosedGaugeImage()
        case .graphicBezel:
            handler(nil)
            return
//            template = CLKComplicationTemplateGraphicBezelCircularText()
        case .graphicRectangular:
            handler(nil)
            return
//            template = CLKComplicationTemplateGraphicRectangularLargeImage()
//            template = CLKComplicationTemplateGraphicRectangularStandardBody()
//            template = CLKComplicationTemplateGraphicRectangularTextGauge()
//            break
        @unknown default:
            fatalError("Unknown complication")
        }

        let entry = CLKComplicationTimelineEntry(date: date, complicationTemplate: template)
        handler(entry) // Call the handler with the current timeline entry
    }

    func getTimelineEntries(for complication: CLKComplication, before date: Date, limit: Int, withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void) {
        // Call the handler with the timeline entries prior to the given date
        handler(nil)
    }

    func getTimelineEntries(for complication: CLKComplication, after date: Date, limit: Int, withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void) {
        // Call the handler with the timeline entries after to the given date
        handler(nil)
    }

    // MARK: - Placeholder Templates

    func getLocalizableSampleTemplate(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTemplate?) -> Void) {
        // This method will be called once per supported complication, and the results will be cached
        handler(nil)
    }
}
