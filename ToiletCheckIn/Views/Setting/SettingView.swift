//
//  SettingView.swift
//  ToiletCheckIn
//
//  Created by Yugo Sugiyama on 2023/10/09.
//

import SwiftUI
import ToiletCheckInCore

struct SettingView: View {
    private var appName: String {
        (Bundle.main.infoDictionary?["CFBundleName"] as? String) ?? "Unknown"
    }

    private var appVersion: String {
        (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String) ?? "Unknown"
    }

    private var buildNumber: String {
        (Bundle.main.infoDictionary?["CFBundleVersion"] as? String) ?? "Unknown"
    }
    @Environment(\.dismiss) private var dismiss
    @State private var shouldShowDataResetAlert = false
    @State private var startDayTime = 0
    @State private var selectedBigType = ToiletType.ToiletBigType.default
    private let startDayTimeSelections = Array(0...24)
    private let sectionHeaderFont: Font = .headline
    private let contentLabelFont: Font = .body
    private let contentSubLabelFont: Font = .subheadline
    private let contentValueFont: Font = .body

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    FontSizeSliderView()
                    LabeledContent {
                        Picker(selection: $startDayTime) {
                            ForEach(startDayTimeSelections, id: \.self) { hour in
                                Text("\(hour)時")
                                    .font(contentValueFont)
                            }
                        } label: {
                            Text("")
                        }
                        .labelsHidden()

                    } label: {
                        Text("1日の記録の開始時刻")
                            .font(contentLabelFont)
                        Text("\(startDayTime)時から24時間単位で記録を表示")
                            .font(contentSubLabelFont)
                    }
                    LabeledContent {
                        Picker(selection: $selectedBigType) {
                            ForEach(ToiletType.ToiletBigType.allCases) { type in
                                Text(type.rawValue)
                                    .font(contentValueFont)
                                    .tag(type)
                            }
                        } label: {
                            Text(selectedBigType.rawValue)
                                .font(contentLabelFont)
                        }
                        .labelsHidden()
                    } label: {
                        Text("\(ToiletType.big(type: .default).displayIconString)の硬さの記録の初期値")
                            .font(contentLabelFont)
                    }
                } header: {
                    Text("設定変更")
                        .font(sectionHeaderFont)
                }
                Section {
                    LabeledContent(content: {
                        Button(action: {
                            shouldShowDataResetAlert = true
                        }, label: {
                            Text("クリアする")
                                .font(contentLabelFont)
                        })
                    }, label: {
                        Text("履歴データのクリア")
                            .font(contentLabelFont)
                    })
                    .alert("データのクリア", isPresented: $shouldShowDataResetAlert) {
                        Button(role: .destructive) {
                            SharedDefaults.clear()
                        } label: {
                            Text("過去の履歴を全てクリアする")
                                .font(contentLabelFont)
                        }
                        Button(role: .cancel, action: {}) {
                            Text("キャンセルする")
                                .font(contentLabelFont)
                        }
                    }
                } header: {
                    Text("データの操作")
                        .font(sectionHeaderFont)
                }
                Section {
                    LabeledContent("アプリ名") {
                        Text(appName)
                            .font(contentLabelFont)
                    }
                    LabeledContent("バージョン") {
                        Text("\(appVersion)(\(buildNumber))")
                            .font(contentLabelFont)
                    }
                } header: {
                    Text("アプリ情報")
                        .font(sectionHeaderFont)
                }
            }
            .onChange(of: selectedBigType, { _, newValue in
                SharedDefaults.selectedBigType = newValue
            })
            .onChange(of: startDayTime, { _, newValue in
                SharedDefaults.startDayTime = newValue
            })
            .onAppear {
                selectedBigType = SharedDefaults.selectedBigType
                startDayTime = SharedDefaults.startDayTime
            }
            .navigationTitle("設定")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        dismiss()
                    } label: {
                        Text("閉じる")
                    }
                }
            }
        }
    }
}

#Preview {
    SettingView()
}
