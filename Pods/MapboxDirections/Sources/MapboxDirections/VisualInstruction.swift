import Foundation
#if canImport(CoreLocation)
import CoreLocation
#else
import Turf
#endif

/**
 The contents of a banner that should be displayed as added visual guidance for a route. The banner instructions are children of the steps during which they should be displayed, but they refer to the maneuver in the following step.
 */
open class VisualInstruction: Codable {
    // MARK: Creating a Visual Instruction
    
    private enum CodingKeys: String, CodingKey {
        case text
        case maneuverType = "type"
        case maneuverDirection = "modifier"
        case components
        case finalHeading = "degrees"
    }

    /**
     Initializes a new visual instruction banner object that displays the given information.
     */
    public init(text: String?, maneuverType: ManeuverType?, maneuverDirection: ManeuverDirection?, components: [Component], degrees: CLLocationDegrees? = nil) {
        self.text = text
        self.maneuverType = maneuverType
        self.maneuverDirection = maneuverDirection
        self.components = components
        self.finalHeading = degrees
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(text, forKey: .text)
        try container.encodeIfPresent(maneuverType, forKey: .maneuverType)
        try container.encodeIfPresent(maneuverDirection, forKey: .maneuverDirection)
        try container.encode(components, forKey: .components)
        try container.encodeIfPresent(finalHeading, forKey: .finalHeading)
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        text = try container.decodeIfPresent(String.self, forKey: .text)
        maneuverType = try container.decodeIfPresent(ManeuverType.self, forKey: .maneuverType)
        maneuverDirection = try container.decodeIfPresent(ManeuverDirection.self, forKey: .maneuverDirection)
        components = try container.decode([Component].self, forKey: .components)
        finalHeading = try container.decodeIfPresent(CLLocationDegrees.self, forKey: .finalHeading)
    }
    
    // MARK: Displaying the Instruction Text
    
    /**
     A plain text representation of the instruction.
     
     This property is set to `nil` when the `text` property in the Mapbox Directions API response is an empty string.
     */
    public let text: String?

    /**
     A structured representation of the instruction.
     */
    public let components: [Component]
    
    // MARK: Displaying a Maneuver Image

    /**
     The type of maneuver required for beginning the step described by the visual instruction.
     */
    public var maneuverType: ManeuverType?

    /**
     Additional directional information to clarify the maneuver type.
     */
    public var maneuverDirection: ManeuverDirection?

    /**
     The heading at which the user exits a roundabout (traffic circle or rotary).

     This property is measured in degrees clockwise relative to the user’s initial heading. A value of 180° means continuing through the roundabout without changing course, whereas a value of 0° means traversing the entire roundabout back to the entry point.

     This property is only relevant if the `maneuverType` is any of the following values: `ManeuverType.takeRoundabout`, `ManeuverType.takeRotary`, `ManeuverType.turnAtRoundabout`, `ManeuverType.exitRoundabout`, or `ManeuverType.exitRotary`.
     */
    public var finalHeading: CLLocationDegrees?
}

extension VisualInstruction: Equatable {
    public static func == (lhs: VisualInstruction, rhs: VisualInstruction) -> Bool {
        return lhs.text == rhs.text &&
            lhs.maneuverType == rhs.maneuverType &&
            lhs.maneuverDirection == rhs.maneuverDirection &&
            lhs.components == rhs.components &&
            lhs.finalHeading == rhs.finalHeading
    }
}
