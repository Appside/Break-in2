//
//  HomeViewController.swift
//  Break in2
//
//  Created by Jonathan Crawford on 08/11/2015.
//  Copyright © 2015 Appside. All rights reserved.
//

import UIKit
import QuartzCore

class HomeViewController: UIViewController {

    //Declare all objects
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var buttonBack: UIImageView!
    @IBOutlet weak var buttonIB: UIButton!
    @IBOutlet weak var buttonTrading: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addHomeBG() //add BG image
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
