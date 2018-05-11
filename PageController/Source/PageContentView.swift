//
//  PageContentView.swift
//  PageController
//
//  Created by user on 2018/5/11.
//  Copyright © 2018年 mobin. All rights reserved.
//

import UIKit


protocol PageContentViewDelegate: class {
    func contentView(_ contentView: PageContentView, inIndex: Int)
    func contentView(_ contentView: PageContentView, sourceIndex: Int, targetIndex: Int, progress: CGFloat)
}

class PageContentView: UIView {

    public weak var delegate: PageContentViewDelegate?
    //=======================================================
    // MARK: Property - private
    //=======================================================
    private var style: PageStyle
    private var childViewController: [UIViewController]
    private var startIndex: Int = 0
    private let CellID = "PageContentCellID"

    public weak var reloader: PageReloadable?
    private var isForbidDelegate: Bool = false
    private var startOffsetX: CGFloat = 0

    private (set) lazy var collectionView: UICollectionView = {

        let layout = PageCollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        
        let collectView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectView.showsHorizontalScrollIndicator = false
        collectView.isPagingEnabled = true
        collectView.scrollsToTop = false
        collectView.dataSource = self
        collectView.delegate = self
        collectView.bounces = false

        if #available(iOS 10, *) {
            collectView.isPrefetchingEnabled = false
        }
        collectView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: CellID)
        return collectView
    }()

     //MARK: - init
    public init(frame: CGRect, style: PageStyle, childViewController: [UIViewController], startIndex: Int = 0) {

        self.style = style
        self.childViewController = childViewController
        self.startIndex = startIndex
        super.init(frame: frame)
        setupUI()
    }


    required init?(coder aDecoder: NSCoder) {
        self.childViewController = [UIViewController]()
        self.style = PageStyle()
        super.init(coder: aDecoder)
    }


    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = bounds

        let layout = collectionView.collectionViewLayout as? PageCollectionViewFlowLayout
        layout?.itemSize = bounds.size
        layout?.offset = CGFloat(startIndex) * bounds.size.width
    }
}


//=======================================================
// MARK: SetupUI
//=======================================================
extension PageContentView {

    private func setupUI() {
        addSubview(collectionView)
        collectionView.backgroundColor = style.contentViewBackgroundColor
        collectionView.isScrollEnabled = style.isContentScrollEnable
    }
}

//=======================================================
// MARK: UICollectionViewDataSource
//=======================================================
extension PageContentView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return childViewController.count
    }


    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellID, for: indexPath)
        cell.contentView.subviews.forEach{
            $0.removeFromSuperview()
        }

        let childVC = childViewController[indexPath.item]
        reloader = childVC as? PageReloadable

        childVC.view.frame = cell.contentView.bounds
        cell.contentView.addSubview(childVC.view)
        return cell
    }
}


//=======================================================
// MARK: UICollectionViewDelegate
//=======================================================
extension PageContentView: UICollectionViewDelegate {

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isForbidDelegate = false
        startOffsetX = scrollView.contentOffset.x
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateUI(scrollView)
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        guard decelerate == false else { return }
        didEndScroll(scrollView)
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        didEndScroll(scrollView)
    }


    private func updateUI(_ scrollView: UIScrollView) {
        guard !isForbidDelegate else { return }

        var progress: CGFloat = 0
        var targetIndex: Int = 0
        var sourceIndex: Int = 0

        let index = Int(scrollView.contentOffset.x / scrollView.bounds.width)

        if collectionView.contentOffset.x > startOffsetX { // 左滑
            sourceIndex = index
            targetIndex = index + 1

            if targetIndex > childViewController.count - 1 { return }
        } else {
            sourceIndex = index + 1
            targetIndex = index
            progress = 1 - progress

            if targetIndex < 0 { return }
        }

        if progress > 0.998 { progress = 1}

        delegate?.contentView(self, sourceIndex: sourceIndex, targetIndex: targetIndex, progress: progress)

    }

    private func didEndScroll(_ scrollView: UIScrollView) {
        let index = Int(round(collectionView.contentOffset.x / collectionView.bounds.width))
        let childVC = childViewController[index]

        reloader = childVC as? PageReloadable
        reloader?.contentViewDidEndScroll?()
        delegate?.contentView(self, inIndex: index)
    }
}


extension PageContentView: PageTitleViewDelegate {
    func titleView(_ titleView: PageTitleView, currentIndex: Int) {
        isForbidDelegate = true
        if currentIndex > childViewController.count - 1 {return}

        let indexPath = IndexPath(item: currentIndex, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .left, animated: false)
    }
}
