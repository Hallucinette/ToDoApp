//
//  PriorityView.swift
//  ToDoListApp
//
//  Created by Amelie Pocchiolo on 04/01/2023.
//

import SwiftUI

struct PriorityView: View {
    
    let priorityTitle: String
    @Binding var selectedPriority: Priority
    
    var body: some View {
        Text(priorityTitle)
            .font(.system(.headline, design: .rounded))
            .foregroundColor(.white)
            .padding(10)
            .background(selectedPriority.priorityType == priorityTitle.lowercased() ? selectedPriority.priorityColor() : Color(.systemGray4))
            .cornerRadius(10)
    }
}

struct PriorityView_Previews: PreviewProvider {
    static var previews: some View {
        PriorityView(priorityTitle: "High", selectedPriority: .constant(.high))
        PriorityView(priorityTitle: "Normal", selectedPriority: .constant(.normal))
        PriorityView(priorityTitle: "low", selectedPriority: .constant(.low))
    }
}
