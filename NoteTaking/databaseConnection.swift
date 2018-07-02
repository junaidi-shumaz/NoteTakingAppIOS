//
//  databaseConnection.swift
//  NoteTaking
//
//  Created by Shumaz Ahamed Junaidi on 12/4/17.
//  Copyright © 2017 ShumazAhamedJunaidi. All rights reserved.
//

import Foundation

class dbCon{
    
    var databaseString : String = String()
    
    func getdbPath() ->String{
        if databaseString.isEmpty{
        databaseString = dbConnect()
        }
        return databaseString
    }
    
    func dbConnect() -> String {
    let filemgr = FileManager.default
    let dirPaths = filemgr.urls(for: .documentDirectory, in: .userDomainMask)

    var databasePathStr = dirPaths[0].appendingPathComponent("notetake.db").path

    print ("database location \(databasePathStr as String)")

    if !filemgr.fileExists(atPath: databasePathStr) {
        
        let contactDB = FMDatabase(path: databasePathStr as String)
        
        if contactDB == nil {
            print ("Error \(contactDB.lastErrorMessage())")
        }
        
        
        
        if (contactDB.open()) {
            var sql_stmt = "CREATE TABLE IF NOT EXISTS notes (ID INTEGER PRIMARY KEY AUTOINCREMENT, EXTRA TEXT, img TEXT, long DOUBLE, lat DOUBLE)"
            
            if !(contactDB.executeStatements(sql_stmt)) {
                print ("Error \(contactDB.lastErrorMessage())")
            }
             sql_stmt = "CREATE TABLE IF NOT EXISTS notesimage (ID INTEGER PRIMARY KEY AUTOINCREMENT, img TEXT, long DOUBLE, lat DOUBLE, note_id INTEGER)"
            
            if !(contactDB.executeStatements(sql_stmt)) {
                print ("Error \(contactDB.lastErrorMessage())")
            }
            contactDB.close()
            
        } else {
            print ("Error \(contactDB.lastErrorMessage())")
    }
  }
        return databasePathStr
}
}
