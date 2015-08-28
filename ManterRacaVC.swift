//
//  ManterRacaVC.swift
//  SiscofaMobile
//
//  Created by Glaubert Moreira Schult on 27/08/15.
//  Copyright (c) 2015 GMS. All rights reserved.
//

import UIKit

class ManterRacaVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var lbRaca: UITextField!
    @IBOutlet var tableRacas: UITableView!
    
    var arrayRacas : NSArray = []
    
    @IBAction func btSalvar(sender: AnyObject) {
        
        let raca = ["nome" : self.lbRaca.text];
        
        var alert = UIAlertController(title: "Alerta", message: "Raca cadastrada com sucesso", preferredStyle: UIAlertControllerStyle.Alert)
        
        var voltarAction = UIAlertAction(title: "voltar", style: UIAlertActionStyle.Default, handler: nil)
        
        var okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) {
            UIAlertAction in
            NSLog("OK Pressed")
            self.performSegueWithIdentifier("sg_voltar_home", sender: nil)
        }

        
        if(self.lbRaca.text == ""){
            alert.message = "Os campo raça deve ser preenchido"
            alert.addAction(voltarAction)
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }
        
        
        if NetworkHelper.isConnectedToNetwork() {
            
            var json = JSONHelper.JSONStringify(raca, prettyPrinted: false);
            
            let myUrl = NSURL(string: Configuracao.getWSURL() + "/inserirRaca");
            
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
                    case "RACA_JA_EXISTE":
                        alert.message = "Raca já foi cadastrada!"
                        alert.addAction(voltarAction)
                        self.presentViewController(alert, animated: true, completion: nil)
                        
                    case "ERRO_CADASTRO_RACA":
                        alert.message = "Erro no cadastro, contate o administrador!"
                        alert.addAction(voltarAction)
                        self.presentViewController(alert, animated: true, completion: nil)
                        
                    case "CADASTRO_RACA_SUCESSO":
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
    
    override func viewWillAppear(animated: Bool) {
        println("Vai Aparecer")
        self.tableRacas.registerClass(UITableViewCell.self, forCellReuseIdentifier: "celula")
        self.tableRacas.dataSource = self
    }
    

        
    override func viewDidLoad() {
        println("Iniciou o load")
        
        if NetworkHelper.isConnectedToNetwork() {
            
            let myUrl = NSURL(string: Configuracao.getWSURL() + "/racas");
            
            let request = NSURLRequest(URL:myUrl!);
            
            var error: NSError?
            var response : NSURLResponse?
            
            let urlData: NSData = NSURLConnection.sendSynchronousRequest(request, returningResponse: &response, error: &error)!;
            
            var erroConvertJson: NSError?
            var jsonResult: NSArray = NSJSONSerialization.JSONObjectWithData(urlData, options: NSJSONReadingOptions.MutableContainers, error: &erroConvertJson) as NSArray!
            if(erroConvertJson == nil){
                self.arrayRacas = jsonResult
                println("fez o json")
            
            } else {
                println(erroConvertJson)
            }
            
            
        } else {
            
            var alert = UIAlertController(title: "Alerta", message: "Sem conexão com a internet, tente mais tarde!", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        println(self.arrayRacas.count)
        return self.arrayRacas.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "celula")
        println(self.arrayRacas[indexPath.row]["nome"])
        cell.textLabel?.text = self.arrayRacas[indexPath.row]["nome"] as String!
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.row {
        //case 0: performSegueWithIdentifier("sg_cadastro_fazenda", sender: nil)
            
        //case 4: performSegueWithIdentifier("sg_cadastro_raca", sender: nil)
            
        default: println(indexPath.row)
        }
    }
    
    
    
    
    
    func startConnection(){
        var url: NSURL = NSURL(string: Configuracao.getWSURL() + "/racas")!;
        var request: NSURLRequest = NSURLRequest(URL: url)
        var connection: NSURLConnection = NSURLConnection(request: request, delegate: self, startImmediately: false)!
        connection.start()
    }
    
    func connection(connection: NSURLConnection!, didReceiveData data: NSData!){
        //self.data.appendData(data)
    }
    
    func connectionDidFinishLoading(connection: NSURLConnection!) {
        var err: NSError
        // throwing an error on the line below (can't figure out where the error message is)
       // var jsonResult: NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) as NSDictionary
        //println(jsonResult)
    }
}
