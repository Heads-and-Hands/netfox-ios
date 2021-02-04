//
// plg
// Copyright © 2021 Heads and Hands. All rights reserved.
//

#if os(iOS)

    import UIKit

    class NFXInfoController_iOS: NFXInfoController {
        // MARK: Lifecycle

        override func viewDidLoad() {
            super.viewDidLoad()

            title = "Info"

            scrollView = UIScrollView()
            scrollView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
            scrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            scrollView.autoresizesSubviews = true
            scrollView.backgroundColor = UIColor.clear
            view.addSubview(scrollView)

            textLabel = UILabel()
            textLabel.frame = CGRect(x: 20, y: 20, width: scrollView.frame.width - 40, height: scrollView.frame.height - 20)
            textLabel.font = UIFont.NFXFont(size: 13)
            textLabel.textColor = UIColor.NFXGray44Color()
            textLabel.attributedText = generateInfoString("Retrieving IP address..")
            textLabel.numberOfLines = 0
            textLabel.sizeToFit()
            scrollView.addSubview(textLabel)

            scrollView.contentSize = CGSize(width: scrollView.frame.width, height: textLabel.frame.maxY)

            generateInfo()
        }

        // MARK: Internal

        var scrollView = UIScrollView()
        var textLabel = UILabel()

        func generateInfo() {
            NFXDebugInfo.getNFXIP { (result) -> Void in
                DispatchQueue.main.async { () -> Void in
                    self.textLabel.attributedText = self.generateInfoString(result)
                }
            }
        }
    }

#endif
