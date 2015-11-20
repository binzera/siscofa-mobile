//
//  SiscofaHomeVC.swift
//  SiscofaMobile
//
//  Created by Glaubert Moreira Schult on 19/06/15.
//  Copyright (c) 2015 GMS. All rights reserved.
//

import UIKit

class SiscofaHomeVC: UIViewController, UITableViewDelegate {
    
    var menu = ["Cadastrar Fazenda", "Cadastrar Lote", "Cadastrar Movimentação", "Cadastrar Tipo Movimentação", "Cadastrar Raça", "Cadastrar Idade"];
    
    override func viewDidLoad() {
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menu.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "myCell")
        
        cell.textLabel?.text = menu[indexPath.row]
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.row {
            case 0: performSegueWithIdentifier("sg_cadastro_fazenda", sender: nil)
            
            case 1: performSegueWithIdentifier("sg_cadastro_lote", sender: nil)
            
            case 4: performSegueWithIdentifier("sg_cadastro_raca", sender: nil)
            
            default: print(indexPath.row)
        }
    }

}
