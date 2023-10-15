//
//  ToiletAddView.swift
//  ToiletCheckIn
//
//  Created by Yugo Sugiyama on 2023/10/09.
//

import SwiftUI
import ToiletCheckInCore

struct ToiletAddView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedDate = Date()
    @State private var selectedToiletType: ToiletType?

    var body: some View {
        NavigationStack {
            VStack {
                ToiletCheckInButtonView(deviceType: .phone) { type in
                    selectedToiletType = type
                }
                DatePicker(selection: $selectedDate,
                           in: ...Date().offsetHours(offset: 1)!,
                           displayedComponents: [.date, .hourAndMinute]) {
                    Text("日付")
                        .font(.title)
                }
                Button(action: {
                    guard let type = selectedToiletType?.bigTypeChanged(type: SharedDefaults.selectedBigType) else { return }
                    let item = ToiletResultItem(toiletType: type, date: selectedDate, deviceType: .phone)
                    SharedDefaults.add(item: item)
                    dismiss()
                }, label: {
                    Text("追加")
                        .fontWeight(.bold)
                        .font(.body)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(12)
                        .disabled(selectedToiletType == nil)
                })
            }
            .padding()
            .navigationTitle("チェックイン")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button(action: {
                        dismiss()
                    }, label: {
                        Text("閉じる")
                    })
                }
            }
        }
    }
}

#Preview {
    ToiletAddView()
}
