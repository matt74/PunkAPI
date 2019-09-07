//
//  ListViewController.swift
//  PunkAPI
//
//  Created by Matthias BUREL on 06.09.19.
//  Copyright © 2019 Matthias BUREL. All rights reserved.
//

import UIKit
import SDWebImage
import FSnapChatLoading

class ListViewController: UITableViewController {
    
    let productService = ProductService()
    let loadingView = FSnapChatLoadingView()
    
    var pageIndex: Int = 1
    var reachMax: Bool = false
    
    var productVMs:[ProductView] = [] {
        didSet {
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tableView.tableFooterView = UIView()
        
        self.title = "PunkAPI"
        loadProducts(withPageIndex: pageIndex)
    }

    
    @objc func loadProducts(withPageIndex: Int) {
        loadingView.show(view: self.view, color: UIColor.black)
        
        self.productService.getProduct(pageIndex: pageIndex) {[weak self] (error, products) in
            guard let strongSelf = self else { return }
            strongSelf.loadingView.hide()
            if error != nil {
                
                self?.reachMax = true
                
                let alert = UIAlertController(title: "Warning", message: "An error occur.", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { _ in}))
                self?.present(alert, animated: true, completion: nil)
                
                return
            }
            strongSelf.productVMs += products
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productVMs.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCellIdentifier", for: indexPath) as? CustomCell else {
            return UITableViewCell()
        }
        let productViewModel = productVMs[indexPath.row]
        
        cell.productNameLabel.text = productViewModel.productNameText
        cell.productTagLabel.text = productViewModel.productTaglineText
        cell.productdescriptionLabel.text = productViewModel.productDescriptionText
        cell.productImage.sd_setImage(with: productViewModel.productImageUrl)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastElement = productVMs.count - 1
        if indexPath.row == lastElement && !reachMax {
            pageIndex+=1
            loadProducts(withPageIndex: pageIndex)
        }
    }
}
