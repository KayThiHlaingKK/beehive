//
//  AddAddressInteractor.swift
//  ST Ecommerce
//
//  Created Hive Innovation Dev on 7/27/22.
//  Copyright © 2022 Shashi. All rights reserved.
//

import Foundation

class AddAddressInteractor {
    
    // MARK: Delegate initialization
    var presenter: AddAddressInterectorToPresenterProtocol?
    
    // MARK: - Call Service
    func createAddressAPICall(request: AddressRequest) {
        APIClient.fetchCreateAddress(request: request).execute(onSuccess: { data in
            if data.status == 422 {
                self.presenter?.failAlert(title: "Alert!", message: data.message ?? "")
            }else{
                self.presenter?.successCreateAddress(response: data)
            }
            
        }, onFailure: { error in
            self.presenter?.fail(error: error)
        })
    }
    
    func updateAddressAPICall(request: AddressRequest) {
        APIClient.fetchUpdateAddress(request: request).execute(onSuccess: { data in
            if data.status == 422 {
                self.presenter?.failAlert(title: "Alert!", message: data.message ?? "")
            }else{
                self.presenter?.successUpdateAddress(response: data)
                
            }
            
        }, onFailure: { error in
            self.presenter?.fail(error: error)
        })
    }
    
    func getOneAddressAPICall(slug: String) {
        APIClient.fetchGetOneAddress(slug: slug).execute(onSuccess: { data in
            if data.status == 422 {
                self.presenter?.failAlert(title: "Alert!", message: data.message ?? "")
            }else{
                self.presenter?.successGetOneAddress(response: data)
            }
            
        }, onFailure: { error in
            self.presenter?.fail(error: error)
        })
    }
    
    func updateShopAddressAPICall(request: UpdateAddressRequest) {
        APIClient.fetchShopUpdateAddress(request: request).execute(onSuccess: { data in
            if data.status == 422 {
                self.presenter?.failAlert(title: "Alert!", message: data.message ?? "")
            }else{
                self.presenter?.fetchShopUpdate(data: data)
            }
            
        }, onFailure: { error in
            print(error.localizedDescription)
        })
    }

    
}

// MARK: - Presenter to Interactor
extension AddAddressInteractor: AddAddressPresentorToInterectorProtocol {
    
    func getUserCityAPICall() {
        APIClient.fetchUserCity().execute(onSuccess: { data in
            self.presenter?.successGetCity(data: data)
        }, onFailure: { error in
            self.presenter?.fail(error: error)
        })
    }
    
    func getUserTownShipAPICall(citySlug: String) {
        APIClient.fetchUserTownShip(citySlug: citySlug).execute(onSuccess: { data in
            self.presenter?.successGetTownShip(data: data)
        }, onFailure: { error in
            self.presenter?.fail(error: error)
        })
    }
    
}
