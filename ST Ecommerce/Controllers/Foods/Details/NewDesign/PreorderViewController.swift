//
//  PreorderViewController.swift
//  ST Ecommerce
//
//  Created by Hive Innovation on 26/10/2021.
//  Copyright © 2021 Shashi. All rights reserved.
//

import UIKit

enum NavigateOption{
    case rootCart
    case cart
    case preorder
}

enum DeliveryMode {
    case delivery
    case pickup
}

enum DeliveryDate {
    case today
    case tomorrow
    case thedayaftertomorrow
}

enum DeliDate: String{
    case today = "today"
    case tomorrow = "tomorrow"
    case thedayaftertomorrow = "thedayaftertomorrow"
}

enum PaymentState {
    case disable
    case enable
    case selected
}

protocol PreorderDelegate {
    func didChange(data: String, deliMode: DeliveryMode, deliDate: DeliveryDate, deliTime: String)
}

protocol PromoDelegate{
    func checkPromo(promo: String,  completion: @escaping (Bool) -> Void)
}


class PreorderViewController: LeadTimeViewController {

    @IBOutlet weak var willdeliView: UIView!
    @IBOutlet weak var willpickupView: UIView!
    @IBOutlet weak var deliBar: UIView!
    @IBOutlet weak var pickupBar: UIView!

    @IBOutlet weak var otherView: UIView!
    @IBOutlet weak var deliveryView: UIView!
    @IBOutlet weak var dateView: UIView!
    @IBOutlet weak var timeView: UIView!

//    @IBOutlet weak var deliDateView: UIView!
    @IBOutlet weak var deliDateView: UIStackView!
    @IBOutlet weak var date1: UILabel!
    @IBOutlet weak var date2: UILabel!
    @IBOutlet weak var date3: UILabel!
    @IBOutlet weak var chooseDate: UILabel!

    @IBOutlet weak var deliTimeView: UIView!
    @IBOutlet weak var timePicker: UIDatePicker!
    @IBOutlet weak var chooseTime: UILabel!
    @IBOutlet weak var timeTableView: UITableView!

    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!


    var restaurantCart: RestaurantCart?

    var willDeli = true
    var deliMode = DeliveryMode.delivery
    var deliDate = DeliveryDate.today
    var navigateDeliDate = DeliveryDate.today
    let currentDate = Date()
    let formatter = DateFormatter()
    let formatter2 = DateFormatter()
    let date = Date()
    var preDelegate: PreorderDelegate!
    var promoDelegate: PromoDelegate!
    var today = ""
    var cartDeliTime = ""
    var chooseDateTime = ""
    var navigateDeliTime = ""
    var d = ""
    var cartDeliDate = DeliveryDate.today
    var deliDateOption = false
    var isFromCart = false
    var currentDateTime = Date()
    var currentTime = Date()
   

    override func viewDidLoad() {
        touchEvents()
        checkLeadTime()
        UISetup()
    }

    override func viewWillLayoutSubviews() {
        super.updateViewConstraints()
        DispatchQueue.main.async {
            self.tableViewHeightConstraint.constant = self.timeTableView.contentSize.height
        }
      

    }

    //MARK: -- TodayOrderCheckDeliTime function

    func checkLeadTime() {
        checkDistanceLeadTime()
        //        checkCurrentLeadTime()
        guard let openingTime = restaurantBranch?.opening_time,
              let closingTime = restaurantBranch?.closing_time
        else { return }


        let openingDateTime = self.getDateTime(openingTime)
        let closingDateTime = self.getDateTime(closingTime)
        var realCurrentTime = Date()
        
        if self.deliMode == .pickup {
            realCurrentTime = Calendar.current.date(byAdding: .minute, value: 0, to: currentTime) ?? Date()
        }else{
            realCurrentTime = Calendar.current.date(byAdding: .minute, value: -15, to: currentTime) ?? Date()
            if distance > radius {
                if let leadTimeMinute = CustomUserDefaults.shared.get(key: .leadTimeMinute) as? String {
                    leadTime = Int(leadTimeMinute) ?? 0
                    realCurrentTime = currentDateTime.addMinute(leadTime) ?? Date()
                }
                
            }else{
                if let leadTimeMinute = CustomUserDefaults.shared.get(key: .orderLeadTime) as? String {
                    leadTime = Int(leadTimeMinute) ?? 0
                    realCurrentTime = currentDateTime.addMinute(leadTime) ?? Date()
                }
            }
            
        }
        let currentTime = currentDateTime.addMinute(0) ?? Date()
        let openLeadTime = realCurrentTime <= closingDateTime
        let beforeOpeningTime = currentTime <= openingDateTime
        let afterClosingTime = realCurrentTime >= closingDateTime

        checkOrderLeadTime(openLeadTime: openLeadTime,beforeOpeningTime: beforeOpeningTime, afterClosingTime: afterClosingTime)

    }

    func checkOrderLeadTime(openLeadTime: Bool,beforeOpeningTime: Bool,afterClosingTime: Bool){
        if beforeOpeningTime{
            todayOrderCheckBeforeOpening()
        }else if afterClosingTime{
            nextDayOrderCheckDeliTime()
        }else {
            todayOrderCheckDeliTime()
        }

    }

    //MARK: -- todayOrderCheckDeliTime function
    fileprivate func pickupModeTodayLeadTime() {
        getTodayLeadTimeArray.removeAll()
        getLeadTimeArray.removeAll()
        getPickupLeadTimeList()
        todayDate()
        timeTableView.reloadData()
    }
    
    fileprivate func deliveryModeTodayLeadTime() {
        checkDistanceLeadTime()
        let date = Date()
        getAfterClosingLeadTime(currentDate: date)
        let curDate = Date.getCurrentDate()
        getTodayLeadTime(currentDate: curDate)
        todayDate()
        timeTableView.reloadData()
    }
    
    func todayOrderCheckDeliTime(){
        deliMode == .pickup ? pickupModeTodayLeadTime() : deliveryModeTodayLeadTime()
    }

    //MARK: -- BeforeOpeningTime function
    fileprivate func todayOrderCheckBeforeOpening(){
        checkDistanceLeadTime()
        let date = Date()
        getAfterClosingLeadTime(currentDate: date)
        let curDate = Date.getCurrentDate()
        getBeforeOpeningLeadTime(currentDate: curDate)
        todayDate()
    }

    //MARK: -- nextOrderCheckDeliTime function
    fileprivate func nextDayOrderCheckDeliTime(){
        checkDistanceLeadTime()
        let currentDay = Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date()
        getAfterClosingLeadTime(currentDate: currentDay)
        tomorrowDate()
        timeTableView.reloadData()
    }

    fileprivate func tomorrowDate() {
        let getDay = getDateOption()
        date1.isHidden = true
        date2.text = "Tomorrow\(getDay.tomorrow)"
        date3.text = getDay.thedayAfterTomorrow
        if navigateDeliDate == .thedayaftertomorrow {
            deliDate = .thedayaftertomorrow
            chooseDate.text = getDay.thedayAfterTomorrow
            navigateDeliTime.isEmpty ? (chooseTime.text = deliTime) : (chooseTime.text = navigateDeliTime)
        }else{
            deliDate = .tomorrow
            chooseDate.text = "Tomorrow\(getDay.tomorrow)"
            navigateDeliTime.isEmpty ? (chooseTime.text = deliTime) : (chooseTime.text = navigateDeliTime)
        }
        chooseTime.textColor = UIColor.black
        deliDateView.isHidden = true
        timeView.isUserInteractionEnabled = true
    }

    fileprivate func todayDate() {
        let getDay = getDateOption()
        date1.isHidden = false
        date1.text = "Today\(today)"
        date2.text = "Tomorrow\(getDay.tomorrow)"
        date3.text = getDay.thedayAfterTomorrow
      
        if navigateDeliDate == .today {
            deliDate = .today
            chooseDate.text = "Today\(today)"
        }else if navigateDeliDate == .tomorrow{
            deliDate = .tomorrow
            chooseDate.text = "Tomorrow\(getDay.tomorrow)"
        }else{
            deliDate = .thedayaftertomorrow
            chooseDate.text = getDay.thedayAfterTomorrow
            
        }
        navigateDeliTime.isEmpty ? (chooseTime.text = deliTime) : (chooseTime.text = navigateDeliTime)
        deliDateView.isHidden = true
        timeView.isUserInteractionEnabled = true
    }


    fileprivate func getDateOption() -> (tomorrow: String, thedayAfterTomorrow: String) {
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.dateFormat = ", MMM dd"
        today = formatter.string(from: Date())
        let temp1 = Calendar.current.date(byAdding: .day, value: 1, to: currentDate) ?? Date()
        let tomorrow = formatter.string(from: temp1)

        formatter.dateFormat = "EEEE, MMM dd"
        let temp = Calendar.current.date(byAdding: .day, value: 2, to: currentDate) ?? Date()
        let thedayAfterTomorrow = formatter.string(from: temp)

        return (tomorrow,thedayAfterTomorrow)
    }


    fileprivate func deliPickupViewSetUp() {
        if deliMode == .delivery{
            pickupBar.isHidden = true
        }else{
            deliBar.isHidden = true
            pickupViewUI()
        }
    }
    
    fileprivate func pickupViewUI() {
        if deliDate == .today {
            deliMode = .pickup
            getTodayLeadTimeArray.removeAll()
            getLeadTimeArray.removeAll()
            checkDistanceLeadTime()
            getPickupLeadTimeList()
            todayDate()
            timeTableView.reloadData()
        }else{
            deliMode = .pickup
            getLeadTimeArray.removeAll()
            let d = Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date()
            getAfterClosingLeadTime(currentDate: d)
            timeTableView.reloadData()
            tomorrowDate()
        }
    }
    
    func UISetup() {
        print("uisetup")
        setupTableView()
        deliveryView.roundCorners(corners: [.topRight, .topLeft], amount: 10)
        deliDateView.layer.cornerRadius = 5
        deliDateView.clipsToBounds = true
        deliDateView.isHidden = true
        timeTableView.isHidden = true
        backgroundView.isHidden = true
        deliPickupViewSetUp()
        chooseTime.textColor = UIColor.black
    }

    func setupTableView(){
        timeTableView.dataSource = self
        timeTableView.delegate = self
        timeTableView.registerCell(type: ListTableViewCell.self)
        timeTableView.reloadData()
    }

    func touchEvents() {

        let tapGestureRecognizer1 = UITapGestureRecognizer(target: self, action: #selector(changeDeliDate(tapGestureRecognizer:)))
        dateView.isUserInteractionEnabled = true
        dateView.addGestureRecognizer(tapGestureRecognizer1)

        let tapGestureRecognizer2 = UITapGestureRecognizer(target: self, action: #selector(changeDeliTime(tapGestureRecognizer:)))
        timeView.isUserInteractionEnabled = true
        timeView.addGestureRecognizer(tapGestureRecognizer2)

        let tapGestureRecognizer3 = UITapGestureRecognizer(target: self, action: #selector(clickOther(tapGestureRecognizer:)))
        otherView.isUserInteractionEnabled = true
        otherView.addGestureRecognizer(tapGestureRecognizer3)

        let tapGestureRecognizer4 = UITapGestureRecognizer(target: self, action: #selector(willDeli(tapGestureRecognizer:)))
        willdeliView.isUserInteractionEnabled = true
        willdeliView.addGestureRecognizer(tapGestureRecognizer4)

        let tapGestureRecognizer5 = UITapGestureRecognizer(target: self, action: #selector(willPickup(tapGestureRecognizer:)))
        willpickupView.isUserInteractionEnabled = true
        willpickupView.addGestureRecognizer(tapGestureRecognizer5)

        let tapGestureRecognizer6 = UITapGestureRecognizer(target: self, action: #selector(chooseDate1(tapGestureRecognizer:)))
        date1.isUserInteractionEnabled = true
        date1.addGestureRecognizer(tapGestureRecognizer6)

        let tapGestureRecognizer7 = UITapGestureRecognizer(target: self, action: #selector(chooseDate2(tapGestureRecognizer:)))
        date2.isUserInteractionEnabled = true
        date2.addGestureRecognizer(tapGestureRecognizer7)

        let tapGestureRecognizer8 = UITapGestureRecognizer(target: self, action: #selector(chooseDate3(tapGestureRecognizer:)))
        date3.isUserInteractionEnabled = true
        date3.addGestureRecognizer(tapGestureRecognizer8)

        let tapGestureRecognizer9 = UITapGestureRecognizer(target: self, action: #selector(closeDateTime(tapGestureRecognizer:)))
        backgroundView.isUserInteractionEnabled = true
        backgroundView.addGestureRecognizer(tapGestureRecognizer9)
    }


    @IBAction func cancelTimeChange(_ sender: UIButton) {
        closeDateTime()
    }

    @objc func closeDateTime(tapGestureRecognizer: UITapGestureRecognizer) {
        closeDateTime()
    }

    @objc func changeDeliDate(tapGestureRecognizer: UITapGestureRecognizer) {
        deliDateView.isHidden = false
        backgroundView.isHidden = false
    }

    @objc func changeDeliTime(tapGestureRecognizer: UITapGestureRecognizer) {
        backgroundView.isHidden = false
        timeTableView.isHidden = false
    }

    @objc func clickOther(tapGestureRecognizer: UITapGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
    }

    @objc func willDeli(tapGestureRecognizer: UITapGestureRecognizer) {
        deliBar.isHidden = false
        pickupBar.isHidden = true
        deliMode = DeliveryMode.delivery
        navigateDeliTime = ""
//        checkLeadTime()
        if navigateDeliDate == .today {
            getTodayLeadTimeArray.removeAll()
            getLeadTimeArray.removeAll()
            checkLeadTime()
            timeTableView.reloadData()
        }else if navigateDeliDate == .tomorrow{
            getTodayLeadTimeArray.removeAll()
            getLeadTimeArray.removeAll()
            let d = Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date()
            getAfterClosingLeadTime(currentDate: d)
            setTheDayTomorrow()
            timeTableView.reloadData()
        }else{
            getTodayLeadTimeArray.removeAll()
            getLeadTimeArray.removeAll()
            let d = Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date()
            getAfterClosingLeadTime(currentDate: d)
            setTheDayAfterDay()
            timeTableView.reloadData()
        }
        
    }

    @objc func willPickup(tapGestureRecognizer: UITapGestureRecognizer) {
        deliBar.isHidden = true
        pickupBar.isHidden = false
        deliMode = DeliveryMode.pickup
        navigateDeliTime = ""
        if deliDate == .today {
            deliDate = .today
            getTodayLeadTimeArray.removeAll()
            getLeadTimeArray.removeAll()
            getPickupLeadTimeList()
            todayDate()
            timeTableView.reloadData()
        }else{
//            deliDate = .tomorrow
//            getTodayLeadTimeArray.removeAll()
//            getLeadTimeArray.removeAll()
//            checkDistanceLeadTime()
//            let currentDay = Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date()
//            getAfterClosingLeadTime(currentDate: currentDay)
//            setTheDayTomorrow()
//            timeTableView.reloadData()
            checkLeadTime()
            timeTableView.reloadData()
        }
        
    }

    @objc func chooseDate1(tapGestureRecognizer: UITapGestureRecognizer) {
        deliDateOption = true
        deliDate = .today
        navigateDeliTime = ""
        deliDate = DeliveryDate.today
        if deliMode == .pickup {
            getTodayLeadTimeArray.removeAll()
            getLeadTimeArray.removeAll()
            checkDistanceLeadTime()
            getPickupLeadTimeList()
            setToday()
            timeTableView.reloadData()
        }else{
            getTodayLeadTimeArray.removeAll()
            getLeadTimeArray.removeAll()
            checkDistanceLeadTime()
            let date = Date()
            getAfterClosingLeadTime(currentDate: date)
            let curDate = Date.getCurrentDate()
            getTodayLeadTime(currentDate: curDate)
            setToday()
            timeTableView.reloadData()
           
        }
        
        backgroundView.isHidden = true
    }

    @objc func chooseDate2(tapGestureRecognizer: UITapGestureRecognizer) {
        deliDateOption = true
        deliDate = DeliveryDate.tomorrow
        print("choose deli date = " , deliDate)
        navigateDeliTime = ""
        chooseDate.text = date2.text ?? ""
        getLeadTimeArray.removeAll()
        let d = Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date()
        getAfterClosingLeadTime(currentDate: d)
        timeTableView.reloadData()
        setTheDayTomorrow()
//        tomorrowDate()
        backgroundView.isHidden = true
    }

    @objc func chooseDate3(tapGestureRecognizer: UITapGestureRecognizer) {
        deliDateOption = true
        deliDate = DeliveryDate.thedayaftertomorrow
        navigateDeliTime = ""
        chooseDate.text = date3.text ?? ""
        getLeadTimeArray.removeAll()
        let d = Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date()
        getAfterClosingLeadTime(currentDate: d)
        timeTableView.reloadData()
        setTheDayAfterDay()
        backgroundView.isHidden = true
    }

    fileprivate func checkSaveOption() {
        switch deliMode {
        case .delivery:
            let deliDateTime = "Delivery : \(chooseDateTime)"
            preDelegate.didChange(data: deliDateTime, deliMode: deliMode, deliDate: deliDate, deliTime: chooseTime.text ?? "")
            if chooseDateTime.contains("ASAP") {
                Singleton.shareInstance.orderType = .instant
            }else{
                Singleton.shareInstance.orderType = .schedule
            }
        case .pickup:
            let deliDateTime = "Pick up : \(chooseDateTime)"
            preDelegate.didChange(data: deliDateTime, deliMode: deliMode, deliDate: deliDate, deliTime: chooseTime.text ?? "")
            Singleton.shareInstance.orderType = .pickup
        }
    }

    @IBAction func saveUpdateClicked(_ sender: UIButton) {
        checkDate()
        checkCartDeliTime()
//        checkChooseDate()
        checkSaveOption()
        Singleton.shareInstance.isBack = true
        Singleton.shareInstance.addressChange = false
        self.dismiss(animated: true, completion: nil)
    }

    fileprivate func checkDate() {
        formatter.dateFormat =  "MMM dd"
        switch deliDate {
        case .today:
            d = formatter.string(from: currentDate)
        case .tomorrow:
            d = formatter.string(from: Calendar.current.date(byAdding: .day, value: 1, to: currentDate) ?? Date())
        case .thedayaftertomorrow:
            d = formatter.string(from: Calendar.current.date(byAdding: .day, value: 2, to: currentDate) ?? Date())
        }
    }

//    func checkChooseDate(){
//        let getDay = getDateOption()
//        if chooseDate.text == "Today\(today)" {
//            deliDate = .today
//        }else if chooseDate.text == "Tomorrow\(getDay.tomorrow)" {
//            deliDate = .tomorrow
//        }else{
//            deliDate = .thedayaftertomorrow
//        }
//    }

    func checkCartDeliTime(){
        if cartDeliTime == "" {
            cartDeliTime = chooseTime.text ?? ""
        }
        if cartDeliTime == "ASAP" {
            chooseDateTime = "\(cartDeliTime)"
        }else{
            chooseDateTime = "\(d) \(cartDeliTime)"
        }
    }

    
    func setTheDayAfterDay() {
        let getDay = getDateOption()
        deliDate = .thedayaftertomorrow
        chooseDate.text = "\(getDay.thedayAfterTomorrow)"
        navigateDeliTime.isEmpty ? ( chooseTime.text = deliTime) : ( chooseTime.text = navigateDeliTime)
        chooseTime.textColor = UIColor.black

        deliDateView.isHidden = true
        timeView.isUserInteractionEnabled = true
    }
    
    func setTheDayTomorrow() {
        let getDay = getDateOption()
        deliDate = .tomorrow
        chooseDate.text = "Tomorrow\(getDay.tomorrow)"
        navigateDeliTime.isEmpty ? ( chooseTime.text = deliTime) : ( chooseTime.text = navigateDeliTime)
        chooseTime.textColor = UIColor.black

        deliDateView.isHidden = true
        timeView.isUserInteractionEnabled = true
    }
    
    func setToday() {
        deliDate = .today
        chooseDate.text = "Today\(today)"
        navigateDeliTime.isEmpty ? ( chooseTime.text = deliTime) : ( chooseTime.text = navigateDeliTime)
        chooseTime.textColor = UIColor.black

        deliDateView.isHidden = true
        timeView.isUserInteractionEnabled = true
    }

    func closeDateTime() {
        deliDateView.isHidden = true
        timeTableView.isHidden = true
        backgroundView.isHidden = true
    }
}

extension PreorderViewController: UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch deliDate {
        case .today:
            return getTodayLeadTimeArray.count
        default:
            return getLeadTimeArray.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = timeTableView.dequeueReusableCell(withIdentifier: ListTableViewCell.identifier, for: indexPath)as? ListTableViewCell else {
            return UITableViewCell()

        }
        switch deliDate {
        case .today:
            cell.titleLabel.text = getTodayLeadTimeArray[indexPath.row]
        default:
            cell.titleLabel.text = getLeadTimeArray[indexPath.row]
        }
        return cell
    }


}

extension PreorderViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        viewWillLayoutSubviews()
    }


    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.estimatedRowHeight
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.deliDate == .today{
            chooseTime.text = self.getTodayLeadTimeArray[indexPath.row]
            Singleton.shareInstance.deliTime = self.getTodayLeadTimeArray[indexPath.row]
        }else{
            chooseTime.text = self.getLeadTimeArray[indexPath.row]
            Singleton.shareInstance.deliTime = self.getLeadTimeArray[indexPath.row]
        }
        backgroundView.isHidden = true
        timeTableView.isHidden = true
    }

}

extension PreorderViewController: DataPassDelegate {
    func dataPass(DeliDate: DeliveryDate, deliTime: String) {
        chooseTime.text = deliTime
        let getDay = getDateOption()
        switch DeliDate {
        case DeliveryDate.today :
            todayDate()
        case DeliveryDate.tomorrow :
            chooseDate.text = "Tomorrow\(getDay.tomorrow)"
            deliDate = DeliveryDate.tomorrow
            timeView.isUserInteractionEnabled = true
        case DeliveryDate.thedayaftertomorrow :
            chooseDate.text = getDay.thedayAfterTomorrow
            deliDate = DeliveryDate.thedayaftertomorrow
            timeView.isUserInteractionEnabled = true
        }
    }
}


