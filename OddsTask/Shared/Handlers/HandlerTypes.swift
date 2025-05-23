//
//  HandlerTypes.swift
//  OddsTask
//
//  Created by Özgü Ataseven on 17.05.2025.
//

import Foundation

public typealias VoidHandler = () -> Void
public typealias BooleanHandler = (Bool) -> Void
public typealias GenericHandler<T> = (T) -> Void
