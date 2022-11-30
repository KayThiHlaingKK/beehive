//
//  ContentViewController.swift
//  ST Ecommerce
//
//  Created Ku Ku Zan on 7/14/22.
//  Copyright © 2022 Shashi. All rights reserved.
//

import Foundation
import UIKit

class ContentViewController: UIViewController {
    
    // MARK: Delegate initialization
    var presenter: ContentViewToPresenterProtocol?
    
    // MARK: Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Custom initializers go here
    
    private var allProducts = [Product]()
    private var discountProducts = [Product]()
    private var currentPage = 1
    var fromCart = false
    var lastPage = 0
    var itemSlug  = ""
    var announcement: Announcement!
    let productCellWidthRatio : CGFloat = 2.3
    let refreshControl = UIRefreshControl()
    private var spinner = UIActivityIndicatorView(style: .gray)
    let screenWidth = UIScreen.main.bounds.size.width
    private enum CellType: String, CaseIterable {
        case ContentListTableViewCell,Cell_TV_Header, Cell_TV_ProductRow
    }
    
    // MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.started()
        checkLogin()
    }
    
    // MARK: User Interaction - Actions & Targets
    
    @IBAction func backDismiss(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: Additional Helpers
    fileprivate func checkLogin(){
        if readLogin() != 0{
            presenter?.getItemContentLists(ItemContentRequest(slug: itemSlug, size: "10", page: "\(currentPage)"))
        }else{
            self.tableView.reloadData()
            self.showNeedToLoginApp()
        }
    }
    
    
    private func setupTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.prefetchDataSource = self
        
        tableView.contentInset = UIEdgeInsets(top: -35, left: 0, bottom: 0, right: 0)
        tableView.backgroundColor = .clear
        
        spinner.startAnimating()
        spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(44))
        tableView.tableFooterView = spinner
        tableView.tableFooterView?.isHidden = true
        tableView.backgroundColor = .white
        CellType.allCases.forEach {
            tableView.register(UINib(nibName: $0.rawValue, bundle: nil), forCellReuseIdentifier: $0.rawValue)
        }
    }
    
    
    private func createAllProductCell(_ indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: CellType.Cell_TV_ProductRow.rawValue, for: indexPath) as! Cell_TV_ProductRow
        let firstIndex = indexPath.row * 2
        
        var twoProducts = [allProducts[firstIndex]]
        if allProducts.indices.contains(firstIndex+1) {
            twoProducts.append(allProducts[firstIndex+1])
        }
        print("two product = " , twoProducts.count)
        cell.type = "contentShop"
        cell.controller = self
        cell.currentIndexPath = indexPath
        cell.setData(allProducts: twoProducts)
        return cell
    }
    
    private func createAnnouncement(_ indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: ContentListTableViewCell.identifier) as! ContentListTableViewCell
        cell.data = self.announcement
        cell.contentListCollectionView.reloadData()
        return cell
    }
    
    
}

// MARK: - Extension
/**
 - tableview datasource & delegate
 */
extension ContentViewController : UITableViewDataSource,Cell_TV_HeaderDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section{
        case 1: return (allProducts.count / 2) + (allProducts.count % 2)
        default: return 1
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 1: return allProducts.isEmpty ? nil: createSectionHeader(title: "All Products", section: section, showViewAllButton: false)
        default: return UIView()
        }

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section{
        case 0: return createAnnouncement(indexPath)
        case 1: return createAllProductCell(indexPath)
        default: return UITableViewCell()
        }
    }
    
    private func createSectionHeader(title: String, section: Int, showViewAllButton: Bool = true) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellType.Cell_TV_Header.rawValue) as! Cell_TV_Header
        cell.viewAllLabel.isHidden = !showViewAllButton
        cell.section = section
        cell.headerLabel.text = title
        return cell
    }
    
    func onTapViewAll(section: Int) {
        goToAllProducts(section: section)
    }
    
    func goToAllProducts(section: Int) {
        let vc: VC_AllProducts = storyboardStore.instantiateViewController(withIdentifier: "VC_AllProducts")
        as! VC_AllProducts
        
        vc.controller = self
        switch section {
        case 1: vc.products = discountProducts
        default: vc.products = []
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension ContentViewController: UITableViewDataSourcePrefetching{
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        currentPage += 1
        if currentPage <= lastPage {
            presenter?.getItemContentLists(ItemContentRequest(slug: itemSlug, size: "10", page: "\(currentPage)"))
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let productCellHeight = screenWidth / homeCellWidthRatio
        _ = productCellHeight * 1.6 + 80
        
        switch indexPath.section {
        case 1:
            let cellWidth = (screenWidth - 48) / 2
            let cellHeight = (cellWidth*1.6) + 20
            return allProducts.isEmpty ? 0 : cellHeight
        default: return tableView.estimatedRowHeight
        }
    }
    
}

extension ContentViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 1: return allProducts.isEmpty ? 0: 50
        default: return 0
        }
    }
    

}

// MARK: - Presenter to View
extension ContentViewController: ContentPresenterToViewProtocl {
    
    func initialControlSetup() {
        setupTableView()
    }
    
    func setItemContentList(_ data: ItemContentModel) {
        self.lastPage = data.last_page ?? 0
        self.allProducts.append(contentsOf: data.data ?? [])
        tableView.reloadData()
    }
    
}
