//
//  BWComposeViewController.swift
//  BTStudioWeiBo
//
//  Created by hadlinks on 2019/4/19.
//  Copyright © 2019 BTStudio. All rights reserved.
//

import UIKit

class BWComposeViewController: BWBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.orange
        
        title = "微博"
        
        navigationItemCustom.leftBarButtonItem = UIBarButtonItem(title: "返回", target: self, action: #selector(dismissVC), isBack: true)
        
        let manager = BWEmoticonManager.shared
        let emoticon = manager.findEmoticon(chsString: "[偷乐]")
        print(emoticon)
    }
    
    @objc func dismissVC() {
        dismiss(animated: true, completion: nil)
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
