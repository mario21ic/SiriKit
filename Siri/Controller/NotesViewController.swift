//
//  NotesViewController.swift
//  Siri
//
//  Created by Erik on 9/3/17.
//  Copyright © 2017 Erik Flores. All rights reserved.
//

import UIKit

class NotesViewController: UIViewController {
    
    @IBOutlet weak var notesTableView: UITableView!
    let noteCell = "noteCell"
    let noteDetailSegue = "noteDetailSegue"
    var notes: [Note] = [] {
        didSet {
            notesTableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        notesTableView.dataSource = self
        notesTableView.delegate = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == noteDetailSegue {
            guard let noteDetailViewController = segue.destination as? NoteDetailViewController else {
                fatalError("Error parsing NoteDetailViewController")
            }
            let indexPath = notesTableView.indexPathForSelectedRow
            noteDetailViewController.noteDescription = notes[(indexPath?.row)!].description
        }
    }
    
    @IBAction func addNote(_ sender: UIBarButtonItem) {
        showAlertForAddNote()
    }
    
    func showAlertForAddNote() {
        let alert = UIAlertController(title: "Notes", message: "Add new Note", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default) { (alertAction) in
            let newNote = alert.textFields![0].text
            let count = self.notes.count
            self.notes.append(Note(id: count+1, description: newNote))
        }
        let cancelButton = UIAlertAction(title: "Cancel", style: .destructive)
        alert.addTextField { (textField) in
            textField.placeholder = "example: make good things"
        }
        alert.addAction(okButton)
        alert.addAction(cancelButton)
        self.present(alert, animated: true, completion: nil)
    }

}

extension NotesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: noteCell, for: indexPath)
        guard let noteCell = cell as? NoteTableViewCell else {
            fatalError("Errro parsing NoteTableViewCell")
        }
        noteCell.noteDescription.text = notes[indexPath.row].description
        return noteCell
    }
}

extension NotesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: noteDetailSegue, sender: nil)
    }
    
}

