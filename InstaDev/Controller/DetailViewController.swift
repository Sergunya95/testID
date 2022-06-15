//
//  DetailViewController.swift
//  InstaDev
//
//  Created by apple on 15.06.2022.
//

import UIKit

class DetailViewController: UIViewController {

    
    @IBOutlet weak var imageLabel: UILabel?
    
    var detail: HotelInfo?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imageLabel?.text = detail?.image
    }
}
