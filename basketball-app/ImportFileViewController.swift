//
//  ImportFileViewController.swift
//  basketball-app
//
//  Created by Maggie Zhang on 9/18/18.
//  Copyright © 2018 David Zucco. All rights reserved.
//

import Foundation
import UIKit

class ImportFileViewController: UIViewController {
    func readDataFromCSV(fileName:String, fileType: String)-> String!{
        guard let filepath = Bundle.main.path(forResource: fileName, ofType: "csv")
            else {
                return nil
        }
        do {
            var contents = try String(contentsOfFile: filepath, encoding: .utf8)
            contents = cleanRows(file: contents)
            return contents
        } catch {
            print("File Read Error for file \(filepath)")
            return nil
        }
    }
    
    
    func cleanRows(file:String)->String{
        var cleanFile = file
        cleanFile = cleanFile.replacingOccurrences(of: "\r", with: "\n")
        cleanFile = cleanFile.replacingOccurrences(of: "\n\n", with: "\n")
        print(cleanFile)
        return cleanFile
    }
}
