//
//  ListViewController.swift
//  PunkAPI
//
//  Created by Matthias BUREL on 06.09.19.
//  Copyright © 2019 Matthias BUREL. All rights reserved.
//

import UIKit
import Foundation
import SDWebImage
import RealmSwift

class ListViewController: UITableViewController {
    
    let productService = ProductService()

    var pageIndex: Int = 1
    var reachMax: Bool = false
    var isLocalData: Bool = false
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var productList:[Product] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    var filteredProduct = [Product]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup the Search Controller
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = true
        searchController.searchBar.placeholder = "Search beer"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        tableView.tableFooterView = UIView()
        
        // Load local data with Realm
        cleanRealm()
        openRealm()
        fetchLocalData()
        
        // Load real data from PunkAPI
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.productList.removeAll()
            self.loadProducts(withPageIndex: self.pageIndex)
        }
    }
    
    func cleanRealm() {
        
        //Clean all previous local Realm file
        let realmURL = Realm.Configuration.defaultConfiguration.fileURL!
        let realmURLs = [
            realmURL,
            realmURL.appendingPathExtension("lock"),
            realmURL.appendingPathExtension("note"),
            realmURL.appendingPathExtension("management")
        ]
        for URL in realmURLs {
            do {
                try FileManager.default.removeItem(at: URL)
            } catch {}
        }
    }
    
    func openRealm() {
        
        //Checks to see if Realm database already exists.
        //If not, copies over pre-populated default.realm
        let defaultRealmPath = Realm.Configuration.defaultConfiguration.fileURL!
        let bundleReamPath = Bundle.main.path(forResource: "default", ofType:"realm")
        
        if !FileManager.default.fileExists(atPath: defaultRealmPath.path) {
            do
            {
                try FileManager.default.copyItem(atPath: bundleReamPath!, toPath: defaultRealmPath.path)
            }
            catch let error as NSError {
                // Catch fires here, with an NSError being thrown
                print("error occurred, here are the details:\n \(error)")
            }
        }
    }
    
    func fetchLocalData() {
        
        let config = Realm.Configuration(
            
            // Get the URL to the bundled file
            fileURL: Bundle.main.url(forResource: "default", withExtension: "realm"),
            // Open the file in read-only mode as application bundles are not writeable
            readOnly: true,
            schemaVersion: 0
        )
        
        // Open the Realm with the configuration
        let realm = try! Realm(configuration: config)
        
        // Read some data from the bundled Realm
        let results = realm.objects(PunkAPI.self)
        
        var product: Product! = Product(name: "", imageUrl: "", description: "", tagline: "")
        var localList = Array<Product>()
        for result in results {
            product.name = result.name
            product.description = result.descriptionText
            product.tagline = result.tagLine
            product.imageUrl = result.image_url
           
            localList.append(product)
        }
        
        isLocalData = true
        productList = localList

    }
    
    @objc func loadProducts(withPageIndex: Int) {
        
        isLocalData = false
        
        self.productService.getProduct(pageIndex: pageIndex) {[weak self] (error, products) in
            guard let strongSelf = self else { return }
            
            if error != nil {
                self?.reachMax = true
                return
            }
            strongSelf.productList += products
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
            return filteredProduct.count
        }
        return productList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCellIdentifier", for: indexPath) as? CustomCell else {
            return UITableViewCell()
        }
        
        let productViewModel: Product
        if isFiltering() {
            productViewModel = filteredProduct[indexPath.row]
        } else {
            productViewModel = productList[indexPath.row]
        }
        
        cell.productNameLabel.text = productViewModel.name
        cell.productTagLabel.text = productViewModel.tagline
        cell.productdescriptionLabel.text = productViewModel.description
        cell.productImage.sd_setImage(with: URL(string: productViewModel.imageUrl))
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastElement = productList.count - 1
        if indexPath.row == lastElement && !reachMax && !isLocalData {
            pageIndex+=1
            loadProducts(withPageIndex: pageIndex)
        }
    }
    
    // MARK: - Private instance methods
    
    func filterContentForSearchText(_ searchText: String) {
        filteredProduct = productList.filter({( product : Product) -> Bool in
            return  product.name.lowercased().contains(searchText.lowercased())
        })
        tableView.reloadData()
    }
    
    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
}

extension ListViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}

