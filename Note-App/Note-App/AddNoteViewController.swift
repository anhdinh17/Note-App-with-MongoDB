//
//  AddNoteViewController.swift
//  Note-App
//
//  Created by Anh Dinh on 2/5/21.
//

import UIKit

class AddNoteViewController: UIViewController {
    
    var note: Note?
    
    // set a flag to check if we want a update or add a new note
    var update = false
    
    @IBOutlet weak var titleTextField: UITextField!
    
    @IBOutlet weak var bodyTextView: UITextView!
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    @IBOutlet weak var deleteButton: UIBarButtonItem!
    
    @IBAction func deleteClick(_ sender: Any) {
        APIFunctions.functions.deleteNote(id: note!._id)
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func saveClick(_ sender: UIBarButtonItem) {
        
        // get the date when clicking on Save button
        let dateForamtter = DateFormatter()
        dateForamtter.dateFormat = "yyyy-MM-dd" //the format we want
        
        // get a String from date, now we have date as String to put it into func
        let date = dateForamtter.string(from: Date())
        
        
        if update == true{
            APIFunctions.functions.updateNote(date: date, title: titleTextField.text!, note: bodyTextView.text, id: note!._id)
            
            // go back to first screen
            self.navigationController?.popViewController(animated: true)
        }else if bodyTextView.text != "" && titleTextField.text != ""{
            // this else if is to make sure that we don't add an empty note to server
            APIFunctions.functions.addNote(date: date,title: titleTextField.text!, note: bodyTextView.text)
            
            // go back to first screen
            self.navigationController?.popViewController(animated: true)
        }
        
        
        
    }
    
    // This is when we click on Add Note, we don't want to see Delete Button
    override func viewWillAppear(_ animated: Bool) {
        if update == false{
            self.deleteButton.isEnabled = false
            self.deleteButton.title = ""
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if update == true {
            titleTextField.text = note?.title
            bodyTextView.text = note?.note
        }
        
    }
    
    
    
}
