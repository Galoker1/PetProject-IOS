//
//  EditorController.swift
//  Notes
//
//  Created by Егор  Хлямов on 17.05.2023.
//

import UIKit

class EditorController: UIViewController{
    let textField = UITextView()
    weak var delegate: NotesController!
    var noteId: Int16?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(textField)
        textField.text = CoreDataManager.shared.fetchNote(id: noteId ?? 0)?.text
        configure()
        self.setColors()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateKeyboard(notification:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateKeyboard(notification:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    @objc func updateKeyboard(notification: Notification){
        guard let userInfo = notification.userInfo as? [String: Any],
              let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {return}
        
        if notification.name == UIResponder.keyboardWillHideNotification{
            textField.frame = view.bounds
        }
        if notification.name == UIResponder.keyboardWillShowNotification{
            textField.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardFrame.height, right: 0)
            textField.scrollIndicatorInsets = textField.contentInset
        }
        textField.scrollRangeToVisible(textField.selectedRange)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
        textField.resignFirstResponder()
    }
    
    func setColors(){
        if SettingsSingletone.shared.getTheme() == 0{
            view.overrideUserInterfaceStyle = .dark
            textField.backgroundColor = .black
            self.navigationController?.navigationBar.barTintColor = .black
        }
        else{
            view.overrideUserInterfaceStyle = .light
            textField.backgroundColor = .white
            self.navigationController?.navigationBar.barTintColor = .white
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setColors()
        textField.font = UIFont.systemFont(ofSize: CGFloat(SettingsSingletone.shared.getFontSize()))
    }
    override func viewWillDisappear(_ animated: Bool) {
        CoreDataManager.shared.updateNote(id: noteId ?? 0, text: self.textField.text)
        self.delegate.notesTable.reloadData()
    }
    func configure(){
        textField.frame = view.bounds
        textField.backgroundColor = .white
        self.navigationController?.navigationBar.tintColor = Resources.Colors.accent
        textField.font = UIFont.systemFont(ofSize: CGFloat(SettingsSingletone.shared.getFontSize()))
    }
}


