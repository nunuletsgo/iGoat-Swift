
//TODO: Comment
//test tests tests
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?



//testsetsetestes






    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        configureSideMenu()
        configureRootController()
        return true
    }
    
    func application(_ app: UIApplication, open url: URL,
                     options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        if url.scheme?.caseInsensitiveCompare("igoat") == .orderedSame,
            let queryInfo = url.parmetersInfo
            {
                let mobileNo = queryInfo["contactNumber"] ?? ""
            let message = queryInfo["message"] ?? ""
            UIAlertController.showAlertWith(title: "iGoat", message: "Message \"\(message)\" sent to \(mobileNo)")
                return true
        }
        return false
    }
}

/testsetestse

extension AppDelegate {
    func configureRootController() {
        self.window = UIWindow()
        let menuTC = MenuTableViewController()
        let sideMenuViewController = SideMenuController()
        sideMenuViewController.embed(sideViewController: menuTC)
        menuTC.assets = Asset.allAssets()
        window?.rootViewController = sideMenuViewController
        window?.makeKeyAndVisible()
    }
    
    func configureSideMenu() {
        SideMenuController.preferences.drawing.menuButtonImage = UIImage(named: "menu")
        SideMenuController.preferences.drawing.sidePanelPosition = .underCenterPanelLeft
        SideMenuController.preferences.drawing.sidePanelWidth = 400
        SideMenuController.preferences.drawing.centerPanelShadow = true
        SideMenuController.preferences.animating.statusBarBehaviour = .horizontalPan
        SideMenuController.preferences.animating.transitionAnimator = FadeAnimator.self
    }
}
