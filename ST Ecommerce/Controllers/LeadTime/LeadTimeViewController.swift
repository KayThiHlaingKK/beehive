//
//  LeadTimeViewController.swift
//  ST Ecommerce
//
//  Created by Ku Ku Zan on 7/2/22.
//  Copyright © 2022 Shashi. All rights reserved.
//

import UIKit

class LeadTimeViewController: UIViewController {

    var restaurantBranch : RestaurantBranch?
    var openingTimeString = ""
    var deliTime = ""
    var leadTime = 45
    var currentLeadTime = Date()
    var getLeadTimeArray = [String]()
    var array: [String] = []
    var getTodayLeadTimeArray: [String] = []
    var distance = 0.0
    var radius = 0.0
    var cartDistance = 0.0
    var navigateOption = NavigateOption.preorder

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        userSettingAPICall()
    }

    func checkDistanceLeadTime() {
        if let radius = CustomUserDefaults.shared.get(key: .radius) as? String {
            self.radius = Double(radius) ?? 0.0
        }
        navigateOption == .cart ? (distance = cartDistance ) : ( distance = restaurantBranch?.distance ?? 0.0)
        if distance  > radius{
            if let leadTimeMinute = CustomUserDefaults.shared.get(key: .leadTimeMinute) as? String {
                leadTime = Int(leadTimeMinute) ?? 0
            }
            
        }else{
            if let leadTimeMinute = CustomUserDefaults.shared.get(key: .orderLeadTime) as? String {
                leadTime = Int(leadTimeMinute) ?? 0
            }
        }
        print("Radius ====>",radius)
        print("Distance =====>",distance)
    }
    
    
//    func checkCurrentLeadTime() {
//        navigateOption == .cart ? (distance = cartDistance ) : ( distance = restaurantBranch?.distance ?? 0.0)
//        if distance > 3.8 {
//            currentLeadTime = Date().adding(minutes: leadTime)
//        }else{
//            currentLeadTime = Date().adding(minutes: 0)
//        }
//    }

    //Get TodayLeadTime
    func getTodayLeadTime(currentDate: String){
        //roundedDate format
        let roundedDate = getRoundedDate(currentDate: currentDate)

        //Get TodayLeadTimeArrayList
        navigateOption == .cart ? (distance = cartDistance ) : ( distance = restaurantBranch?.distance ?? 0.0)
        if distance < 3.8 {
            getTodayLeadTimeArray.append("ASAP")
        }

        //Todaydate Lists
        getTodayDateList(currentDate, roundedDate)


        if getTodayLeadTimeArray.isEmpty{
            deliTime = ""
        }else{
            deliTime = getTodayLeadTimeArray[0]
            if deliTime == "ASAP" {
                Singleton.shareInstance.orderType = .instant
            }else{
                Singleton.shareInstance.orderType = .schedule
            }
        }
    }
    

    func getBeforeOpeningLeadTime(currentDate: String){
        //roundedDate format
        let roundedDate = getRoundedDate(currentDate: currentDate)
        //Todaydate Lists
        getTodayDateList(currentDate, roundedDate)

        deliTime = getTodayLeadTimeArray[0]
        Singleton.shareInstance.orderType = .schedule
    }


    //Get DateTimeList
    func getAfterClosingLeadTime(currentDate: Date){
        var openingTimeString = ""
        var realOpeningTimeString = ""
        var closingTimeString = ""

        // Convert Date to String
        let curDate = Date.getDateToStringFormat(formatStyle: "dd-MM-yyyy", formatDate: currentDate)

        //get openingHour
        if let openingHourString = restaurantBranch?.opening_time{
            openingTimeString += getHourString(openingHourString)
        }

        //get closingHour
        if let closingHourString = restaurantBranch?.closing_time {
            closingTimeString += getHourString(closingHourString)
        }

        //get StartDate & EndDate
        let startDate = "\(curDate) \(openingTimeString)"
        let endDate = "\(curDate) \(closingTimeString)"

        let openingDate = Date.getDateFormat(formatStyle: "dd-MM-yyyy hh:mm a", formatDate: startDate)
        let closingDate = Date.getDateFormat(formatStyle: "dd-MM-yyyy hh:mm a", formatDate: endDate)

        //add leadtime to openingTime
        print(leadTime)
        let leadTimeAddedOpeningTime = openingDate.addingTimeInterval(TimeInterval(leadTime*60))
        let leadtimeAddedOpeningTimeStr = Date.getDateToStringFormat(formatStyle: "hh:mm a", formatDate: leadTimeAddedOpeningTime)

        //rounded leadTime
        realOpeningTimeString +=  leadTimeRounded(leadtimeAddedOpeningTimeStr, curDate)
        print(realOpeningTimeString)

        //get roundedOpeningDate
        let realOpeningDate = Date.getDateFormat(formatStyle: "dd-MM-yyyy hh:mm a", formatDate: realOpeningTimeString)
        let realOpeningTimeStr = Date.getDateToStringFormat(formatStyle: "hh:mm a", formatDate: realOpeningDate)

        //add first index realOpeningTimeStr
        getLeadTimeArray.append(realOpeningTimeStr)

        //get LeadTimeArrayList function
        getLeadTimeArrayList(realOpeningDate, closingDate)

        //append GetLeadTimeArray
        getLeadTimeArray.append(closingTimeString)
        print(getLeadTimeArray)
        //assign to deliTime
        deliTime = getLeadTimeArray[0]
        Singleton.shareInstance.orderType = .schedule
    }
    
    func getPickupLeadTimeList() {
        var closingTimeString = ""
        //get roundedOpeningDate
        let leadTimeOpeningTime = currentLeadTime
        let leadTimeStr = Date.getDateToStringFormat(formatStyle: "hh:mm a", formatDate: leadTimeOpeningTime)
        let curDate = Date.getDateToStringFormat(formatStyle: "dd-MM-yyyy", formatDate: Date())
        let realOpeningTime = leadTimeRounded(leadTimeStr, curDate)
        let realOpeningDate = Date.getDateFormat(formatStyle: "dd-MM-yyyy hh:mm a", formatDate: realOpeningTime)

        //get closingHour
        if let closingHourString = restaurantBranch?.closing_time {
            closingTimeString += getHourString(closingHourString)
        }

        //get StartDate & EndDate
        let endDate = "\(curDate) \(closingTimeString)"
        let closingDate = Date.getDateFormat(formatStyle: "dd-MM-yyyy hh:mm a", formatDate: endDate)
        getPickUpLeadTimeArrayList(realOpeningDate, closingDate)
        getTodayLeadTimeArray.append(closingTimeString)
        print(getTodayLeadTimeArray)
      
        deliTime = getTodayLeadTimeArray[0]
    }
    
    fileprivate func getPickUpLeadTimeArrayList(_ realOpeningDate: Date, _ closingDate: Date) {
        var i = 1
        while true {
            let date = realOpeningDate.addingTimeInterval(TimeInterval(i*15*60))
            let string =  Date.getDateToStringFormat(formatStyle: "hh:mm a", formatDate: date)

            if date >= closingDate {
                break;
            }

            i += 1
            getTodayLeadTimeArray.append(string)
        }
    }

    //GetLeadTimeArrayList Function
    fileprivate func getLeadTimeArrayList(_ realOpeningDate: Date, _ closingDate: Date) {
        var i = 1
        while true {
            let date = realOpeningDate.addingTimeInterval(TimeInterval(i*15*60))
            let string =  Date.getDateToStringFormat(formatStyle: "hh:mm a", formatDate: date)

            if date >= closingDate {
                break;
            }

            i += 1
            print(string)
            getLeadTimeArray.append(string)
        }
        print(getLeadTimeArray)
    }

    //GetTodayDateList Function
    fileprivate func getTodayDateList(_ currentDate: String, _ date1: Date?) {
        for j in getLeadTimeArray{
            let date = "\(currentDate) \(j)"
            let time = Date.getDateFormat(formatStyle: "dd-MM-yyyy hh:mm a", formatDate: date)

            guard let date1 = date1 else {
                return
            }
            print(date1)
            if date1 <= time {
                getTodayLeadTimeArray.append(j)
            }
        }
        print(getTodayLeadTimeArray)
    }

    //LeadTimeRounded Function
    func leadTimeRounded(_ leadTime: String, _ currentDate: String) -> String{
        let arr = leadTime.components(separatedBy: ":")
        var splitArr = arr[1].split(separator: " ")
        var currentHourInt = Int(arr.first ?? "0") ?? 0
        if splitArr[0] >= "01" && splitArr[0] <= "14"{
            splitArr[0] = "15"
        }else if splitArr[0] >= "16" && splitArr[0] <= "29"{
            splitArr[0] = "30"
        }else if splitArr[0] >= "31" && splitArr[0] <= "44"{
            splitArr[0] = "45"
        }else if splitArr[0] >= "46" && splitArr[0] <= "59"{
            currentHourInt += 1
            if currentHourInt > 12{
                currentHourInt = currentHourInt - 12
                splitArr[0] = "00"
            }
            splitArr[0] = "00"
        }
         return "\(currentDate) \(currentHourInt):\(splitArr[0]) \(splitArr[1])"
    }

    //GetRoundedDate Function
    func getRoundedDate(currentDate: String) -> Date{
        //added leadTime to currentTime
        print(leadTime)
        let currentLeadTime = Date().adding(minutes: leadTime)
        let currentLeadTimeStr = Date.getDateToStringFormat(formatStyle: "hh:mm a", formatDate: currentLeadTime)
        let startDate = "\(currentLeadTimeStr)"

        //get Rounded Value
        openingTimeString  = leadTimeRounded(startDate, currentDate)
        print(openingTimeString)
        let roundedDate = Date.getDateFormat(formatStyle: "dd-MM-yyyy hh:mm a", formatDate: openingTimeString)

        return roundedDate
    }

    private func userSettingAPICall(){
//        self.dispatchGroup.enter()
        let param : [String:Any] = [:]
        APIUtils.APICall(postName: APIEndPoint.userSetting.caseValue, method: .get,  parameters: param, controller: self, onSuccess: {  [unowned self] (response) in
                        
            let data = response as! NSDictionary
            let status = data.value(forKey: key_status) as? Int
            if status == 200{
                let settingData = data.value(forKeyPath: "data") as? NSArray ?? []
                
                APIUtils.prepareModalFromData(settingData, apiName: APIEndPoint.userSetting.caseValue, modelName:"UserSetting", onSuccess: { (products) in
                    let data = products as? [UserSetting] ?? []
                    for i in data{
                        if i.key == "restaurant_order_lead_time"{
                            CustomUserDefaults.shared.set(i.value, key: .orderLeadTime)
                        }else if i.key == "lead_time_minute"{
                            CustomUserDefaults.shared.set(i.value, key: .leadTimeMinute)
                        }else if i.key == "restaurant_search_radius" {
                            CustomUserDefaults.shared.set(i.value, key: .radius)
                        }
                    }
                }) { (error, endPoint) in
                    print("error \(String(describing: error?.localizedDescription)), reason \(endPoint)")
                }
            }else{
            }
            
//            self.dispatchGroup.leave()
        }) { (reason, statusCode) in
        }
    }


}
