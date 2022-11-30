//
//  SearchSuggestionTableViewCell.swift
//  ST Ecommerce
//
//  Created by Hive Innovation on 30/11/2021.
//  Copyright © 2021 Shashi. All rights reserved.
//

import Foundation
//import InstantSearchCore
import UIKit

class SearchSuggestionTableViewCell: UITableViewCell {
  
  var didTapTypeAheadButton: (() -> Void)?
  
  private func typeAheadButton() -> UIButton {
    let typeAheadButton = UIButton()
      if #available(iOS 13.0, *) {
          typeAheadButton.setImage(UIImage(systemName: "arrow.up.left"), for: .normal)
      } else {
          // Fallback on earlier versions
      }
    typeAheadButton.sizeToFit()
    typeAheadButton.addTarget(self, action: #selector(typeAheadButtonTap), for: .touchUpInside)
    return typeAheadButton
  }
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    accessoryView = typeAheadButton()
      if #available(iOS 13.0, *) {
          imageView?.image = UIImage(systemName: "magnifyingglass")
      } else {
          // Fallback on earlier versions
      }
    tintColor = .lightGray
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  @objc func typeAheadButtonTap(_ sender: UIButton) {
    didTapTypeAheadButton?()
  }
  
  func setup(with querySuggestion: QuerySuggestion) {
    guard let textLabel = textLabel else { return }
//      textLabel.text = querySuggestion
//    textLabel.attributedText = querySuggestion
//      .highlighted
//      .flatMap(HighlightedString.init)
//      .flatMap { NSAttributedString(highlightedString: $0,
//                                    inverted: true,
//                                    attributes: [.font: UIFont.boldSystemFont(ofSize: textLabel.font.pointSize)])
//    }
  }
  
}

public struct QuerySuggestion {

  /// The suggested search term
  public let query: String

  /// The suggested search term with tagged highlighted part
  public let highlighted: String?

  /// The popularity score of the search term
  public let popularity: Int

}

