//
//  BWEmoticonInputView.swift
//  BTStudioWeiBo
//
//  Created by hadlinks on 2019/4/25.
//  Copyright © 2019 BTStudio. All rights reserved.
//

import UIKit

/// Cell可重用标识
private let CellIdentifier = "CollectionViewCellIdentifier"

/// 表情键盘输入视图
class BWEmoticonInputView: UIView {

    /// 表情集合视图
    @IBOutlet weak var collectionView: UICollectionView!
    
    /// 底部工具栏View
    @IBOutlet weak var toolbarView: UIView!
    
    /// 选中表情的回调闭包
    private var selectedEmoticonCallBack: ((_ emoticon: BWEmoticon?) -> ())?
    
    
    class func inputView(selectedEmoticon: @escaping (_ emoticon: BWEmoticon?) -> ()) -> BWEmoticonInputView {
        let nib = UINib(nibName: "BWEmoticonInputView", bundle: nil)
        
        let view = nib.instantiate(withOwner: nil, options: nil)[0] as! BWEmoticonInputView
        
        view.frame = CGRect(x: 0, y: 0, width: 0, height: 265)
        
        // 记录闭包
        view.selectedEmoticonCallBack = selectedEmoticon
        
        return view
    }
    
    override func awakeFromNib() {
        // 注册可重用Cell
        collectionView.register(BWEmoticonCell.self, forCellWithReuseIdentifier: CellIdentifier)
        
//        collectionView.register(UINib(nibName: "BWEmoticonCell", bundle: nil), forCellWithReuseIdentifier: CellIdentifier)
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

// MARK: - UICollectionViewDataSource
extension BWEmoticonInputView: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // 表情包的组数
        return BWEmoticonManager.shared.packages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let package = BWEmoticonManager.shared.packages[section]
        // 表情包分组中的页数
        return package.numberOfPages
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier, for: indexPath) as! BWEmoticonCell
        
        // 表情包分组
        let package = BWEmoticonManager.shared.packages[indexPath.section]
        
        // 表情包分组中第几页的表情数据
        cell.emoticons = package.emoticons(at: indexPath.row)
        
        // 设置代理
        cell.delegate = self
        
        return cell
    }
}


// MARK: - BWEmoticonCellDelegate
extension BWEmoticonInputView: BWEmoticonCellDelegate {
    
    func emoticonCellDidSelectedEmoticon(cell: BWEmoticonCell, emoticon: BWEmoticon?) {
        // 执行闭包,回传选中的表情模型
        selectedEmoticonCallBack?(emoticon)
    }
}
