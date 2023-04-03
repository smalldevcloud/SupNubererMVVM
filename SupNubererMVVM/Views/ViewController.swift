//
//  ViewController.swift
//  SupNubererMVVM
//
//  Created by cloud8 on 31.03.23.
//

import UIKit

class ViewController: UIViewController {
    
    var viewModel = ViewModel()

    @IBOutlet weak var inputTF: UITextField!
    
    @IBOutlet weak var nameTF: UITextField!
    
    @IBOutlet weak var resultTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        bindViewModel()
    }

    @IBAction func convertPressed(_ sender: Any) {
        
        viewModel.convertBtnPressed(number: inputTF.text ?? "", name: nameTF.text ?? "")
    }
    func bindViewModel() {
            
            viewModel.whatsThat.bind({ (resultNumber) in
            
                DispatchQueue.main.async {
                    self.resultTF.text = resultNumber
                }
                
            })
            
        }
    
}

