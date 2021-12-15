//
//  Main Screen.swift
//  Berlin Clock App
//
//  Created by Vasiliy Shannikov on 13.12.2021.
//

import SwiftUI

struct Main_Screen: View {
    @State
    var date: Date = Date()
    var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    var body: some View {
       
        VStack{
            Text("Time is \((get_hours(d: date)),specifier:"%02d"):\((get_minutes(d: date)),specifier:"%02d"):\((get_seconds(d: date)),specifier:"%02d")")
//                .onReceive(timer) { input in
//                    date = input
//                }
            ZStack{
                RoundedRectangle(cornerRadius: 16)
                    .fill(.white)
                    
                VStack {
                    SecondsCircle(seconds: get_seconds(d: date))
                        .frame(width: 56, height: 56)
                  
                    HStack{
                       
                        FourUnitLine(unitQuant: get_fiveHoursBlocks(d: date))
                    }
                    HStack{
                        FourUnitLine(unitQuant: get_oneHourBlocks(d: date))
                    }
                    HStack {
                        ElevenUnitLine(unitQuant: get_fiveMinutesBlocks(d: date))
                    }
                    HStack {
                        FourUnitLine(unitQuant: get_oneMinuteBlocks(d: date), rectColor: MyColors.yellowOn, rectColorInit: MyColors.yellowOff)
                    }
                    
                }
              
                .padding(.horizontal,16)
                .padding(.vertical,32)
            }
             .background(MyColors.screenBack)
            .frame( height: 312, alignment: .top)
            .padding(.bottom,19)
            ZStack{
                RoundedRectangle(cornerRadius: 12)
                    .fill(.white)
                HStack{
                    Text("insert time")
                        .bold()
                        .font(.system(size: 18, weight:.regular))
                        .frame(width: 180, height: 24, alignment: .leading)
                    DatePicker("", selection: $date,  displayedComponents: .hourAndMinute)
                        .datePickerStyle(.compact)
                        .environment(\.locale, Locale(identifier: "ru_RU"))
                        .onReceive(timer) { input in
                            date = input
                        }
                }
                .padding(.horizontal,16)
                
            }
            .frame( height: 54, alignment: .top)
           Spacer()
        }
        .padding(.horizontal,16)
        .background(MyColors.screenBack)
    }
}

struct Main_Screen_Previews: PreviewProvider {
    static var previews: some View {
        Main_Screen()
    }
}

enum MyColors {
    static var redOn: Color = Color( red: 255/255, green: 59/255, blue: 48/255, opacity: 1)
    static var redOff: Color = Color( red: 1.0, green: 0.54, blue: 0.51, opacity: 1)
    static var yellowOn: Color = Color(red: 1.0, green: 0.8, blue: 0.0, opacity: 1.0)
    static var yellowOff: Color = Color(red: 1.0, green: 0.88, blue: 0.4, opacity: 1.0)
    static var screenBack: Color = Color( red: 0.95, green: 0.95, blue: 0.93, opacity: 1.0)
}

enum LineType: Int {
    case fifeHours, oneHour, oneMinute = 4
    case fiveMinutes = 11
}



struct FourUnitLine: View {
    
    var unitQuant:Int
    var rectColor = MyColors.redOn
    var rectColorInit = MyColors.redOff
    var lampLine = Array(repeating: RoundedRectangle(cornerRadius: 4), count: 4)

    var body: some View{
        ForEach(0..<lampLine.count) {i in
            if i < unitQuant {
                lampLine[i]
                    .fill(rectColor)
            }
            else {
                lampLine[i]
                    .fill(rectColorInit)
            }
        }
    }
}
struct SecondsCircle: View {
    
    var seconds: Int
    
    var body: some View {
        if seconds % 2 == 0 {
            Circle()
                .fill(MyColors.yellowOn)
        }
        else {
            Circle()
                .fill(MyColors.yellowOff)
        }
    }
}
struct ElevenUnitLine: View {
  
    var unitQuant :Int

    var lampLine = Array(repeating: RoundedRectangle(cornerRadius: 2), count: 11)
    var body: some View{
        ForEach(0..<lampLine.count) {i in
            if unitQuant > i  {
                if i % 3 == 2 {
                    lampLine[i]
                            .fill(MyColors.redOn)
                }
                else {
                    lampLine[i]
                            .fill(MyColors.yellowOn)
                }
            }
            else  {
                if i  % 3 == 2 {
                    lampLine[i]
                            .fill(MyColors.redOff)
                }
                else {
                    lampLine[i]
                            .fill(MyColors.yellowOff)
                }
            }
        }
    }
}

func get_fiveHoursBlocks (d: Date) -> Int {
    let calendar = Calendar.current
    let hour: Int = calendar.component(.hour, from: d)
    return hour / 5
}

func get_oneHourBlocks (d: Date) -> Int {
    let calendar = Calendar.current
    let hour: Int = calendar.component(.hour, from: d)
    return hour % 5
}

func get_fiveMinutesBlocks (d: Date) -> Int {
    let calendar = Calendar.current
    let minutes: Int = calendar.component(.minute, from: d)
    return minutes / 5
}

func get_oneMinuteBlocks (d: Date) -> Int {
    let calendar = Calendar.current
    let minutes: Int = calendar.component(.minute, from: d)
    return minutes % 5
}

func get_minutes (d: Date) -> Int {
    Calendar
        .current
        .component(.minute, from: d)
}

func get_hours (d: Date) -> Int {
    Calendar
        .current
        .component(.hour, from: d)
}

func get_seconds (d: Date) -> Int {
    Calendar
        .current
        .component(.second, from: d)
   
}

//DatePicker(selection: $date, displayedComponents:
//                                  .hourAndMinute) {
//                            Text("Insert time")
//                        }
//                            .environment(\.locale, Locale(identifier: "ru_RU"))
