//
//  main.swift
//  ExperimentsEverything
//
//  Created by Anbalagan on 12/11/25.
//



//POUND_KEYWORD(keyPath)
//POUND_KEYWORD(line)
//POUND_KEYWORD(selector)
//POUND_KEYWORD(file)
//POUND_KEYWORD(fileID)
//POUND_KEYWORD(filePath)
//POUND_KEYWORD(column)
//POUND_KEYWORD(function)
//POUND_KEYWORD(dsohandle)
//POUND_KEYWORD(assert)


//POUND_DIRECTIVE_KEYWORD(sourceLocation)
//POUND_DIRECTIVE_KEYWORD(warning)
//POUND_DIRECTIVE_KEYWORD(error)
//POUND_COND_DIRECTIVE_KEYWORD(if)
//POUND_COND_DIRECTIVE_KEYWORD(else)
//POUND_COND_DIRECTIVE_KEYWORD(elseif)
//POUND_COND_DIRECTIVE_KEYWORD(endif)


/// Use the `#sourceLocation` directive to change the current `#file` and `#line`
/// metadata that the compiler emits. This is useful when generating source or
/// when you want diagnostics and stack traces to refer to a different file
/// name or line number.
///
/// Example: set a custom file and line, print the current file and line, then
/// reset to the original location.

// Set custom information
#sourceLocation(file: "CustomFile.swift", line: 100)
print("\(#fileID):\(#line)")
// Reset to original
#sourceLocation()
