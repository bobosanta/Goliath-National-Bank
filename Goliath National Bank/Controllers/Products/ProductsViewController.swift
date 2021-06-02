//
//  ViewController.swift
//  Goliath National Bank
//
//  Created by Bogdan on 01.06.2021.
//

import UIKit

class ProductsViewController: BaseViewController {

    @IBOutlet weak var productTableView: UITableView!
    @IBOutlet weak var currencyInputView: UITextField!

    private let currencyPickerView = UIPickerView()

    private var transactionsDictionary: Dictionary = [String: [ProductTransaction]]()
    private var ratesDictionary: Dictionary = [String: [String: Decimal]]()
    private var transactions = [ProductTransaction]()
    private var rates = [Rate]()

    private var selectedCurrency = ""
    private var selectedItemSKU = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        currencyInputView.inputView = currencyPickerView
        currencyPickerView.delegate = self

        showSpinner()

        let dispatchGroup = DispatchGroup()

        dispatchGroup.enter()
        getTransactions { dispatchGroup.leave() }

        dispatchGroup.enter()
        getRates { dispatchGroup.leave() }

        dispatchGroup.notify(queue: .main) {
            self.dismissSpinner()
            self.productTableView.reloadData()
        }

    }

    private func getRates(completion: @escaping () -> Void) {
        APIClient.rates { [self] rates in
            self.rates = rates ?? []

            for rate in self.rates {
                if self.ratesDictionary[rate.from] == nil {
                    self.ratesDictionary[rate.from] = [rate.to: rate.rate]
                } else {
                    if var arr = (self.ratesDictionary[rate.from]) {
                        arr[rate.to] = rate.rate
                        self.ratesDictionary[rate.from] = arr
                    }
                }
            }
            selectedCurrency = Array(ratesDictionary.keys).first ?? "EUR"
            self.currencyInputView.text = selectedCurrency
            completion()
        }
    }

    private func getTransactions(completion: @escaping () -> Void) {
        APIClient.transactions { tr in
            self.transactions = tr ?? []
            for transaction in self.transactions {
                if self.transactionsDictionary[transaction.sku] == nil {
                    self.transactionsDictionary[transaction.sku] = [transaction]
                } else {
                    if var arr = (self.transactionsDictionary[transaction.sku]) {
                        arr.append(transaction)
                        self.transactionsDictionary[transaction.sku] = arr
                    }
                }
            }
            completion()
        }
    }

    private func getTotalValueForProduct(withSKU sku: String, inCurrency currency: String) throws -> Double {
        guard let productTransactions = transactionsDictionary[sku] else {
            throw RuntimeError(message: "Can't get total value for product.")
        }
        var totalValueInSelectedCurrency = Decimal.zero
        for tr in productTransactions {
//            let price = convertPrice(fromValue: tr.currency, toValue: currency, price: tr.amount, visited: [])
            let price = convertPrice(tr.amount, fromCurrency: tr.currency, toCurrency: currency)
            totalValueInSelectedCurrency += price
        }
        
        let roundedValue = round((totalValueInSelectedCurrency as NSDecimalNumber).doubleValue * 100) / 100.0
        
        return roundedValue
    }


//    func x(fromValue: String, toValue: String, price: Decimal, visited: [String]) -> Decimal {
//        if fromValue == toValue {
//            return price
//        } else if let fromDict = ratesDictionary[fromValue] {
//            if let rate = fromDict[toValue] {
//                return rate * price
//            } else {
//                for (k, v) in fromDict {
//                    if !visited.contains(k) {
//                        var vis = visited
//                        vis.append(k)
//
//                        let ppp = convertPrice(fromValue: k, toValue: toValue, price: v, visited: vis)
//                        if ppp != Decimal.zero {
//                            return price * ppp
//                        }
//                    }
//                }
//            }
//        }
//
//        return Decimal.zero
//    }


    private func convertPrice(_ price: Decimal, fromCurrency: String, toCurrency: String) -> Decimal {
        let convertedPrice = Decimal.zero

        if fromCurrency == toCurrency {
            return price
        }

        if let dict = ratesDictionary[fromCurrency], let rate = dict[toCurrency] {
            return price * rate
        }

        if let dict = ratesDictionary[fromCurrency] {
            for r in dict {
                if let rdict = ratesDictionary[r.key], let rate = rdict[toCurrency] {
                    return price * r.value * rate
                }
            }
        }

        if let dict = ratesDictionary[fromCurrency] {
            for r in dict {
                if let rdict = ratesDictionary[r.key] {
                    for rr in rdict {
                        if let rdict = ratesDictionary[rr.key], let rate = rdict[toCurrency] {
                            return price * r.value * rr.value * rate
                        }
                    }
                }
            }
        }

        return convertedPrice
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? ConversionRatesViewController {
            do {
                try vc.totalAmount = getTotalValueForProduct(withSKU: selectedItemSKU, inCurrency: "EUR")
                vc.title = selectedItemSKU
                vc.transactions = Array(transactionsDictionary[selectedItemSKU] ?? [])
            } catch let error {
                showAlert(title: "Error", message: error.localizedDescription, preferedStyle: .alert)
            }
        }
    }

}

extension ProductsViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactionsDictionary.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = productTableView.dequeueReusableCell(withIdentifier: "TransactionCell") as? ProductTableViewCell else { return UITableViewCell() }
        do {
            cell.skuLabel.text = Array(transactionsDictionary.keys)[indexPath.row]
            try cell.amountLabel.text = "\(getTotalValueForProduct(withSKU: Array(transactionsDictionary.keys)[indexPath.row], inCurrency: selectedCurrency))"
//            "\((transactions[indexPath.row].amount as NSDecimalNumber).doubleValue.rounded(.toNearestOrEven))"
            cell.currencyLabel.text = selectedCurrency
            return cell
        } catch let error {
            showAlert(title: "Error", message: error.localizedDescription, preferedStyle: .alert)
            return UITableViewCell()
        }

    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedItemSKU = Array(transactionsDictionary.keys)[indexPath.row]
        performSegue(withIdentifier: "showTransactionDetails", sender: nil)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }

}

extension ProductsViewController: UIPickerViewDelegate, UIPickerViewDataSource {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return ratesDictionary.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Array(ratesDictionary.keys)[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedCurrency = Array(ratesDictionary.keys)[row]
        currencyInputView.text = selectedCurrency
        currencyInputView.resignFirstResponder()
        productTableView.reloadData()
    }

}

