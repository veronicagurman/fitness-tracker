import Foundation
import SwiftData

struct DailySleep{
    var date: Date
    var duration: TimeInterval
}

@Observable
class SleepViewModel{
    func sleepForDay(date: Date, entries: [SleepEntry]) -> DailySleep{
        let sleep = entries.first(where: { element in
            Calendar.current.isDate(element.end, inSameDayAs: date)
        })
        let result = DailySleep(date: date, duration: sleep?.duration ?? 0)
        return result
        }
    
    func sleepForWeek(date: Date, entries: [SleepEntry]) -> [DailySleep] {
        var results: [DailySleep] = []
        for i in 0...6{
            guard let currentDate = Calendar.current.date(byAdding: .day, value: -i, to: date) else { continue }
            results.append(sleepForDay(date: currentDate, entries: entries))
        }
        return results.reversed()
    }
    
    func sleepForMonth(date: Date, entries: [SleepEntry]) -> [DailySleep] {
        var results: [DailySleep] = []
        guard let month = Calendar.current.range(of: .day, in: .month, for: date) else { return results }
        for i in 1...month.count{
            guard let currentDate = Calendar.current.date(byAdding: .day, value: -i, to: date) else { continue }
            results.append(sleepForDay(date: currentDate, entries: entries))
        }
        return results.reversed()
    }
    
    func sleepForYear(date: Date, entries: [SleepEntry]) -> [DailySleep] {
        var results: [DailySleep] = []
        guard let year = Calendar.current.range(of: .day, in: .year, for: date) else { return results }
        for i in 1...year.count{
            guard let currentDate = Calendar.current.date(byAdding: .day, value: -i, to: date) else { continue }
            results.append(sleepForDay(date: currentDate, entries: entries))
        }
        return results.reversed()
    }
   
    func addSleep(start: Date, end: Date, context: ModelContext){
        let sleep = SleepEntry(start: start, end: end)
        context.insert(sleep)
    }
    
}
