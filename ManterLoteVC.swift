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
    
    var idadePicker: UIPickerView!
    var racaPicker: UIPickerView!
    
    var idadePickerValues: NSArray = []
    var racasPickerValues: NSArray = []
    
    var tag = "raca"
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int{
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        if(tag == "raca") {
            return racasPickerValues.count
        } else {
            return idadePickerValues.count
        }
        
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        if(tag == "raca") {
            return racasPickerValues[row]["nome"] as String
        } else {
            return idadePickerValues[row]["descricao"] as String
        }
        
    }
    
    func pickerView(pickerView: UIPickerView!, didSelectRow row: Int, inComponent component: Int){
        if(tag == "raca") {
            racaTextField.text = self.racasPickerValues[row]["nome"] as String
            self.view.endEditing(true)
        } else {
            idadeTextField.text = self.idadePickerValues[row]["descricao"] as String
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

    
    @IBAction func racaBeginEdit(sender: AnyObject) {
        self.carregarArrayRacas()
        self.racaPicker = UIPickerView()
        racaPicker.dataSource = self
        racaPicker.delegate = self
        racaTextField.inputView = racaPicker
        tag = "raca"
        
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //idadeTextField.text = idadePickerValues[0]
    }
    
    
    func carregarArrayRacas () {
        if NetworkHelper.isConnectedToNetwork() {
            
            let myUrl = NSURL(string: Configuracao.getWSURL() + "/racas");
            
            let request = NSURLRequest(URL:myUrl!);
            
            var error: NSError?
            var response : NSURLResponse?
            
            let urlData: NSData = NSURLConnection.sendSynchronousRequest(request, returningResponse: &response, error: &error)!;
            
            var erroConvertJson: NSError?
            
            var jsonResult: NSArray = NSJSONSerialization.JSONObjectWithData(urlData, options: NSJSONReadingOptions.MutableContainers, error: &erroConvertJson) as NSArray!
            if(erroConvertJson == nil){
                self.racasPickerValues = jsonResult

            } else {
                println(erroConvertJson)
            }
            
            
        } else {
            
            var alert = UIAlertController(title: "Alerta", message: "Sem conexão com a internet, tente mais tarde!", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }

        
    }
    
    func carregarArrayIdades(){
        if NetworkHelper.isConnectedToNetwork() {
            
            let myUrl = NSURL(string: Configuracao.getWSURL() + "/idades");
            
            let request = NSURLRequest(URL:myUrl!);
            
            var error: NSError?
            var response : NSURLResponse?
            
            let urlData: NSData = NSURLConnection.sendSynchronousRequest(request, returningResponse: &response, error: &error)!;
            
            var erroConvertJson: NSError?

            var jsonResult: NSArray = NSJSONSerialization.JSONObjectWithData(urlData, options: NSJSONReadingOptions.MutableContainers, error: &erroConvertJson) as NSArray!
            if(erroConvertJson == nil){
                self.idadePickerValues = jsonResult
                
//                if jsonResult.count > 0 {
//                    for valor in jsonResult {
//                        var descricao : String = valor["descricao"] as String
//                        self.idadePickerValues.append(descricao)
//                    }
//                    
//                }
            } else {
                println(erroConvertJson)
            }
            
            
        } else {
            
            var alert = UIAlertController(title: "Alerta", message: "Sem conexão com a internet, tente mais tarde!", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }

    }

}
