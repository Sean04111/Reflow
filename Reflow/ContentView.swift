//
//  ContentView.swift
//  Reflow
//
//  Created by Sean on 2/27/25.
//

import SwiftUI
import AppKit

struct ContentView: View {
    @State private var name:String = "test"
    
    var body: some View {
//        VStack{
//            Text(name)
//                .font(.title)
//                .foregroundColor(.blue)
//                .bold()
//                .lineLimit(2)
//                .frame(width:200, height: 50,alignment: .center)
//                .truncationMode(.tail)
//            Text("Hello, world!")
//  
//        }
        
//        VStack(spacing:20){
//            Button(action:{
//                signin(message: "sign in successfully")
//            },label:get_signin_text)
//            
//            Button("button1",action:{
//                signin(message: "sign in successfully")
//            })
//           self.addToContainer
//        }
//        HStack(spacing:0){
//            self.input_text
//            Button("commit",action: {
//                self.signin(message: self.input)
//            })
//        }
        Text("hello")
            .font(.title)
            .padding()
       
    }
    
    private func signin(message:String){
        let Notification = NSUserNotification()
        Notification.title = "New message"
        Notification.informativeText = message
        Notification.soundName = NSUserNotificationDefaultSoundName
        
        
        let center = NSUserNotificationCenter.default
        center.deliver(Notification)
       
    }
    
    private func get_signin_text() -> some View{
        return Text("Sign in")
    }
    
    struct Item:Identifiable{
        let id = UUID()
        let title: String
        let desc: String
    }
    
    @State private var items:[Item] = []
    
    var addToContainer: some View {
        List{
            ForEach(items){ item in
                Text(item.desc)
            }
            Button(action:{
                self.addItem()
            },label:self.get_add_item_lable)
        }
        
    }
    
    func addItem (){
        let NewItem = Item(title:"NewItemTitle", desc:"NewItemDesc")
        self.items.append(NewItem)
    }
    
    func get_add_item_lable()->some View{
        return Text("add Item")
    }
    
    
    @State private var input: String = ""
    @State private var isEdit = false
    
    var input_text: some View {
        VStack(spacing:30){
            TextField("type here",text: $input){isEdit in
                self.isEdit = true
            }
        }
    }
    

    
}




#Preview {
    ContentView()
}
