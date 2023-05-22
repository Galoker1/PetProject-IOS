//
//  SettingsViewController.swift
//  Notes
//
//  Created by Егор  Хлямов on 20.05.2023.
//

import UIKit

class SettingsViewController: UIViewController {
    let button = UIButton()
    let themeLabel = UILabel()
    let themeControl = UISegmentedControl(items: ["Dark","Light"])
    let fontSizeLabel = UILabel()
    let fontSizeControl = UIStepper()
    let fontSizeValueLabel = UILabel()
    
    weak var delegate: FoldersController!
    override func viewDidLoad() {
        print(SettingsSingletone.shared.getTheme())
        super.viewDidLoad()
        
        self.view.addSubview(themeLabel)
        confiigureThemeLabel(label: themeLabel)
        
        self.view.addSubview(themeControl)
        confiigureThemeControl(control: themeControl)
        
        self.view.addSubview(fontSizeLabel)
        confiigureFontSizeLabel(label: fontSizeLabel)
        
        self.view.addSubview(fontSizeControl)
        confiigureFontSizeControl(control: fontSizeControl)
        
        self.view.addSubview(button)
        confiigureDeleteButton(button: button)
        
        self.view.addSubview(fontSizeValueLabel)
        confiigureFontSizeValueLabel(label: fontSizeValueLabel)
        
        self.configure()
        self.setColors()
        // Do any additional setup after loading the view.
    }
    
    func configure(){
        
        
    }
    func setColors(){
        if SettingsSingletone.shared.getTheme() == 0{
            view.overrideUserInterfaceStyle = .dark
            view.backgroundColor = .black
        }
        else{
            view.overrideUserInterfaceStyle = .light
            view.backgroundColor = .white
        }
    }
    func confiigureDeleteButton(button: UIButton){
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .lightGray
        button.setTitle("Delete All Data", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: self.fontSizeControl.bottomAnchor, constant: 100),
            button.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            button.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
        ]
        )
    }
    
    func confiigureThemeLabel(label: UILabel){
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Theme"
        label.font = UIFont.systemFont(ofSize: 25, weight: .medium)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            label.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            label.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
        ]
        )
    }
    
    func confiigureThemeControl(control: UISegmentedControl){
        control.selectedSegmentIndex = SettingsSingletone.shared.getTheme()
        control.translatesAutoresizingMaskIntoConstraints = false
        control.addTarget(self, action: #selector(selectedValue), for: .valueChanged)
        NSLayoutConstraint.activate([
            control.topAnchor.constraint(equalTo: self.themeLabel.bottomAnchor , constant: 10),
            control.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            control.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
        ]
        )
    }
    
    func confiigureFontSizeLabel(label: UILabel){
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Editor Font Size"
        label.font = UIFont.systemFont(ofSize: 25, weight: .medium)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: self.themeControl.bottomAnchor, constant: 30),
            label.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            label.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
        ]
        )
    }
    
    func confiigureFontSizeControl(control: UIStepper){
        control.translatesAutoresizingMaskIntoConstraints = false
        control.value = Double(SettingsSingletone.shared.getFontSize())
        control.stepValue = 1.0
        control.addTarget(self, action: #selector(sizeControlClicked), for: .valueChanged)
        NSLayoutConstraint.activate([
            control.topAnchor.constraint(equalTo: self.fontSizeLabel.bottomAnchor , constant: 10),
            control.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            control.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
           
        ]
        )
    }
    func confiigureFontSizeValueLabel(label: UILabel){
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text =  String(SettingsSingletone.shared.getFontSize()) + "pt"
        label.font = UIFont.systemFont(ofSize: 25, weight: .medium)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: self.fontSizeLabel.bottomAnchor, constant: 8),
            label.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
        ]
        )
    }
    
    @objc func selectedValue(target: UISegmentedControl){
            
        SettingsSingletone.shared.setTheme(theme: target.selectedSegmentIndex)
        setColors()
    }
    @objc func sizeControlClicked(target: UIStepper){
        SettingsSingletone.shared.setFontSize(size: Int(target.value))
        fontSizeValueLabel.text = String(SettingsSingletone.shared.getFontSize()) + "pt"
    }
    @objc func buttonAction(sender: UIButton!) {
        CoreDataManager.shared.deleteAllFolders()
        CoreDataManager.shared.deleteAllNotes()
        delegate.foldersTable.reloadData()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
