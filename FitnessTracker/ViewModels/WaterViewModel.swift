import Foundation
import SwiftData

struct DailyWater {
    var date: Date
    var amount: Double
}

@Observable
class WaterViewModel {

    func addWater(value: Double, context: ModelContext) {
        let newEntry = WaterEntry(date: Date(), value: value)
        context.insert(newEntry)
    }

    func drinkDuringTheDay(date: Date, entries: [WaterEntry]) -> Double {
        entries
            .filter { Calendar.current.isDate($0.date, inSameDayAs: date) }
            .reduce(0.0) { $0 + $1.value }
    }

    func waterForDay(date: Date, entries: [WaterEntry]) -> DailyWater {
        DailyWater(date: date, amount: drinkDuringTheDay(date: date, entries: entries))
    }

    private func waterForLastDays(_ days: Int, date: Date, entries: [WaterEntry]) -> [DailyWater] {
        var result: [DailyWater] = []
        for i in 0..<days {
            guard let currentDate = Calendar.current.date(byAdding: .day, value: -i, to: date) else { continue }
            result.append(DailyWater(date: currentDate,
                                     amount: drinkDuringTheDay(date: currentDate, entries: entries)))
        }
        return result.reversed()
    }

    func waterForWeek(date: Date, entries: [WaterEntry]) -> [DailyWater] {
        waterForLastDays(7, date: date, entries: entries)
    }

    func waterForMonth(date: Date, entries: [WaterEntry]) -> [DailyWater] {
        guard let range = Calendar.current.range(of: .day, in: .month, for: date) else { return [] }
        return waterForLastDays(range.count, date: date, entries: entries)
    }

    func waterForYear(date: Date, entries: [WaterEntry]) -> [DailyWater] {
        var result: [DailyWater] = []
        for i in 0..<12 {
            guard let monthDate = Calendar.current.date(byAdding: .month, value: -i, to: date) else { continue }
            let sum = entries
                .filter { Calendar.current.isDate($0.date, equalTo: monthDate, toGranularity: .month) }
                .reduce(0.0) { $0 + $1.value }
            result.append(DailyWater(date: monthDate, amount: sum))
        }
        return result.reversed()
    }
}
