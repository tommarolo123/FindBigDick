//
//  SelectedImageViewController.swift
//  menuApp
//
//  Created by Phan Tai on R 1/12/15.
//  Copyright © Reiwa 1 com.is151050. All rights reserved.
//

import UIKit

class SelectedImageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var Simage: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        Simage.image = selectedImage
        tableView.dataSource = self
        tableView.delegate = self
        
        
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return List_image_text.count
    }

    //追加④ セルに値を設定するデータソースメソッド（必須）
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // セルを取得する
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cellimagetext", for: indexPath)
        // セルに表示する値を設定する
        cell.textLabel!.text = List_image_text[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        List_selected.id = "\(indexPath.row)"
        List_selected.name = List_image_text[indexPath.row]
        print(List_selected.id)
        print(List_selected.name)
         let des0 = storyboard?.instantiateViewController(withIdentifier: "Info2ViewController")
         navigationController?.pushViewController(des0!, animated: true)
         
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



