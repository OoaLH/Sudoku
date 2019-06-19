//
//  ViewController.swift
//  Sudoku
//
//  Created by 张翌璠 on 9/11/18.
//  Copyright © 2018 张翌璠. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        
        end.text="start!"
        
        generate()
        
        generateview()
       super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    var number=[6,3,7,1,5,8,4,2,9,4,2,5,6,7,9,1,3,8,8,9,1,2,3,4,6,5,7,2      ,6,4,9,8,5,3,7,1,5,7,8,3,6,1,9,4,2,3,1,9,4,2,7,5,8,6,7,4,6,8,1,3,2,9,5,9,5,2,7,4,6,8,1,3,1,8,3,5,9,2,7,6,4]
    var collection=Array(repeating: 0, count: 9)
    var display=Array(repeating: 0, count: 81)
    var finished=Array(repeating: 0, count: 81)
    var red=1
    var judge=Array(repeating: true, count: 81)
    var flag=0
    @IBOutlet weak var end: UILabel!
    func generate(){
        for i in 0..<9{
            collection[i]=Int(arc4random_uniform(9)+1)
            check(tag:i)
            
        }
        
        for i in 0..<81{
            if number[i]==1{
                number[i]=collection[0]
                
            }
            else if number[i]==2{
                number[i]=collection[1]
                
            }
            else if number[i]==3{
                number[i]=collection[2]
                
            }
            else if number[i]==4{
                number[i]=collection[3]
                
            }
            else if number[i]==5{
                number[i]=collection[4]
                
            }
            else if number[i]==6{
                number[i]=collection[5]
                
            }
            else if number[i]==7{
                number[i]=collection[6]
                
            }
            else if number[i]==8{
                number[i]=collection[7]
                
            }
            else if number[i]==9{
                number[i]=collection[8]
                
            }
        }
        var row1=Int(arc4random_uniform(2)+4)
        var row2=Int(arc4random_uniform(2)+4)
        var line1=Int(arc4random_uniform(2)+4)
        var line2=Int(arc4random_uniform(2)+4)
        converse1(row1:row1,row2:row2)
        converse2(line1: line1, line2: line2)
        row1=Int(arc4random_uniform(2)+1)
        row2=Int(arc4random_uniform(2)+1)
        line1=Int(arc4random_uniform(2)+1)
        line2=Int(arc4random_uniform(2)+1)
        converse1(row1:row1,row2:row2)
        converse2(line1: line1, line2: line2)
        row1=Int(arc4random_uniform(2)+7)
        row2=Int(arc4random_uniform(2)+7)
        line1=Int(arc4random_uniform(2)+7)
        line2=Int(arc4random_uniform(2)+7)
        converse1(row1:row1,row2:row2)
        converse2(line1: line1, line2: line2)
        for i in 0..<81{
            let k = Int(arc4random_uniform(2))
            if k == 0{
                display[i]=number[i]
            }
        }
    }

    func check(tag:Int){
        for j in 0..<tag{
            if collection[tag]==collection[j]{
                collection[tag]=Int(arc4random_uniform(9)+1)
                check(tag:tag)
            }
        }
    }
    func converse1(row1:Int,row2:Int){
        
        for i in (row1-1)*9..<(row1-1)*9+9{
            let j=i+(row2-row1)*9
            let k=number[i]
            number[i]=number[j]
            number[j]=k
            
        }
    }
    func converse2(line1:Int,line2:Int){
        for i in 0..<9{
            let k=number[i*9+line1]
            number[i*9+line1]=number[i*9+line2]
            number[i*9+line2]=k
        }
    }
    
    @IBAction func fill(_ sender: UIButton) {
        let button = UIButton(type:.system)
        button.frame=CGRect(x: 7+((red-1)%9)*40, y: 135+((red-1)/9-1)*40, width: 40, height: 40)
        button.backgroundColor = UIColor.white
        button.layer.borderColor = UIColor.red.cgColor
        button.layer.borderWidth = 2
        button.tag=red
        button.setTitle(sender.title(for: .normal), for: .normal)
        
        
        display[red-1]=Int(button.title(for: .normal)!)!
        button.addTarget(self, action: #selector(tap), for: .touchUpInside)
        judge[button.tag-1]=checkall(place:button.tag-1)
        if judge[button.tag-1] == false{
            button.setTitleColor(UIColor.red,for: .normal)
        }
        else    {
            button.setTitleColor(UIColor.black,for: .normal)
            for x in 0..<81{
                if display[x] != 0{
                    flag+=1
                }
            }
            if flag==81{
               end.text="you win!"
            }
            flag=0
        }
        finished[red-1]=1
        self.view.addSubview(button)
        
    }
    func checkall(place:Int)->Bool{
        let i = place/9
        let j = place%9
        
      
        for x in 0..<81{
            if (x/9==i||x%9==j)&&(x != place){
                if display[place]==display[x]{
                    
                    return false
                }
            }
            
        }
        if (i==0||i==3||i==6)&&(j==0||j==3||j==6){
            if display[place]==display[place+10]||display[place]==display[place+11]||display[place]==display[place+19]||display[place]==display[place+20]{
                return false
            }
        }
        else if (i==0||i==3||i==6)&&(j==1||j==4||j==7){
            if display[place]==display[place+10]||display[place]==display[place+17]||display[place]==display[place+8]||display[place]==display[place+19]{
                return false
            }
        }
        else if (i==0||i==3||i==6)&&(j==2||j==5||j==8){
            if display[place]==display[place+8]||display[place]==display[place+17]||display[place]==display[place+7]||display[place]==display[place+16]{
                return false
            }
        }
        else if (i==1||i==4||i==7)&&(j==0||j==3||j==6){
            if display[place]==display[place-8]||display[place]==display[place-7]||display[place]==display[place+10]||display[place]==display[place+11]{
                return false
            }
        }
        else if (i==1||i==4||i==7)&&(j==1||j==4||j==7){
            if display[place]==display[place+10]||display[place]==display[place+8]||display[place]==display[place-8]||display[place]==display[place-10]{
                return false
            }
        }
        else if (i==1||i==4||i==7)&&(j==2||j==5||j==8){
            if display[place]==display[place+8]||display[place]==display[place+7]||display[place]==display[place-11]||display[place]==display[place-10]{
                return false
            }
        }
        else if (i==2||i==5||i==8)&&(j==2||j==5||j==8){
            if display[place]==display[place-20]||display[place]==display[place-19]||display[place]==display[place-11]||display[place]==display[place-10]{
                return false
            }
        }
        else if (i==2||i==5||i==8)&&(j==1||j==4||j==7){
            if display[place]==display[place-17]||display[place]==display[place-19]||display[place]==display[place-8]||display[place]==display[place-10]{
                return false
            }
        }
        else if (i==2||i==5||i==8)&&(j==0||j==3||j==6){
            if display[place]==display[place-8]||display[place]==display[place-7]||display[place]==display[place-17]||display[place]==display[place-16]{
                return false
            }
        }
        return true
    }
    @IBAction func start(_ sender: UIButton) {
        clearview()
        end.text="start!"
        display=Array(repeating: 0, count: 81)
        finished=Array(repeating: 0, count: 81)
        judge=Array(repeating: true, count: 81)
        red=1
        generate()
        generateview()
    }
    func clearview() {
        for v in self.view.subviews as [UIView] {
            for index in 1..<82{
                v.viewWithTag(index)?.removeFromSuperview()
            }}
    }
    func generateview(){
        for buttontag in 1..<82{
            
            let button = UIButton(type:.system)
            button.frame=CGRect(x: 7+((buttontag-1)%9)*40, y: 135+((buttontag-1)/9-1)*40, width: 40, height: 40)
            button.backgroundColor = UIColor.white
            button.layer.borderColor = UIColor.blue.cgColor
            button.layer.borderWidth = 1
            if display[buttontag-1] != 0{
                button.setTitle(String(display[buttontag-1]), for: .normal)
                button.setTitleColor(UIColor.blue,for: .normal)
            }
            button.tag=buttontag
            button.addTarget(self, action: #selector(tap), for: .touchUpInside)
            
            self.view.addSubview(button)
            //playing=true
        }
        let line1 = UIView()
        line1.frame=CGRect(x: 7, y: 215, width: 360, height: 2)
        line1.backgroundColor = UIColor.black
        self.view.addSubview(line1)
        let line2 = UIView()
        line2.frame=CGRect(x: 7, y: 335, width: 360, height: 2)
        line2.backgroundColor = UIColor.black
        self.view.addSubview(line2)
        let line3 = UIView()
        line3.frame=CGRect(x: 127, y: 95, width: 2, height: 360)
        line3.backgroundColor = UIColor.black
        self.view.addSubview(line3)
        let line4 = UIView()
        line4.frame=CGRect(x: 247, y: 95, width: 2, height: 360)
        line4.backgroundColor = UIColor.black
        self.view.addSubview(line4)
        
    }
    
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func tap(sender: UIButton!) {
        if red != sender.tag{
            reset()
        }
        if display[sender.tag-1]==0||finished[sender.tag-1]==1{
            sender.layer.borderColor=UIColor.red.cgColor
            sender.layer.borderWidth = 2
            red=sender.tag
        }
        
    }
    func reset(){
        
        let button = UIButton(type:.system)
        button.frame=CGRect(x: 7+((red-1)%9)*40, y: 135+((red-1)/9-1)*40, width: 40, height: 40)
        button.backgroundColor = UIColor.white
        button.layer.borderColor = UIColor.blue.cgColor
        button.layer.borderWidth = 1
        button.addTarget(self, action: #selector(tap), for: .touchUpInside)
        button.tag=red
        if finished[red-1]==0&&display[red-1] != 0{
            button.setTitle(String(display[red-1]), for: .normal)
            button.setTitleColor(UIColor.blue,for: .normal)
        }
        else if finished[red-1] != 0{
            button.setTitle(String(display[red-1]), for: .normal)
            button.setTitleColor(UIColor.black,for: .normal)
        }
        if judge[red-1]==false{
            button.setTitle(String(display[red-1]), for: .normal)
            button.setTitleColor(UIColor.red,for: .normal)
        }
        self.view.addSubview(button)
        let line1 = UIView()
        line1.frame=CGRect(x: 7, y: 215, width: 360, height: 2)
        line1.backgroundColor = UIColor.black
        self.view.addSubview(line1)
        let line2 = UIView()
        line2.frame=CGRect(x: 7, y: 335, width: 360, height: 2)
        line2.backgroundColor = UIColor.black
        self.view.addSubview(line2)
        let line3 = UIView()
        line3.frame=CGRect(x: 127, y: 95, width: 2, height: 360)
        line3.backgroundColor = UIColor.black
        self.view.addSubview(line3)
        let line4 = UIView()
        line4.frame=CGRect(x: 247, y: 95, width: 2, height: 360)
        line4.backgroundColor = UIColor.black
        self.view.addSubview(line4)
    }
}

