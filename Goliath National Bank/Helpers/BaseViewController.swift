//
//  Spinner.swift
//  Goliath National Bank
//
//  Created by Bogdan on 01.06.2021.
//

import UIKit

class BaseViewController: UIViewController {

    var containerView: UIView!
    
    var spinner = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
    
    func showSpinner() {
        containerView = UIView(frame: view.frame)
        containerView.backgroundColor = UIColor.white.withAlphaComponent(0.7)

        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.startAnimating()
        containerView.addSubview(spinner)

        spinner.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        
        view.addSubview(containerView)
    }
    
    func dismissSpinner() {
        containerView?.removeFromSuperview()
        containerView = nil
    }
    
    func showAlert(title: String, message: String, preferedStyle: UIAlertController.Style) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: preferedStyle)
        let cancel = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }

}
