//
//  EntryViewController.swift
//  MyToDoList
//
//  Created by Afraz Siddiqui on 4/28/20.
//  Copyright © 2020 ASN GROUP LLC. All rights reserved.
//

import RealmSwift
import UIKit
import MapKit

class EntryViewController: UIViewController, UITextFieldDelegate, UIGestureRecognizerDelegate {

    @IBOutlet var textField: UITextField!
    @IBOutlet var datePicker: UIDatePicker!
    
    

    private let realm = try! Realm()
    public var completionHandler: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()

        textField.becomeFirstResponder()
        textField.delegate = self
        datePicker.setDate(Date(), animated: true)
    }
    
    

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    @objc func didTapSaveButton() {
        if let text = textField.text, !text.isEmpty {
            let date = datePicker.date
            
            realm.beginWrite()
            let newItem = ToDoListItem()
            newItem.date = date
            newItem.item = text
            realm.add(newItem)
            try! realm.commitWrite()

            completionHandler?()
            navigationController?.popToRootViewController(animated: true)
            
            // IMPORTANT: make reminder
            let center = UNUserNotificationCenter.current()
            let content = UNMutableNotificationContent()
            content.title = text
            content.body = text
            content.sound = .default
            
            let earlyDate = Calendar.current.date( byAdding: .minute, value: -30, to: datePicker.date)
            let comps = Calendar.current.dateComponents([.year, .month, .day, .hour,.minute], from: earlyDate!)
            let trigger = UNCalendarNotificationTrigger(dateMatching: comps, repeats: false)
            print("TRIGGER")
            print(trigger.nextTriggerDate())
            
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            center.add(request)
            
        }
        else {
            print("Add something")
        }
    }


}
