//
//  PageTitleView.swift
//  PageController
//
//  Created by user on 2018/5/10.
//  Copyright © 2018年 mobin. All rights reserved.
//

import UIKit

public typealias TitleClickHandler = (PageTitleView, Int) ->()

@objc public protocol PageTitleViewDelegate: class {

    @objc optional var reloader: PageReloadable? {get}
    func titleView(_ titleView: PageTitleView, currentIndex: Int)
}

/// 如果contentView中的view需要实现某些刷新的方法，请让对应的childViewController遵守这个协议
@objc public protocol PageReloadable: class {

    /// 如果需要双击标题刷新或者作其他处理，请实现这个方法
    @objc optional func titleViewDidSelectedSameTitle()

    /// 如果pageContentView滚动到下一页停下来需要刷新或者作其他处理，请实现这个方法
    @objc optional func contentViewDidEndScroll()
}


open class PageTitleView: UIView {

    //=======================================================
    // MARK: public - Property
    //=======================================================
    public weak var delegate: PageTitleViewDelegate?
    public var clickHandler: TitleClickHandler?

    //=======================================================
    // MARK: private - Property
    //=======================================================
    private var style: PageStyle
    private var titles: [String]
    private var currentIndex: Int = 0
    private lazy var selectRGB: ColorRGB = self.style.titleSelectedColor.getRGB()
    private lazy var normalRGB: ColorRGB = self.style.titleColor.getRGB()
    private lazy var deltaRGB: ColorRGB = {
        let deltaR = self.selectRGB.red - self.normalRGB.red
        let deltaG = self.selectRGB.green - self.normalRGB.green
        let deltaB = self.selectRGB.blue - self.normalRGB.blue
        return (deltaR, deltaG, deltaB)
    }()

    private lazy var titleLabels: [UILabel] = [UILabel]()
    private lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.showsHorizontalScrollIndicator = false
        scroll.scrollsToTop = false
        return scroll
    }()

    private lazy var bottomLine: UIView = {
        let line = UIView()
        line.backgroundColor = style.bottomLineColor
        return line
    }()

    private lazy var coverView: UIView = {
        let cover = UIView()
        cover.backgroundColor = style.contentViewBackgroundColor
        cover.alpha = style.coverViewAlpha
        return cover
    }()

    //=======================================================
    // MARK: public - init
    //=======================================================
    public init(frame: CGRect, style: PageStyle, titles: [String], currentIndex: Int = 0) {
        self.style = style
        self.titles = titles
        self.currentIndex = currentIndex
        super.init(frame: frame)
        setupUI()
    }
    required public init?(coder aDecoder: NSCoder) {
        self.style = PageStyle()
        self.titles = [String]()
        super.init(coder: aDecoder)
    }

    override open func layoutSubviews() {
        super.layoutSubviews()
        scrollView.frame = self.bounds
        layoutLabels()
        layoutBottomLine()
        layoutCoverView()
    }
}


//=======================================================
// MARK: setUpUI
//=======================================================
extension PageTitleView {
    private func setupUI() {

        setupScrollView()
        setupTitleLabels()
        setupBottomLine()
        setupCoverView()
    }

    private func setupScrollView() {
        addSubview(scrollView)
        scrollView.backgroundColor = style.titleViewBackgroundColor

    }

    private func setupTitleLabels() {

        for (i, title) in titles.enumerated() {
            let label = UILabel()
            label.tag = i
            label.text = title
            label.textColor = i == currentIndex ? style.titleSelectedColor : style.titleColor
            label.textAlignment = .center
            label.font = UIFont.systemFont(ofSize: style.titleFontSize)
            scrollView.addSubview(label)

            let tapGes = UITapGestureRecognizer(target: self, action: #selector(titleLabelDidClick(_:)))
            label.addGestureRecognizer(tapGes)
            label.isUserInteractionEnabled = true
            titleLabels.append(label)
        }
    }

    private func setupBottomLine() {
        guard style.isShowBottomLine else { return }
        scrollView.addSubview(bottomLine)
    }

    private func setupCoverView() {
        guard style.isShowCoverView else { return }
        scrollView.insertSubview(coverView, at: 0)

        coverView.layer.cornerRadius = style.coverViewRadius
        coverView.layer.masksToBounds = true
    }
}


//=======================================================
// MARK: Layout
//=======================================================
extension PageTitleView {

    private func layoutLabels() {
        var labelX: CGFloat = 0
        let labelY: CGFloat = 0
        var labelW: CGFloat = 0
        let labelH: CGFloat = frame.size.height

        let count = titleLabels.count
        for (i, titleLabel) in titleLabels.enumerated() {
            if style.isTitleScrollEnable {
                labelW = (titles[i] as NSString).boundingRect(with: CGSize(width: CGFloat.greatestFiniteMagnitude,
                                                                           height: 0),
                                                              options: .usesLineFragmentOrigin,
                                                              attributes: [NSAttributedStringKey.font : titleLabel.font],
                                                              context: nil).width
                labelX = i == 0 ? style.titleMargin * 0.5 : (titleLabels[i-1].frame.maxX + style.titleMargin)

            } else {
                labelW = bounds.width / CGFloat(count)
                labelX = labelW * CGFloat(i)
            }

            titleLabel.frame = CGRect(x: labelX, y: labelY, width: labelW, height: labelH)
        }

        /// 是否缩放
        if style.isScaleEnable {
            titleLabels.first?.transform = CGAffineTransform(scaleX: style.maximumScaleFactor,
                                                             y: style.maximumScaleFactor)
        }
        /// 是否滚动
        if style.isTitleScrollEnable {
            guard let label = titleLabels.last else {return}
            scrollView.contentSize.width = label.frame.maxX + style.titleMargin * 0.5
        }

    }

    private func layoutBottomLine() {

        guard titleLabels.count - 1 >= currentIndex else { return }
        let label = titleLabels[currentIndex]

        bottomLine.frame.origin.x = label.frame.origin.x
        bottomLine.frame.origin.y = bounds.height - style.bottomLineHeight
        bottomLine.frame.size.width = label.frame.width
        bottomLine.frame.size.height = label.frame.height

    }
    private func layoutCoverView() {

        guard titleLabels.count - 1 >= currentIndex else { return }
        let label = titleLabels[currentIndex]
        var coverW = label.bounds.width
        let coverH = style.coverViewHeight
        var coverX = label.frame.origin.x
        let coverY = (label.frame.height - coverH) * 0.5

        if style.isTitleScrollEnable {
            coverX -= style.coverMargin
            coverW += 2 * style.coverMargin
        }

        coverView.frame = CGRect(x: coverX, y: coverY, width: coverW, height: coverH)
    }

}


//=======================================================
// MARK: 监听Label点击
//=======================================================
extension PageTitleView {
    @objc private func titleLabelDidClick(_ tap: UITapGestureRecognizer) {

        guard let targetLabel = tap.view as? UILabel else { return }
        clickHandler?(self,targetLabel.tag)
        if targetLabel.tag == currentIndex {
            delegate?.reloader??.titleViewDidSelectedSameTitle?()
            return
        }


        let sourceLabel = titleLabels[currentIndex]
        sourceLabel.textColor = style.titleColor
        targetLabel.textColor = style.titleSelectedColor

        currentIndex = targetLabel.tag
        adjustLabelPosition(targetLabel)
        delegate?.titleView(self, currentIndex: currentIndex)
        if style.isScaleEnable {

            UIView.animate(withDuration: style.animateDuration, animations: {
                sourceLabel.transform = CGAffineTransform.identity
                targetLabel.transform = CGAffineTransform(scaleX: self.style.maximumScaleFactor,
                                                          y: self.style.maximumScaleFactor)
            })
        }

        if style.isShowCoverView {
            let coverX = style.isTitleScrollEnable ? (targetLabel.frame.origin.x - style.coverMargin) : (targetLabel.frame.origin.x)
            let coverW = style.isTitleScrollEnable ? (targetLabel.frame.width + style.coverMargin * 2) : (targetLabel.frame.width)

            UIView.animate(withDuration: style.animateDuration, animations: {
                self.coverView.frame.origin.x = coverX
                self.coverView.frame.size.width = coverW
            })
        }

        if style.isShowBottomLine {
            UIView.animate(withDuration: style.animateDuration, animations: {
                self.bottomLine.frame.origin.x = targetLabel.frame.origin.x
                self.bottomLine.frame.size.width = targetLabel.frame.width
            })
        }

    }

    private func adjustLabelPosition(_ targetLabel: UILabel) {
        guard style.isTitleScrollEnable else { return }

        var offsetX = targetLabel.center.x - bounds.width * 0.5

        if offsetX < 0 {
            offsetX = 0
        }
        if offsetX > scrollView.contentSize.width - scrollView.bounds.width {
            offsetX = scrollView.contentSize.width - scrollView.bounds.width
        }

        scrollView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
    }
}


extension PageTitleView: PageContentViewDelegate {
    func contentView(_ contentView: PageContentView, inIndex: Int) {
        currentIndex = inIndex

        let targetLabel = titleLabels[currentIndex]
        adjustLabelPosition(targetLabel)
        fix(targetLabel)
    }
    func contentView(_ contentView: PageContentView, sourceIndex: Int, targetIndex: Int, progress: CGFloat) {
        if sourceIndex > titleLabels.count - 1 || sourceIndex < 0 {
            return
        }
        if targetIndex > titleLabels.count - 1 || targetIndex < 0 {
            return
        }
        let sourceLabel = titleLabels[sourceIndex]
        let targetLabel = titleLabels[targetIndex]

        sourceLabel.textColor = UIColor(r: selectRGB.red - progress * deltaRGB.red, g: selectRGB.green - progress * deltaRGB.green, b: selectRGB.blue - progress * deltaRGB.blue)
        targetLabel.textColor = UIColor(r: normalRGB.red + progress * deltaRGB.red, g: normalRGB.green + progress * deltaRGB.green, b: normalRGB.blue + progress * deltaRGB.blue)

        if style.isScaleEnable {
            let deltaScale = style.maximumScaleFactor - 1.0
            sourceLabel.transform = CGAffineTransform(scaleX: style.maximumScaleFactor - progress * deltaScale, y: style.maximumScaleFactor - progress * deltaScale)
            targetLabel.transform = CGAffineTransform(scaleX: 1.0 + progress * deltaScale, y: 1.0 + progress * deltaScale)
        }

        if style.isShowBottomLine {
            let deltaX = targetLabel.frame.origin.x - sourceLabel.frame.origin.x
            let deltaW = targetLabel.frame.width - sourceLabel.frame.width
            bottomLine.frame.origin.x = sourceLabel.frame.origin.x + progress * deltaX
            bottomLine.frame.size.width = sourceLabel.frame.width + progress * deltaW
        }

        if style.isShowCoverView {
            let deltaX = targetLabel.frame.origin.x - sourceLabel.frame.origin.x
            let deltaW = targetLabel.frame.width - sourceLabel.frame.width
            coverView.frame.size.width = style.isTitleScrollEnable ? (sourceLabel.frame.width + 2 * style.coverMargin + deltaW * progress) : (sourceLabel.frame.width + deltaW * progress)
            coverView.frame.origin.x = style.isTitleScrollEnable ? (sourceLabel.frame.origin.x - style.coverMargin + deltaX * progress) : (sourceLabel.frame.origin.x + deltaX * progress)
        }
    }

    private func fix(_ targetLabel: UILabel) {
        UIView.animate(withDuration: 0.05) {
            targetLabel.textColor = self.style.titleSelectedColor

            if self.style.isScaleEnable {
                targetLabel.transform = CGAffineTransform(scaleX: self.style.maximumScaleFactor, y: self.style.maximumScaleFactor)
            }

            if self.style.isShowBottomLine {
                self.bottomLine.frame.origin.x = targetLabel.frame.origin.x
                self.bottomLine.frame.size.width = targetLabel.frame.width
            }

            if self.style.isShowCoverView {

                self.coverView.frame.size.width = self.style.isTitleScrollEnable ? (targetLabel.frame.width + 2 * self.style.coverMargin) : targetLabel.frame.width
                self.coverView.frame.origin.x = self.style.isTitleScrollEnable ? (targetLabel.frame.origin.x - self.style.coverMargin) : targetLabel.frame.origin.x
            }
        }
    }
}
