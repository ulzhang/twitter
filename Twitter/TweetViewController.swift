//
//  TweetViewController.swift
//  
//
//  Created by Kevin Zhang on 3/3/19.
//

import UIKit

class TweetViewController: UIViewController {

    
    @IBOutlet weak var tweetTextView: UITextView!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // pop up text box
        tweetTextView.becomeFirstResponder()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    @IBAction func tweet(_ sender: Any) {
        
        if (!tweetTextView.text.isEmpty) {
            TwitterAPICaller.client?.postTweet(tweetString: tweetTextView.text, success: {
                print("\(self.tweetTextView.text ?? "success")")
                self.dismiss(animated: true, completion: nil)
            }, failure: { (Error) in
                // PASS THE ERROR OBJECT INTO STRING
                print("error posting tweeet \(Error)")
                self.dismiss(animated: true, completion: nil)
            })
        } else {
            // if text IS empty
            self.dismiss(animated: true, completion: nil)
            print("empty string")
        }
        
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
