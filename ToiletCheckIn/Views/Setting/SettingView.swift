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

    var body: some View {
        NavigationStack {
            Form {
                Section("設定変更") {
                    FontSizeSliderView()
                    LabeledContent("履歴データのクリア") {
                        Button(action: {
                            shouldShowDataResetAlert = true
                        }, label: {
                            Text("クリアする")
                        })
                    }
                    .alert("データのクリア", isPresented: $shouldShowDataResetAlert) {
                        Button(role: .destructive) {
                            SharedDefaultsManager.clear()
                        } label: {
                            Text("過去の履歴を全てクリアする")
                        }
                        Button(role: .cancel, action: {}) {
                            Text("キャンセルする")
                        }
                    }
                }
                Section("アプリ情報") {
                    LabeledContent("アプリ名") {
                        Text(appName)
                    }
                    LabeledContent("バージョン") {
                        Text("\(appVersion)(\(buildNumber))")
                    }
                }
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
