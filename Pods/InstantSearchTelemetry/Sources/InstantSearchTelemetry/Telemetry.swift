//
//  InstantSearchTelemetry.swift
//  
//
//  Created by Vladislav Fitc on 06/10/2021.
//

import Foundation

public typealias TelemetryComponent = Com_Algolia_Instantsearch_Telemetry_Component
public typealias TelemetryComponentType = Com_Algolia_Instantsearch_Telemetry_ComponentType
public typealias TelemetryComponentParams = Com_Algolia_Instantsearch_Telemetry_ComponentParam
public typealias TelemetrySchema = Com_Algolia_Instantsearch_Telemetry_Schema

public class InstantSearchTelemetry {
  
  /// Shared telemetry tracking instance
  public static let shared = InstantSearchTelemetry()
  
  /// Whether the telemetry tracing is enabled
  public var isEnabled: Bool = true
  
  /// Dictionary mapping a component to its type, ensuring each component is tracked only once
  var components: [TelemetryComponentType: TelemetryComponent] = [:] {
    didSet {
      if oldValue != components {
        schema = .with {
          $0.components = Array(components.values).sorted(by: { $0.type.rawValue < $1.type.rawValue })
        }
      }
    }
  }
  
  /// Telemetry protobuf schema
  /// - Note: Updated after each update of the `components` dictionary
  private var schema: TelemetrySchema = .init()
  
  /// Telemetry information encoded as  base64 gzipped string
  public var encodedValue: String? {
    guard isEnabled else {
      return nil
    }
    guard let telemetryDataString = try? schema.serializedData().gzipped().base64EncodedString() else {
      return nil
    }
    return telemetryDataString
  }
  
  /// Remove all collected telemetry data
  public func reset() {
    components.removeAll()
  }
  
  /// Get component of the provided type
  public func component(ofType type: TelemetryComponentType) -> TelemetryComponent? {
    return components[type]
  }
  
  public func traceConnector(type: TelemetryComponentType,
                             parameters: TelemetryComponentParams...) {
    traceConnector(type: type,
                   parameters: parameters)
  }
  
  public func traceConnector(type: TelemetryComponentType,
                             parameters: [TelemetryComponentParams?]) {
    traceConnector(type: type,
                   parameters: parameters.compactMap { $0 })
  }
  
  public func traceConnector(type: TelemetryComponentType,
                             parameters: [TelemetryComponentParams]) {
    trace(type: type,
          parameters: parameters,
          isConnector: true)
  }
  
  public func trace(type: TelemetryComponentType,
                    parameters: TelemetryComponentParams...) {
    trace(type: type,
          parameters: parameters)
  }
  
  public func trace(type: TelemetryComponentType,
                    parameters: [TelemetryComponentParams?]) {
    trace(type: type,
          parameters: parameters.compactMap { $0 })
  }
  
  
  public func trace(type: TelemetryComponentType,
                    parameters: [TelemetryComponentParams]) {
    trace(type: type,
          parameters: parameters,
          isConnector: false)
  }
  
  private func trace(type: TelemetryComponentType,
                     parameters: [TelemetryComponentParams],
                     isConnector: Bool) {
    guard isEnabled else { return }
    
    let isExistingComponentConnector: Bool
    let existingComponentParameters: [TelemetryComponentParams]
    
    if let existingComponent = components[type] {
      isExistingComponentConnector = existingComponent.isConnector
      existingComponentParameters = existingComponent.parameters
    } else {
      isExistingComponentConnector = false
      existingComponentParameters = []
    }
    
    let component = TelemetryComponent.with {
      $0.type = type
      $0.parameters = Array(Set(parameters).union(existingComponentParameters)).sorted(by: { $0.rawValue < $1.rawValue })
      $0.isConnector = isExistingComponentConnector || isConnector
    }
    
    components[type] = component
  }
  
}

// Covenient aliases for parameters whose names conflict with component names
public extension TelemetryComponentParams {
  
  static let filterState = TelemetryComponentParams.filterStateParameter
  static let hitsSearcher = TelemetryComponentParams.hitsSearcherParameter
  static let facetSearcher = TelemetryComponentParams.facetSearcherParameter
  
}
