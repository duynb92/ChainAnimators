import UIKit

public struct ChainAnimators {
    
    /// Starts a chain of animators sequentially.
    ///
    /// - Parameters:
    ///   - animators: The array of animators to run in order.
    ///   - completion: An optional completion block called when the chain finishes or is interrupted.
    /// - Returns: The final position of the animator that concluded the chain.
    @discardableResult
    public static func startChainAnimators(
        _ animators: [UIViewPropertyAnimator],
        completion: (() -> Void)? = nil
    ) async -> UIViewAnimatingPosition? {
        guard !animators.isEmpty else {
            completion?()
            return nil
        }
        
        var finalPosition: UIViewAnimatingPosition = .end
        
        for animator in animators {
            animator.startAnimation()
            finalPosition = await animator.addCompletion()
            
            // Per requirement: If interrupted or reversed (not at .end), stop the chain.
            if finalPosition != .end {
                break
            }
        }
        
        completion?()
        return finalPosition
    }
}
