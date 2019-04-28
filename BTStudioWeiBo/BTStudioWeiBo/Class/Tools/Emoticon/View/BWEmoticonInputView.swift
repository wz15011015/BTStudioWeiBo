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
    
    /// 分页控制器
    @IBOutlet weak var pageControl: UIPageControl!
    
    /// 底部工具栏View
    @IBOutlet weak var toolbarView: BWEmoticonToolbar!
    
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
        
        // 设置工具栏代理
        toolbarView.delegate = self
        
        // 设置分页控件
        let bundle = BWEmoticonManager.shared.bundle
        if let imageNormal = UIImage(named: "compose_keyboard_dot_normal", in: bundle, compatibleWith: nil),
            let imageSelected = UIImage(named: "compose_keyboard_dot_selected", in: bundle, compatibleWith: nil) {
            // 使用填充图片设置颜色 (该方式设置的图片显示不完整)
//            pageControl.pageIndicatorTintColor = UIColor(patternImage: imageNormal)
//            pageControl.currentPageIndicatorTintColor = UIColor(patternImage: imageSelected)
            
            // 使用KVC设置私有成员属性
            pageControl.setValue(imageNormal, forKey: "_pageImage")
            pageControl.setValue(imageSelected, forKey: "_currentPageImage")
        }
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


// MARK: - UIScrollViewDelegate
extension BWEmoticonInputView: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // 1. 获取中心点
        var center = scrollView.center
        center.x += scrollView.contentOffset.x
        
        // 2. 获取当前显示cell的indexPath
        let indexPaths = collectionView.indexPathsForVisibleItems
        
        // 3. 判断中心点在哪一个indexPath上,则就在哪一个页面上
        var targetIndexPath: IndexPath?
        for indexPath in indexPaths {
            // 根据indexPath获取Cell
            let cell = collectionView.cellForItem(at: indexPath)
            // 判断中心点是否在该Cell位置,若在,则记录该indexPath
            if cell?.frame.contains(center) == true {
                targetIndexPath = indexPath
            }
        }
        
        // 4. 根据找到的indexPath设置选中分组按钮的索引
        // targetIndexPath.section 就是对应的分组索引
        guard let indexPath = targetIndexPath else {
            return
        }
        toolbarView.selectedIndex = indexPath.section
        
        // 5. 设置分页控件
        // 总页数
        pageControl.numberOfPages = collectionView.numberOfItems(inSection: indexPath.section)
        // 当前页码
        pageControl.currentPage = indexPath.row
    }
}


// MARK: - BWEmoticonCellDelegate
extension BWEmoticonInputView: BWEmoticonCellDelegate {
    
    func emoticonCellDidSelectedEmoticon(cell: BWEmoticonCell, emoticon: BWEmoticon?) {
        // 执行闭包,回传选中的表情模型
        selectedEmoticonCallBack?(emoticon)
        
        // 如果当前分组就是最近分组,则不添加最近使用的表情
        let index = collectionView.indexPathsForVisibleItems[0]
        if index.section == 0 {
            return
        }
        
        // 添加最近使用的表情
        if let emoticon = emoticon {
            BWEmoticonManager.shared.addRecentEmoticon(emoticon: emoticon)
            
            // 刷新CollectionView
            // 刷新第0组
            let sections = IndexSet(integer: 0)
            collectionView.reloadSections(sections)
        }
    }
}


// MARK: - BWEmoticonToolbarDelegate
extension BWEmoticonInputView: BWEmoticonToolbarDelegate {
    
    func emoticonToolbarDidSelectedItemIndex(toolbar: BWEmoticonToolbar, index: Int) {
        // 让collectionView滚动
        let indexPath = IndexPath(item: 0, section: index)
        collectionView.scrollToItem(at: indexPath, at: .left, animated: false)
    }
}
