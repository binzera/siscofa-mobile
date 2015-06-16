//
//  CadastroVC.swift
//  SiscofaMobile
//
//  Created by Glaubert Moreira Schult on 11/06/15.
//  Copyright (c) 2015 GMS. All rights reserved.
//

import UIKit

class CadastroVC: UIViewController {

    @IBOutlet var lbNome: UITextField!
    @IBOutlet var lbEmail: UITextField!
    @IBOutlet var lbUser: UITextField!
    @IBOutlet var lbSenha: UITextField!

    
    @IBAction func cadastrarUsuario(sender: AnyObject) {
        var usuario = ["nome" : lbNome.text,
                    "email" : lbEmail.text,
                    "usuario": lbUser.text,
                    "senha": lbSenha.text]
        
        var json = JSONHelper.JSONStringify(usuario, prettyPrinted: false);
        
        let myUrl = NSURL(string: Configuracao.getWSURL() + "/cadastrarUsuario");
        
        let request = NSMutableURLRequest(URL:myUrl!);
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
            
            // You can print out response object
            println("response = \(response)")
            
            // Print out response body
            let responseString = NSString(data: data, encoding: NSUTF8StringEncoding)
            println("responseString = \(responseString)")
            
            //Let's convert response sent from a server side script to a NSDictionary object:
            
            var err: NSError?
            var myJSON = NSJSONSerialization.JSONObjectWithData(data, options: .MutableLeaves, error:&err) as? NSDictionary
            
        }
        
        task.resume()
        
        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
