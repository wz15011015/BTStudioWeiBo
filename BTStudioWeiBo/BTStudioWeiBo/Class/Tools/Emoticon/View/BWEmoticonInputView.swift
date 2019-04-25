//
//  BWEmoticonInputView.swift
//  BTStudioWeiBo
//
//  Created by hadlinks on 2019/4/25.
//  Copyright © 2019 BTStudio. All rights reserved.
//

import UIKit

private let CellIdentifier = "CollectionViewCellIdentifier"

/// 表情键盘输入视图
class BWEmoticonInputView: UIView {

    /// 表情集合视图
    @IBOutlet weak var collectionView: UICollectionView!
    
    /// 底部工具栏View
    @IBOutlet weak var toolbarView: UIView!
    
    
    class func inputView() -> BWEmoticonInputView {
        let nib = UINib(nibName: "BWEmoticonInputView", bundle: nil)
        
        let view = nib.instantiate(withOwner: nil, options: nil)[0] as! BWEmoticonInputView
        
        return view
    }
    
    override func awakeFromNib() {
        // 注册Cell
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
        return BWEmoticonManager.shared.packages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let package = BWEmoticonManager.shared.packages[section]
        return package.numberOfPages
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier, for: indexPath) as! BWEmoticonCell
        
        let package = BWEmoticonManager.shared.packages[indexPath.section]
        cell.emoticons = package.emoticons(at: indexPath.row)
        
        // 设置代理
        cell.delegate = self
        
        return cell
    }
}


// MARK: - BWEmoticonCellDelegate
extension BWEmoticonInputView: BWEmoticonCellDelegate {
    
    func emoticonCellDidSelectedEmoticon(cell: BWEmoticonCell, emoticon: BWEmoticon?) {
        print("点击了 \(emoticon?.chs ?? "删除")")
    }
}
