import SwiftUI
import SwiftData
import Charts

struct WaterView: View {
    @State private var viewModel: WaterViewModel = WaterViewModel()
    @State private var value: Double = 250
    @State private var isPresented = false
    @Environment(\.modelContext) private var modelContext
    @Query private var entries: [WaterEntry]
    let amounts: [Double] = [10, 50, 100, 250, 500, 1000]
    @State private var period = Period.day
    var body: some View {
        VStack{
            Text("You drink today \(String(format: "%.0f", viewModel.drinkDuringTheDay(date: Date(), entries: entries))) ml")
            Picker("Period", selection: $period) {
                ForEach(Period.allCases, id: \.self) { item in
                    Text(item.rawValue)
                }
            }
            switch(period){
            case .day:
                let daily = viewModel.waterForDay(date: Date(), entries: entries)
                Chart{
                    BarMark(
                        x: .value("Day", daily.date),
                        y: .value("amount", daily.amount)
                    )
                    
                }
            case .week:
                Chart(viewModel.waterForWeek(date: Date(), entries: entries), id: \.date) { element in
                    
                    BarMark(
                        x: .value("Day", element.date),
                        y: .value("amount", element.amount)
                    )
                    
                    
                }
            case .month:
                Chart(viewModel.waterForMonth(date: Date(), entries: entries), id: \.date) { element in
                    
                    BarMark(
                        x: .value("Day", element.date),
                        y: .value("amount", element.amount)
                    )
                    
                    
                }
            case .year: Chart(viewModel.waterForYear(date: Date(), entries: entries), id: \.date){ element in
                BarMark(
                    x: .value("Day", element.date),
                    y: .value("amount", element.amount)
                )
            }
            }
            
            Button("+") {
                isPresented = true
            }.sheet(isPresented: $isPresented, content: {
                VStack{
                    Picker("Select ml", selection: $value) {
                        ForEach(amounts, id: \.self){value in
                            Text(String(format: "%.0f", value))
                        }
                    }.pickerStyle(.wheel)
                    Button("Add") {
                        viewModel.addWater(value: value, context: modelContext)
                        print(entries.count)
                        isPresented = false
                    }
                }
               
            })
            .buttonStyle(.bordered)
            
        }
    }
}

#Preview {
    WaterView()
}
