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
        
        var alert = UIAlertController(title: "Alerta", message: "", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        
        if(tfUser.text == "" || tfSenha.text == ""){
            alert.message = "Usuário e senha devem ser preenchidos!"
            self.presentViewController(alert, animated: true, completion: nil)
            return
            
        }
        
        
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
                
                dispatch_async(dispatch_get_main_queue()) {
                
                    var erroConvertJson: NSError?
                    var jsonResult: AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &erroConvertJson)
                    if(erroConvertJson == nil){
                        println(jsonResult)
                        NSUserDefaults.standardUserDefaults().setObject(jsonResult, forKey: "usuario")
                        self.performSegueWithIdentifier("tabBarHome", sender: nil)
                        
                    } else {
                            
                        switch responseString as String {
                            
                            case "USER_NAO_CADASTRADO":
                                alert.message = "Usuário não cadastrado"
                                self.presentViewController(alert, animated: true, completion: nil)
                            
                            case "SENHA_INCORRETA":
                                //Criei outra forma de alert para testar a diferenca entre elas
                                var alerta = UIAlertController(title: "Alerta", message: "Senha nao confere.", preferredStyle: UIAlertControllerStyle.Alert)
                            
                                alerta.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
                                
                                    self.dismissViewControllerAnimated(true, completion: nil)
                                
                                }))
                            
                                self.presentViewController(alerta, animated: true, completion: nil)
                            
                            
                            default:
                                alert.message = "O Servidor retornou algo inesperado, contate o administrador"
                                self.presentViewController(alert, animated: true, completion: nil)
                                println("Nao sei o que aconteceu, o retorno foi:  \(responseString)")
                            
                        }
                    }
                }
                
            }
            
            task.resume()
            
        } else {
            alert.message = "Sem conexão com a internet! Tente mais tarde."
            self.presentViewController(alert, animated: true, completion: nil)
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
