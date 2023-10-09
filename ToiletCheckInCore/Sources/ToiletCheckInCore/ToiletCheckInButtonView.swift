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
    @State private var lastCheckInType: ToiletType?
    @State private var selectedToiletType: ToiletType?
    private var watchDisplayText: String {
        if let lastCheckInType {
            return "追加✅: \(lastCheckInType.displayText)"
        } else {
            return ""
        }
    }
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

    private func buttonOpacity(type: ToiletType) -> CGFloat {
        return (selectedToiletType != nil && selectedToiletType != type) ? 0.4 : 1
    }

    private func button(type: ToiletType) -> some View {
        Button(action: {
            print(type.displayText)
            if deviceType == .watch {
                save(type: type)
            }
            completion(type)
            lastCheckInType = type
            selectedToiletType = type
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                lastCheckInType = nil
            }
        }, label: {
            Text(type.displayText)
                .font(.system(size: fontSize, weight: .bold))
        })
    }

    public var body: some View {
        VStack {
            if deviceType == .watch {
                Text("チェックインする")
                    .font(.headline)
                Spacer()
                    .frame(height: 20)
            }
            HStack {
                ForEach(ToiletType.allCases) { type in
                    button(type: type)
                        .opacity(buttonOpacity(type: type))
                }
            }
            if deviceType == .watch {
                Spacer()
                    .frame(height: 20)
                Text(watchDisplayText)
            }
        }
    }

    private func save(type: ToiletType) {
        let item = ToiletResultItem(toiletType: type, date: Date(), deviceType: deviceType)

        SharedDefaultsManager.add(item: item)
    }
}

#Preview {
    ToiletCheckInButtonView(deviceType: .phone) {_ in }
}
