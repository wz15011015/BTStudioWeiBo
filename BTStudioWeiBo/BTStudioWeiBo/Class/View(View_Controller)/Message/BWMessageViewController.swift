//
//  BWMessageViewController.swift
//  BTStudioWeiBo
//
//  Created by hadlinks on 2019/3/30.
//  Copyright © 2019 BTStudio. All rights reserved.
//

import UIKit
import Alamofire

class BWMessageViewController: BWBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadStatusList()
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


// MARK: - Alamofire学习
extension BWMessageViewController {
    
    private func loadStatusList() {
        let urlString = "https://api.weibo.com/2/statuses/home_timeline.json"
        let parameter = ["access_token": "2.00UfZikCTQtzcE57ad9fa3c6DhHNJD", "since_id": "0", "max_id": "0"]
        AF.request(urlString, method: .get, parameters: parameter).responseJSON { (response) in
            let result = response.result
            let value = response.value
            print(result)
        }
    }
}
