//
//  EditNoteControllerViewController.swift
//  NoteTaking
//
//  Created by Shumaz Ahamed Junaidi on 11/22/17.
//  Copyright © 2017 ShumazAhamedJunaidi. All rights reserved.
//

import UIKit

class EditNoteControllerViewController: UIViewController {

    @IBOutlet weak var camera: UIImageView!
    @IBOutlet weak var note: UITextView!
    var noteVal = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        note.text = noteVal
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
