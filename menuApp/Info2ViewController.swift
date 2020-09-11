//
//  Info2ViewController.swift
//  menuApp
//
//  Created by Phan Tai on R 2/01/18.
//  Copyright © Reiwa 2 com.is151050. All rights reserved.
//

import UIKit
var commentString = ""
class Info2ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var ArrayMain = [String]()
    var searchword = List_selected.name
    //var searchword = "辛味チキン"
    var count1 = 0
    var count2 = 0
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var result1: UILabel!
    @IBOutlet weak var result2: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        name.text = searchword
        tableView.dataSource = self
        tableView.delegate = self
        
        searchWeibo(keyword: searchword)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ArrayMain.count
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // セルを取得する
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cellInfo2", for: indexPath)
        // セルに表示する値を設定する
        cell.textLabel!.attributedText = ArrayMain[indexPath.row].htmlToAttributedString
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        commentString = ArrayMain[indexPath.row]
         let des0 = storyboard?.instantiateViewController(withIdentifier: "resultViewController")
         navigationController?.pushViewController(des0!, animated: true)
         
    }
    
    func countString(word:String,str:String) -> Int{
        var count = 0
        var nextRange = str.startIndex..<str.endIndex //最初は文字列全体から探す
        while let range = str.range(of: word, options: .caseInsensitive, range: nextRange) { //.caseInsensitiveで探す方が、lowercaseStringを作ってから探すより普通は早い
            count += 1
            nextRange = range.upperBound..<str.endIndex //見つけた単語の次(range.upperBound)から元の文字列の最後までの範囲で次を探す
        }
        return count
    }
    
    func searchWeibo (keyword : String){
        let link: String = "https://m.weibo.cn/api/container/getIndex?type=wb&queryVal=\(searchword)&containerid=100103type=2%26q%3D\(searchword)&page=5"
        guard let req_url = URL(string: link.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!) else { return }
        let req = URLRequest(url: req_url)

        let task: URLSessionTask  = URLSession.shared.dataTask(with: req, completionHandler: {data, response, error in
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
                //let utf8 = String(data: json as! Data ,encoding: .utf8)
                //print(self.jsonToString(json: json as AnyObject))
                let jsonString: String = self.jsonToString(json: json as AnyObject)
                let personalData: Data =  jsonString.data(using: String.Encoding.utf8)!
                do {
                    let jsonArray = try JSONSerialization.jsonObject(with: personalData) as! Dictionary<String, Any>
                    let jsonArray2 = jsonArray["data"] as AnyObject
                    let jsonArray3 = jsonArray2["cards"] as AnyObject
                    let jsonArray4 = jsonArray3 as! Array<Dictionary<String, Any>>
                    let jsonArray5 = jsonArray4[0] as AnyObject
                    let jsonArray6 = jsonArray5["card_group"] as! Array<Dictionary<String, Any>>
                    
                    for i in 0...(jsonArray6.count-1)
                    {
                        let jsonArray61 = jsonArray6[i] as AnyObject
                        let jsonArray7 = jsonArray61["mblog"] as AnyObject
                        var jsonArray8 = jsonArray7["text"] as! String
                        jsonArray8 = jsonArray8.replacingOccurrences(of: "好吃", with: "<a style='font-size:22px;color:red;font-weight:bold;'>好吃</a>")
                        jsonArray8 = jsonArray8.replacingOccurrences(of: "难吃", with: "<a style='font-size:22px;color:red;font-weight:bold;'>难吃</a>")
                        self.ArrayMain.append(jsonArray8)
                        self.count1 += self.countString(word: "好吃", str: jsonArray8)
                        self.count2 += self.countString(word: "难吃", str: jsonArray8)
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                            if(self.count1>self.count2){
                                self.result1.text = "美味い＞まずい"
                                self.result2.text = "\(self.count1)＞\(self.count2)"
                            }else if(self.count1==self.count2){
                                self.result1.text = "美味い=まずい"
                                self.result2.text = "\(self.count1)=\(self.count2)"
                            }else{
                                self.result1.text = "美味い<まずい"
                                self.result2.text = "\(self.count1)<\(self.count2)"
                            }
                        }
                    }
                } catch {
                    print(error)
                }
                //let jsonArray = json as AnyObject
                
                //print(jsonArray["data"])
                
                
                //let jsonArray = json as AnyObject
                
                
                
            }
            catch {
                print(error)
            }
        })
        task.resume()
    }
    func jsonToString(json: AnyObject) -> String{
        do {
            let data1 =  try JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions.prettyPrinted) // first of all convert json to the data
            let convertedString = String(data: data1, encoding: String.Encoding.utf8) // the data will be converted to the string
            return convertedString ?? ""
            //print(convertedString ?? "defaultvalue")
        } catch {
            //print(myJSONError)
            return ""
        }

    }
    

}
struct WeiboData: Codable {
       var cardlistInfo: CARD_GROUP?
   
struct CARD_GROUP: Codable {
    var can_shared: String?
    var mblog: MBLOD?
}
struct MBLOD: Codable {
    var id: String?
    var text: String?
}
}

struct Shop {
    var cardlistInfo: String?
    var can_shared: String?
}

struct ResultJson: Codable {
       let data:[WeiboData]?
}
extension String {
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return NSAttributedString()
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
}
