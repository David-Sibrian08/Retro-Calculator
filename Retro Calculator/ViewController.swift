//
//  ViewController.swift
//  Retro Calculator
//
//  Created by Sibrian on 6/30/16.
//  Copyright © 2016 Sibrian. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    @IBOutlet weak var outputLabel: UILabel!
    
    enum Operation: String {
        case Divide = "/"
        case Multiply = "*"
        case Add = "+"
        case Subtract = "-"
        case Empty = "Empty"
    }
    
    var buttonSound: AVAudioPlayer!
    
    var result = ""
    var runningNumber = "0"
    var leftValue = ""
    var rightValue = ""
    var currentOperation: Operation = .Empty
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //1: Grab the path of the file
        let path = Bundle.main.path(forResource: "btn", ofType: "wav")
        
        //2: Create the URL that the audio player will use
        let soundURL = URL(fileURLWithPath: path!)
        
        //3: Assign the player to the button sound
        do {
            try buttonSound = AVAudioPlayer(contentsOf: soundURL)
            buttonSound.prepareToPlay()
        } catch let error as NSError {
            print(error.debugDescription)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Making an IBAction for every number button is not ideal.
    //Change the tag for each button
    @IBAction func numberKeyPressed(_ button: UIButton!) {
        playSound()
        
        runningNumber += "\(button.tag)"
        outputLabel.text = runningNumber
    }
    
    @IBAction func divideButtonPressed(_ sender: UIButton) {
        processOperation(Operation.Divide)
        
    }
    
    @IBAction func multiplyButtonPressed(_ sender: UIButton) {
        processOperation(Operation.Multiply)
    }
    
    @IBAction func subtractButtonPressed(_ sender: UIButton) {
        processOperation(Operation.Subtract)
    }
    
    @IBAction func addButtonPressed(_ sender: UIButton) {
        processOperation(Operation.Add)
    }
    
    @IBAction func equalsButtonPressed(_ sender: UIButton) {
        processOperation(currentOperation)
    }
    
    @IBAction func clearButtonPressed(_ sender: UIButton) {
        playSound()
        result = ""
        runningNumber = "0"
        leftValue = ""
        rightValue = ""
        currentOperation = .Empty
        
        outputLabel.text = "0"
        
    }
    
    
    func processOperation(_ op: Operation) {
        playSound()
        
        if currentOperation != .Empty {
            //perform arithmetic
            if runningNumber != "" {
                rightValue = runningNumber
                runningNumber = ""

                if currentOperation == .Multiply {
                    result = "\(Double(leftValue)! * Double(rightValue)!)"
                } else if currentOperation == .Divide {
                    result = "\(Double(leftValue)! / Double(rightValue)!)"
                } else if currentOperation == .Add {
                    result = "\(Double(leftValue)! + Double(rightValue)!)"
                } else if currentOperation == .Subtract {
                    result = "\(Double(leftValue)! - Double(rightValue)!)"
                }
                
                leftValue = result
                outputLabel.text = result
                
            }
            
            currentOperation = op
            
        } else {
            //first operator instance
            leftValue = runningNumber
            runningNumber = ""
            currentOperation = op
        }
    }
    
    func playSound() {
        if buttonSound.isPlaying {
            buttonSound.stop()
        }
        buttonSound.play()
    }
    
}

