//
//  resultViewController.swift
//  menuApp
//
//  Created by Phan Tai on R 2/01/18.
//  Copyright © Reiwa 2 com.is151050. All rights reserved.
//

import UIKit

class resultViewController: UIViewController {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var result: UILabel!
    @IBOutlet weak var comment: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        name.text = List_selected.name
        comment.attributedText = commentString.htmlToAttributedString
        let count1 = countString(word: "好吃", str: commentString)
        let count2 = countString(word: "难吃", str: commentString)
        if(count1>count2){
            result.text = "美味い＞まずい"
        }else if(count1 == count2){
            result.text = "美味い=まずい"
        }else{
            result.text = "美味い<まずい"
        }
        
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

