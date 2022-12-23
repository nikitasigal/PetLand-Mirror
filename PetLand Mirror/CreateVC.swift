//
//  CreateVC.swift
//  PetLand Mirror
//
//  Created by Никита Сигал on 05.12.2022.
//

import UIKit

class CreateVC: UIViewController {
    static let identifier = "Create"
    
    @IBOutlet var tableView: UITableView!
    
    var imageCell: SelectImageCell!
    var nameCell: ValidatedTextFieldCell!
    var speciesCell: SelectAnimalCell!
    var breedCell: ValidatedTextFieldCell!
    var descriptionCell: DescriptionCell!
    
    var cells: [[UITableViewCell]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // dismiss keyboard on tap
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
        tableView.keyboardDismissMode = .onDrag
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.sectionHeaderHeight = UITableView.automaticDimension
        
        tableView.register(UINib(nibName: ValidatedTextFieldCell.identifier, bundle: nil), forCellReuseIdentifier: ValidatedTextFieldCell.identifier)
        
        cells = createCells()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if #available(iOS 13.0, *) {
            self.navigationController?.setNavigationBarHidden(true, animated: false)
            self.navigationController?.setNavigationBarHidden(false, animated: false)
        }
    }
}

extension CreateVC {
    func createCells() -> [[UITableViewCell]] {
        imageCell = tableView.dequeueReusableCell(withIdentifier: SelectImageCell.identifier) as? SelectImageCell
        
        nameCell = tableView.dequeueReusableCell(withIdentifier: ValidatedTextFieldCell.identifier) as? ValidatedTextFieldCell
        nameCell.configure(placeholder: "Name", type: .text)
        
        speciesCell = tableView.dequeueReusableCell(withIdentifier: SelectAnimalCell.identifier) as? SelectAnimalCell
        
        breedCell = tableView.dequeueReusableCell(withIdentifier: ValidatedTextFieldCell.identifier) as? ValidatedTextFieldCell
        breedCell.configure(placeholder: "Breed", type: .text)
        
        descriptionCell = tableView.dequeueReusableCell(withIdentifier: DescriptionCell.identifier) as? DescriptionCell
        descriptionCell.configure { [weak self] in
            self?.tableView.beginUpdates()
            self?.tableView.endUpdates()
        }
            
        return [[imageCell], [nameCell], [speciesCell, breedCell], [descriptionCell]]
    }
    
    @objc
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if tableView.frame.origin.y == 0 {
                tableView.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc
    func keyboardWillHide(notification: NSNotification) {
        if tableView.frame.origin.y != 0 {
            tableView.frame.origin.y = 0
        }
    }
}

extension CreateVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        4
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        ["Image", "General", "Species", "Description"][section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cells[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cells[indexPath.section][indexPath.row]
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
