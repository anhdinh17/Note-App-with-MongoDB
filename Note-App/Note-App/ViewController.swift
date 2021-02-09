//
//  ViewController.swift
//  Note-App
//
//  Created by Anh Dinh on 1/26/21.
//

import UIKit


protocol DataDelegate {
    func updateArray(newArray: String)
}



class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {


    var notesArray = [Note]()
    
    // because we use Table View
    @IBOutlet weak var notesTableView: UITableView!
    
    // viewWillAppear and viewDidAppear are to reload the data when we hit the Save button
    // The reason is viewDidLoad only runs once when we start the app so we need these 2 to fetch data again
    override func viewWillAppear(_ animated: Bool) {
        APIFunctions.functions.fetchNotes()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        APIFunctions.functions.fetchNotes()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        notesTableView.delegate = self
        notesTableView.dataSource = self
        
        // Using Singleton that we created in APIFunctions
        APIFunctions.functions.delegate = self
        APIFunctions.functions.fetchNotes()
        
    }

//MARK: - TableView Delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notesArray.count
    }
//MARK: - TableView DataSource
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "prototypeCell", for: indexPath) as! NotePrototypeCell
        
        cell.title.text = notesArray[indexPath.row].title
        cell.note.text = notesArray[indexPath.row].note
        cell.date.text = notesArray[indexPath.row].date
        
        return cell
    }
    
//MARK: - Prepare Segue way
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let vc = segue.destination as! AddNoteViewController
        
        if segue.identifier == "updateNoteSegue"{
            // notesTableView.indexPathForSelectedRow!.row is the row that we click on
            vc.note = notesArray[notesTableView.indexPathForSelectedRow!.row]
            vc.update = true
        }
    }
    
    
}

//MARK: - Prototype Function
extension ViewController: DataDelegate {
    
    func updateArray(newArray: String) {
        do{
            notesArray = try JSONDecoder().decode([Note].self, from: newArray.data(using: .utf8)!)
            
            print(notesArray)
        }catch{
            print("Failed to decode: \(error)")
        }
        
        notesTableView.reloadData()
    }
    
    
    
}
