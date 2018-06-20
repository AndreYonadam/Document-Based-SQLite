//
//  ViewController.swift
//  Document Based SQLite
//
//  Created by Andre Yonadam on 6/19/18.
//  Copyright © 2018 Andre Yonadam. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    
    @IBAction func addDataToDBClicked(_ sender: Any) {
        if let document = view.window?.windowController?.document as? Document {
            try! document.memoryDBQueue.write { db in
                try db.execute("""
        INSERT INTO entry (title)
        VALUES (?)
        """, arguments: ["Added"])
                
            }
            document.updateChangeCount(NSDocument.ChangeType.changeDone)
        }
    }
    
}

