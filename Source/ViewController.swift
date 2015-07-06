//
//  ViewController.swift
//  Avetuc
//
//  Created by Daiwei Lu on 7/5/15.
//  Copyright (c) 2015 Daiwei Lu. All rights reserved.
//

import UIKit
import CoreStore

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let app = UIApplication.sharedApplication().delegate as! AppDelegate
        let dataStack = app.dataStack

        let entities = dataStack.fetchAll(From(MyEntity))

        println(entities)

        dataStack.beginAsynchronous { (transaction) -> Void in
            let entity = transaction.create(Into(MyEntity))
            entity.name = "Daiwei"
            entity.count = 123
            transaction.commit()
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

