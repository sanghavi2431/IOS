//
//  ContactListVC.swift
//  Woloo
//
//  Created on 27/04/21.
//

import UIKit
import ContactsUI
//NOT USED
class ContactListVC: UIViewController {
    var allContacts = [CNContact]()
    var selectedContacts = [CNContact]()
    var searchedContacts = [CNContact]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchContacts()
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func backBtnPressed(_ sender: UIButton) {
        
        
        self.navigationController?.popViewController(animated: true)
        
    }
    private func fetchContacts() {
        // 1.
        let store = CNContactStore()
        store.requestAccess(for: .contacts) { (granted, error) in
            if let error = error {
                print("failed to request access", error)
                return
            }
            if granted {
                // 2.
                let keys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey]
                let request = CNContactFetchRequest(keysToFetch: keys as [CNKeyDescriptor])
                do {
                    // 3.
                    try store.enumerateContacts(with: request, usingBlock: { (contact, stopPointer) in
                        //self.contacts.append(contact)
                    })
                } catch let error {
                    print("Failed to enumerate contact", error)
                }
            } else {
                print("access denied")
            }
        }
    }
    func searchContact(searchString: String) -> [CNContact] {

            //Fetch
            let contactStore: CNContactStore = CNContactStore()
            var contacts: [CNContact] = [CNContact]()
            let fetchRequest: CNContactFetchRequest = CNContactFetchRequest(keysToFetch: [CNContactVCardSerialization.descriptorForRequiredKeys()])

            do {
                try contactStore.enumerateContacts(with: fetchRequest, usingBlock: {
                    contact, _ in
                    contacts.append(contact) })

            } catch {
                print("Get contacts \(error)")
            }

            //Search
             var resultArray: [CNContact] = [CNContact]()

            for item in contacts {

                for email in item.emailAddresses {
                    if email.value.contains(searchString) {
                        resultArray.append(item)
                    }
                }
            }

            let withoutDuplicates: [CNContact] = [CNContact](Set(resultArray))
            return withoutDuplicates

    }

}
