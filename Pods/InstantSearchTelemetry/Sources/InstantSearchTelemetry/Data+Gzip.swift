//
//  Data+Gzip.swift
//  
//
//  Created by Vladislav Fitc on 18/05/2022.
//

import Foundation

extension Data {
  
  func gzipped() -> Data {
    Gzip.gzipCompress(self)
  }
    
  func gunzipped() throws -> Data {
    try Gzip.gzipDecomress(self)
  }
  
}

