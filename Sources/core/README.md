# core

`core` is a small Clang module used by the Swift experiments in this package. It exposes C declarations from its public headers through [module.modulemap](include/module.modulemap).

## Module layout

| Area | Purpose |
|---|---|
| [include/](include/) | Public C headers and the API Notes overlay consumed by Clang. |
| [src/](src/) | C implementation files. |
| [module.modulemap](include/module.modulemap) | Declares the `core` Clang module and exports its headers. |
| [core.apinotes](include/core.apinotes) | Changes how selected C declarations are imported into Swift without modifying the C headers. |

The module map exports [BitField.h](include/BitField.h), [IntArray.h](include/IntArray.h), and [misc.h](include/misc.h). Code that imports `core` from Swift can therefore use the public declarations from those headers.

## Clang API Notes

An `.apinotes` file is a YAML-like metadata overlay for a Clang module. It lets an API author improve the Swift import of an existing C or Objective-C API while leaving the original C header untouched.

This module’s [core.apinotes](include/core.apinotes) has three effects:

1. It identifies the module as `core`, matching the module map.
2. It imports the C function-pointer typedef `my_assert_message_provider_t` as the more Swift-like `AssertMessageProvider`.
3. It imports `my_assert` as `coreAssert(_:message:)` and marks its second parameter as nonnull.

The underlying C declaration remains:

```c
void my_assert(bool condition, my_assert_message_provider_t messageProvider);
```

but Swift code sees the API using the names and nullability provided by the overlay. This keeps C and Swift naming conventions separate while preserving a single C ABI.

For related Apple documentation, see [Customizing Objective-C APIs](https://developer.apple.com/documentation/swift/objective-c-and-c-code-customization) and [Renaming Objective-C APIs for Swift](https://developer.apple.com/documentation/swift/renaming-objective-c-apis-for-swift).

## C APIs demonstrated

### Assertion callback

[misc.h](include/misc.h) declares `my_assert` and the `my_assert_message_provider_t` callback type. [misc.c](src/misc.c) calls the optional provider only when the condition is false, then writes the resulting message to standard error.

The `extern "C"` block in the header prevents C++ name mangling, allowing the same function to be linked from both C and C++.

### Flexible array member

[IntArray.h](include/IntArray.h) demonstrates a dynamically sized C allocation:

```c
typedef struct IntArray {
    int count;
    int capacity;
    int values[];
} IntArray;
```

`values[]` has no storage inside `sizeof(IntArray)`. `IntArray_Create` calculates enough trailing space with `IntArray_allocation_size_for_capacity`, and `IntArray_Push` grows that allocation with `realloc`. Because a reallocation can move the allocation, `IntArray_Push` accepts `IntArray **` and updates the caller’s pointer.

Use `IntArray_Destroy` to release an array created by `IntArray_Create`.

### Packed bit fields

[BitField.h](include/BitField.h) defines `unix_permission_t`, a packed bit-field structure representing read, write, and execute permissions in one byte. `unix_permission_create()` returns a value with read and write enabled.

Bit-field layout is implementation-defined, so this is a useful interop experiment but should not be used as a portable serialized or network format without defining the byte-level representation explicitly.

## Source links

- [BitField.h](include/BitField.h) · [BitField.c](src/BitField.c)
- [IntArray.h](include/IntArray.h) · [IntArray.c](src/IntArray.c)
- [misc.h](include/misc.h) · [misc.c](src/misc.c)
- [module.modulemap](include/module.modulemap)
- [core.apinotes](include/core.apinotes)
