//
//  SwiftUIView.swift
//  CauseCure
//
//  Created by Lukas Ebeling on 15.01.21.
//


import SwiftUI

//private let cellSpacing: Length = 10

struct LinesView: View {
    private var game: State<Lines>
    @Binding var playing: Bool
    init(rules: Lines.Rules, playing: Binding<Bool>) {
        self.game = State(initialValue: Lines(rules: rules))
        self._playing = playing
    }

    var body: some View {
        VStack(alignment: .center, spacing: 20) {

            Text("Score \(self.game.wrappedValue.score)")

            Circle()
                .foregroundColor(self.game.wrappedValue.nextColorToPut.color)
                .frame(width: 50, height: 50, alignment: .center)

            BoardView(size: self.game.wrappedValue.rules.size) { row, column in
                CellView(cell: self.game.wrappedValue[Lines.LineIndex(row: row, column: column)]) {
                    self.game.wrappedValue.put(at: Lines.LineIndex(row: row, column: column))
                }
            }
                .aspectRatio(contentMode: .fit)
                .padding(10)

            Button(action: { self.playing = false },
                   label: { Text("Go Back") })
        }
    }
}

private struct BoardView: View {
    let size: Int
    let createCellHandler: (Int, Int) -> CellView
    init(size: Int, createCellHandler: @escaping (Int, Int) -> CellView) {
        self.size = size
        self.createCellHandler = createCellHandler
    }

    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            ForEach(0..<self.size) { column in
                HStack(alignment: .center, spacing: 10) {
                    ForEach(0..<self.size) { row in
                        self.createCellHandler(row, column)
                    }
                }
            }
        }
    }
}

private extension Lines.Cell {
    var color: Color {
        switch self {
        case .empty: return Color(0xCCCCCC)
        case .fill(let color): return color.color
        }
    }
}

private extension Lines.CellColor {
    var color: Color {
        switch self {
        case .blue: return Color(0x0000AA)
        case .green: return Color(0x00AA00)
        case .red: return Color(0xAA0000)
        case .yellow: return Color(0xe5e500)
        case .pink: return Color(0xe55ea2)
        }
    }
}

private struct CellView: View {
    let cell: Lines.Cell
    let didTapHandler: () -> ()

    init(cell: Lines.Cell, didTapHandler: @escaping () -> ()) {
        self.cell = cell
        self.didTapHandler = didTapHandler
    }

    var body: some View {
        Button(
            action: didTapHandler,
            label: { cellContent })
    }

    private var cellContent: some View {
        Rectangle()
            .foregroundColor(Color(0xCCCCCC))
            .overlay(circle)
    }

    private var circle: some View {
        Circle()
            .inset(by: 5)
            .foregroundColor(cell.color)
            .scaleEffect(cell == .empty ? 0 : 1)
            .animation(Animation.easeInOut)
    }
}
extension Color {
    init(_ value: Int) {
        let red = Double(value >> 16 & 0xff) / 255.0
        let green = Double(value >> 8 & 0xff) / 255.0
        let blue = Double(value & 0xff) / 255.0

        self.init(red: red, green: green, blue: blue)
    }
}


//#if DEBUG
//struct LinesView_Previews : PreviewProvider {
//    static var previews: some View {
//        LinesView(rules: Lines.Difficulty.easy.rules)
//    }
//}
//#endif

