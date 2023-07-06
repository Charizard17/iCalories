//
//  ProgressView.swift
//  iCalories
//
//  Created by Esad Dursun on 06.07.23.
//  Copyright © 2023 ChariLab. All rights reserved.
//

import SwiftUI
import Charts

struct ChartsView: View {
    @FetchRequest(sortDescriptors: [SortDescriptor(\.date, order: .reverse)]) var foodArray: FetchedResults<Food>
    
    @AppStorage(goalKey) var goal: Int = 1700
    
    
    var viewDays: [ViewDay] {
        var viewDays: [ViewDay] = []
        
        let calendar = Calendar.current
        let currentDate = calendar.startOfDay(for: Date())
        
        for i in 0..<10 {
            if let date = calendar.date(byAdding: .day, value: -i, to: currentDate) {
                let filteredFood = foodArray.filter { calendar.isDate($0.date!, inSameDayAs: date) }
                let totalCalories = filteredFood.reduce(0) { $0 + $1.calories }
                let totalGrams = filteredFood.reduce(0) { $0 + $1.grams }
                
                viewDays.append(ViewDay(date: date, totalCalories: Int(totalCalories), totalGrams: totalGrams))
            }
        }
        
        return viewDays
    }
    
    var caloriesChartHighestScaleValue: Double {
        let maxValue = Double(viewDays.map { $0.totalCalories }.max() ?? 2000) * 1.5
        return maxValue < Double(goal) ? Double(goal) * 1.5 : maxValue
    }
    
    var gramsChartHighestScaleValue: Double {
        Double(viewDays.map { $0.totalGrams }.max() ?? 1000) * 1.5
    }
    
    var dailyAverageCalories: Int {
        let totalCalories = viewDays.reduce(0) { $0 + $1.totalCalories }
        return Int(Double(totalCalories) / Double(viewDays.count))
    }
    
    var dailyAverageGrams: Int {
        let totalGrams = viewDays.reduce(0) { $0 + $1.totalGrams }
        return Int(totalGrams / Double(viewDays.count))
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Calories By Day")
                    .foregroundColor(.teal)
                    .font(.system(size: largeFontSize, weight: .bold))
                    .padding(.bottom, -15)
                Chart {
                    RuleMark(y: .value("Goal", goal))
                        .foregroundStyle(Color.pink)
                        .lineStyle(StrokeStyle(lineWidth: 1, dash: [5]))
                        .annotation(alignment: .trailing) {
                            Text("Goal")
                                .font(.system(size: smallFontSize))
                                .foregroundColor(.gray)
                        }
                    
                    ForEach(viewDays) { viewDay in
                        BarMark(
                            x: .value("Day", viewDay.date, unit: .day),
                            y: .value("Kcal", viewDay.totalCalories == 0 ? 10 : viewDay.totalCalories)
                        )
                        .foregroundStyle(Color.teal.gradient)
                        .cornerRadius(2)
                    }
                }
                .frame(height: 180)
                .chartYScale(domain: 0...caloriesChartHighestScaleValue)
                .chartXAxis {
                    AxisMarks(values: viewDays.map { $0.date }) { date in
                        AxisValueLabel(format: .dateTime.weekday(), centered: true, orientation: .verticalReversed)
                        
                    }
                }
                .chartYAxis {
                    AxisMarks(position: .leading)
                }
                
                HStack {
                    DottedLine()
                        .stroke(style: StrokeStyle(lineWidth: 1, dash: [5]))
                        .frame(width: 50, height: 1)
                        .foregroundColor(Color.pink)
                    Stepper("Goal: \(goal)", value: $goal, in: 100...5000, step: 100)
                        .font(.system(size: smallFontSize))
                        .foregroundColor(.gray)
                    Spacer()
                }
                .padding(.bottom, 20)
                
                if foodArray.isEmpty {
                    Text("No data available")
                        .foregroundColor(.gray)
                        .font(.system(size: mediumFontSize))
                        .padding(.top, 50)
                } else {
                    Text("Grams By Day")
                        .foregroundColor(.teal)
                        .font(.system(size: largeFontSize, weight: .bold))
                        .padding(.bottom, -15)
                    Chart {
                        ForEach(viewDays) { viewDay in
                            BarMark(
                                x: .value("Day", viewDay.date, unit: .day),
                                y: .value("Grams", viewDay.totalGrams == 0 ? 10 : viewDay.totalGrams)
                            )
                            .foregroundStyle(Color.teal.gradient)
                            .cornerRadius(2)
                        }
                    }
                    .frame(height: 180)
                    .chartYScale(domain: 0...gramsChartHighestScaleValue)
                    .chartXAxis {
                        AxisMarks(values: viewDays.map { $0.date }) { date in
                            AxisValueLabel(format: .dateTime.weekday(), centered: true, orientation: .verticalReversed)
                            
                        }
                    }
                    .chartYAxis {
                        AxisMarks(position: .leading)
                    }
                    HStack {
                        Spacer()
                        Text("Daily average: \(dailyAverageCalories) Kcal, \(dailyAverageGrams) g")
                            .font(.system(size: smallFontSize))
                            .foregroundColor(.gray)
                    }
                    .padding(.top, 20)
                }
                Spacer()
            }
            .padding()
            .navigationTitle(chartsViewTitle)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Image(uiImage: UIImage(named: iCaloriesLogoAsset) ?? UIImage())
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 35, height: 35)
                }
            }
        }
    }
}

struct ProgressView_Previews: PreviewProvider {
    static var previews: some View {
        ChartsView()
    }
}


struct ViewDay: Identifiable {
    let id = UUID()
    let date: Date
    let totalCalories: Int
    let totalGrams: Double
}

extension Date {
    static func from(year: Int, month: Int, day: Int) -> Date {
        let components = DateComponents(year: year, month: month, day: day)
        return Calendar.current.date(from: components)!
    }
}

struct DottedLine: Shape {
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: rect.width, y: rect.height))
        return path
    }
}
