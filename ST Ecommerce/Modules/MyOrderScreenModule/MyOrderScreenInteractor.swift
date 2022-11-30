//
//  MyOrderScreenInteractor.swift
//  ST Ecommerce
//
//  Created MacBook Pro on 17/05/2022.
//  Copyright © 2022 Shashi. All rights reserved.

//

import Foundation
import Alamofire

class MyOrderScreenInteractor {
    
    // MARK: Delegate initialization
    var presenter: MyOrderScreenInterectorToPresenterProtocol?
    
    
    // MARK: - Call Service
    func getShopOrdersAPICall(_ data: MyOrderRequest){
        presenter?.fetchingStart()
        APIClient.fetchShopOrderList(requestModel: data).execute(onSuccess: { data in
            if data.status == 200 {
                self.presenter?.shopSuccess(data)
            }else{
                if data.message == "Unauthenticated." {
                    self.presenter?.failAuthenticateStatus(message: data.message ?? "")
                }else{
                    self.presenter?.failStatus(message: data.message ?? "")
                }
            }
        }, onFailure: { error in
            self.presenter?.fail(error: error)
        })
    }
    
    func getFoodOrderAPICall(_ data: MyOrderRequest) {
        presenter?.fetchingStart()
        APIClient.fetchFoodOrderList(requestModel: data).execute(onSuccess: { data in
            if data.status == 200 {
                self.presenter?.foodSuccess(data)
            }else{
                if data.message == "Unauthenticated." {
                    self.presenter?.failAuthenticateStatus(message: data.message ?? "")
                }else{
                    self.presenter?.failStatus(message: data.message ?? "")
                }
            }
        }, onFailure: { error in
            self.presenter?.fail(error: error)
        })
    }
    
    
}

// MARK: - Presenter to Interactor
extension MyOrderScreenInteractor: MyOrderScreenPresentorToInterectorProtocol {
   
}
