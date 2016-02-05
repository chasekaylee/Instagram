//
//  PhotosDetailViewController.swift
//  Instagram
//
//  Created by Chase Lee on 2/4/16.
//  Copyright © 2016 Chase Lee. All rights reserved.
//

import UIKit

class PhotosDetailViewController: UIViewController {
    
    var imageUrl: NSURL!

    @IBOutlet weak var photoView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        photoView.setImageWithURL(imageUrl)

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
