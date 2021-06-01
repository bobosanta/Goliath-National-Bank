//
//  ViewController.swift
//  Goliath National Bank
//
//  Created by Bogdan on 01.06.2021.
//

import UIKit

class ProductsViewController: UIViewController {

    @IBOutlet weak var productTableView: UITableView!


    override func viewDidLoad() {
        super.viewDidLoad()



    }


}

extension ProductsViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = productTableView.dequeueReusableCell(withIdentifier: "TransactionCell") else { return UITableViewCell() }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        performSegue(withIdentifier: "showTransactionDetails", sender: UITableViewCell.self)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }

}

