//
//  ViewController.swift
//  SCalc
//
//  Created by Nico Zino on 2017/03/10.
//  Copyright © 2017 Nico Zino. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var resultLbl: UILabel!
    var clearOnType = false
    var brain = SBrain()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func charAction(_ sender: UIButton) {
        // what to do when a number/char is pressed
        if clearOnType {
            resultLbl.text = sender.title(for: .normal)
            clearOnType = false
        } else {
            resultLbl.text = resultLbl.text! + sender.title(for: .normal)!
        }
    }
    
    @IBAction func pointAction(_ sender: UIButton) {
        if clearOnType {
            resultLbl.text = "0."
            clearOnType = false
        } else if (resultLbl.text?.contains("."))! {
            return
        } else {
            resultLbl.text = resultLbl.text! + "."
        }
    }
    
    @IBAction func operatorAction(_ sender: UIButton) {
        if clearOnType {
            resultLbl.text = String(brain.result)
        }
        
        if !clearOnType {
            brain.setOperand(operand: Double(resultLbl.text ?? "")) // ?
            clearOnType = true
        }
        if let symbol = sender.title(for: .normal) {
            brain.performMath(symbol: symbol)
        }
    
        resultLbl.text = String(brain.result)
    }

    @IBAction func clearAction(_ sender: UIButton) {
        brain.setOperand(operand: nil)
        brain.setPendingBinary(pending: nil) // vider la pile
        clearOnType = true
        resultLbl.text = "0" // afficher 0 lors du clear
    
   }
    
}

