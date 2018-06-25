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
                let answer = ac.textFields![0].text!.lowercased()
                self.submit(answer: answer)
        }
        
        ac.addAction(submitAction)
        present(ac, animated: true)
    }
    
    //click submit button from alert
    func submit(answer: String){
        print(answer)
        //checks
        if isPossible(word: answer) && !isAlreadyUsed(word: answer) && isReal(word: answer){
            //insert new row in tableview
            usedWords.insert(answer, at: 0)
            let indexPath = IndexPath(row: 0, section: 0)
            tableView.insertRows(at: [indexPath], with: .automatic)
        }else{
            let errorTitle:String = "Oops,"
            let errorMessage:String = "Can't use that word."
            let ac = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(ac, animated: true)
        }
    }
    
    //MARK: word check methods
    func isPossible(word: String) -> Bool {
        print("isPossible \(word)")
        
        var tempSelectedWord = selectedWord
        //loop through tempWord, remove letters that are found in tempSelectedWord
        for letter in word{
            if let letterIndex = tempSelectedWord.index(of:letter){
                tempSelectedWord.remove(at: letterIndex)
            }else{
                return false
            }
        }
        return true
    }
    
    func isAlreadyUsed(word: String) -> Bool {
        print("isOriginal \(word)")
        
        if word == selectedWord {
            return true
        }
        
        return usedWords.contains(word)
    }
    
    func isReal(word: String) -> Bool {
        print("isReal \(word)")
        
        if word.count < 2{
            return false
        }
        
        //TODO: use lexicontext or some other static library instead
        let wordChecker = UITextChecker() //use spellcheck
        let wordRange = NSMakeRange(0, word.utf16.count)
        let misspelledRange:NSRange = wordChecker.rangeOfMisspelledWord(in: word, range: wordRange, startingAt: 0, wrap: false, language: "en")
        
        return misspelledRange.location == NSNotFound //no mispellings found -> returns true
    }
    
    //MAR: start. reshuffles array, resets
    func startGame(){
        //reshuffle array
        allWords = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: allWords) as! [String]
        selectedWord = allWords[0].lowercased()
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

