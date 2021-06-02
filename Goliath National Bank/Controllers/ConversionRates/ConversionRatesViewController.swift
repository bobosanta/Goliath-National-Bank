//
//  ConversionRatesViewController.swift
//  Goliath National Bank
//
//  Created by Bogdan on 01.06.2021.
//

import UIKit

class ConversionRatesViewController: UIViewController {

    @IBOutlet weak var conversionRatesTableView: UITableView!
    @IBOutlet weak var totalAmountLabel: UILabel!
    @IBOutlet weak var totalCurrencyLabel: UILabel!

    var transactions = [ProductTransaction]()
    var totalAmount: Double = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        totalAmountLabel.text = "\(totalAmount)"
        totalCurrencyLabel.text = "EUR"
    }

}

extension ConversionRatesViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactions.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = conversionRatesTableView.dequeueReusableCell(withIdentifier: "conversionRateCell") as? ConversionRatesTableViewCell else { return UITableViewCell() }
        let roundedValue = round((transactions[indexPath.row].amount as NSDecimalNumber).doubleValue * 100) / 100.0
        cell.amountLabel.text = "\(roundedValue)"
        cell.currencyLabel.text = transactions[indexPath.row].currency
        return cell
    }




}
