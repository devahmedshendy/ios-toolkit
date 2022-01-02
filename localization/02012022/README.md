## NOTES:
- User `AppLocalization.swift`, `AppLocalizationHelper.swift`, `MirroringLabel.swift`, and `MirroringViewController.swift` classes in `didFinishLaunchingWithOptions` of `AppDelegate.swift` class:
```swift
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        AppLocalizationHelper.DoTheMagic()
        
        return true
    }
```

- Use this code for changing the language with flipping animation:
```swift
@IBAction func changeLangButtonTapped(_ sender: Any) {
    let rootviewcontroller: UIWindow = ((UIApplication.shared.delegate?.window)!)!
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    rootviewcontroller.rootViewController = storyboard.instantiateViewController(withIdentifier: "TabBarVC")
    let mainwindow = (UIApplication.shared.delegate?.window!)!
    
    if AppLocalization.currentAppleLanguage() == "en" {
        UIView.transition(with: mainwindow, duration: 0.55001, options: .transitionFlipFromLeft, animations: { () -> Void in
        }) { (finished) -> Void in
            AppLocalization.setAppleLAnguageTo(lang: "ar")
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
            // Refresh The View To Reload The View
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let TabBarVC = storyboard.instantiateViewController(identifier: "TabBarVC")
            appDelegate.window!.rootViewController = TabBarVC
        }
        
    } else {
        UIView.transition(with: mainwindow,
                            duration: 0.55001,
                            options: .transitionFlipFromLeft, animations: { () -> Void in
                            }) { (finished) -> Void in
            AppLocalization.setAppleLAnguageTo(lang: "en")
            UIView.appearance().semanticContentAttribute = .forceLeftToRight
            // Refresh The View To Reload The View
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let TabBarVC = storyboard.instantiateViewController(identifier: "TabBarVC")
            appDelegate.window!.rootViewController = TabBarVC
        }
    }
}
```