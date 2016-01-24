//
//  main.swift
//  TZEAdmin
//
//  Created by Michael L Mehr on 1/16/16.
//  Copyright © 2016 Michael L. Mehr. All rights reserved.
//

import Foundation

let cli = CommandLine()

let commandList: String = "\n"
"\t GENMASTERTZLIST - Generate the master time zone list data in CSV format\n"


let command = StringOption(shortFlag: "c", helpMessage: "Specify the REST API command to use.\n\(commandList)")

let options = [command]

// ADMIN TASKS:
cli.addOptions(options)

do {
    try cli.parse()
} catch {
    cli.printUsage(error)
    exit(EX_USAGE)
}

if let comd = command.value {
    switch command.value! {
    case "GENMASTERTZLIST":
        print(serializeTimeZoneNames(true))
    default:
        print("Unspecified command.")
        break
    }
} else {
    print("Help")
}
