//
//  FoldersController.swift
//  Notes
//
//  Created by Егор  Хлямов on 14.05.2023.
//

import UIKit

class FoldersController: UIViewController{
    
    let foldersTable = UITableView()
    let identifireCell = "foldersTableCell"
    var folders:[Folder] = []
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
        
        let addButton: UIBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "folder.badge.plus"), style: .done, target: self, action: #selector(self.buttonTouched))
        
        self.navigationItem.rightBarButtonItem = addButton
        folders = CoreDataManager.shared.fetchFolders()
        foldersTable.frame = view.bounds
        foldersTable.register(UITableViewCell.self, forCellReuseIdentifier: identifireCell)
        
        foldersTable.delegate = self
        foldersTable.dataSource = self
        self.navigationItem.rightBarButtonItem?.tintColor = Resources.Colors.accent
        
        self.view.addSubview(foldersTable)
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
        let alert = UIAlertController(title: "Add Folder", message: "Enter a name", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.text = ""
        }
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            guard let textField = alert?.textFields![0] else {return}
            if textField.text != ""{
                CoreDataManager.shared.createFolder(name: textField.text ?? "NewFolder")
                self.folders = CoreDataManager.shared.fetchFolders()
                self.foldersTable.reloadData()
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    
}

extension FoldersController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let folderId = folders[indexPath.row].id
        let vc = NotesController()
        vc.folderId = folderId
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            CoreDataManager.shared.deleteFolder(id: folders[indexPath.row].id)
            CoreDataManager.shared.deleteNotesByFolder(id: folders[indexPath.row].id)
            folders.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .top)
        }
    }
}

extension FoldersController:  UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return folders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = foldersTable.dequeueReusableCell(withIdentifier: identifireCell)
        cell?.textLabel?.text = folders[indexPath.row].name
        
        return cell!
    }

    
    
}

