//
//  ManterMovimentacaoVC.swift
//  SiscofaMobile
//
//  Created by Glaubert Moreira Schult on 13/12/15.
//  Copyright © 2015 GMS. All rights reserved.
//

import Foundation


import UIKit

class ManterMovimentacaoVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource
{
    
    @IBOutlet var tfTipoMov: UITextField!
    @IBOutlet var tfFazenda: UITextField!
    @IBOutlet var tfQtdGado: UITextField!
    @IBOutlet var sexo: UISegmentedControl!
    @IBOutlet var qtdArrobas: UITextField!
    @IBOutlet var tfValorArroba: UITextField!
    
    var fazendaPicker: UIPickerView!
    var tipoMoviPicker: UIPickerView!
    
    var fazendaPickerValues: NSArray = []
    var tipoMoviPickerValues: NSArray = []
    
    var tipoMovSelecionado = 0
    var fazendaSelecionado = 0
    
    let alertaClasse = UIAlertController(title: "Alerta", message: "Movimentação cadastrada com sucesso!", preferredStyle: UIAlertControllerStyle.Alert)
    
    var tag = "Fazenda"
    
    
    @IBAction func tipoMovBeginEdit(sender: AnyObject) {
        self.carregarArrayTipoMovi()
        self.tipoMoviPicker = UIPickerView()
        tipoMoviPicker.dataSource = self
        tipoMoviPicker.delegate = self
        tfTipoMov.inputView = tipoMoviPicker
        tag = "tipoMovi"
    }
    
    @IBAction func tipoMovEndEdit(sender: AnyObject) {
        self.tipoMovSelecionado = tipoMoviPicker.selectedRowInComponent(0)
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int{
        return 1
    }
    
    @IBAction func fazendaBeginEdit(sender: AnyObject) {
        self.carregarArrayFazendas()
        self.fazendaPicker = UIPickerView()
        fazendaPicker.dataSource = self
        fazendaPicker.delegate = self
        tfFazenda.inputView = fazendaPicker
        tag = "fazenda"
    }
    
    @IBAction func fazendaEndEdit(sender: AnyObject) {
        self.fazendaSelecionado = fazendaPicker.selectedRowInComponent(0)
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        if tag == "tipoMovi" {
            return tipoMoviPickerValues.count
        }
        if tag == "fazenda" {
            return fazendaPickerValues.count
        }
        return 1;
    }
    
    @IBAction func salvarMovimentacao(sender: AnyObject) {
        
        var sexo = "M"
        if(self.sexo.selectedSegmentIndex == 1) {
            sexo = "F"
        }
        
        if NetworkHelper.isConnectedToNetwork() {
            
            let usuario: Dictionary<String,AnyObject> = NSUserDefaults.standardUserDefaults().objectForKey("usuario") as! Dictionary<String,AnyObject>
            
            let movimentacao : [String : AnyObject] =
            [
                "qtdGado": tfQtdGado.text!,
                "sexo": sexo,
                "qtdArrobas": self.qtdArrobas.text!,
                "valorArroba": self.tfValorArroba.text!,
                "fazenda": self.fazendaPickerValues[self.fazendaSelecionado],
                "tipoMovimentacao": self.tipoMoviPickerValues[self.tipoMovSelecionado],
                "usuario": usuario
            ]
            
            let json = JSONHelper.JSONStringify(movimentacao, prettyPrinted: false);
            print(json)
            
            let url = NSURL(string: Configuracao.getWSURL() + "/cadastrarMovimentacao")
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
                        self.performSegueWithIdentifier("sg_voltar_home", sender: nil)
                    }
                    
                    switch responseString as! String {
                        
                        case "ERRO_CADASTRO_MOV":
                            self.alertaClasse.message = "Erro no cadastro, contate o administrador!"
                            self.alertaClasse.addAction(voltarAction)
                            self.presentViewController(self.alertaClasse, animated: true, completion: nil)
                            
                        case "CADASTRO_MOV_SUCESSO":
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
    
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if tag == "tipoMovi" {
            return tipoMoviPickerValues[row]["descricao"] as? String
        }
        if tag == "fazenda" {
            return fazendaPickerValues[row]["nome"] as? String
        }
        return ""
        
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        if tag == "tipoMovi" {
            tfTipoMov.text = self.tipoMoviPickerValues[row]["descricao"] as? String
            self.view.endEditing(true)
        }
        if tag == "fazenda" {
            tfFazenda.text = self.fazendaPickerValues[row]["nome"] as? String
            self.view.endEditing(true)
        }
        
    }
    
    
    func carregarArrayTipoMovi() {
        if NetworkHelper.isConnectedToNetwork() {
            
            let url = NSURL(string: Configuracao.getWSURL() + "/tipoMovimentacoes")
            let request = NSMutableURLRequest(URL:url!);
            
            
            var response : NSURLResponse?
            
            do  {
                let urlData: NSData = try NSURLConnection.sendSynchronousRequest(request, returningResponse: &response);
                
                let jsonResult: NSArray = try NSJSONSerialization.JSONObjectWithData(urlData, options: .AllowFragments) as! NSArray
                
                self.tipoMoviPickerValues = jsonResult
                
            } catch {
                
                let alert = UIAlertController(title: "Alerta", message: "Erro ao carregar tipo movimentacoes, contate adm.", preferredStyle: UIAlertControllerStyle.Alert)
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
            
            let usuario: AnyObject? = NSUserDefaults.standardUserDefaults().objectForKey("usuario");
            
            let json = JSON(usuario!);
            print(json)
            
            let url = NSURL(string: Configuracao.getWSURL() + "/fazendasOfUser");
            let request = NSMutableURLRequest(URL:url!);
            
            request.HTTPMethod = "POST";
            request.HTTPBody = try! json.rawData();
            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type");
            
            var response : NSURLResponse?
            
            do  {
                let urlData: NSData = try NSURLConnection.sendSynchronousRequest(request, returningResponse: &response);
                
                let jsonResult: NSArray = try NSJSONSerialization.JSONObjectWithData(urlData, options: .AllowFragments) as! NSArray
                
                self.fazendaPickerValues = jsonResult
                
            } catch {
                print("Erro na conversao do JSON")
                let alert = UIAlertController(title: "Alerta", message: "Erro ao carregar Fazendas, contate adm.", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
            
        } else {
            
            let alert = UIAlertController(title: "Alerta", message: "Sem conexão com a internet, tente mais tarde!", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
        
        
    }

    
}