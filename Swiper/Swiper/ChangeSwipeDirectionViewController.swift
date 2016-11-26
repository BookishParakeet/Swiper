//
//  ChangeSwipeDirectionViewController.swift
//  Swiper
//
//  Created by Charlie Wang on 11/25/16.
//  Copyright © 2016 BookishParakeet. All rights reserved.
//

import UIKit
import AWSMobileHubHelper
import AWSDynamoDB

class ChangeSwipeDirectionViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet var socialMediaScrollView: UIScrollView!
    
    var thumbButt: UIButton?
    var passedDirection: String! = ""
    let socialMediaTypes = [
        "facebook": #imageLiteral(resourceName: "FBIcon"), "twitter":#imageLiteral(resourceName: "TwitterIcon"), "imessage":#imageLiteral(resourceName: "iMessageIcon"), "weibo": #imageLiteral(resourceName: "WeiboIcon")
    ]
     var socialMedia = [#imageLiteral(resourceName: "FBIcon"), #imageLiteral(resourceName: "TwitterIcon"), #imageLiteral(resourceName: "iMessageIcon"), #imageLiteral(resourceName: "GIcon"), #imageLiteral(resourceName: "FlickrIcon"), #imageLiteral(resourceName: "LinkedInIcon"), #imageLiteral(resourceName: "TumblrIcon"), #imageLiteral(resourceName: "WeiboIcon")]
    
    @IBOutlet var currentMedia: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setCurrentMedia(socialMedia: passedDirection)
        self.initScrollView()
        socialMediaScrollView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func buttonAction(button: UIButton) {
        print("Load number: \(button.tag)")
    }
    
    override func viewWillLayoutSubviews(){
        super.viewWillLayoutSubviews();
    }
    
    func initScrollView(){
        var x: CGFloat = 0
        let y: CGFloat = 10
        let buttonWidth:CGFloat = 100
        let buttonHeight: CGFloat = 100
        let buttonGap: CGFloat = 10
        let numberOfButtons = socialMedia.count
        
        for index in 0...numberOfButtons - 1 {
            print (index)
            let buttonTag = index
            let buttonImage:UIImage = socialMedia[index]
            let button = UIButton(type: UIButtonType.custom) as UIButton
            button.tag = buttonTag
            button.frame = CGRect(origin: CGPoint(x: x,y :y), size: CGSize(width: buttonWidth, height: buttonHeight))
            button.setImage(buttonImage, for: .normal)
            button.showsTouchWhenHighlighted = true
            button.addTarget(self, action: Selector(("buttonAction:")), for:.touchUpInside)
            x +=  buttonWidth + buttonGap
            socialMediaScrollView.addSubview(button)
        }
        let buttonsCountFloat = CGFloat(Int(numberOfButtons))
        var x_val = buttonWidth * CGFloat(buttonsCountFloat+4)
        
        socialMediaScrollView.contentSize = CGSize(width: x_val, height: y)
    }
    
    func setCurrentMedia(socialMedia:String) {
        let dynamoDBObjectMapper = AWSDynamoDBObjectMapper.default()
        
        dynamoDBObjectMapper .load(PictureUsUserSetting1.self, hashKey: AWSIdentityManager.defaultIdentityManager().identityId!, rangeKey: nil) .continue(with: AWSExecutor.mainThread(), with: { (task:AWSTask!) -> AnyObject! in
            if (task.error == nil) {
                if (task.result != nil) {
                    let tableRow = task.result as! PictureUsUserSetting1
                    if (socialMedia == "up") {
                        self.currentMedia.image = self.socialMediaTypes[tableRow._up!]
                    } else if (socialMedia == "down") {
                        self.currentMedia.image = self.socialMediaTypes[tableRow._down!]
                    } else if (socialMedia == "left") {
                        self.currentMedia.image = self.socialMediaTypes[tableRow._left!]
                    } else {
                        self.currentMedia.image = self.socialMediaTypes[tableRow._right!]
                    }
                }
            }
                return nil
        })
    }

}
