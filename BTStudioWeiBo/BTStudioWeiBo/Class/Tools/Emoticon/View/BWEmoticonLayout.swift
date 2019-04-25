//
//  BWEmoticonLayout.swift
//  BTStudioWeiBo
//
//  Created by hadlinks on 2019/4/25.
//  Copyright © 2019 BTStudio. All rights reserved.
//

import UIKit

/// 表情集合视图的布局
class BWEmoticonLayout: UICollectionViewFlowLayout {
    
    /// prepare 就是 OC 中的prepareLayout
    override func prepare() {
        super.prepare()
        
        guard let collectionView = collectionView else {
            return
        }
        
        // 设定滚动方向
        /**
         若水平方向滚动, 则Cell垂直方向布局;
         若竖直方向滚动, 则Cell水平方向布局.
         */
        scrollDirection = .horizontal
        
        itemSize = collectionView.bounds.size
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
    }
}
