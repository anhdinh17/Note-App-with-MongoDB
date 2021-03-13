//
//  ViewController.swift
//  AFTest
//
//  Created by Anh Dinh on 3/12/21.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        DataManager.shared.fetchData2()
    }


}

