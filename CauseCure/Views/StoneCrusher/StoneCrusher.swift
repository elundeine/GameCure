//
//  StoneCrusher.swift
//  CauseCure
//
//  Created by Lukas Ebeling on 15.01.21.
//

import SwiftUI


struct StoneCrusher: View {
    @Binding var playing: Bool
    var body: some View {
        NavigationView{
        List {
            ForEach(Lines.Difficulty.allCases, id: \Lines.Difficulty.self) { difficulty in
                self.navigationLinkFor(difficulty: difficulty).onTapGesture {
                }
                
            }

            NavigationLink(destination: CustomRulesCreatorView(playing: $playing), label: { Text("Custom") })
        }
            .navigationBarTitle(Text("StoneCrusher"))
        }
    }

    func navigationLinkFor(difficulty: Lines.Difficulty) -> some View {
        let size = difficulty.rules.size
        let label = { Text("\(size)x\(size)") }
        let linesView = LinesView(rules: difficulty.rules,playing: $playing)
        return NavigationLink(destination: linesView, label: label)
    }
}

private struct CustomRulesCreatorView: View {
    @Binding var playing: Bool
    @State private var size: Int = 6
    @State private var availableColorCount: Int = 4
    @State private var lineLength: Int = 4
    @State private var addRandomCount: Int = 2

    private var linesView: LinesView {
        let rules = Lines.Rules(
            size: size,
            availableColorsCount: availableColorCount,
            lineLength: lineLength,
            addRandomCount: addRandomCount)

        return LinesView(rules: rules, playing: $playing)
    }

    var body: some View {
        Form {
            Stepper(value: $size, in: 3...20) { Text("Board size (\(size)x\(size))") }
            Stepper(value: $availableColorCount, in: 2...Lines.CellColor.allCases.count) { Text("Colors \(availableColorCount)") }
            Stepper(value: $lineLength, in: 2...8) { Text("Line length \(lineLength)") }
            Stepper(value: $addRandomCount, in: 1...8) {
                Text("Amount of random to add \(addRandomCount)")
                    .lineLimit(nil)
            }

            NavigationLink(destination: linesView,
                             label: { Text("Play!") })
        }
            .padding(20)
            .navigationBarTitle(Text("Custom rules"))
    }
}
