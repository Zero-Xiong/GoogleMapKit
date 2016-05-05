//
//  TypesTableViewControllerDelegate.swift
//  GoogleMapKit
//
//  Created by xiong on 5/5/16.
//  Copyright © 2016 Zero Inc. All rights reserved.
//

import Foundation

protocol TypesTableViewControllerDelegate: class {
    func typesController(controller: TypesTableViewController, didSelectTypes types: [String])
}