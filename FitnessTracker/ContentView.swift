import SwiftUI

struct ContentView: View {
    var body: some View {
       TabView {
               HomeView()
                    .tabItem {
                        Label("", systemImage: "house")
                    }
                
                StepsView()
                    .tabItem {
                        Label("", systemImage: "figure.walk")
                    }
                SleepView()
                    .tabItem {
                        Label("", systemImage: "bed.double")
                    }
                WaterView()
                    .tabItem {
                        Label("", systemImage: "drop")
                    }
                WorkoutView()
                    .tabItem {
                        Label("", systemImage: "dumbbell")
                    }
            
        }
    }
}

#Preview {
    ContentView()
}
