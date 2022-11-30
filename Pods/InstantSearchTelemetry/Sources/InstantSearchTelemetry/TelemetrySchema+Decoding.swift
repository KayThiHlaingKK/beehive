//
//  TelemetrySchema+Decoding.swift
//  
//
//  Created by Vladislav Fitc on 27/01/2022.
//

import Foundation

public enum TelemetrySchemaDecodingError: Error {
  case base64DecodingFailure
  case deserializationError(Error)
  case unzipFailure(Error)
}

public extension TelemetrySchema {
  
  init(gzippedBase64String input: String) throws {
    guard let compressedData = Data(base64Encoded: input) else {
      throw TelemetrySchemaDecodingError.base64DecodingFailure
    }
    
    let uncompressedData: Data
    do {
      uncompressedData = try compressedData.gunzipped()
    } catch let unzipError {
      throw TelemetrySchemaDecodingError.unzipFailure(unzipError)
    }
    
    do {
      self = try TelemetrySchema(serializedData: uncompressedData)
    } catch let deserializationError {
      throw TelemetrySchemaDecodingError.deserializationError(deserializationError)
    }
  }
  
}
