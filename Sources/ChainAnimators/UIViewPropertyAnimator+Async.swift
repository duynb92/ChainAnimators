//
//  UIViewPropertyAnimator+Async.swift
//  ChainAnimators
//

import UIKit

extension UIViewPropertyAnimator {
    /// Resumes when the animator completes.
    ///
    /// - Returns: The final position of the animation.
    @discardableResult
    public func addCompletion() async -> UIViewAnimatingPosition {
        await withCheckedContinuation { continuation in
            self.addCompletion { position in
                continuation.resume(returning: position)
            }
        }
    }
}
