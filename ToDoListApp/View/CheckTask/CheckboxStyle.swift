//
//  CheckboxStyle.swift
//  ToDoListApp
//
//  Created by Amelie Pocchiolo on 04/01/2023.
//

import SwiftUI

struct CheckboxStyle: ToggleStyle {
    
    let taskColor: Color
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            Image(systemName: configuration.isOn ? "checkmark.circle.fill" : "circle")
                .resizable()
                .frame(width: 25, height: 25)
                .foregroundColor(self.taskColor)
                .onTapGesture {
                    configuration.isOn.toggle()
                }
            configuration.label
        }
    }
}

struct CheckboxStyle_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Toggle(isOn: .constant(true)) {
                Text("Toggle is on")
            }
            
            Toggle(isOn: .constant(false)) {
                Text("Toggle is off")
            }
        }
        .toggleStyle(CheckboxStyle(taskColor: .orange))
    }
}
