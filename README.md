# ChainAnimators

A lightweight Swift framework for easily chaining `UIViewPropertyAnimator` instances using Swift Concurrency (`async/await`).

## Overview

`ChainAnimators` simplifies the process of running multiple `UIViewPropertyAnimator` animations in sequence. By leveraging Swift's `async/await` syntax, it eliminates "completion handler hell" and provides a clean, readable way to define complex animation sequences.

### Key Features
- **Sequential Execution**: Run a list of animators one after another.
- **Interruption Support**: Automatically stops the chain if any animator is interrupted or reversed.
- **Swift Concurrency**: Native support for awaiting individual animators or entire chains.
- **Modern API**: Clean and expressive syntax.

## Installation

### Swift Package Manager (SPM)

Add `ChainAnimators` as a dependency in your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/your-repo/ChainAnimators.git", from: "1.0.0")
]
```

Or add it directly in Xcode by going to **File > Add Packages...** and entering the repository URL.

## Usage

### Chaining Multiple Animations

You can run an array of animators sequentially using `ChainAnimators.startChainAnimators`:

```swift
let anim1 = UIViewPropertyAnimator(duration: 1.0, curve: .easeInOut) {
    self.myView.alpha = 0.5
}

let anim2 = UIViewPropertyAnimator(duration: 0.5, curve: .linear) {
    self.myView.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
}

Task {
    let finalPosition = await ChainAnimators.startChainAnimators([anim1, anim2])
    print("Animation chain completed at position: \(finalPosition)")
}
```

### Awaiting a Single Animator

The framework also provides a convenient extension to `UIViewPropertyAnimator` to await its completion directly:

```swift
let animator = UIViewPropertyAnimator(duration: 2.0, curve: .easeIn) {
    self.myView.center = destination
}

animator.startAnimation()
let position = await animator.addCompletion()
```

### Interruption Handling

If any animator in the chain is interrupted (e.g., via `stopAnimation(false)` followed by `finishAnimation(at:)`), the chain will **automatically halt** and return the final position of the interrupted animator.

## Contribution Guide

Contributions are welcome! If you have suggestions for improvements or bug fixes, please:

1. Fork the repository.
2. Create a new branch for your feature or fix.
3. Submit a Pull Request with a clear description of your changes.
4. Ensure all tests pass.

## License

`ChainAnimators` is available under the MIT license. See the [LICENSE](LICENSE) file for more info. (Note: Please ensure you create a LICENSE file if one is missing).
