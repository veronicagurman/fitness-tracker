import SwiftUI
import SwiftData
import Charts

extension SleepView{
    static func currentDate(hour: Int, minutes: Int) -> Date{
        Calendar.current.date(bySettingHour: hour, minute: minutes, second: 0, of: Date()) ?? Date()
    }
}

struct SleepView: View {
    @State private var viewModel: SleepViewModel = SleepViewModel()
    @State private var start: Date = SleepView.currentDate(hour: 23, minutes: 0)
    @State private var end: Date = SleepView.currentDate(hour: 06, minutes: 0)
    @Environment(\.modelContext) private var context
    @Query private var entries: [SleepEntry]
    @State private var period = Period.day
    
    var body: some View {
        VStack{
            Picker("Period", selection: $period){
                ForEach(Period.allCases, id: \.self){element in
                    Text(element.rawValue)
                }
            }
        switch period{
        case .day:
            let daily = viewModel.sleepForDay(date: Date(), entries: entries)
            Chart{
                BarMark(x: .value("day", daily.date), y: .value("amount", daily.duration))
            }
        case .week:
            Chart(viewModel.sleepForWeek(date: Date(), entries: entries), id: \.date){ element in
                    BarMark( x: .value("day", element.date), y: .value("amount", element.duration))
                }
        case .month:
            Chart(viewModel.sleepForMonth(date: Date(), entries: entries), id: \.date){ element in
                BarMark(x: .value("day", element.date), y: .value("amount", element.duration))
            }
        case .year:
            Chart(viewModel.sleepForYear(date: Date(), entries: entries), id: \.date){ element in
                BarMark(x: .value("day", element.date), y: .value("amount", element.duration))
            }
            
        }
        
            DatePicker("Время отхода ко сну", selection: $start, displayedComponents: .hourAndMinute)
            DatePicker("Время пробуждения", selection: $end, displayedComponents: .hourAndMinute)
                
                
            Button("Add"){
                var adjustedStart = start
                if end < start{
                    adjustedStart = Calendar.current.date(byAdding: .day, value: -1, to: start) ?? start
                }
                viewModel.addSleep(start: adjustedStart, end: end, context: context)
                start = SleepView.currentDate(hour: 23, minutes: 0)
                end = SleepView.currentDate(hour: 06, minutes: 0)
            }
        }.padding()
        
        
    }
}

#Preview {
    SleepView()
}
