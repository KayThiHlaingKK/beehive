//
//  MyProtocols.swift
//  ST Ecommerce
//
//  Created by necixy on 06/07/20.
//  Copyright © 2020 Shashi. All rights reserved.
//

import Foundation

//MARK: - Tinny Credit Card
protocol TinnyDoneDelegate : NSObjectProtocol {
    func fillingDetailsDone()
}

protocol ChooseOpationDelegate {
    func chooseFoodOption()
    func chooseShopOption()
}
