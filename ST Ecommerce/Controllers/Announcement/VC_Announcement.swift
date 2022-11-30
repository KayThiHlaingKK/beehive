//
//  VC_Announcement.swift
//  ST Ecommerce
//
//  Created by Min Thet Maung on 08/10/2021.
//  Copyright © 2021 Shashi. All rights reserved.
//

import UIKit

class VC_Announcement: UIViewController {
    
    var controller: UIViewController!
    private var announcement: Announcement!
    private var otherAnnouncements = [Announcement]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tableView.reloadData()
    }
    

    @IBAction func dismiss(_ sender: UIButton) {
        controller.navigationController?.popViewController(animated: true)
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UITableView.automaticDimension
        
        tableView.register(UINib(nibName: "Cell_TV_AnnouncementDetail", bundle: nil), forCellReuseIdentifier: "Cell_TV_AnnouncementDetail")
        tableView.register(UINib(nibName: "Cell_TV_Announcement", bundle: nil), forCellReuseIdentifier: "Cell_TV_Announcement")
        tableView.allowsSelection = false
    }
    
    func setData(announcment: Announcement, otherAnnouncements: [Announcement]) {
        self.announcement = announcment
        self.otherAnnouncements = otherAnnouncements
    }
    
}


extension VC_Announcement: UITableViewDelegate, UITableViewDataSource {

    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell_TV_AnnouncementDetail") as! Cell_TV_AnnouncementDetail
            cell.controller = self.controller
            cell.setData(announcement: self.announcement)
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell_TV_Announcement") as! Cell_TV_Announcement
            cell.controller = controller
            cell.setData(announcments: self.otherAnnouncements)
            cell.sectionTitle.text = "Other Announcements"
            
            return cell
        }
    }
   
}
