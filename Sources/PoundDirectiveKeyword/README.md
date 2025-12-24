# Swift Pound Keywords and Directives

Swift uses various compiler-reserved constructs prefixed with `#`, known as **pound keywords** and **pound directives**, to inject metadata, control compilation, and influence diagnostics. These are categorized as follows:

---

## 🧠 POUND_KEYWORD

These are **compiler-injected expressions** that provide contextual metadata at compile time. They can be used in runtime code, especially for diagnostics, logging, and source introspection.

| Keyword      | Description |
|--------------|-------------|
| `#keyPath`   | Creates a key path to a property, used in KVO and Swift reflection. |
| `#line`      | Current line number in source file. |
| `#selector`  | Converts a Swift method into an Objective-C selector. |
| `#file`      | Full path of the current source file. |
| `#fileID`    | Module-relative identifier for the current file. |
| `#filePath`  | Absolute path of the current file. |
| `#column`    | Current column number in source file. |
| `#function`  | Name of the current function or method. |
| `#dsohandle` | Handle to the dynamic shared object (used for symbol resolution). |
| `#assert`    | Used internally for compiler assertions. |

---

## ⚙️ POUND_DIRECTIVE_KEYWORD

These are **compiler directives** that affect how the source code is interpreted or compiled. They are not expressions and cannot be used in runtime logic.

| Directive         | Description |
|-------------------|-------------|
| `#sourceLocation` | Overrides the current file and line metadata for diagnostics and logging. |
| `#warning`        | Emits a custom warning during compilation. |
| `#error`          | Emits a custom error during compilation. |

---

## 🔀 POUND_COND_DIRECTIVE_KEYWORD

These are **conditional compilation directives** used to include or exclude code based on build configuration flags.

| Conditional Directive | Description |
|------------------------|-------------|
| `#if`                  | Begins a conditional compilation block. |
| `#else`                | Provides an alternative block if the condition is false. |
| `#elseif`              | Adds an additional conditional branch. |
| `#endif`               | Ends the conditional compilation block. |

---

## 🧪 Example Usage

```swift
#if DEBUG
print("Debug mode: \(#fileID):\(#line)")
#else
print("Release mode")
#endif

#sourceLocation(file: "CustomFile.swift", line: 42)
print("Location overridden: \(#fileID):\(#line)")
#sourceLocation()

#warning("This API is deprecated and will be removed in future versions.")
