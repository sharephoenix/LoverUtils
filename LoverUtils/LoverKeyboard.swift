//
//  LKeyboardAnimation.swift
//  LoverUtils
//
//  Created by phoenix on 2022/11/2.
//

import Foundation
import UIKit

public class LoverKeyboard: NSObject {
    /// 监听是否是第一响应者
    private var wrappedValue: (() ->  UIView?)
    /// 需要偏移的View，这个 View 必须是 wrappedValue 的父 View
    private var transformView: (() ->  UIView?)
    /// 必须要露出来的 View
    private var wrapView: (() -> UIView?)

    public init(targetView value: @escaping (() ->  UIView?),
                wrapView:  @escaping (() ->  UIView?),
                transformView: @escaping (() -> UIView?)) {
        self.wrappedValue = value
        self.wrapView = wrapView
        self.transformView = transformView
        super.init()
        //监听键盘通知
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(_:)),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillhide(_:)),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    //键盘改变
    @objc func keyboardWillShow(_ sender: NSNotification) {

        var targetView = wrappedValue()

        guard let transformView = transformView(), targetView?.isFirstResponder ?? false else { return }
        /// 判断是否有响应键盘的 View
        var currentViewContainView = false
        while targetView != nil {
            if transformView === targetView {
                currentViewContainView = true
                break
            }
            targetView = targetView?.next as? UIView
        }
        guard currentViewContainView else { return }

        /// 计算偏移高度
        guard let targetView = wrapView() else { return }

        guard let keyboardFrame = (sender.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as AnyObject).cgRectValue else {
            return
        }
        /// targetView 在 Window 的 frame
        guard let targetFrame = targetView.window?.convert(targetView.bounds, from: targetView) else {
            return
        }

        guard let windowHeight = transformView.window?.frame.height else { return }

        let transformOffset = keyboardFrame.height - (windowHeight - targetFrame.maxY)

        if transformView.transform == .identity && transformOffset < 0 {
            return
        }

        //获取动画执行的时间
        var duration = sender.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double
        if duration == nil { duration = 0.25 }

        UIView.animate(withDuration: duration!, delay: 0, options: .allowAnimatedContent, animations: {
            transformView.transform = transformView.transform.translatedBy(x: 0, y: -transformOffset)
        }, completion: nil)
    }

    @objc func keyboardWillhide(_ sender: NSNotification) {
        guard wrappedValue()?.isFirstResponder ?? false, let transformView = transformView() else { return }
        UIView.animate(withDuration: 0.1, animations: {
            transformView.transform = CGAffineTransform.identity
        })
    }
}
