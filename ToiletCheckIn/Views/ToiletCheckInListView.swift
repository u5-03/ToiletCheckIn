//
//  ToiletCheckInListView.swift
//  ToiletCheckIn
//
//  Created by Yugo Sugiyama on 2023/10/09.
//

import SwiftUI
import ToiletCheckInCore

struct ToiletCheckInListView: View {
    @Environment(\.scenePhase) var scenePhase
    @Environment(\.appState) private var appState
    @State private var resultItems: [ToiletResultItem] = []
    @State private var shouldShowSettingView = false
    @State private var shouldShowAddingView = false
    private let buttonSizeHeight: CGFloat = 60
    private let buttonBottomMargin: CGFloat = 20
    private var results: [ToiletResult] {
        resultItems.asToiletResultConverted(startingHour: SharedDefaults.startDayTime)
    }


    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottomTrailing) {
                listView
                plusButtonView
            }
            .onAppear {
                refreshResults()
            }
            .onChange(of: shouldShowAddingView, { _, newValue in
                if !newValue {
                    refreshResults()
                }
            })
            .onChange(of: shouldShowSettingView, { _, newValue in
                if !newValue {
                    refreshResults()
                }
            })
            .onChange(of: scenePhase) { _, newValue in
                if newValue == .active {
                    refreshResults()
                }
            }
            .sheet(isPresented: $shouldShowSettingView) {
                SettingView()
            }
            .sheet(isPresented: $shouldShowAddingView) {
                ToiletAddView()
            }
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button("設定", systemImage: "gearshape.fill") {
                        shouldShowSettingView = true
                    }
                }
            }
            .navigationTitle("トイレチェックイン")
        }
    }
}

private extension ToiletCheckInListView {
    var plusButtonView: some View {
        Button(action: {
            shouldShowAddingView = true
        }) {
            Image(systemName: "plus.circle.fill")
                .resizable()
                .frame(width: buttonSizeHeight, height: buttonSizeHeight)
                .background(Color.blue)
                .foregroundColor(.white)
                .clipShape(Circle())
                .shadow(radius: 10)
        }
        .padding(.trailing, buttonBottomMargin)
        .padding(.bottom, buttonBottomMargin)
    }

    @ViewBuilder
    var listView: some View {
        if !resultItems.isEmpty {
            VStack(alignment: .leading) {
                List {
                    ForEach(results) { result in
                        if !result.items.isEmpty {
                            Section(content: {
                                ForEach(result.items) { item in
                                    HStack {
                                        Text(item.date.asString(withFormat: .dateTimeWithWeekDayNoZero, locale: .jp))
                                            .font(.system(type: appState.fontSizeType))
                                        Spacer()
                                        Text(item.toiletType.displayText)
                                            .font(.system(type: appState.fontSizeType))
                                    }
                                    .contextMenu {
                                        if case .big(let type) = item.toiletType {
                                            itemContextMenuView(toiletBigType: type, item: item)
                                        }
                                    }
                                }
                                .onDelete { indexSet in
                                    delete(at: indexSet, result: result)
                                }
                            }, header: {
                                NavigationLink {
                                    ToiletCheckInDetailView(result: result)
                                } label: {
                                    HStack {
                                        Text("\(result.displayDateString)\n\(result.sectionDisplayValueWithTimeRange)")
                                        // Ref: https://stackoverflow.com/a/71914266
                                            .multilineTextAlignment(.leading)
                                            .font(.system(type: appState.fontSizeType))
                                            .foregroundStyle(Color(uiColor: .secondaryLabel))
                                        Spacer()
                                        Image(systemName: "chevron.compact.right")
                                            .resizable()
                                            .frame(height: appState.fontSizeType.rawValue)
                                            .scaledToFit()
                                            .foregroundStyle(Color(uiColor: .secondaryLabel))
                                    }
                                }
                            })
                        }
                    }
                }
                .refreshable {
                    refreshResults()
                }
            }
        } else {
            Text("データがありません")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }

    func itemContextMenuView(toiletBigType: ToiletType.ToiletBigType, item: ToiletResultItem) -> some View {
        let leftToiletBigTypes = ToiletType.ToiletBigType.allCases.filter({ $0 != toiletBigType })

        return ForEach(leftToiletBigTypes, id: \.self) { type in
            Button(action: {
                let newItem = ToiletResultItem(
                    id: item.id,
                    toiletType: .big(type: type),
                    date: item.date,
                    deviceType: item.deviceType
                )
                SharedDefaults.update(item: newItem)
                refreshResults()
            }) {
                Text("\(type.rawValue)へ変更")
            }
        }
    }
}

private extension ToiletCheckInListView {
    func refreshResults() {
        withAnimation {
            resultItems = SharedDefaults.toiletResults
        }
    }

    func delete(at offsets: IndexSet, result: ToiletResult) {
        withAnimation {
            offsets.forEach { index in
                let item = result.items[index]
                SharedDefaults.remove(item: item)
            }
        } completion: {
            refreshResults()
        }
    }
}

#Preview {
    ToiletCheckInListView()
        .environment(AppState())
}

