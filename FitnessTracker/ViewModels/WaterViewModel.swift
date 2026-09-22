import Foundation
import SwiftData

struct DailyWater{
    var date: Date
    var amount: Double
}

@Observable
class WaterViewModel{
    
    func addWater(value: Double, context: ModelContext) {
        let newEntry = WaterEntry(date: Date(), value: value)
        context.insert(newEntry)
    }
    
    func drinkDuringTheDay(date: Date, entries: [WaterEntry]) -> Double{
        let sum = entries.filter{Calendar.current.isDate($0.date, inSameDayAs: date)}.reduce(0.0){$0 + $1.value}
        return sum
    }
    func waterForDay(date: Date,  entries: [WaterEntry]) -> DailyWater {
        let result = DailyWater(date: date, amount: drinkDuringTheDay(date: date, entries: entries))
        return result
    }
    func waterForWeek(date: Date, entries: [WaterEntry]) -> [DailyWater] {
        var result: [DailyWater] = []
        for i in 0...6{
            guard let currentDate = Calendar.current.date(byAdding: .day, value: -i, to: date) else { continue }
            result.append(DailyWater(date: currentDate, amount: drinkDuringTheDay(date: currentDate, entries: entries)))
        }
        return result.reversed()
    }
    
    func waterForMonth(date: Date, entries: [WaterEntry]) -> [DailyWater] {
        var result: [DailyWater] = []
        guard let month = Calendar.current.range(of: .day, in: .month, for: date) else {
            return result
        }
        for i in 1...month.count{
            guard let currentDate = Calendar.current.date(byAdding: .day, value: -i, to: date) else { continue }
            result.append(DailyWater(date: currentDate, amount: drinkDuringTheDay(date: currentDate, entries: entries)))
        }
        return result.reversed()
    }
    func waterForYear(date: Date, entries: [WaterEntry]) -> [DailyWater] {
        var result: [DailyWater] = []
        guard let year = Calendar.current.range(of: .day, in: .year, for: date) else {
            return result
        }
        for i in 1...year.count{
            guard let currentDate = Calendar.current.date(byAdding: .day, value: -i, to: date) else { continue }
            result.append(DailyWater(date: currentDate, amount: drinkDuringTheDay(date: currentDate, entries: entries)))
        }
        return result.reversed()
    }
    
}
