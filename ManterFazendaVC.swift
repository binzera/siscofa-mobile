//
//  ManterFazendaVC.swift
//  SiscofaMobile
//
//  Created by Glaubert Moreira Schult on 07/06/15.
//  Copyright (c) 2015 GMS. All rights reserved.
//

import UIKit

class ManterFazendaVC: UIViewController, UIAlertViewDelegate {
    
    @IBOutlet var tfNomeFaz: UITextField!
    @IBOutlet var tfAlqueires: UITextField!
    
    @IBAction func cadastrarFazenda(sender: AnyObject) {
        


        
        let fazenda = ["nome" : self.tfNomeFaz.text,
            "qtdAlqueires" : self.tfAlqueires.text,
            "usuario": NSUserDefaults.standardUserDefaults().objectForKey("usuario")!]
        
        var alert = UIAlertController(title: "Alerta", message: "Fazenda cadastrada com sucesso", preferredStyle: UIAlertControllerStyle.Alert)
        var voltarAction = UIAlertAction(title: "voltar", style: UIAlertActionStyle.Default, handler: nil)
        var okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) {
            UIAlertAction in
            NSLog("OK Pressed")
            self.performSegueWithIdentifier("sg_voltar_home", sender: nil)
        }
        
        
        if(self.tfNomeFaz.text == "" || self.tfAlqueires.text == ""){
            alert.message = "Os campos nome e alqueires devem ser preenchidos"
            alert.addAction(voltarAction)
            self.presentViewController(alert, animated: true, completion: nil)
            return
            
        }
        
        if NetworkHelper.isConnectedToNetwork() {
            
            var json = JSONHelper.JSONStringify(fazenda, prettyPrinted: false);
            
            let myUrl = NSURL(string: Configuracao.getWSURL() + "/cadastrarFazenda");
            
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
                
                
                dispatch_async(dispatch_get_main_queue()) {
                    switch responseString as String {
                        case "FAZ_JA_EXISTE":
                            alert.message = "Fazenda já foi cadastrada!"
                            alert.addAction(voltarAction)
                            self.presentViewController(alert, animated: true, completion: nil)
                            
                        case "ERRO_CADASTRO_FAZ":
                            alert.message = "Erro no cadastro, contate o administrador!"
                            alert.addAction(voltarAction)
                            self.presentViewController(alert, animated: true, completion: nil)
                            
                        case "CADASTRO_FAZ_SUCESSO":
                            alert.addAction(okAction)
                            self.presentViewController(alert, animated: true, completion: nil)
                        default:
                            println("Nao sei o que aconteceu")
                    }
                }
                
                }
            
            
            task.resume()
            
            
        } else {
            var alert = UIAlertController(title: "Alerta", message: "Sem conexão com a internet, tente mais tarde!", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }

    }
    
//    func alertView(view :UIAlertView, clickedButtonAtIndex :Integer) -> Void {
//        switch clickedButtonAtIndex {
//        }
//    }
    
    
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