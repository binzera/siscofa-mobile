//
//  LoginVC.swift
//  SiscofaMobile
//
//  Created by Glaubert Moreira Schult on 10/06/15.
//  Copyright (c) 2015 GMS. All rights reserved.
//

import UIKit


class LoginVC: UIViewController {
    
    @IBOutlet var tfUser: UITextField!
    @IBOutlet var tfSenha: UITextField!

    
    
    @IBAction func logar(sender: AnyObject) {
        if NetworkHelper.isConnectedToNetwork() {
            var usuario = [ "usuario": tfUser.text,
                "senha": tfSenha.text]
            
            var json = JSONHelper.JSONStringify(usuario, prettyPrinted: false)
            
            let url = NSURL(string: Configuracao.getWSURL() + "/logar")
            let request = NSMutableURLRequest(URL:url!);
            
            request.HTTPMethod = "POST";
            request.HTTPBody = json.dataUsingEncoding(NSUTF8StringEncoding);
            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type");
            
            let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
                data, response, error in
                
                if error != nil
                {
                    println("error=\(error)")
                    return
                }
                
                
                // Print out response body
                let responseString = NSString(data: data, encoding: NSUTF8StringEncoding)
                println("responseString = \(responseString)")
                
                dispatch_async(dispatch_get_main_queue()) {
                
                if responseString == "OK" {
                    self.performSegueWithIdentifier("tabBarHome", sender: nil)
                    
                }
                
                if responseString == "USER_NAO_CADASTRADO" {
                    var alert = UIAlertController(title: "Alerta", message: "Usuario nao cadastrado", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                }
                
                if responseString == "SENHA_INCORRETA" {
                    var alerta = UIAlertController(title: "Alerta", message: "Senha nao confere.", preferredStyle: UIAlertControllerStyle.Alert)
                    
                    alerta.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
                        
                        self.dismissViewControllerAnimated(true, completion: nil)
                        
                    }))
                    
                    self.presentViewController(alerta, animated: true, completion: nil)
                }
                }
                
            }
            
            task.resume()
            
        }
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
    }
    
    override func viewDidAppear(animated: Bool) {
       
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
