//
//  ViewController.swift
//  BroadcastTVApp
//
//  Created by Vadde Narendra on 4/14/20.
//  Copyright © 2020 Narendra Vadde. All rights reserved.
//

import UIKit

struct Detail {
    var url: String
    var title: String
    var isSelected: Bool  = false
    
}

class ViewController: UIViewController {

    @IBOutlet weak var broadcastButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var playAndPauseButton: UIButton!
    
    var discoveredRokuBox: DiscoveredRokuBox?
    
    var items = [Detail(url: "https://gwapi.zee5.com/details/bhadradri/0-0-bhadradri", title: "Bhadradri"),
                 Detail(url: "https://gwapi.zee5.com/details/daring-mard/0-0-daringmard", title: "Daring Mard"),
                 Detail(url: "https://gwapi.zee5.com/details/mera-badla-revenge/0-0-2512", title: "Mera Badla: Revenge"),
                 Detail(url: "https://gwapi.zee5.com/details/weekend-bollywood-bonanza/0-0-6984", title: "Weekend Bollywood Bonanza"),
                 Detail(url: "https://gwapi.zee5.com/details/weekend-movie-bonanza/0-0-7318", title: "Weekend Movie Bonanza"),
                 Detail(url: "https://gwapi.zee5.com/details/srimanthudu/0-0-2701", title: "Srimanthudu"),
                 Detail(url: "https://gwapi.zee5.com/details/aparichit-the-stranger/0-0-aparichitthestranger", title: "Aparichit The Stranger")]
    
    var isTapped = true
    var isPlay = true
    
    var selectedIndex : Int?
    
    //create a new button
    let button: UIButton = UIButton(type: UIButton.ButtonType.custom)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        button.setImage(UIImage(named: "broadcast.png"), for: UIControl.State.normal)
        
        // eventhandler calling
        button.addTarget(self, action: #selector(onTapped), for: UIControl.Event.touchUpInside)
        
        // button added barbuttonItem
        let barButton = UIBarButtonItem(customView: button)
        
        //assign button to navigationbar
        self.navigationItem.rightBarButtonItem = barButton
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.reloadData()
        
    }
    
    @IBAction func playPauseButtonTapped(_ sender: UIButton) {
        
    if isPlay == true {
        playAndPauseButton.setImage(UIImage(named: "pause.png"), for: UIControl.State.normal)
        isPlay = false
    
    } else {
        playAndPauseButton.setImage(UIImage(named: "play.png"), for: UIControl.State.normal)
        isPlay = true
    }
        
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
       
        if let previousIndex = selectedIndex {
            if (previousIndex > 0){
                items[previousIndex].isSelected = false
                items[previousIndex - 1].isSelected = true
                selectedIndex = previousIndex - 1
                tableView.reloadData()
            }
        }
    }
    
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        
        if let nextIndex = selectedIndex {
            
            if (nextIndex < items.count - 1){
                items[nextIndex].isSelected = false
                items[nextIndex + 1].isSelected = true
                selectedIndex = nextIndex + 1
                tableView.reloadData()
            }
            
        }
        
    }
    
    
    // eventhandler for barbuttonitem
    @objc func onTapped(){
        
        let popupVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "popup") as! PopupViewController
        self.addChild(popupVC)
        popupVC.view.frame = self.view.frame
        view.addSubview(popupVC.view)
        popupVC.didMove(toParent: self)
        
        //set image for button
        if isTapped == true {
            button.setImage(UIImage(named: "broadcasting.png"), for: UIControl.State.normal)
            isTapped = false
        } else {
            button.setImage(UIImage(named: "broadcast.png"), for: UIControl.State.normal)
            isTapped = true
        }
    }
}

extension ViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableViewCell", for: indexPath) as! TitleTableViewCell
        
        cell.titleLbl.text = (items[indexPath.row].title)
        
        if(items[indexPath.row].isSelected){
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
       
        if let selected = selectedIndex {
            items[selected].isSelected = false
            selectedIndex = indexPath.row
            items[indexPath.row].isSelected = true
            tableView.reloadData()
        }else {
            selectedIndex = indexPath.row
            items[indexPath.row].isSelected = true
            tableView.reloadData()
        }
    }
}
