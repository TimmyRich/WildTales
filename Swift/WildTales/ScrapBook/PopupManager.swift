//
//  PopupManager.swift
//  WildTales
//
//  Created by Yujie Wei on 18/4/2025
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
    
    func present() {
        guard !action.isPresented else { return }
        self.action = .present
    }
    
    func dismiss() {
        self.action = .dismiss
    }
}

extension PopupManager.Action {
    var isPresented: Bool { self == .present}
    
}
