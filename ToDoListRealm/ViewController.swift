//
//  ViewController.swift
//  ToDoListRealm
//
//  Created by STC on 20/10/23.
//

import UIKit
import RealmSwift
class contact : Object{
    @Persisted var fistname: String
    @Persisted var lastname : String
   convenience init(fistname: String, lastname: String) {
       self.init()
        self.fistname = fistname
        self.lastname = lastname
    }
}



class ViewController: UIViewController {
    
    
    @IBOutlet weak var contactTableView: UITableView!
    
    var ContactArray = [contact]()
    override func viewDidLoad() {
        super.viewDidLoad()
        configration()
        // Do any additional setup after loading the view.
    }


    
    @IBAction func AddButton(_ sender: Any) {
        contactConfigration(isadd: true, index: 0)
        //        let alert = UIAlertController(title: "Add Contact", message: "Please Enter Contact Details", preferredStyle: .alert)
        //
        //        let save = UIAlertAction(title: "Save", style: .default){_ in
        //            if let firstName = alert.textFields?.first?.text,
        //               let lastName = alert.textFields?[1].text{
        //                let contact1 = contact(fistname: firstName, lastname: lastName)
        //                    self.ContactArray.append(contact1)
        //                self.contactTableView.reloadData()
        //
        //            }
        //        }
        //        let cance = UIAlertAction(title: "Cancel", style: .cancel,handler: nil)
        //
        //        alert.addTextField{ firstNameTextfield in
        //            firstNameTextfield.placeholder = "Enter First Name"
        //
        //        }
        //        alert.addTextField{ LastNameTextfield in
        //            LastNameTextfield.placeholder = "Enter Last Name"
        //
        //        }
        //                alert.addAction(save)
        //        alert.addAction(cance)
        //
        //        present(alert, animated: true)
        //        print("Add Button Click")
        //    }
    }
    
}
extension ViewController{
    func configration(){
        contactTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        ContactArray = databaseHelper.shared.getContact()
    }
    func contactConfigration(isadd: Bool,index : Int){
        let alert = UIAlertController(title: isadd ? "Add Contact":"Update Contact" , message: isadd ? "Please Enter Contact Details" : "Please Update Contact Details", preferredStyle: .alert)
      
        let save = UIAlertAction(title: "Save", style: .default){_ in
            if let firstName = alert.textFields?.first?.text,
               let lastName = alert.textFields?[1].text{
                let contact1 = contact(fistname: firstName, lastname: lastName)
                if isadd{
                    self.ContactArray.append(contact1)
                    databaseHelper.shared.saveContact(contact11: contact1)
                }else{
                    databaseHelper.shared.updateContact(oldContact: self.ContactArray[index], NewContact: contact1)
                }
                self.contactTableView.reloadData()
                
            }
        }
        let cance = UIAlertAction(title: "Cancel", style: .cancel,handler: nil)
        
        alert.addTextField{ firstNameTextfield in
//            if isadd{
//                firstNameTextfield.placeholder = "Enter First Name"
//            }else{
//                firstNameTextfield.placeholder = self.ContactArray[index].fistname
//            }
            firstNameTextfield.placeholder = isadd ? "Enter First Name" : self.ContactArray[index].fistname
   
            
        }
        alert.addTextField{ LastNameTextfield in
            if isadd{
                LastNameTextfield.placeholder = "Enter last Name"
            }else{
                LastNameTextfield.placeholder = self.ContactArray[index].lastname
            }
        
        }
                alert.addAction(save)
        alert.addAction(cance)
        
        present(alert, animated: true)
        print("Add Button Click")
    }
}
extension ViewController : UITableViewDataSource{


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return ContactArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard var cell = contactTableView.dequeueReusableCell(withIdentifier: "cell") else{
            return UITableViewCell()
        }
        cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        cell.textLabel?.text = ContactArray[indexPath.row].fistname
        cell.detailTextLabel?.text = ContactArray[indexPath.row].lastname
        return cell
    }


}

extension ViewController : UITableViewDelegate{
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let edit = UIContextualAction(style: .normal, title: "EDIT") { _, _, _ in
            self.contactConfigration(isadd: false, index: indexPath.row)
//            let alert = UIAlertController(title: "UPDATE Contact", message: "Please UPDATE Contact Details", preferredStyle: .alert)
//
//            let save = UIAlertAction(title: "Save", style: .default){_ in
//                if let firstName = alert.textFields?.first?.text,
//                   let lastName = alert.textFields?[1].text{
//                    let contact1 = contact(fistname: firstName, lastname: lastName)
//                       // self.ContactArray.append(contact1)
//                    self.ContactArray[indexPath.row] = contact1
//                    self.contactTableView.reloadData()
//
//                }
//            }
//            let cance = UIAlertAction(title: "Cancel", style: .cancel,handler: nil)
//
//            alert.addTextField{ firstNameTextfield in
//                firstNameTextfield.placeholder = self.ContactArray[indexPath.row].fistname
//
//            }
//            alert.addTextField{ LastNameTextfield in
//                LastNameTextfield.placeholder = self.ContactArray[indexPath.row].lastname
//
//            }
//                    alert.addAction(save)
//            alert.addAction(cance)
//
//            self.present(alert, animated: true)
//            print("Add Button Click")
        }
        
        
        let Delete = UIContextualAction(style: .destructive, title: "DELETE") { _, _, _ in
            
            databaseHelper.shared.deleteContact(contact2:self.ContactArray[indexPath.row])
            self.ContactArray.remove(at: indexPath.row)
                self.contactTableView.reloadData()
        }
        Delete.backgroundColor = .systemMint
        let SwipeConfigration = UISwipeActionsConfiguration(actions: [edit,Delete])
        return SwipeConfigration
    }
    
}
