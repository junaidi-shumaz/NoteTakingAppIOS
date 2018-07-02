//
//  ViewController.swift
//  NoteTaking
//
//  Created by Shumaz Ahamed Junaidi on 11/22/17.
//  Copyright © 2017 ShumazAhamedJunaidi. All rights reserved.
//

import UIKit
var counter: Int!
var data: [String] = []
var databasePath : String = String()

class ViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    
    @IBOutlet weak var table: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNotes))
        self.navigationItem.rightBarButtonItem = addButton
        self.navigationItem.leftBarButtonItem = editButtonItem
        databasePath = dbCon().getdbPath()
        ///load()
        loadDataFromSql()
    }
    override func viewDidAppear(_ animated: Bool) {
        loadDataFromSql()
        table.reloadData()
    }
    @objc func addNotes(){
        if table.isEditing {
            return
        }
        let name : String = "\(data.count + 1)-Row"
        data.insert(name, at: 0)
        let indexPath : IndexPath = IndexPath(row: 0, section: 0)
        table.beginUpdates()
        table.insertRows(at: [indexPath], with: .automatic)
        table.endUpdates()
        ///save()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        table.setEditing(editing, animated: animated)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        
        cell.textLabel?.text = data[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        data.remove (at: indexPath.row)
        table.beginUpdates()
        table.deleteRows(at: [indexPath], with: .fade)
        table.endUpdates()
        ///save()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        counter = indexPath.row
        var res:[String]! = data[counter].components(separatedBy: "-")
       /// var res = data[counter].split(separator: "-")
        print("res---\(Int(res[0])!)")
        counter = Int(res[0])
        //print(data[counter].split(separator: "-"))
        performSegue(withIdentifier: "seague", sender: self)
    }
    func save() {
        UserDefaults.standard.set(data, forKey: "notes")
        UserDefaults.standard.synchronize()
    }
    
    func load() {
        if let loadedData = UserDefaults.standard.value(forKey: "notes") as? [String] {
            data = loadedData
            table.reloadData()
        }
    }
    
    
    func loadDataFromSql(){
        
        let contactDB = FMDatabase(path: databasePath as String)
        
        if (contactDB.open()) {
            let querySQL = "SELECT id, extra FROM notes"
            data.removeAll()
            ///let querySQL = "DELETE FROM notes"
            ///let querySQL = "drop table notes"
            
            let results: FMResultSet = contactDB.executeQuery(querySQL, withArgumentsIn: [])!
            var i:Int = 0
            while results.next() {
                var res = "\(String(results.int(forColumn: "id")))-\(results.string(forColumn: "extra")!)"
                data.insert(res, at: i)
                print ("\(res)\(i)")
                i = i + 1
                  } 
            print (data)
            contactDB.close()
        } else {
            print ("Error \(contactDB.lastErrorMessage())")
        }
    }
}

