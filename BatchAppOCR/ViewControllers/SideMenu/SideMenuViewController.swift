//
//  SideMenuViewController.swift
//  Batch4App
//
//  Created by Muhammad Yousaf on 11/05/2021.
//

import UIKit
import SafariServices


class SideMenuViewController: BaseViewController{
    
    @IBOutlet weak var tableView: UITableView!

    var menuArray = [ [kPurchase,"photo_camera"],[kRateUs,"rate_app"],[kShareApp,"ic_share"],[kPrivacy,"privacy_policy"]]
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tableView.reloadData()
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
        tableView.register(UINib(nibName: "SideMenuTableViewCell", bundle: nil), forCellReuseIdentifier: "SideMenuTableViewCell")
    }
    
    @IBAction func crossAction(_ sender: UIButton) {
        
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.view.frame = CGRect(x: -UIScreen.main.bounds.size.width, y: 0, width: UIScreen.main.bounds.size.width,height: UIScreen.main.bounds.size.height)
            self.view.layoutIfNeeded()
            self.view.backgroundColor = UIColor.clear
        }, completion: { (finished) -> Void in
            self.view.removeFromSuperview()
            self.removeFromParent()
        })
    }
}
extension SideMenuViewController:UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SideMenuTableViewCell", for: indexPath) as! SideMenuTableViewCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.titleLabel.text = menuArray[indexPath.row][0]
        cell.titleImage.image = UIImage(named: menuArray[indexPath.row][1])
      
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if PurchaseStatusUserDefualt.value == 1 && indexPath.row == 0{
            return 0
        }else{
            return 60
        }
       
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0{
            let vc = UpgradeAppViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }else if indexPath.row == 1{
            rateApp()
        }else if indexPath.row == 2{
            showShareActivity(msg: "Share the App Link", image: nil, url: nil, sourceRect: nil)
        }else if indexPath.row == 3{
            
            let url = URL(string: privacyPolicy)
            let vc = SFSafariViewController(url: url!)
            present(vc, animated: true, completion: nil)
        }
        
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView.init(frame: .zero)
    }
}
