//
//  PopupViewController.swift
//  BroadcastTVApp
//
//  Created by Vadde Narendra on 4/15/20.
//  Copyright © 2020 Narendra Vadde. All rights reserved.
//

import UIKit

class PopupViewController: UIViewController {

    @IBOutlet weak var popupTableView: UITableView!
        
    var  deviceData = [Details]()
    
    var tableData = [AnyHashable]()
    var launchURL: String?
    var dialMgr = DIALManager()
    var discovery = Discovery()
    var countDiscovered: Int?
    var selectedIndex: Int?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("ViewController buttonBroadcastPressed")
        
        // Mainview background color
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)

        // Do any additional setup after loading the view, typically from a nib.
        popupTableView.dataSource = self
        popupTableView.layer.borderWidth = 1.0
        popupTableView.layer.borderColor = UIColor.gray.cgColor

        tableData = [AnyHashable]()

        countDiscovered = 0
        
        /// call start broadcast
        Discovery.startSSDPBroadcast((SSDPDiscoveryDelegateListener(owner: self)))
    }
    
    
    @IBAction func doneBtnTapped(_ sender: UIButton) {
        
        print("ViewController buttonDonePressed")
        
        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
        
    }
    

}

extension PopupViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "popcell", for: indexPath) as! PopupTVC
        
        cell.deviceTitleLbl.text = tableData[indexPath.row].description
        
        if(tableData[indexPath.row] as! Bool){
            cell.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        } else {
            cell.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let box = tableData[indexPath.row] as? DiscoveredRokuBox {
            if let controller = parent as? ViewController {
                controller.discoveredRokuBox = box
            }
            if let dialURL = box.dialURL {
                print("DIAL URL: \(dialURL)")
                
            }
            
            launchURL = dialMgr.launchApp(box.dialURL, "")
            
        }
        
        dialMgr.sendDelete(launchURL)
        
    }
    
    
}


class SSDPDiscoveryDelegateListener: NSObject, DiscoveryEventsDelegate {
    
    func onFinished(_ count: Int32) {
        owner.popupTableView.reloadData()
        print(String(format: "SSDPDiscoveryDelegateListener onFinished count: %i found", count))
    }
    
    
    var owner = PopupViewController()
    
    init(owner: PopupViewController?) {
        self.owner = owner!
    }

    func onFound(_ box: DiscoveredRokuBox?) {
        if let ip = box?.ip {
            print("SSDPDiscoveryDelegateListener onDevice url: \(ip)")
        }
        if let box = box {
            self.owner.tableData.append(box)
        }
        if let ip = box?.ip {
            print(ip)
        }

        owner.countDiscovered! += 1
        owner.dialMgr.fetchDetails(box)
    }

}
