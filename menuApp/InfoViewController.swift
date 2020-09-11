//
//  InfoViewController.swift
//  menuApp
//
//  Created by Phan Tai on R 1/12/07.
//  Copyright © Reiwa 1 com.is151050. All rights reserved.
//

import UIKit

class InfoViewController: UIViewController {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var namelable: UILabel!
    @IBOutlet weak var foodimage: UIImageView!
    @IBOutlet weak var weiboimage: UIImageView!
    let WeiboImageArr:[String] = ["hitumabusi.jpg","natou.png","basusi.png"]
    let FoodImageArr:[String] = ["hitumabusi-1.jpg","natouImg","basusiImg"]
    let NamechinaArr:[String] = ["ひつまぶし","纳豆","ばすし"]
    var num = Int(List_selected.id)
    override func viewDidLoad() {
        super.viewDidLoad()

        name.text = NamechinaArr[num!]
        namelable.text = List_selected.name
        // Do any additional setup after loading the view.
        weiboimage.image = UIImage(named: WeiboImageArr[num!])
       foodimage.image = UIImage(named: FoodImageArr[num!])
        
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
