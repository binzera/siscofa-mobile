//
//  ManterLoteVC.swift
//  SiscofaMobile
//
//  Created by Glaubert Moreira Schult on 30/08/15.
//  Copyright (c) 2015 GMS. All rights reserved.
//

import UIKit

class ManterLoteVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet var racaTextField: UITextField!
    @IBOutlet var idadeTextField: UITextField!
    @IBOutlet var sexoOutlet: UISegmentedControl!
    @IBOutlet var tfQuantidade: UITextField!
    @IBOutlet var tfArrobas: UITextField!
    @IBOutlet var tfFazenda: UITextField!
    
    var idadePicker: UIPickerView!
    var racaPicker: UIPickerView!
    var fazendaPicker: UIPickerView!
    
    var idadePickerValues: NSArray = []
    var racasPickerValues: NSArray = []
    var fazendaPickerValues: NSArray = []
    
    var idadeSelecionado = 0
    var fazendaSelecionado = 0
    var racaSelecionado = 0
    
    var tag = "raca"
    
    let alertaClasse = UIAlertController(title: "Alerta", message: "Lote Cadastrado com sucesso!", preferredStyle: UIAlertControllerStyle.Alert)
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int{
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        if(tag == "raca") {
            return racasPickerValues.count
        }
        if tag == "idade" {
            return idadePickerValues.count
        }
        if tag == "fazenda" {
            return fazendaPickerValues.count
        }
        return 1;
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String {
        if(tag == "raca") {
            return racasPickerValues[row]["nome"] as! String
        }
        if tag == "idade" {
            return idadePickerValues[row]["descricao"] as! String
        }
        if tag == "fazenda" {
            return fazendaPickerValues[row]["nome"] as! String
        }
        return ""
        
    }
    
    func pickerView(pickerView: UIPickerView!, didSelectRow row: Int, inComponent component: Int){
        if(tag == "raca") {
            racaTextField.text = self.racasPickerValues[row]["nome"] as! String
            self.view.endEditing(true)
        }
        if tag == "idade" {
            idadeTextField.text = self.idadePickerValues[row]["descricao"] as! String
            self.view.endEditing(true)
        }
        if tag == "fazenda" {
            tfFazenda.text = self.fazendaPickerValues[row]["nome"] as! String
            self.view.endEditing(true)
        }
        
    }
    
 
    
    @IBAction func idadeBeginEdit(sender: AnyObject) {
        self.carregarArrayIdades()
        self.idadePicker = UIPickerView()
        idadePicker.dataSource = self
        idadePicker.delegate = self
        idadeTextField.inputView = idadePicker
        tag = "idade"
    }

    @IBAction func idadeEndEdit(sender: AnyObject) {
        self.idadeSelecionado = idadePicker.selectedRowInComponent(0)
    }

    @IBAction func racaEndEdit(sender: AnyObject) {
        self.racaSelecionado = racaPicker.selectedRowInComponent(0)
    }
    
    @IBAction func fazendaEndEdit(sender: AnyObject) {
        self.fazendaSelecionado = fazendaPicker.selectedRowInComponent(0)
    }
    
    @IBAction func racaBeginEdit(sender: AnyObject) {
        self.carregarArrayRacas()
        self.racaPicker = UIPickerView()
        racaPicker.dataSource = self
        racaPicker.delegate = self
        racaTextField.inputView = racaPicker
        tag = "raca"
        
    }
    
    @IBAction func fazendaBeginEdit(sender: AnyObject) {
        self.carregarArrayFazendas()
        self.fazendaPicker = UIPickerView()
        fazendaPicker.dataSource = self
        fazendaPicker.delegate = self
        tfFazenda.inputView = fazendaPicker
        tag = "fazenda"
    }
    
    @IBAction func salvar(sender: AnyObject) {
        
       //validarCamposFormulario()
        var sexo = "M"
        if(self.sexoOutlet.selectedSegmentIndex == 1) {
            sexo = "F"
        }
        
        if NetworkHelper.isConnectedToNetwork() {
            
            let usuario: Dictionary<String,AnyObject> = NSUserDefaults.standardUserDefaults().objectForKey("usuario") as! Dictionary<String,AnyObject>
    
            let lote = (qtdGado: tfQuantidade.text,
                sexo: sexo,
                qtdArrobas: tfArrobas.text,
                valorArroba: 0,
                fazenda: self.fazendaPickerValues[self.fazendaSelecionado],
                racaGado: self.racasPickerValues[self.racaSelecionado],
                idade: self.idadePickerValues[self.idadeSelecionado],
                usuario: usuario) as! AnyObject;
            
            let json = JSONHelper.JSONStringify(lote, prettyPrinted: false);
            print(json)
            
            let url = NSURL(string: Configuracao.getWSURL() + "/cadastrarLote")
            let request = NSMutableURLRequest(URL:url!);
            
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
                
                dispatch_async(dispatch_get_main_queue()) {
                    
                    let voltarAction = UIAlertAction(title: "voltar", style: UIAlertActionStyle.Default, handler: nil)
                    let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) {
                        UIAlertAction in
                        NSLog("OK Pressed")
                        self.performSegueWithIdentifier("sg_voltar_home", sender: nil)
                    }
                        
                    switch responseString as! String {
                        
                        case "LOTE_JA_EXISTE":
                            self.alertaClasse.message = "Fazenda já foi cadastrada!"
                            self.alertaClasse.addAction(voltarAction)
                            self.presentViewController(self.alertaClasse, animated: true, completion: nil)
                            
                        case "ERRO_CADASTRO_LOTE":
                            self.alertaClasse.message = "Erro no cadastro, contate o administrador!"
                            self.alertaClasse.addAction(voltarAction)
                            self.presentViewController(self.alertaClasse, animated: true, completion: nil)
                            
                        case "CADASTRO_LOTE_SUCESSO":
                            self.alertaClasse.addAction(okAction)
                            self.presentViewController(self.alertaClasse, animated: true, completion: nil)
                        default:
                            print("Nao sei o que aconteceu")
                    }
                        
                }
            
            }
            
            task.resume()
            
        } else {
            self.alertaClasse.message = "Sem conexão com a internet! Tente mais tarde."
            self.presentViewController(self.alertaClasse, animated: true, completion: nil)
        }

    
    }
    
    func validarCamposFormulario(){
        if(tfQuantidade.text == "" || racaTextField.text == ""){
            self.alertaClasse.message = "Usuário e senha devem ser preenchidos!"
            self.presentViewController(alertaClasse, animated: true, completion: nil)
            return
    
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    func carregarArrayRacas () {
        if NetworkHelper.isConnectedToNetwork() {
            
            let myUrl = NSURL(string: Configuracao.getWSURL() + "/racas");
            
            let request = NSURLRequest(URL:myUrl!);
            
            var response : NSURLResponse?
            
            if let httpResponse = response as? NSHTTPURLResponse {
                if httpResponse.statusCode == 200 {
            
                    do  {
                        let urlData: NSData = try NSURLConnection.sendSynchronousRequest(request, returningResponse: &response);
                        
                        let jsonResult: NSArray = try NSJSONSerialization.JSONObjectWithData(urlData, options: .AllowFragments) as! NSArray
                        
                        self.racasPickerValues = jsonResult
                        
                        print("fez o json")
                        
                    } catch {
                        print("Erro na conversao do JSON")
                    }
                }
            } else {
                let alert = UIAlertController(title: "Alerta", message: "Erro ao carregar raças, contate adm!", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
            
            
        } else {
            
            let alert = UIAlertController(title: "Alerta", message: "Sem conexão com a internet, tente mais tarde!", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }

        
    }
    
    func carregarArrayIdades(){
        if NetworkHelper.isConnectedToNetwork() {
            
            let myUrl = NSURL(string: Configuracao.getWSURL() + "/idades");
            
            let request = NSURLRequest(URL:myUrl!);
            
            var response : NSURLResponse?
            
            if let httpResponse = response as? NSHTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    
                    do  {
                        let urlData: NSData = try NSURLConnection.sendSynchronousRequest(request, returningResponse: &response);
                        
                        let jsonResult: NSArray = try NSJSONSerialization.JSONObjectWithData(urlData, options: .AllowFragments) as! NSArray
                        
                        self.racasPickerValues = jsonResult
                        
                        print("fez o json")
                        
                    } catch {
                        print("Erro na conversao do JSON")
                    }
                }
            } else {
                let alert = UIAlertController(title: "Alerta", message: "Erro ao carregar Idades, contate adm.", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
            
            
        } else {
            
            let alert = UIAlertController(title: "Alerta", message: "Sem conexão com a internet, tente mais tarde!", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }

    }
    
    func carregarArrayFazendas () {
        if NetworkHelper.isConnectedToNetwork() {
            
            var usuario: AnyObject? = NSUserDefaults.standardUserDefaults().objectForKey("usuario")
            
            var json = JSONHelper.JSONStringify(usuario!, prettyPrinted: true)
            
            let url = NSURL(string: Configuracao.getWSURL() + "/fazendasOfUser")
            let request = NSMutableURLRequest(URL:url!);
            
            request.HTTPMethod = "POST";
            request.HTTPBody = json.dataUsingEncoding(NSUTF8StringEncoding);
            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type");
            
            var response : NSURLResponse?
            
            if let httpResponse = response as? NSHTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    
                    do  {
                        let urlData: NSData = try NSURLConnection.sendSynchronousRequest(request, returningResponse: &response);
                        
                        let jsonResult: NSArray = try NSJSONSerialization.JSONObjectWithData(urlData, options: .AllowFragments) as! NSArray
                        
                        self.fazendaPickerValues = jsonResult
                        
                        print("fez o json")
                        
                    } catch {
                        print("Erro na conversao do JSON")
                    }
                }
            } else {
                let alert = UIAlertController(title: "Alerta", message: "Erro ao carregar Fazendas, contate adm.", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
            
        } else {
            
            var alert = UIAlertController(title: "Alerta", message: "Sem conexão com a internet, tente mais tarde!", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
        
        
    }

}
