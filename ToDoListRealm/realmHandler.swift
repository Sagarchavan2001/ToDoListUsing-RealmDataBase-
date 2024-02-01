//
//  realmHandler.swift
//  ToDoListRealm
//
//  Created by STC on 21/10/23.
//

import UIKit
import RealmSwift
class databaseHelper{
    static let shared =  databaseHelper()
    private var realm = try! Realm()
    func getDataUrl()-> URL?{
        return Realm.Configuration.defaultConfiguration.fileURL
    }
    func saveContact(contact11 : contact){
        try! realm.write{
            realm.add(contact11)
        }
        
    }
    
    func getContact() -> [contact]{
        return Array(realm.objects(contact.self))
    }
    func deleteContact(contact2 : contact){
        try! realm.write{
            realm.delete(contact2)
        }
    }
    func updateContact(oldContact : contact, NewContact : contact){
        try! realm.write{
            oldContact.fistname = NewContact.fistname
            oldContact.lastname = NewContact.lastname
        }
        
    }
}
