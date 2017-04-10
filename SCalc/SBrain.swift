//
//  SBrain.swift
//  SCalc
//
//  Created by Nico Zino on 2017/03/10.
//  Copyright © 2017 Nico Zino. All rights reserved.
//

import Foundation

func multiply(arg1 : Double, arg2: Double) -> Double {
    return arg1*arg2
}

class SBrain {
    
    private var accumulator : Double?
    
    private enum Symbol {
        case constant(Double)
        case unaryOperation((Double)->Double)
        case binaryOperation((Double,Double)->Double)
        case equals
    }
    
    private var operations : Dictionary<String, Symbol> = [
        "π" : Symbol.constant(Double.pi),
        "√" : Symbol.unaryOperation(sqrt), // ?
        "*" : Symbol.binaryOperation(multiply),
        "-" : Symbol.binaryOperation({ (x, y) -> Double in
            return x - y
        }),
        "+" : Symbol.binaryOperation({ $0 + $1 }),
        "/" : Symbol.binaryOperation({ $0 / $1 }), // Ajout de l'operande division
        "=" : Symbol.equals
    ]
    
    func performMath(symbol: String) {
        if let op = operations[symbol] {
            switch op {
            case .constant(let c):
                accumulator = c
            case .unaryOperation(let f):
                if accumulator != nil {
                    accumulator = f(accumulator!)
                }
            case .binaryOperation(let f):
                if accumulator != nil {
                    pendingBinary = PendingBinaryOperation(function: f, firstOperand: accumulator!) //?
                    accumulator = nil
                }
            case .equals:
                performPendingBinaryOp()
                break
            }
        }
    }
    
    private var pendingBinary : PendingBinaryOperation?
    
    private func performPendingBinaryOp() {
        if pendingBinary != nil && accumulator != nil {
            accumulator = pendingBinary?.perform(with: accumulator!)
        }
    }
    
    struct PendingBinaryOperation { //?
        let function : (Double,Double) -> Double //?
        let firstOperand : Double//?
        
        func perform(with secondOperand : Double) -> Double {
            return function(firstOperand, secondOperand)
        }
    }
    
    func setOperand(operand: Double?) {
        accumulator = operand
    }
    
    // Vider la pile de calcul lors du clear
    func setPendingBinary(pending: PendingBinaryOperation?) {
        pendingBinary = pending
    }
    
    // Test de retour pour savoir si il faut afficger la valeur saisie ou le résultat du calcul
    var result: Double {
        get {
            if pendingBinary != nil {
                return accumulator ?? pendingBinary!.firstOperand
            }
            else{
                return accumulator ?? 0
            }
        }
    }
}
