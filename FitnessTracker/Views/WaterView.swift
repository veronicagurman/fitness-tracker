import SwiftUI
import SwiftData
import Charts

struct WaterView: View {
    @State private var viewModel = WaterViewModel()
    @State private var value: Double = 250
    @State private var isPresented = false
    @State private var period = Period.day
    @AppStorage("waterGoal") private var goal: Double = 2000

    @Environment(\.modelContext) private var modelContext
    @Query private var entries: [WaterEntry]

    let amounts: [Double] = [10, 50, 100, 250, 500, 1000]

    var body: some View {
        VStack(spacing: 16) {
            Text("You drink today \(String(format: "%.0f", viewModel.drinkDuringTheDay(date: Date(), entries: entries))) ml")

            Stepper("Goal: \(Int(goal)) ml", value: $goal, in: 500...5000, step: 250)
                .padding(.horizontal)

            Picker("Period", selection: $period) {
                ForEach(Period.allCases, id: \.self) { item in
                    Text(item.rawValue)
                }
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)

            switch period {
            case .day:
                waterChart([viewModel.waterForDay(date: Date(), entries: entries)],
                           unit: .day, showGoal: true)
            case .week:
                waterChart(viewModel.waterForWeek(date: Date(), entries: entries),
                           unit: .day, showGoal: true)
            case .month:
                waterChart(viewModel.waterForMonth(date: Date(), entries: entries),
                           unit: .day, showGoal: true)
            case .year:
                waterChart(viewModel.waterForYear(date: Date(), entries: entries),
                           unit: .month, showGoal: false)
            }

            Button("+") {
                isPresented = true
            }
            .buttonStyle(.bordered)
            .sheet(isPresented: $isPresented) {
                VStack {
                    Picker("Select ml", selection: $value) {
                        ForEach(amounts, id: \.self) { amount in
                            Text(String(format: "%.0f", amount))
                        }
                    }
                    .pickerStyle(.wheel)

                    Button("Add") {
                        viewModel.addWater(value: value, context: modelContext)
                        isPresented = false
                    }
                }
                .presentationDetents([.medium])
            }
        }
        .padding(.vertical)
    }

    private func waterChart(_ data: [DailyWater], unit: Calendar.Component, showGoal: Bool) -> some View {
        Chart {
            ForEach(data, id: \.date) { element in
                BarMark(
                    x: .value("Date", element.date, unit: unit),
                    y: .value("Amount", element.amount)
                )
            }
            if showGoal {
                RuleMark(y: .value("Goal", goal))
                    .foregroundStyle(.red)
                    .lineStyle(StrokeStyle(lineWidth: 2, dash: [6]))
            }
        }
        .padding(.horizontal)
    }
}

#Preview {
    WaterView()
        .modelContainer(for: WaterEntry.self, inMemory: true)
}
