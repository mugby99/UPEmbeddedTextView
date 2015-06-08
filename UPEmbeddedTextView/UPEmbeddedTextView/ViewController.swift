//
//  ViewController.swift
//  UPEmbeddedTextView
//
//  Created by Martin Uribe on 4/5/15.
//  Copyright (c) 2015 up. All rights reserved.
//  
//  Disclaimer:
//  TEST VIEW CONTROLLER: Ideally, this view controller represents a common view
//  controller used by anyone who attempts to use this library. It is not and should not
//  however, be (a required) part of the library if possible.
//

import UIKit

// EPIC: Try to reduce the amount of preparation the client requires in order to begin
// using the TextView API. For example the Keyboard delegation, the current properties
// being used by this controller, the cell's height calculation and the delegate methods
// of UITextView. We should focus in making the life easier for those using our library,
// not making them spend 4 hours trying to understand how to set up everything!

class ViewController: UIViewController, UITableViewDataSource, UITextViewDelegate {

    // TODO: How to avoid client requiring all these properties??
    var previousTextViewRect: CGSize!
    @IBOutlet weak var widthConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    var testText: NSString = "Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda."
    
    var testText2: NSString = "Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda."
    
    var testText3: NSString = "Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda."
    var testTexts: NSMutableArray!
    var tableViewManager: UPManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.previousTextViewRect = CGSizeZero
        self.testTexts = [testText, testText2, testText3]
        self.tableViewManager = UPManager(delegate:self, tableView: self.tableView)
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self)
        super.viewWillDisappear(animated)
    }
    
    func keyboardWillShow(notification: NSNotification)
    {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            
            var contentInsets = self.tableView.contentInset
            contentInsets = UIEdgeInsets(top: contentInsets.top, left: contentInsets.left, bottom: keyboardSize.height + UIApplication.sharedApplication().statusBarFrame.size.height, right: contentInsets.right)
            
            if keyboardSize.height > 0
            {
                self.tableView.contentInset = contentInsets
                self.tableView.scrollIndicatorInsets = contentInsets
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification)
    {
        var contentInsets = self.tableView.contentInset
        contentInsets = UIEdgeInsets(top: contentInsets.top, left: contentInsets.left, bottom: 0, right: contentInsets.right)
        self.tableView.contentInset = contentInsets
        self.tableView.scrollIndicatorInsets = contentInsets
    }
    
    // MARK: - UITableViewDataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {

        if indexPath.section == 0 && (indexPath.row == 0 || indexPath.row == 1 || indexPath.row == 2) {
            
            return self.tableViewManager.heightForRowAtIndexPath(indexPath, reuseIdentifier: "testCell", textForTextView:{ (textView, indexPath) -> String in
                
                if let testText = self.testTexts[indexPath.row] as? String{
                    return testText
                }
                return ""
            })
        }
        
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        if let cell = tableView.dequeueReusableCellWithIdentifier("testCell", forIndexPath: indexPath) as? TestCellTableViewCell{
            cell.textView.delegate = self.tableViewManager
            
            if let testText = self.testTexts[indexPath.row] as? String{
                cell.textView.text = testText
            }
            cell.textView.tag = indexPath.row
            
            return cell
        }
        let cell = UITableViewCell()
        return cell
    }
    
    // MARK: - UITextViewDelegate
    
    func textViewDidChange(textView: UITextView) {
        if let cell = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: textView.tag, inSection: 0)) as? TestCellTableViewCell{
            if cell.textView == textView{
                self.testTexts[textView.tag] = cell.textView.text
            }
        }
    }
}

