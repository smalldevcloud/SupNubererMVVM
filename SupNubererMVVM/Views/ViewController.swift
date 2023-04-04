//
//  ViewController.swift
//  SupNubererMVVM
//
//  Created by cloud8 on 31.03.23.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var viewModel = ViewModel()

    @IBOutlet weak var inputTF: UITextField!
    
    @IBOutlet weak var nameTF: UITextField!
    
    @IBOutlet weak var resultTF: UITextField!
    
    @IBOutlet weak var clientsTV: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        let pasteboardString: String? = UIPasteboard.general.string
        if let theString = pasteboardString {
            inputTF.text = theString }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.hideKeyboardWhenTappedAround() 
        bindViewModel()
        clientsTV.dataSource = self
        viewModel.coreDataVM.fetchClients()
        clientsTV.reloadData()
    }

    @IBAction func convertPressed(_ sender: Any) {
        
        viewModel.convertBtnPressed(number: inputTF.text ?? "", name: nameTF.text ?? "")
        viewModel.coreDataVM.fetchClients()
        clientsTV.reloadData()
    }
    func bindViewModel() {
            
            viewModel.dynamic.bind({ (resultNumber) in
            
                DispatchQueue.main.async {
                    self.resultTF.text = resultNumber
                    self.clientsTV.reloadData()
                }
                
            })
            
        }
    
    
    @IBAction func sendPressed(_ sender: Any) {
        
        viewModel.sendToTelegram()
    }
    
    
    @IBAction func clearPressed(_ sender: Any) {
        viewModel.coreDataVM.clearDatabase()
        viewModel.coreDataVM.fetchClients()
        clientsTV.reloadData()    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        print("there must be \(viewModel.coreDataVM.savedEntities.count) cells")
        return viewModel.coreDataVM.savedEntities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let nib = UINib(nibName: "ClientTVCell", bundle: nil)
        clientsTV.register(nib, forCellReuseIdentifier: "clientsTVCell")
        
        
        let client = viewModel.coreDataVM.savedEntities[indexPath.row]
        
        let cell = clientsTV.dequeueReusableCell(withIdentifier: ClientTVCell.identifier, for: indexPath) as! ClientTVCell

        cell.clientName.text = client.value(forKeyPath: "name") as? String
        cell.clientNumber.text = client.value(forKeyPath: "number") as? String
        
        cell.callButtonHandler = { [self] in
            
            UIPasteboard.general.string = client.value(forKeyPath: "number") as! String
            callNumber(phoneNumber: client.value(forKeyPath: "number") as! String)
            
        }

        cell.backgroundColor = .systemFill
        
        return cell
    }
    
    private func callNumber(phoneNumber: String) {
        UIApplication.shared.open(NSURL(string: "tel://\(phoneNumber)")! as URL)
    }
    
}
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

