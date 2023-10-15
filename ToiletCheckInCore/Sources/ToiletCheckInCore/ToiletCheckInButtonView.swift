//
//  ToiletCheckInButtonView.swift
//
//
//  Created by Yugo Sugiyama on 2023/10/02.
//

import SwiftUI

public struct ToiletCheckInButtonView: View {
    let deviceType: DeviceType
    let completion: (ToiletType) -> Void
    @State private var selectedToiletType: ToiletType?
    @State private var shouldShowCheckmark = false

    private var fontSize: CGFloat {
        switch deviceType {
        case .watch, .widget:
            return 20
        case .phone:
            return 60
        }
    }

    public init(deviceType: DeviceType, completion: @escaping (ToiletType) -> Void) {
        self.deviceType = deviceType
        self.completion = completion
    }

    private func buttonOpacity(toiletType: ToiletType) -> CGFloat {
        return (selectedToiletType != nil && selectedToiletType != toiletType) ? 0.2 : 1
    }

    private func button(toiletType: ToiletType) -> some View {
        Button(action: {
            if deviceType == .watch {
                withAnimation {
                    shouldShowCheckmark = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        shouldShowCheckmark = false
                    }
                }
            }
            selectedToiletType = toiletType
            completion(toiletType)
        }, label: {
            Text(toiletType.displayIconString)
                .font(.system(size: fontSize, weight: .bold))
        })
    }

    public var body: some View {
        VStack {
            Spacer()
            HStack(spacing: 4) {
                Text("チェックイン")
                    .font(.system(size: 16, weight: .bold))
                Group {
                    if shouldShowCheckmark {
                        Image(systemName: "checkmark")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    } else {
                        Color.clear
                    }
                }
                .frame(width: 16, height: 16)
            }
            Spacer()
                .frame(height: 20)
            HStack {
                ForEach([ToiletType.big(type: .hard), ToiletType.small]) { type in
                    button(toiletType: type)
                        .opacity(buttonOpacity(toiletType: type))
                }
            }
            Spacer()
        }
    }

    private func save(type: ToiletType) {
        let item = ToiletResultItem(toiletType: type, date: Date(), deviceType: deviceType)

        SharedDefaults.add(item: item)
    }
}

#Preview {
    ToiletCheckInButtonView(deviceType: .phone) {_ in }
}
