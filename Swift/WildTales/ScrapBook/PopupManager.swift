//
//  PopupManager.swift
//  WildTales
//
//  Created by Yujie Wei on 18/4/2025
//  It manages the presentation state of popup view in Scrapbook
//  Heavily inspired by the following content
//  Reference: https://www.youtube.com/watch?v=OaIn7HBlCSk

import Foundation

final class PopupManager: ObservableObject {

    enum Action {
        case none
        case present
        case dismiss
    }

    @Published private(set) var action: Action = .none

    // only proceed if the action is not presented
    func present() {
        guard !action.isPresented else { return }
        self.action = .present
    }

    func dismiss() {
        self.action = .dismiss
    }
}

extension PopupManager.Action {
    var isPresented: Bool { self == .present }

}
