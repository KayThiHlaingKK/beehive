//
//  ConfirmPlaceOrderInteractor.swift
//  ST Ecommerce
//
//  Created Hive Innovation Dev on 8/5/22.
//  Copyright © 2022 Shashi. All rights reserved.
//

import Foundation
import UIKit
import KBZPayAPPPay
import InstantSearch
import MapKit
import CoreLocation

class ConfirmPlaceOrderInteractor {
    
    // MARK: Delegate initialization
    var presenter: ConfirmPlaceOrderInterectorToPresenterProtocol?
    
    // MARK: - Call Service
    func userSettingAPICall() {
        presenter?.fetchingStart()
        APIClient.fetchUserSetting().execute(onSuccess: { data in
            self.presenter?.setUserSetting(data: data)
        }, onFailure: { error in
            self.presenter?.fail(error: error)
        })
    }
    
    func confirmPlaceOrderAPICall(cartType: Cart,request: ConfirmOrderRequest) {
        cartType == .restaurant ? (restaurantCheckOutAPICall(request: request)) : (shopCheckOutAPICall(request: request))
    }
    
    func restaurantCheckOutAPICall(request: ConfirmOrderRequest) {
        presenter?.fetchingStart()
        APIClient.fetchRestaurantCheckOut(request: request).execute { data in
            self.presenter?.setCheckOutData(data: data)
        } onFailure: { error in
            self.presenter?.fail(error: error)
        }

    }
    
    func shopCheckOutAPICall(request: ConfirmOrderRequest) {
        presenter?.fetchingStart()
        APIClient.fetchShopCheckOut(request: request).execute { data in
            self.presenter?.setCheckOutData(data: data)
        } onFailure: { error in
            self.presenter?.fail(error: error)
        }

    }
    
    func getCreditAPICall() {
        APIClient.fetchUserCredit().execute(onSuccess: { data in
            self.presenter?.success(data)
        }, onFailure: { error in
            self.presenter?.fail(error: error)
        })
    }
    
    func updateAddressAPICall(request: AddressRequest) {
        APIClient.fetchUpdateAddress(request: request).execute(onSuccess: { data in
            if data.status == 200 {
                Singleton.shareInstance.selectedAddress = data.data
                self.presenter?.setUpdateAddressData(data: data)
            }else{
                self.presenter?.failUpdateAddress()
            }
        }, onFailure: { error in
            self.presenter?.fail(error: error)
        })
    }
    
    func shopUpdateAddressAPICall(request: UpdateAddressRequest) {
        APIClient.fetchShopUpdateAddress(request: request).execute(onSuccess: { data in
            if data.status == 200 {
                self.presenter?.setShopUpdateAddress(data: data)
            }else{
                self.presenter?.failShopUpdateAddress(title: "PromoCodeAlert",message: data.message ?? "")
            }
        }, onFailure: { error in
            self.presenter?.fail(error: error)
        })
    }
    
    
    
    func foodUpdateAddressAPICall(request: UpdateAddressRequest) {
        APIClient.fetchFoodUpdateAddress(request: request).execute(onSuccess: { data in
            if data.status == 200 {
                self.presenter?.setFoodUpdateAddress(data: data)
            }else{
                self.presenter?.failShopUpdateAddress(title: "PromoCodeAlert",message: data.message ?? "")
            }
        }, onFailure: { error in
            self.presenter?.fail(error: error)
        })
    }
    
    func getViewCartAPICall() {
        APIClient.fetchViewCart().execute { data in
            if data.status == 200 {
                if let data = data.data {
                    self.presenter?.setViewCartData(data: data)
                }
            }
        } onFailure: { error in
            self.presenter?.fail(error: error)
        }

    }
    
}

// MARK: - Presenter to Interactor
extension ConfirmPlaceOrderInteractor: ConfirmPlaceOrderPresentorToInterectorProtocol {
    
    
    func kbzPayAPICall(prepayId: String,randomString: String,currentTimeMilliSeconds: Int) {
        let kbzPayVC = PaymentViewController()
        print("goToKBZPay")
        
        #if STAGING
        print("it is staging")
        let MERCHANT_CODE = "200144"
        let APP_ID = "kp8ddaafe77e4b45ba97cff5892ab6b8"
        let APP_KEY = "ef7d003df99dc62c85d2bbd4ff30fbed"
        let urlScheme = "KBZPayAPPPayDemo"
        
        #else
        print("it is production")
        let MERCHANT_CODE = "70025502"
        let APP_ID = "kp10a51ac0acb4439898e781409b9f3a"
        let APP_KEY = "43997935d6e5ac4157b4481c9a184f4e"
        let urlScheme = "KBZPayAPPPay"
        
        #endif
        
//        let nonceStr = randomString(length: 32)
        let nonceStr = randomString
        
        let orderString = "appid=\(APP_ID)&merch_code=\(MERCHANT_CODE)&nonce_str=\(nonceStr)&prepay_id=\(prepayId)&timestamp=\(currentTimeMilliSeconds)"
        
        let signStr = "\(orderString)&key=\(APP_KEY)"
        let sign = signStr.sha256()
        
        print("withOrderInfo == ", orderString)
        print("sign == ", sign)
        print("urlScheme == ", urlScheme)
        
        kbzPayVC.startPay(withOrderInfo: orderString, signType: "SHA256", sign: sign, appScheme: urlScheme)
    }

    func cbPayAPICall(reference: String) {
        var url = NSURL(string: "")
        #if STAGING
        url = NSURL(string: "cbuat://pay?keyreference=" + reference)
        #else
        url = NSURL(string: "cb://pay?keyreference=" + reference)
        #endif
        
        if (UIApplication.shared.canOpenURL(url! as URL)) {
            UIApplication.shared.openURL(url! as URL)
        }else{
            presenter?.urlFail(errorMessage: "The operation couldn’t be completed.")
        }
    }
    
    
    func getAddressFromLatLong(pdblLatitude: String, withLongitude pdblLongitude: String, addressTitle: UILabel, addressLabel: UILabel,cartType: Cart,cartAddress: Address) {
        var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
        let lat: Double = Double("\(pdblLatitude)")!
        let lon: Double = Double("\(pdblLongitude)")!
        let ceo: CLGeocoder = CLGeocoder()
        center.latitude = lat
        center.longitude = lon

        let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)

        var addressString : String = ""
        ceo.reverseGeocodeLocation(loc, completionHandler:
            {(placemarks, error) in
                if (error != nil)
                {
                    print("reverse geodcode fail: \(error!.localizedDescription)")
                }
                let pm = (placemarks ?? nil) as [CLPlacemark]

                if pm.count > 0 {
                    let pm = placemarks![0]

                    if pm.subLocality != nil {
                        addressString = addressString + pm.subLocality! + ", "
                    }
                    if pm.thoroughfare != nil {
                        addressString = addressString + pm.thoroughfare! + ", "
                    }
                    if pm.locality != nil {
                        addressString = addressString + pm.locality! + ", "
                    }
                    if pm.country != nil {
                        addressString = addressString + pm.country! + ", "
                    }
                    if pm.postalCode != nil {
                        addressString = addressString + pm.postalCode! + " "
                    }
                    addressTitle.text = "Home"
                    addressLabel.text = addressString
                    
                    var defaultAddress = Address()
                    defaultAddress.latitude = Double(pdblLatitude)
                    defaultAddress.longitude = Double(pdblLongitude)
                    defaultAddress.street_name = addressString
                    Singleton.shareInstance.selectedAddress = defaultAddress
                    if cartType == .store {
                        self.updateAddressAPICall(request: AddressRequest(label: defaultAddress.label ?? "Home", house_number: defaultAddress.house_number ?? "", street_name: defaultAddress.street_name ?? "", floor: defaultAddress.floor ?? 0, township_slug: defaultAddress.township?.slug ?? "", latitude: defaultAddress.latitude ?? 0.0, longitude: defaultAddress.latitude ?? 0.0, addressSlug: defaultAddress.slug ?? ""))
                        self.shopUpdateAddressAPICall(request: UpdateAddressRequest(customer_slug: Singleton.shareInstance.userProfile?.slug ?? "", house_number: defaultAddress.house_number ?? "", floor: defaultAddress.floor ?? 0, street_name: defaultAddress.street_name ?? "", latitude: defaultAddress.latitude ?? 0.0, longitude: defaultAddress.longitude ?? 0.0, township_slug: defaultAddress.township?.slug ?? ""))
                    }else{
                        self.foodUpdateAddressAPICall(request: UpdateAddressRequest(customer_slug: Singleton.shareInstance.userProfile?.slug ?? "", house_number: defaultAddress.house_number ?? "", floor: defaultAddress.floor ?? 0, street_name: defaultAddress.street_name ?? "", latitude: defaultAddress.latitude ?? 0.0, longitude: defaultAddress.longitude ?? 0.0, township_slug: defaultAddress.township?.slug ?? ""))
                    }
              }
        })
    }
    
}
