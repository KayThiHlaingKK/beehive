//
//  Gzip.swift
//  
//
//  Created by Vladislav Fitc on 19/05/2022.
//

import Foundation
import Compression

struct Gzip {
  
  static let header = Data([0x1f, 0x8b, 0x08, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x13])
  static let footerSize = 8
  
  static func footer(for data: Data) -> Data {
    var checksum = CRC32.checksum(bytes: data.map { $0 })
    let checksumData = Data(bytes: &checksum,
                            count: MemoryLayout.size(ofValue: checksum))
    var size = Int32(data.count)
    let sizeData = Data(bytes: &size,
                        count: MemoryLayout.size(ofValue: size))
    
    var output = Data()
    output.append(checksumData)
    output.append(sizeData)
    return output
  }
  
  static func zlibCompress(_ data: Data) -> Data {
    let dataSize = data.count
    let byteSize = MemoryLayout<UInt8>.stride
    let bufferSize = dataSize / byteSize
    let destinationBuffer = UnsafeMutablePointer<UInt8>.allocate(capacity: bufferSize)
    var sourceBuffer = Array<UInt8>(repeating: 0, count: bufferSize)
    data.copyBytes(to: &sourceBuffer, count: dataSize)
    let compressedSize = compression_encode_buffer(destinationBuffer,
                                                   dataSize,
                                                   &sourceBuffer,
                                                   dataSize,
                                                   nil,
                                                   COMPRESSION_ZLIB)
    return NSData(bytesNoCopy: destinationBuffer, length: compressedSize) as Data
  }
  
  static func zlibDecompress(_ data: Data) throws -> Data {
    let decodedCapacity = 8_000_000
    let decodedDestinationBuffer = UnsafeMutablePointer<UInt8>.allocate(capacity: decodedCapacity)
    return data.withUnsafeBytes {
      (encodedSourceBuffer: UnsafeRawBufferPointer) -> Data in
      let decodedCharCount = compression_decode_buffer(decodedDestinationBuffer,
                                                       decodedCapacity,
                                                       encodedSourceBuffer.bindMemory(to: UInt8.self).baseAddress!,
                                                       data.count,
                                                       nil,
                                                       COMPRESSION_ZLIB)
      
      return NSData(bytesNoCopy: decodedDestinationBuffer, length: decodedCharCount) as Data
    }
  }
  
  static func gzipCompress(_ data: Data) -> Data {
    var output = Data()
    output.append(header)
    output.append(zlibCompress(data))
    output.append(footer(for: data))
    return output
  }
  
  static func gzipDecomress(_ data: Data) throws -> Data {
    return try zlibDecompress(data.dropFirst(header.count).dropLast(footerSize))
  }
  
}
