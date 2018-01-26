//
//  AddItemViewController.swift
//  Blet Exam
//
//  Created by Peisure on 1/26/18.
//  Copyright © 2018 Ben. All rights reserved.
//

import UIKit

class AddItemViewController: UIViewController {

    @IBOutlet weak var titleLabel: UITextField!
    @IBOutlet weak var contentLabel: UITextView!
    @IBOutlet weak var timePick: UIDatePicker!
    
    
    weak var delegate:AddViewDelegate?
    var indexPath:NSIndexPath?
    var item:Todolist?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = item?.title
        contentLabel.text = item?.content

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func buttonPressed(_ sender: UIButton) {
        delegate?.addItem(self, with: titleLabel.text!, contentLabel.text, and: timePick.date, by: sender, at: indexPath)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


protocol AddViewDelegate:class {
    func addItem(_ controller:AddItemViewController, with toDoTitle:String,_ content:String,and beginTime:Date, by sender: UIButton, at indexPath:NSIndexPath?)
}
