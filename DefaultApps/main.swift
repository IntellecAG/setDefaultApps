//
//  main.swift
//  DefaultApps
//
//  Created by Hartmann, Fabian (Ext) on 10.08.17.
//  Copyright © 2017 Intellec. All rights reserved.
//

import Foundation

// ---- DEFINITIONS ----
// var settingsdomain = "com.intellec.defaultapps"
// var settingskey = "force"
let stderr = FileHandle.standardError
let stdout = FileHandle.standardOutput

// function for setting the defaults apps
func setdefaults(_ settingskey: String, settingsdomain: String) {
    // set variables used later
    // the users input will be stored in here
    var input = ""
    // determs if the setting should be applied
    var runpolicy = false
    
    // checks if an argument is available
    if CommandLine.arguments.count > 1 {
        // stores the user input
        input = CommandLine.arguments[1]
        NSLog("run Policies containing Trigger: \(input)")
    }
    else {
        NSLog("no Trigger specified, run Policies containing Trigger: default")
    }

    // call class for handling settings
    let pref = UserDefaults()
    // set setting domain
    pref.addSuite(named: settingsdomain)

    if pref.objectIsForced(forKey: settingskey ,inDomain: settingsdomain) == true {
        // set array to content of setting domain
        let policyarray : NSArray = pref.array(forKey: settingskey)! as NSArray
        // calculate number of entries in the policy array for loop through
        let size = policyarray.count
        // loop through policy array
        for index in 0...size {
            if index < (size) {
                // set policy to a single policy entry ot the policy array
                let policy : NSDictionary = policyarray[index] as! NSDictionary
                // read content from policy
                let typ : NSString = policy.value(forKey: "Typ") as! NSString
                let appid : NSString = policy.value(forKey: "AppID") as! NSString
                let handler : NSString = policy.value(forKey: "Handler") as! NSString
                let trigger : NSString = policy.value(forKey: "Trigger") as! NSString
                // creates an array of triggers based on the seperator ", "
                let triggerarray = trigger.components(separatedBy: ", ")
              
                // checks if the user specified an input
                if !input.isEmpty {
                    // the curent handler modification entry will be checked for maching triggers
                    if !((triggerarray.filter({$0.hasPrefix(input)})).filter({$0.hasSuffix(input)})).isEmpty {
                        runpolicy = true
                    } else {
                        runpolicy = false
                    }
                // if the user didn't specify an input, "default" is used as trigger
                } else {
                    // the curent handler modification entry will be checked for maching "default" trigger
                    if !((triggerarray.filter({$0.hasPrefix("default")})).filter({$0.hasSuffix("default")})).isEmpty {
                        runpolicy = true
                    } else {
                        runpolicy = false
                    }
                }
                
                if runpolicy {
                    // determ which type is defined
                    switch typ {
                    case "content":
                        // set the Defaults for a ContentType
                        LSSetDefaultRoleHandlerForContentType(handler as CFString,LSRolesMask.all, appid)
                    case "url":
                        // set the Defaults for a URLSheme
                        LSSetDefaultHandlerForURLScheme(handler as CFString, appid)
                    default:
                        // handling unknown type
                        print("Error: \(typ) os an unknown operation specified in tpe policy")
                    }
                    NSLog("set ApplicationID: \(appid) to handle: \(handler)")
                }
            }
        }

    } else {
       print( "Only settings set by MDM are allowed.")
    }
    
}




// call function for setting the DefaultApp by provide the domain containing the settings and the key storing the policy
setdefaults("force" ,settingsdomain: "com.intellec.defaultapps")

 print("\n\nCreated by Fabian Hartmann on 10.08.17.\nCopyright © 2017 Intellec AG. All rights reserved.")
