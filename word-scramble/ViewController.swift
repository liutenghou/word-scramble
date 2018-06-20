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
        
        //set the right nav bar button
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promptForAnswer))
        
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
    
    //click the add button in nav
    @objc func promptForAnswer(){
        print("calling promptForAnswer")
        
        //closure example
        let ac = UIAlertController(title: "Enter answer", message: nil, preferredStyle: .alert)
        ac.addTextField() //adds an editable text field to alert

        let submitAction = UIAlertAction(title: "Submit", style: .default){
            [unowned self, ac] (action:UIAlertAction) in
                let answer = ac.textFields![0]
                self.submit(answer: answer.text!)
        }
        
        ac.addAction(submitAction)
        present(ac, animated: true)
    }
    
    //click submit button from alert
    func submit(answer: String){
        print(answer)
        
        let lowerAnswer = answer.lowercased()
        
        //check if word can be made from given letters
        
        //check if word is valid
        
        //check if word is already used else add
        
        if isPossible(word: lowerAnswer) && isOriginal(word: lowerAnswer) && isReal(word: lowerAnswer){
            //insert new row in tableview
            usedWords.insert(lowerAnswer, at: 0)
            let indexPath = IndexPath(row: 0, section: 0)
            tableView.insertRows(at: [indexPath], with: .automatic)
        }
    }
    
    //MARK: word check methods
    func isPossible(word: String) -> Bool {
        print("isPossible \(word)")
        return true
    }
    
    func isOriginal(word: String) -> Bool {
        print("isOriginal \(word)")
        return true
    }
    
    func isReal(word: String) -> Bool {
        print("isReal \(word)")
        return true
    }
    
    //MAR: start. reshuffles array, resets
    func startGame(){
        //reshuffle array
        allWords = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: allWords) as! [String]
        selectedWord = allWords[0]
        title = selectedWord
        usedWords.removeAll(keepingCapacity: true)
        tableView.reloadData()
    }
    
    //MARK: UITableView methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usedWords.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Word", for: indexPath)
        cell.textLabel?.text = usedWords[indexPath.row]
        return cell
    }

    //MARK: UIViewController methods
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

