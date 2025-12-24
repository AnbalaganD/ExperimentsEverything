//
//  Basic.swift
//  ExperimentsEverything
//
//  Created by Anbalagan on 02/12/25.
//

import Foundation

/*
 
 #define _SYS_NAMELEN    256

 struct  utsname {
     char    sysname[_SYS_NAMELEN];  /* [XSI] Name of OS */
     char    nodename[_SYS_NAMELEN]; /* [XSI] Name of this network node */
     char    release[_SYS_NAMELEN];  /* [XSI] Release level */
     char    version[_SYS_NAMELEN];  /* [XSI] Version level */
     char    machine[_SYS_NAMELEN];  /* [XSI] Hardware type */
 };

 __BEGIN_DECLS
 int uname(struct utsname *);
 __END_DECLS
 
 */

// In C program sysname and other property of utsname is fixed size Array.
// In C fixed size array, swift will be interprete as tuples
// We can get the original name using "withUnsafeBytes" function

func basicInterOperability() {
    
    var systemInfo = utsname()
    uname(&systemInfo)
    print(systemInfo.machine) // This will print tuple with 256 value
    
    // Converting Tuple into readble String format
    let machine = withUnsafeBytes(of: &systemInfo.machine) { ptr in
        guard let cPtr = ptr.baseAddress?.assumingMemoryBound(to: CChar.self) else {
            return ""
        }
        return String(cString: cPtr)
    }
    
    print(machine)
    
    // We can use mirror also for this perpose
    let machineName = Mirror(reflecting: systemInfo.machine).children.reduce("") { result, element in
        guard let value = element.value as? Int8, value != 0 else {
            return result
        }
        return result + String(UnicodeScalar(UInt8(value)))
    }
    
    print(machineName)
}
