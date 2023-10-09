//
//  FontSizeSliderView.swift
//  ToiletCheckIn
//
//  Created by Yugo Sugiyama on 2023/10/09.
//

import SwiftUI

enum FontSizeType: Double, CaseIterable {
    case ss = 16
    case s = 20
    case m = 24
    case l = 28
    case ll = 32
}

struct FontSizeSliderView: View {
    @Environment(\.appState) private var appState
    @State private var sliderValue: Double = 0
    private var fontSizeType: FontSizeType {
        FontSizeType.allCases[Int(sliderValue)]
    }

    var body: some View {
        VStack {
            Text("一覧などの文字がこのサイズで表示されます")
                .font(.system(type: fontSizeType))
                .lineLimit(nil)
            HStack(spacing: 8) {
                Text("あ")
                    .font(.system(type: .s))
                Slider(value: $sliderValue, in: 0...Double(FontSizeType.allCases.count - 1), step: 1)
                    .frame(height: 30)
                Text("あ")
                    .font(.system(type: .ll))
            }
        }
        .onAppear {
            sliderValue = Double(FontSizeType.allCases.firstIndex(where: { $0 == appState.fontSizeType }) ?? 0)
        }
        .onChange(of: sliderValue) { _, _ in
            UserDefaults.standard.fontSizeType = fontSizeType
            appState.fontSizeType = fontSizeType
        }
    }
}

#Preview {
    FontSizeSliderView()
        .padding(30)
}
