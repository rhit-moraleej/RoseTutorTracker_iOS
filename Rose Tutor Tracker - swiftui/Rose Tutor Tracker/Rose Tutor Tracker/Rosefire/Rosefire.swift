//
// Created by Elvis on 4/8/22.
//

//
//  Rosefire.swift
//
//  Created by Tyler Rockwood, edited by Dave Fisher on 1/14/2020.
//  Copyright © 2018 RoseHulman. All rights reserved.
//

import SwiftUI
import WebKit
import Firebase

typealias RosefireCallback = ((NSError?, RosefireResult?) -> ())?

struct RosefireLogin: UIViewControllerRepresentable{
    class Coordinator {
        
    }

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    @Binding var roseResult : RosefireResult
    @EnvironmentObject var loggIn: AuthManager
//    private var token : String
    func makeUIViewController(context: Context) -> WebviewController {
        let rosefire = WebviewController()
        rosefire.registryToken = Private_keys.token
        rosefire.callback = { (err, result) in
            rosefire.dismiss(animated: true, completion: nil)
            if let err = err {
                print("Rosefire sign in error! \(err)")
                return
              }
              print("Result = \(result!.token!)")
              print("Result = \(result!.username!)")
              print("Result = \(result!.name!)")
              print("Result = \(result!.email!)")
              print("Result = \(result!.group!)")
              Auth.auth().signIn(withCustomToken: result!.token) { (authResult, error) in
                if let error = error {
                  print("Firebase sign in error! \(error)")
                  return
                }
                  roseResult = result!
                // User is signed in using Firebase!
                  print("The user is now actually signed in using the Rosefire token")
                  UserDefaults.standard.set(true, forKey: UserData.loggedIn)
//                  AuthManager.shared.currentUser = Auth.auth().currentUser
                  print("\(AuthManager.shared.currentUser)")
              }

            }
        rosefire.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel",
                                                                    style: .plain,
                                                                    target: self, action: nil
                                                                    )

        return rosefire
    }
    
    private func cancelled(webview: WebviewController){
        let err = NSError(domain: "User cancelled login", code: 0, userInfo: nil)
        webview.callback!(err, nil)
    }

    func updateUIViewController(_ uiViewController: WebviewController, context: Context) {

    }
}

public class RosefireResult : NSObject {
  public var token : String!
  public var username : String!
  public var name : String!
  public var email : String!
  public var group : String!

  init(token: String?) {
    self.token = token
    if token == nil {
      return
    }
    var payload = token!.split{$0 == "."}.map(String.init)[1]
    var paddingNeeded = payload.count % 4
    while paddingNeeded > 0 {
      payload = payload + "="
      paddingNeeded = paddingNeeded - 1
    }
    let decodedData = NSData(base64Encoded: payload, options: NSData.Base64DecodingOptions(rawValue: 0))
    var json : [String:Any]
    do {
      json = try JSONSerialization.jsonObject(with: decodedData! as Data, options: []) as! [String:Any]
      if json["d"] != nil {
        // old format
        json = json["d"] as! [String:AnyObject]
      } else {
        // new format
        let username = json["uid"] as! String
        json = json["claims"] as! [String:Any]
        json["uid"] = username
      }
      self.username = (json["uid"] as? String)
      self.name = (json["name"] as? String)
      self.email = (json["email"] as? String)
      self.group = (json["group"] as? String)
    } catch {
      print("Error: Couldn't parse Rosefire JWT")
    }
  }
}


class WebviewController : UIViewController, WKScriptMessageHandler, WKNavigationDelegate, WKUIDelegate {

    var webview: WKWebView?
    var registryToken: String?
    var callback: RosefireCallback = nil

    internal override func loadView() {
        super.loadView()
        let contentController = WKUserContentController()
        contentController.add(
                self,
                name: "rosefire"
        )
        let config = WKWebViewConfiguration()
        config.userContentController = contentController
        webview = WKWebView(
                frame: view.bounds,
                configuration: config
        )
        view = webview!
    }

    internal override func viewDidLoad() {
        super.viewDidLoad()

        let token = registryToken!.stringByAddingPercentEncodingForRFC3986()!
        let rosefireUrl = "https://rosefire.csse.rose-hulman.edu/webview/login?registryToken=\(token)&platform=ios"
        let url = URL(string: rosefireUrl)
        let req = URLRequest(url: url!)
        webview!.load(req)
    }

    @objc func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if(message.name == "rosefire") {
            let token = message.body as! String
            callback!(nil, RosefireResult(token: token))
//            print("THE TOKEN DATA: \(token)")
        }
    }
}

// From http://useyourloaf.com/blog/how-to-percent-encode-a-url-string/
extension String {
    func stringByAddingPercentEncodingForRFC3986() -> String? {
        let unreserved = "-._~/?"
        let allowed = NSMutableCharacterSet.alphanumeric()
        allowed.addCharacters(in: unreserved)
        return addingPercentEncoding(withAllowedCharacters: allowed as CharacterSet)
    }
}

