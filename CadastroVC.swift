//
//  CadastroVC.swift
//  SiscofaMobile
//
//  Created by Glaubert Moreira Schult on 11/06/15.
//  Copyright (c) 2015 GMS. All rights reserved.
//

import UIKit

class CadastroVC: UIViewController, UIAlertViewDelegate {

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
            
            // Print out response body
            let responseString = NSString(data: data, encoding: NSUTF8StringEncoding)
            println("responseString = \(responseString)")
            
            var alert = UIAlertController(title: "Alerta", message: "Usuário cadastrado com sucesso", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "voltar", style: UIAlertActionStyle.Default, handler: nil))
            
            var okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) {
                UIAlertAction in
                NSLog("OK Pressed")
                self.performSegueWithIdentifier("sg_voltar_login", sender: nil)
            }
            
            dispatch_async(dispatch_get_main_queue()) {
                switch responseString as String {
                    case "USUARIO_JA_CADASTRADO":
                        alert.message = "Usuário já existe!"
                        self.presentViewController(alert, animated: true, completion: nil)
                    
                    
                    case "ERRO_CADASTRO":
                        alert.message = "Erro no cadastro, contate o administrador!"
                        self.presentViewController(alert, animated: true, completion: nil)
                    
                    case "[{\"property\":\"email\",\"message\":\"Email Invalido\"}]":
                        alert.message = "Email Inválido"
                        self.presentViewController(alert, animated: true, completion: nil)
                    
                    case "USUARIO_CADASTRADO_SUCESSO":
                        var alertSucess = UIAlertController(title: "Alerta", message: "Usuário cadastrado com sucesso", preferredStyle: UIAlertControllerStyle.Alert)
                        alertSucess.addAction(okAction)
                        self.presentViewController(alertSucess, animated: true, completion: nil)
                    default:
                        println("Nao sei o que aconteceu")
                }
                
            }
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
