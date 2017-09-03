//
//  NoteDetailViewController.swift
//  Siri
//
//  Created by Erik on 9/3/17.
//  Copyright © 2017 Erik Flores. All rights reserved.
//

import UIKit

class NoteDetailViewController: UIViewController {
    
    @IBOutlet weak var noteTextView: UITextView!
    var noteDescription:String? = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        noteTextView.text = noteDescription
    }

}
