//
//  MyEnum.swift
//  ST Ecommerce
//
//  Created by necixy on 30/06/20.
//  Copyright © 2020 Shashi. All rights reserved.
//

import Foundation
import Alamofire

//MARK: - API
//var BASEURL = "https://www.hiveinnovation.com.mm/api/" //LIVE SERVER
//let BASEURL = "http://54.151.206.200/stdev/api/" //AWS DEV SERVER


#if STAGING
// MARK: - STAGING SERVER
var BASEURL = "https://beehive-api.hivestage.com/api/v3"
var IMAGE_DOWNLOAD_URL = "https://beehive-images.hivestage.com"
#else
// MARK: - Production SERVER
var BASEURL = "https://api.beehivemm.com/api/v2"
var IMAGE_DOWNLOAD_URL = "https://images.beehivemm.com"
#endif

var appstoreLink = "itms-apps://itunes.apple.com/app/id1542568103"

public enum APIEndPoint
{
    case appVersion
    case townships
    case rating
    case register
    case login
    case cities
    case send_OTP
    case check_OTP
    case forgot_password
    case reset_password
    case change_password
    case logout
    case refreshToken

    case productCategoryWise
    case productsPath
    case product
    case productSearchStore
    case productByCategory
    case categorizedProduct
    case shopSubcategory
    case recommendProduct
    case productCart
    case productPromo
    case productCheckout
    case mpuCheckout
    case mpgsCheckout

    case addToCartStore
    case getCartItemsStore
    case storeCartPath
    case updateItemInCartStore
    case shopCategories
    case categories
    case restaurantCart
    case restaurantPromo

    case restaurant
    case restaurantCategories
    case homeSuggestions
    case announcements
    case promotions
    case restaurantMenuCart
    case restaurantDetailMenu
    case cart
    case restaurantCheckout
    case restaurantsRecommendations

    case getAddresses
    case Address
    case nearestAddress
    case makeAddressPrimary

    case shopOrder
    case foodOrder
    case restaurantRating
    case productRating
    case newArrival
    case brands
    case categoryList
    case productNewArrival
    case productDiscount

    case userProfile
    case serviceAnnouncement
    case checkCredit
    case orderDetails
    case home_banner_sliders
    case home_banner_popup
    case destroyCart
    case getRestaurantsCategorywise
    case getRestaurantsSliders
    case restaurants
    case restaurantsDetail
    case restaurant_categories
    case add
    case getItems
    case getMenu
    case cartPathRestro
    case remove
    case update
    case destroy
    case delete
    case orderPathRestro
    case place
    case detail
    case rate
    case updateprofile
    case productCategory
    case searchRestaurant
    case stores
    case shops
    case donation
    case policy
    case termsAndcondition
    case homeSearch
    case getAllAddresses
    case getAddress
    case getCartCount
    case cancelOrderFood
    case cancelOrderStore
    case reorder
    case moreFromThisShop
    case storeOrders

    case favouriteProductList
    case favouriteRestaurantList

    case validatePromo
    case searchHistory
    case clearHistory

    case trackOrder
    case trackOrderStore
    case removeCode
    case removeCodeRestro
    case applyPromoCode
    case applyPromoCodeRestro
    case validateCode
    case validateCodeRestro
    case updatePushToken

    case buy_Now
    case supports
    case otherProducts
    case notificationData
    case makePrimary
    case check_in
    case rewards

    case createToken
    case shopAllSearch
    case userSetting

    var caseValue: String{
        switch self{

        case .appVersion:                   return "/versions"
        case  .homeSearch:                 return "/user/search?keyword="
        case .homeSuggestions:                                 return "/user/suggestions"//"home/suggestions"
        case .newArrival:                             return "/user/new-arrivals"//"home/new-arrivals"
        case .brands:                               return "/user/brands"
        case .categoryList:                         return "/user/shop-main-categories?populate=1"
        case .announcements:                        return "/announcements"
        case .promotions:                           return "/promotions"

        case .townships:                            return "/townships"
        case .cities:                               return "/user/cities"
        case .rating:                               return "ratings"
        case .register:                             return "/user/register"//"register"
        case .login:                                return "/user/login"
        case .send_OTP:                             return "/user/send-otp"
        case .check_OTP:                            return "/user/check-otp"
        case .forgot_password:                      return "/user/forgot-password"
        case .reset_password:                       return "/user/reset-password"
        case .change_password:                      return "/user/password/update"
        case .logout:                               return "/user/logout"
        case .refreshToken:                         return "/user/refresh-token"

        case .productCategory:                      return "categories/"
        case .product:                              return "/user/products"
        case .productByCategory:                    return "/user/product-categories/"
        case .productCategoryWise:                  return "products/category-wise"
        case .categorizedProduct:                   return "/user/shop/categorized/products"
        case .shopSubcategory:                      return "/user/shop-sub-categories"
        case .recommendProduct:                     return "/user/products/recommendations"
        case .productCart:                          return "/shops/carts/products"
        case .productPromo:                         return "/shops/carts/promocode"
        case .productCheckout:                      return "/shops/carts/checkout"
        case .mpuCheckout:                          return "/mpu/checkout/"
        case .mpgsCheckout:                          return "/mpgs/checkout/"

        case .categories:                           return "categories"
        case .shopCategories:                           return "/user/shops/categories"
        case .productsPath:                         return "products/"
        case .moreFromThisShop:                  return "/user/shops"
        case .productNewArrival:                    return "/products/arrivals"
        case .productDiscount:                      return "/products/discounts"
        case .searchHistory:                      return "/user/histories/search"
        case .clearHistory:                         return "/user/histories/clear"


        case .addToCartStore:                       return "store/cart/add"
        case .getCartItemsStore:                    return "store/cart/items"
        case .storeCartPath:                        return "store/cart/"
        case .updateItemInCartStore:                return "store/cart/"
        case .restaurantCart:                           return "/restaurants/carts"
        case .restaurantPromo:                           return "/restaurants/carts/promocode"

        case .getAddresses:                         return "/user/profile/address/"
        case .Address:                        return "/user/addresses"
        case .nearestAddress:   return "/user/addresses/nearest"
        case .getAllAddresses:             return "/user/addresses"
        case .getAddress:                  return "user/profile/address"

        case .userProfile:                        return "/user/profile"
        case .serviceAnnouncement:             return "/user/service-status"
        case .checkCredit:                          return "/user/credits"
        case .makeAddressPrimary:                   return "user/profile/address/2/make_primary"

        case .shopOrder:                           return "/user/shop-orders"
        case .foodOrder:                           return "/user/restaurant-orders"
        case .restaurantRating:             return "/user/restaurants/ratings"
        case .productRating:            return "/user/shops/ratings"
        case .orderDetails:                           return "store/orders/"

        case .home_banner_sliders:                  return "/user/ads?type=banner"
        case .home_banner_popup:             return "/user/ads?type=popup"
        case .destroyCart:                  return "store/cart/destroy"

        case .getRestaurantsCategorywise:                  return "restaurants/category-wise"
        case .getRestaurantsSliders:                  return "restaurants/sliders"
        case .restaurants:                  return "/user/restaurants/branches"
        case .getMenu:                  return "menus"
        case .restaurant_categories:          return "/user/restaurant-categories"
        case .restaurantCategories:                           return "restaurant-categories"
        case .restaurant:                   return "/user/restaurants/"
        case .restaurantMenuCart:                return "/restaurants/carts/menus/"
        case .restaurantCheckout:           return "/restaurants/carts/checkout"
        case .restaurantsRecommendations:   return "/user/restaurants/recommendations"

        case .add:                  return "add"
        case .remove:                  return "remove"
        case .destroy:                  return "destroy"
        case .update:                  return "update"
        case .delete:                  return "delete"
        case .getItems:                  return "items"

        case .cartPathRestro:                  return "restaurants/cart/"
        case .orderPathRestro:                  return "restaurants/orders/"
        case .place:                  return "place"
        case .detail:                  return "detail"
        case .rate:                  return "rate"
        case .productSearchStore:         return "/user/products/search?keyword="
        case .otherProducts:         return "products"
        case .updateprofile:                  return "user/profile/update"

        case .searchRestaurant:      return "/user/restaurants/branches?filter="
        case .stores:                     return "/user/product-shops/"
        case .shops:                     return "/user/shops"
        case .donation:                     return "home/donation"
        case .policy:                     return "pages/user-privacy-policy"
        case .termsAndcondition:                     return "pages/user-terms-conditions"

        case .cart:                         return "/carts"
        case .getCartCount:                return "user/profile/cart"
        case .cancelOrderFood:                 return "restaurants/orders/"
        case .cancelOrderStore:              return "store/orders/"
        case .reorder:                        return "restaurants/orders/"

        case .storeOrders:                  return "store/orders/"
        case .favouriteProductList:                    return "/user/products/favorites"
        case .favouriteRestaurantList:             return "/user/restaurants/favorites"

        case .validatePromo:            return "/user/promocode/validate"

        case .trackOrder:              return "/track"
        case .trackOrderStore:          return "/timeline"
        case .removeCode:          return "/remove-code"
        case .removeCodeRestro:          return "remove-code"
        case .applyPromoCode:          return "/apply-code"
        case .applyPromoCodeRestro:          return "apply-code"
        case .validateCode:          return "/validate-code"
        case .validateCodeRestro:          return "validate-code"
        case .updatePushToken:          return "user/profile/device"
        case .buy_Now:                           return "/buy-now?qty="
        case .supports:                          return "support/number"
        case .notificationData:                  return "notification"
        case .makePrimary:         return "set-primary"
        case .check_in:                   return "user/daily-check-in"
        case .rewards:              return "user/rewards"

        case .createToken:          return "/user/tokens"
        case .shopAllSearch:        return "/user/shops?filter="
        case .userSetting:          return "/user/settings"
        case .restaurantsDetail:    return "/user/restaurant-branches"
        case .restaurantDetailMenu:     return "/user/menus/"
        }
    }
}

//MARK: -
public enum Role
{
    case user
    var caseValue: String{
        switch self{
        case .user:                             return "user"
        }
    }
}

public enum MyOrderStatus
{
    case current
    case past
    var caseValue: String{
        switch self{
        case .current:                return "current"
        case .past:                  return "past"
        }
    }
}

public enum Cart
{
    case store
    case restaurant
    var caseValue: String{
        switch self{
        case .store:                return "store"
        case .restaurant:                  return "restaurant"
        }
    }
}


public enum PaymentMode
{
    case cash
    case kbz
    case credit
    case mpu
    case cb
    case mpgs
    var caseValue: String{
        switch self{
        case .cash:                       return "COD"
        case .kbz:                         return "KPay"
        case .credit:                     return "Credit"
        case .mpu:                          return "MPU"
        case .cb:                           return "CBPay"
        case .mpgs:                         return "MPGS"
        }
    }
}

public enum OrderType
{
    case pickup
    case instant
    case schedule
    var caseValue: String{
        switch self{
        case .instant:  return "instant"
        case .pickup:   return "pickup"
        case .schedule: return "schedule"
        }
    }
}

public enum StoreCellType
{
    case verticalGrid
    case horizontalLinear
    case single
    var caseValue: String{
        switch self{
        case .verticalGrid:                       return "vertical_grid"
        case .horizontalLinear:                   return "horizontal_linear"
        case .single:                             return "single"
//        case .other:                                return "Other"
        }
    }
}


public enum Type
{
    case restaurant
    case product
    var caseValue: String{
        switch self{
        case .restaurant:               return "restaurant"
        case .product:                  return "product"
        }
    }
}

public enum HomeItemType
{
    case SuggestionsProductType
    case SuggestionsRestaurantType
    case NewArrivalsProductType
    case NewArrivalsRestaurantType
    case FavouriteProductsType
    case FavouriteRestaurantType
    var caseValue: String{
        switch self{
        case .SuggestionsProductType:            return "SuggestionsProductType"
        case .SuggestionsRestaurantType:         return "SuggestionsRestaurantType"
        case .NewArrivalsProductType:            return "NewArrivalsProductType"
        case .NewArrivalsRestaurantType:         return "NewArrivalsRestaurantType"
        case .FavouriteProductsType:              return "FavouriteProductsType"
        case .FavouriteRestaurantType:            return "FavouriteRestaurantType"


        }
    }
}

public enum RatingStatus
{
    case ask
    case done
    case notDelivered
    var caseValue: String{
        switch self{
        case .ask:                             return "ask"
        case .done:                             return "done"
        case .notDelivered:                             return "na"
        }
    }
}

public enum DeliveryStatus
{
    case pending
    case delivered
    var caseValue: String{
        switch self{
        case .pending:                             return "pending"
        case .delivered:                             return "delivered"
        }
    }
}

// for cases in store

public enum StoreProduct
{
    case search
    case viewAll
    case store
    case other
    var caseValue: String{
        switch self{
        case .search:                             return "search"
        case .viewAll:                             return "viewAll"
        case .store:                             return "store"
        case .other:               return "other"
        }
    }
}


enum TrackOrderStatus {
    case pending
    case accepted
    case delivered
}


public enum TrackStoreOrderStatus
{
    case pending
    case confirmed
    case readyToShip
    case orderShipped
    case delivered
    case cancelled
    var caseValue: String{
        switch self{
        case .pending:                               return "pending"
        case .confirmed:                             return "processing"
        case .readyToShip:                           return "ready to ship"
        case .orderShipped:                          return "shipped"
        case .delivered:                             return "delivered"
        case .cancelled:                             return "cancelled"
        }
    }
}

public enum ProductType
{
    case newArrivalsProduct
    case suggestionsProduct
    case favouriteProducts
    case storeOtherProduct
    case storeProductHLinear
    case storeProductVLinear
    case youMayAlsolike
    case weRecommended
    case other
    case youMayAlsoLikeCart

}
