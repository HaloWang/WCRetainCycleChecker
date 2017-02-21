# WCRetainCycleChecker

**WCRetainCycleChecker** is a tool to check the retain-cycle between UIViewController subclass and proterties it retains.

🇨🇳 [中文](http://halowang.github.io/2017/02/21/WCRetainCycleChecker/)

## How it work?

WCRetainCycleChecker use method swizzling to change the implementation of `UIViewController.viewDidDisappear`.

## Installation

```ruby
pod 'WCRetainCycleChecker', :configurations => ['Debug']
```

Then:

```
cd YOUR_PODFILE_PATH && pod install
```

After finish it, WCRetainCycleChecker will effect in your project. If your UIViewController subclass has retain-cycle, WCRetainCycleChecker will warn you with following message:

```
Warning：<RetainedViewController: 0x7fa789f01800> still in memory after `-viewDidDisappear` (2s)
```

## More

You can also use [FBRetainCycleDetector](ttps://github.com/facebook/FBRetainCycleDetector) in `WCRetainCycleChecker.retainCycleFound` callback to get more infomation.

There is also a repo called [MLeaksFinder](https://github.com/Zepo/MLeaksFinder) which is more powerful than my repo 👍.
