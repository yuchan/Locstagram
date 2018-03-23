//
//  AuthenticationWebViewController.swift
//  Locstagram
//
//  Created by Yusuke Ohashi on 2018/03/23.
//  Copyright © 2018 Yusuke Ohashi. All rights reserved.
//

import UIKit
import WebKit
import KeychainAccess
import IG

class AuthenticationWebViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.navigationDelegate = self
        // Do any additional setup after loading the view.
        if let url = IG.authenticationUrl() {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension AuthenticationWebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        guard let url = navigationAction.request.url,
            url.path == "/locstagram-callback" else {
            decisionHandler(.allow)
            return
        }

        if let params = url.query?.split(separator: "&").filter({ (substring) -> Bool in
            if String(substring).contains("code=") {
                return true
            }
            return false
        }) {
            guard params.count > 0, params[0].split(separator: "=").count > 1 else {
                decisionHandler(.cancel)
                return
            }

            let code: String = String(params[0].split(separator: "=")[1])

            IG.getAccessToken(code: code, completion: { (data, response, error) in
                if error != nil, data == nil {

                } else {
                    do {
                        let response = try IGAuthResponse(data: data!)
                        try Keychain(service: "Instagram").set(response.accessToken, key: "access_token")
                    } catch {

                    }

                    DispatchQueue.main.async {
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            })
        }

        decisionHandler(.cancel)
    }
}
