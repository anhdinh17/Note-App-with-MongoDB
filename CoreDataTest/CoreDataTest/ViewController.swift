//
//  ViewController.swift
//  CoreDataTest
//
//  Created by Anh Dinh on 3/12/21.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }


}

