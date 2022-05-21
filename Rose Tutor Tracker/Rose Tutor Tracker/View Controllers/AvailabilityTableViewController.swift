//
//  AvailabilityTableViewController.swift
//  Rose Tutor Tracker
//
//  Created by Elvis on 5/20/22.
//

import UIKit
import Firebase

class dateCell: UITableViewCell {
    
    @IBOutlet weak var weekDay: UILabel!
    @IBOutlet weak var workTogge: UISwitch!
    @IBOutlet weak var timePickView: UIStackView!
    @IBOutlet weak var startTimeTextFeild: UITextField!
    @IBOutlet weak var endTimeTextFeild: UITextField!

    
    
    @IBAction func update(_ sender: Any) {
        print(startTimeTextFeild.text!)
        print(endTimeTextFeild.text!)
        print(startTimeTextFeild.tag)
        let index = endTimeTextFeild.tag
        
        let wd = Day(rawValue: index)
        print(wd!.printDay())
        
        let start = startTimeTextFeild.text!.components(separatedBy: ":")
        let end = endTimeTextFeild.text!.components(separatedBy: ":")
        
        let newDay = TutorDate(working: true, startHour: Int(start[0])!,
                  startMin: Int(start[1])!, endHour: Int(end[0])!,
                  endMin: Int(end[1])!, day: wd!.printDay())
        
        UserDocumentManager.shared.currTutor?.days[index] = newDay
        UserDocumentManager.shared.updateTutor()
    }
}

class AvailabilityTableViewController: UITableViewController {
    let kCell = "dateCell"
    let datePicker = UIDatePicker()
//    var currTextField: UITextField?
    
    var userListener: ListenerRegistration?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startListeningForTutor()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        stopListeningForTutor()
        UserDocumentManager.shared.updateTutor()
    }
    
    func startListeningForTutor(){
        stopListeningForTutor()
        
        userListener = UserDocumentManager.shared.startListeningStudent(for: Auth.auth().currentUser!.uid) {
            //
        }
    }
    
    @IBAction func toggleSwitch(_ sender: Any) {
//        let s = sender as UISwitch
//        UserDocumentManager.shared.updateDay(s)
    }
    
    func stopListeningForTutor(){
        UserDocumentManager.shared.stopListening(userListener)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return UserDocumentManager.shared.currTutor!.days.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kCell, for: indexPath) as! dateCell
        
        let day = UserDocumentManager.shared.currTutor!.days[indexPath.row]
        print("\(day.day), working: \(day.working)")
        cell.weekDay.text = day.day
        
        cell.workTogge.setOn(day.working, animated: true)
        cell.workTogge.tag = indexPath.row
        
        cell.endTimeTextFeild.tag = indexPath.row
        cell.startTimeTextFeild.tag = indexPath.row
        
        cell.startTimeTextFeild.addTarget(self, action: #selector(createDatePicker), for: .editingDidBegin)
        
        cell.workTogge.addTarget(self, action: #selector(self.switchValueDidChange), for: .valueChanged)
        if day.working {
            cell.startTimeTextFeild.text = String(format: "%02d:%02d", day.startHour, day.startMin)
            cell.endTimeTextFeild.text = String(format: "%02d:%02d", day.endHour, day.endMin)
            
        }
        
        cell.selectionStyle = .none
        return cell
    }
    
    @objc func switchValueDidChange(sender:UISwitch!) {
        print(sender.isOn)
        UserDocumentManager.shared.updateDay(sender.tag)
        UserDocumentManager.shared.updateTutor()
        self.tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let day = UserDocumentManager.shared.currTutor!.days[indexPath.row]
        
        if day.working {
            return 165
        }
        
        return 50
    }
    
    @objc
    func createDatePicker(_ sender: UITextField) {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
//        currTextField = sender
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(done))
        toolbar.setItems([doneButton], animated: true)
        sender.inputAccessoryView = toolbar
        sender.inputView = datePicker
        datePicker.datePickerMode = .time
//        datePicker.datePickerStyle = .
    }
    
    @objc func done(_ sender: UITextField){
        print("pressed done")
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
//        formatter.timeZone =
//        sender.text = "\(datePicker.date)"
//        let hour = datePicker.
//        sender.text =
        print(formatter.string(from: datePicker.date))
        print(datePicker.date)
        self.view.endEditing(true)
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
}
