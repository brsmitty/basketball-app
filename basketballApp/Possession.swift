//
//  Possession.swift
//  basketball-app
//
//  Created by David on 11/23/18.
//  Copyright © 2018 David Zucco. All rights reserved.
//

import UIKit

/** Defines a posession */
class Possession: NSObject {
    var actions: [Action]
    var removedActions: [Action]
    
    init(actions: [Action]?) {
        self.actions = actions ?? []
        self.removedActions = []
    }
    
    func addNewAction(action: Action) {
        self.actions.append(action)
    }
    
    func removeAction() {
        self.removedActions.append(actions.remove(at: actions.count - 1))
    }
    
    func restoreRemovedAction() {
        self.actions.append(self.removedActions.remove(at: actions.count - 1))
    }
}
