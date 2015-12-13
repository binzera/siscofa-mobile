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
        let usuario = ["nome" : lbNome.text,
            "email" : lbEmail.text,
            "usuario": lbUser.text,
            "senha": lbSenha.text]
        
        let json = JSONHelper.JSONStringify(usuario as! AnyObject, prettyPrinted: false);
        
        let myUrl = NSURL(string: Configuracao.getWSURL() + "/cadastrarUsuario");
        
        let request = NSMutableURLRequest(URL:myUrl!);
        request.HTTPMethod = "POST";
        
        request.HTTPBody = json.dataUsingEncoding(NSUTF8StringEncoding);
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type");
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            
            if error != nil
            {
                print("error=\(error)")
                return
            }
            
            // Print out response body
            let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
            print("responseString = \(responseString)")
            
            let alert = UIAlertController(title: "Alerta", message: "Usuário cadastrado com sucesso", preferredStyle: UIAlertControllerStyle.Alert)
            
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) {
                UIAlertAction in
                self.performSegueWithIdentifier("sg_voltar_login", sender: nil)
            }
            
            _ = UIAlertAction(title: "voltar", style: UIAlertActionStyle.Default, handler: nil)
            
            dispatch_async(dispatch_get_main_queue()) {
                switch responseString as! String {
                case "USUARIO_JA_CADASTRADO":
                    alert.message = "Usuário já existe!"
                    alert.addAction(UIAlertAction(title: "voltar", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                    
                    
                case "ERRO_CADASTRO":
                    alert.message = "Erro no cadastro, contate o administrador!"
                    alert.addAction(UIAlertAction(title: "voltar", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                    
                case "[{\"property\":\"email\",\"message\":\"Email Invalido\"}]":
                    alert.message = "Email Inválido"
                    alert.addAction(UIAlertAction(title: "voltar", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                    
                case "USUARIO_CADASTRADO_SUCESSO":
                    alert.addAction(okAction)
                    self.presentViewController(alert, animated: true, completion: nil)
                default:
                    print("Nao sei o que aconteceu, o retorno foi:  \(responseString)")
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
