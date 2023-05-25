//
//  SavingHistory.swift
//  Steps
//
//  Created by Haruto Hamano on 2023/05/24.
//

import SwiftUI
import Charts
import Foundation

struct SavingModel {
    let amount: Double
    let createAt: Date
}

struct SavingHistory: View {
    let list = [
        SavingModel[amount: 101, createAt: dateFormatter.date(from: "23/11/2003") ?? Date()],
        SavingModel[amount: 101, createAt: dateFormatter.date(from: "23/11/2003") ?? Date()],
        SavingModel[amount: 101, createAt: dateFormatter.date(from: "23/11/2003") ?? Date()],
        SavingModel[amount: 101, createAt: dateFormatter.date(from: "23/11/2003") ?? Date()],
        SavingModel[amount: 101, createAt: dateFormatter.date(from: "23/11/2003") ?? Date()],
        SavingModel[amount: 101, createAt: dateFormatter.date(from: "23/11/2003") ?? Date()],
        SavingModel[amount: 101, createAt: dateFormatter.date(from: "23/11/2003") ?? Date()],
    ]
    
    static var dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "dd/MM/yy"
        return df
    }()
    
    var body: some View{
        Chart(){
            
        }
        
        Text("")
    }
}
