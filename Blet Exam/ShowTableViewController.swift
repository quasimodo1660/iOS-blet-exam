//
//  ViewController.swift
//  Blet Exam
//
//  Created by Peisure on 1/25/18.
//  Copyright © 2018 Ben. All rights reserved.
//

import UIKit
import CoreData

class ShowTableViewController: UITableViewController, AddViewDelegate, cellDelegate{
    
    
    
    

    
    
    let manageDatabase = (UIApplication.shared.delegate as!
        AppDelegate).persistentContainer.viewContext
    
    
    var com = [Todolist]()
    var incom = [Todolist]()
    
    //****************  Display table **********************************
    var sectionTitle = ["Incomplete","Complete"]
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitle.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitle[section]
    }

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return incom.count
        }
        else{
            return com.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ICell") as! ICell
            cell.displayTitle.text = incom[indexPath.row].title
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            let myTime = incom[indexPath.row].beginDate
            cell.displayTime.text = formatter.string(from: myTime!)
            cell.delegate = self
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "CCell") as! CCell
            cell.displayTitle.text = com[indexPath.row].title
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            let myTime = com[indexPath.row].beginDate
            cell.displayTime.text = formatter.string(from: myTime!)
            return cell
        }
    }
    
    
    //***************** add, edit data  *********************************
    
    func addItem(_ controller: AddItemViewController, with toDoTitle: String, _ content: String, and beginTime: Date, by sender: UIButton, at indexPath: NSIndexPath?) {
        if sender.tag == 0 {
            self.navigationController?.popViewController(animated: true)
            dismiss(animated: true, completion: nil)
        }
        else{
            if let ip = indexPath{
                let item = incom[ip.row]
                item.title = toDoTitle
                item.content = content
                item.beginDate = beginTime
                item.finish = false
            }
            else{
                let item = NSEntityDescription.insertNewObject(forEntityName: "Todolist", into: manageDatabase) as! Todolist
                item.title = toDoTitle
                item.content = content
                item.beginDate = beginTime
                item.finish = false
                incom.append(item)
            }
            
            do{
                try manageDatabase.save()
            }
            catch{
                print("\(error)")
            }
            self.navigationController?.popViewController(animated: true)
            dismiss(animated: true, completion: nil)
            fetchAllItems()
            tableView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addItem"{
            let target = segue.destination as! AddItemViewController
            target.delegate = self
        }
        else if segue.identifier == "edit"{
            let target = segue.destination as! AddItemViewController
            target.delegate = self
            if let indexPath = (sender as? NSIndexPath){
                target.item = incom[indexPath.row]
                target.indexPath = indexPath
            }
        }
       
    }
    
    //********************  TableView Stuff   ********************************

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchAllItems()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //*********************  Database stuff   **********************************
    func fetchAllItems(){
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Todolist")
        request.predicate = NSPredicate(format: "finish == %@", NSNumber(value: true))
        do{
            let result = try manageDatabase.fetch(request)
            com = result as! [Todolist]
        }
        catch{
            print("\(error)")
        }
        request.predicate = NSPredicate(format: "finish == %@", NSNumber(value: false))
        do{
            let result = try manageDatabase.fetch(request)
            incom = result as! [Todolist]
        }
        catch{
            print("\(error)")
        }
    }
    //********************** Row selected stuff  ***********************************
    func editRow(_ sender: ICell) {
        print("here")
        let indexPath = tableView.indexPath(for: sender)! as NSIndexPath
        performSegue(withIdentifier: "edit", sender: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var item:Todolist?
        if indexPath.section == 0{
            item = incom[indexPath.row]
        }
        else{
            item = com[indexPath.row]
        }
        if item?.finish == false{
            item?.finish = true
        }
        else{
            item?.finish = false
        }
        do{
            try manageDatabase.save()
        }
        catch{
            print("\(error)")
        }
        fetchAllItems()
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        <#code#>
    }
    
    
    
    
    
    
}

class CCell:UITableViewCell{
    @IBOutlet weak var displayTitle: UILabel!
    @IBOutlet weak var displayTime: UILabel!
}


class ICell:UITableViewCell{
    @IBOutlet weak var displayTime: UILabel!
    @IBOutlet weak var displayTitle: UILabel!
    weak var delegate:cellDelegate?
    
    @IBAction func editButtonPressed(_ sender: UIButton) {
        delegate?.editRow(self)
    }
    
}

protocol cellDelegate:class {
   func editRow(_ sender:ICell)
}








