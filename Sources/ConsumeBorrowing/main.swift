//
//  main.swift
//  ExperimentsEverything
//
//  Created by Anbalagan on 07/11/24.
//

/// By default, most Swift types are `Copyable`.
/// This means values can be copied and used independently unless a type
/// explicitly opts out (e.g., by declaring `~Copyable`).
// A simple `User` type that is copyable by default.
struct User {
    var name: String
}

func checkOwnership() {
    let newUser = User(name: "Anonymous")
    let userCopy = consume newUser
    print(userCopy.name)
    
    // Uncomment below line see the compiler error
    // print(newUser)
    
    let anbalagan = User(name: "Anbalagan")
    takeFullControl(anbalagan)
    print(anbalagan)
    
    takeFullControl(consume anbalagan) // Pass full ownership to this function
    // Uncomment below line see the compiler error
    // print(anbalagan)
}

checkOwnership()
modifyAndPrint(User(name: "Anonymous"))

/// Modifies and prints a borrowed `User`.
///
/// - Parameter user: A `borrowing` parameter which allows read-only access
///   to the caller's value without taking ownership. Because the function
///   only borrows the value, it cannot mutate `user` directly and the caller
///   retains ownership after the call returns.
///
/// Ownership notes:
/// - `borrowing` means this function receives a transient reference to the
///   value. You may read from it, but writes are forbidden. Attempting to
///   assign to `user` or mutate its properties will result in a compiler error.
/// - To create a local, mutable value from a borrowed one, use the contextual
///   `copy` keyword. `copy user` produces an independent value you own and can
///   freely mutate inside this scope without affecting the original `user`.
///
/// In this example, `anbu` is created via `copy user`, then mutated, while
/// `user` remains unchanged and readable.

func modifyAndPrint(_ user: borrowing User) {
    // Uncomment below line see the compiler error
    // user.name = "Hello"
    
    // Here `copy` is contextual keywork
    var anbu = copy user
    anbu.name = "Anbu"
    print(user.name)
    print(anbu)
}

/// Takes full ownership of a `User`.
///
/// - Parameter user: A `consuming` parameter that transfers ownership of the
///   value into this function. After the call, the caller can no longer use the
///   passed argument unless it provided a fresh value (e.g., with `copy`) or
///   regains ownership some other way.
///
/// Ownership notes:
/// - `consuming` means this function becomes the unique owner of `user`.
///   The caller's binding is invalidated once the call is made.
/// - Because this function owns `user`, it may freely mutate it (e.g.,
///   `user.name = "Anbu"`) and even reassign the parameter to a new value
///   (`user = User(name: "Anbu D")`).
/// - Attempting to use the original argument at the call site after passing
///   it as `consuming` will result in a compiler error, because ownership has
///   been transferred.
func takeFullControl(_ user: consuming User) {
    user.name = "Anbu"
    print(user)
    user = User(name: "Anbu D")
    print(user)
}


/// A non-copyable `Payment` type that models a single-use resource.
///
/// This type opts out of copyability using `~Copyable`, which means values of
/// `Payment` cannot be implicitly or explicitly copied. You must move them
/// (transfer ownership) when passing to functions, or explicitly consume them
/// when you are done.
///
/// Why non-copyable? Some domains have resources that must not be duplicated
/// (file handles, network connections, payments, database transactions).
/// Making the type non-copyable lets the compiler enforce single ownership
/// and one-time use, preventing accidental duplication of critical operations.
struct Payment: ~Copyable {
    // `borrowing` indicates this method borrows `self` (doesn't consume it)
    borrowing func inspect() {
        print("Inspecting payment - self is still valid after this")
    }
    
    /// Executes the payment as a one-time operation.
    ///
    /// - Ownership: The method is marked `consuming`, which means it takes
    ///   ownership of `self`. After calling `run()`, the caller can no longer
    ///   use the same instance because ownership has been transferred into
    ///   this method.
    ///
    /// - Lifecycle: In a `consuming` method, you must either:
    ///   1. Return/move the value (transferring ownership to the caller), or
    ///   2. Explicitly end its lifetime using `discard self`
    ///
    ///   Since `run()` completes the payment and there is nothing meaningful
    ///   to return, we explicitly end the lifetime with `discard self`.
    ///
    /// Why `discard self`?
    /// - It explicitly tells the compiler that this owned, non-copyable value
    ///   is intentionally consumed and its lifetime ends here.
    /// - It prevents a compiler error about an unused consumed parameter.
    /// - **Critical**: `discard self` explicitly SUPPRESSES the call to `deinit`.
    ///   The value is destroyed immediately without running any cleanup code.
    /// - Use `discard` only when you are certain no cleanup is needed, or when
    ///   you've already performed all necessary cleanup manually before the discard.
    /// - If your type requires cleanup in `deinit`, either perform cleanup
    ///   manually before using `discard`, or let the value go out of scope
    ///   naturally (which will call `deinit` automatically).
    consuming func run() {
        // Perform payment work here...
        print("Processing payment...")
        
        // Explicitly end the lifetime WITHOUT calling deinit.
        // Only use this when no cleanup is needed.
        discard self
    }

    /// Cleanup hook that runs when a `Payment` instance's lifetime ends.
    ///
    /// `deinit` is called automatically when:
    /// - The instance goes out of scope naturally
    /// - A consuming method completes without using `discard self`
    /// - The value is dropped in any context that allows natural destruction
    ///
    /// `deinit` is **NOT** called when:
    /// - You explicitly use `discard self` (which suppresses deinit)
    ///
    /// Use `deinit` for deterministic cleanup:
    /// - Releasing external resources (file handles, network connections)
    /// - Logging or auditing that the resource was finalized
    /// - Canceling operations or notifying other systems
    /// - Closing database transactions or network sessions
    ///
    /// **Important**: If your type needs cleanup in deinit, be careful with
    /// `discard self`. Either perform manual cleanup before discarding, or
    /// avoid using `discard` altogether and let the value be destroyed naturally.
    deinit {
        // Clean up external resources here if needed.
        print("Payment finalized and resources released")
    }
}

// USAGE EXAMPLES:

// Example 1: Using run() which discards and skips deinit
func processPayment() {
    let payment = Payment()
    payment.run()  // Prints "Processing payment..." but NOT "Payment finalized..."
}

// Example 2: Letting payment go out of scope naturally (deinit WILL be called)
func createPayment() {
    let payment = Payment()
    // payment goes out of scope here
}
