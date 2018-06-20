//
//  Document.swift
//  Document Based SQLite
//
//  Created by Andre Yonadam on 6/19/18.
//  Copyright © 2018 Andre Yonadam. All rights reserved.
//

import Cocoa
import GRDB

class Document: NSDocument {
    
    let memoryDBQueue = DatabaseQueue()
    
    override init() {
        super.init()
        // Add your subclass-specific initialization here.
        try! memoryDBQueue.write { db in
            try db.execute("""
        CREATE TABLE entry (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          title TEXT NOT NULL)
        """)
            
            
        }
    }
    
    override class var autosavesInPlace: Bool {
        return true
    }
    
    override func makeWindowControllers() {
        // Returns the Storyboard that contains your Document window.
        let storyboard = NSStoryboard(name: NSStoryboard.Name("Main"), bundle: nil)
        let windowController = storyboard.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier("Document Window Controller")) as! NSWindowController
        self.addWindowController(windowController)
        
        do {
            try memoryDBQueue.read { db in
                // Fetch database rows
                let rows = try Row.fetchCursor(db, "SELECT * FROM entry")
                while let row = try rows.next() {
                    let title: String = row["title"]
                    NSLog("Title: " + title)
                }
            }
        } catch {
            NSLog("Reading DB Error!")
        }
    }
    
    override func write(to url: URL, ofType typeName: String, for saveOperation: NSDocument.SaveOperationType, originalContentsURL absoluteOriginalContentsURL: URL?) throws {
        let destination = try DatabaseQueue(path: url.path)
        do {
            try memoryDBQueue.backup(to: destination)
        } catch {
            throw NSError(domain: NSOSStatusErrorDomain, code: unimpErr, userInfo: nil)
        }
    }
    
    override func read(from url: URL, ofType typeName: String) throws {
        let source = try DatabaseQueue(path: url.path)
        do {
            try source.backup(to: memoryDBQueue)
        } catch {
            throw NSError(domain: NSOSStatusErrorDomain, code: unimpErr, userInfo: nil)
        }
    }
    
    
}

