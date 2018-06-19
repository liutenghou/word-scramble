//
//  ViewController.swift
//  word-scramble
//
//  Created by Leo Liu on 6/18/18.
//  Copyright © 2018 hungryforcookies. All rights reserved.
//

import UIKit
import GameplayKit

class ViewController: UITableViewController {
    
    //MARK:properties
    var allWords = [String]()
    var usedWords = [String]()
    var selectedWord:String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let startWordsPath = Bundle.main.url(forResource: "start", withExtension: "txt"){
            if let startWords = try? String(contentsOf: startWordsPath){
                allWords = startWords.components(separatedBy: "\n")
                //print(allWords)
            }
        }else{
            allWords = ["silkworm"]
        }
        
        startGame()
    }
    
    //load new word
    func startGame(){
        //reshuffle array
        allWords = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: allWords) as! [String]
        selectedWord = allWords[0]
        title = selectedWord
        usedWords.removeAll(keepingCapacity: true)
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

