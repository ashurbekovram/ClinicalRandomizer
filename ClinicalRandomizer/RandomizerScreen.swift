//
//  RandomizerScreen.swift
//  ClinicalRandomizer
//
//  Created by Ramazan Ashurbekov on 25.06.2022.
//

import SwiftUI

struct RandomizerScreen: View {
    @AppStorage("heightFrom") private var heightFrom: Int = 155
    @AppStorage("heightTo") private var heightTo: Int = 195
    @AppStorage("height") private var height: Int = 175
    
    @AppStorage("weightFrom") private var weightFrom: Int = 60
    @AppStorage("weightTo") private var weightTo: Int = 90
    @AppStorage("weight") private var weight: Int = 75
    
    @State private var bloodPreasureTop: Int = 120
    @State private var bloodPreasureBottom: Int = 80
    @State private var birthYear: Int = 1990
    
    private var minYear: Int {
        1900
    }
    
    private var maxYear: Int {
        Calendar.current.component(.year, from: Date())
    }
    
    private var age: Int {
        Calendar.current.component(.year, from: Date()) - birthYear
    }
    
    private var massIndex: String {
        let heightInMeters: Float = Float(height) * 0.01
        let massIndex: Float = Float(weight) / (heightInMeters * heightInMeters)
        return String(format: "%.2f", massIndex)
    }
    
    private var bloodPreasure: (top: Int, bottom: Int) {
        let top = Int.random(in: 120...145)
        let bottom: Int
        switch top {
        case 120...135:
            bottom = top - Int.random(in: 40...50)
        default:
            bottom = top - Int.random(in: 50...55)
        }
        return (top: top, bottom: bottom)
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    VStack {
                        HStack {
                            Text("Год рождения").bold()
                            Spacer()
                        }
                        Picker("Год рождения", selection: $birthYear) {
                            ForEach(minYear...maxYear, id: \.self) {
                                Text(String($0))
                            }
                        }
                        .pickerStyle(.wheel)
                        .frame(height: 120)
                        .clipped()
                    }
                    .padding(.top, 8)
                    MedicalCalculatorField(
                        title: "Рост",
                        fromValue: $heightFrom,
                        toValue: $heightTo
                    )
                    MedicalCalculatorField(
                        title: "Вес",
                        fromValue: $weightFrom,
                        toValue: $weightTo
                    )
                }
                Section {
                    HStack {
                        Text("Возраст")
                        Spacer(minLength: 16)
                        Text(age.description).bold()
                    }
                    HStack {
                        Text("Рост")
                        Spacer(minLength: 16)
                        Text(height.description).bold()
                    }
                    HStack {
                        Text("Вес")
                        Spacer(minLength: 16)
                        Text(weight.description).bold()
                    }
                    HStack {
                        Text("Индекс массы тела")
                        Spacer(minLength: 16)
                        Text(massIndex).bold()
                    }
                    HStack {
                        Text("АД")
                        Spacer(minLength: 16)
                        Text(bloodPreasureTop.description).bold()
                        Text("/").bold()
                        Text(bloodPreasureBottom.description).bold()
                    }
                }
                Section {
                    Button {
                        height = Int.random(in: heightFrom...heightTo)
                        weight = Int.random(in: weightFrom...weightTo)
                        let bloodPreasure = bloodPreasure
                        bloodPreasureTop = bloodPreasure.top
                        bloodPreasureBottom = bloodPreasure.bottom
                    } label: {
                        Text("Обновить").bold()
                    }
                }
            }
            .padding(.top, -20)
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Диспансеризация")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Сброс") {
                        heightFrom = 155
                        heightTo = 195
                        weightFrom = 60
                        weightTo = 90
                        birthYear = 1990
                    }
                }
                ToolbarItem(placement: .keyboard) {
                    Button("Готово") {
                        UIApplication.shared.sendAction(
                            #selector(UIResponder.resignFirstResponder),
                            to: nil,
                            from: nil,
                            for: nil
                        )
                    }
                }
            }
        }
    }
}

struct MedicalCalculatorField: View {
    private let title: String
    
    @Binding private var fromValue: Int
    @Binding private var toValue: Int
    
    init(
        title: String,
        fromValue: Binding<Int>,
        toValue: Binding<Int>
    ) {
        self.title = title
        self._fromValue = fromValue
        self._toValue = toValue
    }
    
    var body: some View {
        VStack {
            HStack {
                Text(title).bold()
                Spacer()
            }
            HStack {
                Text("От")
                TextField("От", text: Binding(
                    get: {
                        fromValue <= 0 ? "" : fromValue.description
                    }, set: { new in
                        fromValue = Int(new) ?? 0
                    }
                ))
                .textFieldStyle(.roundedBorder)
                .keyboardType(.numberPad)
                .frame(width: 112)
                Spacer()
                Text("До")
                    .textFieldStyle(.roundedBorder)
                TextField(
                    "До",
                    text: Binding(
                        get: {
                            toValue <= 0 ? "" : toValue.description
                        }, set: { new in
                            toValue = Int(new) ?? 0
                        }
                    )
                )
                .textFieldStyle(.roundedBorder)
                .keyboardType(.numberPad)
                .frame(width: 112)
            }
        }
        .padding(.vertical, 8)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        RandomizerScreen()
    }
}
