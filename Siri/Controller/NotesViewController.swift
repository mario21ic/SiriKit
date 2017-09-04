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
        addStoredDataToMemory()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == noteDetailSegue {
            guard let noteDetailViewController = segue.destination as? NoteDetailViewController else {
                fatalError("Error parsing NoteDetailViewController")
            }
            let indexPath = notesTableView.indexPathForSelectedRow
            noteDetailViewController.note = notes[(indexPath?.row)!]
        }
    }
    
    @IBAction func addNote(_ sender: UIBarButtonItem) {
        showAlertForAddNote()
    }
    
    func addStoredDataToMemory() {
        let storeNotes: [String: String] = NotesManager.sharedInstance.notes()
        for (_, item) in storeNotes.enumerated() {
            self.notes.append(Note(title: item.key, content: item.value, groupName: item.key))
        }
    }
    
    func showAlertForAddNote() {
        let alert = UIAlertController(title: "Notes", message: "Add new Note", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default) { (alertAction) in
            let titleNote = alert.textFields![0].text
            let contentNote = alert.textFields![1].text
            NotesManager.sharedInstance.add(note: contentNote!, toGroup: titleNote!)
            self.addStoredDataToMemory()
        }
        let cancelButton = UIAlertAction(title: "Cancel", style: .destructive)
        alert.addTextField { (textField) in
            textField.placeholder = "Title for your note"
        }
        alert.addTextField { (textField) in
                textField.placeholder = "content for your note"
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
        noteCell.title.text = notes[indexPath.row].title
        noteCell.content.text = notes[indexPath.row].content
        return noteCell
    }
}

extension NotesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: noteDetailSegue, sender: nil)
    }
    
}

