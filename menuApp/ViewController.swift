//
//  ViewController.swift
//  menuApp
//
//  Created by User on 2019/12/07.
//  Copyright © 2019 com.is151050. All rights reserved.
//

import UIKit
import SwiftyTesseract
import CropViewController
var List_selected = PhraseModel_list()
var List_image_text = [String]()
var selectedImage = UIImage()
class ViewController: UIViewController {

    let swiftyTesseract = SwiftyTesseract(language: RecognitionLanguage.japanese)
    @IBAction func camera(_ sender: Any) {
        
        let alert:UIAlertController = UIAlertController(title: "Messenger", message: "select", preferredStyle: .alert)
            let btnPhoto:UIAlertAction = UIAlertAction(title: "Photo", style: .default){ (UIAlertAction) in
                let imgPiker = UIImagePickerController()
                imgPiker.sourceType = UIImagePickerController.SourceType.photoLibrary
                imgPiker.delegate = self
                imgPiker.allowsEditing = true
                self.present(imgPiker, animated: true, completion: nil)

            }
        
            let btnCamera:UIAlertAction = UIAlertAction(title: "Camera", style: .default) {
                (UIAlertAction) in
                if(UIImagePickerController.isSourceTypeAvailable(.camera)){
                    let imgPiker = UIImagePickerController()
                    imgPiker.sourceType = UIImagePickerController.SourceType.camera
                    imgPiker.delegate = self
                    imgPiker.allowsEditing = false
                    self.present(imgPiker, animated: true, completion: nil)
                }else{
                    print("no camera")
                }
            }
            alert.addAction(btnPhoto)
            alert.addAction(btnCamera)
            
            self.present(alert, animated: true, completion: nil)
    
    }

    

    
    @IBAction func selectcellNum(_ sender: Any) {
        
    }
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tbView: UITableView!
    let menuList = ["ひつまぶし","纳豆","ばすし","ひつまぶし","馬刺身","白子","とんこつラーメン","すき焼き","味噌汁","サーモン","うどん","天ぷら","おでん","たこ焼き","親丼","オムライス","懐石料理"]
    
    var searchmenu = [String]()
    var searching = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let image = UIImage(named: "test.jpg")

        UIImageWriteToSavedPhotosAlbum(image!, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
        
        // Do any additional setup after loading the view.
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
    if let error = error {
        // we got back an error!
        let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    } else {
        let ac = UIAlertController(title: "Saved!", message: "Your altered image has been saved to your photos.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
}

}



extension ViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching {
           return searchmenu.count
        }else{
            return menuList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if searching{
            cell?.textLabel?.text = searchmenu[indexPath.row]
        }else{
            cell?.textLabel?.text = menuList[indexPath.row]
        }
        
        
        cell?.textLabel?.text = menuList[indexPath.row]

        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        List_selected.id = "\(indexPath.row)"
        List_selected.name = menuList[indexPath.row]
        print(List_selected.id)
        print(List_selected.name)
        if(List_selected.name == menuList[0]||List_selected.name == menuList[1]||List_selected.name == menuList[2]){
            let des0 = storyboard?.instantiateViewController(withIdentifier: "InfoViewController")
            navigationController?.pushViewController(des0!, animated: true)
        }else{
            let des0 = storyboard?.instantiateViewController(withIdentifier: "Info2ViewController")
            navigationController?.pushViewController(des0!, animated: true)
        }
    }
}
extension ViewController : UIImagePickerControllerDelegate,UINavigationControllerDelegate,CropViewControllerDelegate{

    
    func presentCropViewController(image: UIImage, crop: Bool) {
        let cropViewController = CropViewController(image: image)
        cropViewController.delegate = self
        present(cropViewController, animated: true, completion: nil)
    }
    
    func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        
        selectedImage = image
        
        swiftyTesseract.performOCR(on: image) { recognizedString in
            guard let text = recognizedString else { return }
            //print("\(text)")

            List_image_text = text.components(separatedBy: "\n")
            //print("\(-start.timeIntervalSinceNow)")
            let des0 = self.storyboard?.instantiateViewController(withIdentifier: "SelectedImageViewController")
            self.navigationController?.pushViewController(des0!, animated: true)
        }
        dismiss(animated: true, completion: nil)
    }
    
    

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let choseImg = info[.originalImage] as! UIImage

        dismiss(animated: true, completion: nil)
        presentCropViewController(image: choseImg,crop: true)
    }
    
    



}







extension ViewController: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchmenu = menuList.filter({$0.lowercased().prefix(searchText.count) == searchText.lowercased()})
        searching = true
        tbView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchBar.text = ""
        tbView.reloadData()
    }
    
}
