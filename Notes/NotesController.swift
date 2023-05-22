//
//  NotesController.swift
//  Notes
//
//  Created by Егор  Хлямов on 14.05.2023.
//

import UIKit

class NotesController: UIViewController{
    var folderId: Int16?
    var notes:[Note] = []
    let notesTable = UITableView()
    let identifireCell = "foldersTableCell"
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewWillAppear(_ animated: Bool) {
        self.setColors()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        notesTable.frame = view.bounds
        notesTable.register(UITableViewCell.self, forCellReuseIdentifier: identifireCell)
        notesTable.delegate = self
        notesTable.dataSource = self
        
        let addButton: UIBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "pencil.tip.crop.circle.badge.plus"), style: .done, target: self, action: #selector(self.buttonTouched))
        self.navigationItem.rightBarButtonItem = addButton
        self.navigationController?.navigationBar.tintColor = Resources.Colors.accent
        self.navigationItem.rightBarButtonItem?.tintColor = Resources.Colors.accent
        
        self.view.addSubview(notesTable)
        self.setColors()
    }
    
    func setColors(){
        if SettingsSingletone.shared.getTheme() == 0{
            view.overrideUserInterfaceStyle = .dark
            view.backgroundColor = .black
            self.navigationController?.navigationBar.barTintColor = .black
        }
        else{
            view.overrideUserInterfaceStyle = .light
            view.backgroundColor = .white
            self.navigationController?.navigationBar.barTintColor = .white
        }
    }

    private func configure(){
    }
    
    @objc private func buttonTouched() {
        let idNewNote = CoreDataManager.shared.createNote(folderId: folderId!)
        let vc = EditorController()
        vc.delegate = self
        vc.noteId = idNewNote
        
        self.navigationController?.pushViewController(vc, animated: true)
        

    }
}

extension NotesController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = EditorController()
        vc.noteId = notes[indexPath.row].id
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            CoreDataManager.shared.deleteNote(id: notes[indexPath.row].id)
            notes.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .top)
        }
    }
}

extension NotesController:  UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        notes = CoreDataManager.shared.fetchNotes(folderId: folderId!)
        return notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = notesTable.dequeueReusableCell(withIdentifier: identifireCell)
        
        let name = notes[indexPath.row].text.components(separatedBy: "\n")[0]
        cell?.textLabel?.text = name
        
        return cell!
    }


}
    



