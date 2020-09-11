//
//  SecondViewController.swift
//  menuApp
//
//  Created by User on 2019/12/07.
//  Copyright © 2019 com.is151050. All rights reserved.
//

import UIKit
import CoreData

class SecondViewController: UIViewController {
    @IBOutlet weak var Name: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBOutlet weak var closeBtn: UIButton!
    
    @IBAction func closeButton(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    

}
