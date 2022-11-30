//
//  VC_ManageAddress.swift
//  ST Ecommerce
//
//  Created by Min Thet Maung on 13/01/2022.
//  Copyright © 2022 Shashi. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire

class VC_ManageAddress: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addNewAddressButton: UIButton!
    
    private var addresses = [Address]()
    private var userProfile: Profile?
    private let cellID = "Cell_TV_AddressRow"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        prepareUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        userProfile = Singleton.shareInstance.userProfile
        loadUserAddressFromServer()
    }
    
    private func setupTableView() {
        tableView.contentInset = UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 0)
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(UINib(nibName: cellID, bundle: nil), forCellReuseIdentifier: cellID)
    }
    
    private func prepareUI() {
        addNewAddressButton.layer.cornerRadius = 5
        addNewAddressButton.clipsToBounds = true
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addNewAddressButtonPressed(_ sender: UIButton) {
//        let vc : VC_Add_Address = storyboardAddress.instantiateViewController(withIdentifier: "VC_Add_Address") as! VC_Add_Address
        navigationController?.pushView(AddAddressRouter())
//        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension VC_ManageAddress: AddressRowDelegate {
    
    func editAddress(indexPath: IndexPath) {
        
        //            let vc : VC_Add_Address = storyboardAddress.instantiateViewController(withIdentifier: "VC_Add_Address") as! VC_Add_Address
        let address = addresses[indexPath.row]
//        Singleton.shareInstance.selectedAddress = address
        if let lat = address.latitude, let long = address.longitude, let addressSlug = address.slug{
            let clLocation = CLLocationCoordinate2D(latitude: Double(lat), longitude: Double(long))
            let vc = AddAddressRouter.init(userCoordinate: clLocation, address: address, profileData: userProfile, slug: addressSlug, fromEdit: true)
            navigationController?.pushView(vc)
        }
    }
    
    func deleteAddress(indexPath: IndexPath) {
        
        self.presentAlertWithTitle(title: warningText, message: addressDeletePromptText, options: noText, yesText) { (option) in

            switch(option) {
                case 1:
                    self.deleteAction(indexPath: indexPath)
                default:
                    break
            }
        }
        
    }
    
    func deleteAction(indexPath: IndexPath) {
        let address = addresses[indexPath.row]
        guard let slug = address.slug else { return }
        
        self.showHud(message: loadingText)
        
        APIUtils.APICall(postName: "\(APIEndPoint.Address.caseValue)/\(slug)", method: .delete, parameters: [String:Any](), controller: self, onSuccess: { [unowned self] (response) in
            
            self.hideHud()
            let data = response as! NSDictionary
            let status = data[key_status] as? Int
            
            if status == 200 {
                self.addresses.remove(at: indexPath.row)
                Singleton.shareInstance.address?.remove(at: indexPath.row)
                self.tableView.reloadData()
                
                let message = data.value(forKey: key_message) as? String ?? ""
                
                self.presentAlertWithTitle(title: successText, message: message, options: okayText) { (option) in
                    switch(option) {
                    case 0:
                        self.loadUserAddressFromServer()
                    default:
                        break
                    }
                }
                
            } else {
                let message = data[key_message] as? String ?? serverError
                self.presentAlert(title: errorText, message: message)
            }
        }) { (reason, statusCode) in
            self.hideHud()
        }
    }
    
}

extension VC_ManageAddress: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as? Cell_TV_AddressRow else {
            return UITableViewCell()
        }
        cell.delegate = self
        cell.indexPath = indexPath
        cell.setData(address: addresses[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        addresses.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}


extension VC_ManageAddress {
    
    func loadUserAddressFromServer() {
        APIClient.fetchGetAddress().execute { data in
            if data.status == 200 {
                DispatchQueue.main.async { [unowned self] in
                    self.addresses = data.data as? [Address] ?? []
                    self.hideHud()
                    self.tableView.reloadData()
                }
            }
        } onFailure: { error in
            print(error)
        }

    }
}
