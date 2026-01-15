//
//  ChainAnimatorsTests.swift
//  ChainAnimatorsTests
//
//  Created by Duy on 15/1/26.
//

import XCTest
@testable import ChainAnimators

@MainActor
final class ChainAnimatorsTests: XCTestCase {

    func testEmptyAnimators() async {
        let result = await ChainAnimators.startChainAnimators([])
        XCTAssertNil(result)
    }

    func testSingleAnimator() async {
        let view = UIView()
        let animator = UIViewPropertyAnimator(duration: 0.01, curve: .linear) {
            view.alpha = 0.5
        }
        let result = await ChainAnimators.startChainAnimators([animator])
        XCTAssertEqual(result, .end)
        XCTAssertEqual(view.alpha, 0.5)
    }

    func testSequentialExecution() async {
        let view = UIView()
        let anim1 = UIViewPropertyAnimator(duration: 0.01, curve: .linear) { view.tag = 1 }
        let anim2 = UIViewPropertyAnimator(duration: 0.01, curve: .linear) { view.tag = 2 }
        
        let result = await ChainAnimators.startChainAnimators([anim1, anim2])
        XCTAssertEqual(result, .end)
        XCTAssertEqual(view.tag, 2)
    }

    func testInterruptionStopsChain() async {
        let view = UIView()
        let anim1 = UIViewPropertyAnimator(duration: 1.0, curve: .linear) { view.tag = 1 }
        let anim2 = UIViewPropertyAnimator(duration: 1.0, curve: .linear) { view.tag = 2 }
        
        // Start the chain in a task
        let task = Task {
            return await ChainAnimators.startChainAnimators([anim1, anim2])
        }
        
        // Wait a bit and stop the first animation
        try? await Task.sleep(nanoseconds: 100_000_000) // 0.1s
        anim1.pauseAnimation()
        anim1.stopAnimation(false)
        anim1.finishAnimation(at: .current)
        
        let result = await task.value
        XCTAssertEqual(result, .current, "Chain should have stopped at .current")
        XCTAssertEqual(view.tag, 1, "Second animation should NOT have run")
    }

}
