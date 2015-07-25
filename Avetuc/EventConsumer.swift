//
//  EventConsumer.swift
//  Avetuc
//
//  Created by Daiwei Lu on 7/25/15.
//  Copyright (c) 2015 Daiwei Lu. All rights reserved.
//

import Foundation
import SwiftTask

typealias HandlerTask = Task<Void, Void, Void>

class EventConsumer {

    typealias EventHandler = Any -> HandlerTask?

    let type: EventType
    let handler: EventHandler

    init<T>(type: EventType, handler: T -> HandlerTask?) {
        self.type = type
        self.handler = { handler($0 as! T) }
        Dispatcher.instance.register(self)
    }

    func consume(data: Any) -> HandlerTask? {
        return self.handler(data)
    }
    
}

func listen<T>(type: EventType, handler: T -> Void) -> EventConsumer {
    return EventConsumer(type: type) { (n: T) -> HandlerTask? in
        handler(n)

        //TODO: - Support async handler
        return nil
    }
}
