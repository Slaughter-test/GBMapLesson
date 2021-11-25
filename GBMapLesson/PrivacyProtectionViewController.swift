//
//  PrivacyProtectionViewController.swift
//  GBMapLesson
//
//  Created by Юрий Егоров on 18.11.2021.
//

import UIKit

class PrivacyProtectionViewController: UIViewController {
    
    var privacyLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }

    private func setupViews() {
        view.backgroundColor = .black
        privacyLabel = UILabel()
        privacyLabel.text = "Ничего не увидишь падла"
        privacyLabel.textColor = .white
        view.addSubview(privacyLabel, anchors: [.leading(100), .height(50), .trailing(-100), .bottom(-450)])
    }
}
