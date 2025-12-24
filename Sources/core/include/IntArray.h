//
//  IntArray.h
//  ExperimentsEverything
//
//  Created by Anbalagan on 02/12/25.
//

#ifndef IntArray_h
#define IntArray_h

#include <stdio.h>
#include <stdlib.h> // for malloc, free, size_t
#include <string.h> // for memcpy (optional)

// IntArray with a flexible array member. Allocate with enough trailing storage.
typedef struct IntArray {
    int count;     // number of valid elements
    int capacity;  // number of allocated elements in values
    int values[];  // flexible array member
} IntArray;

// Compute the total allocation size for an IntArray with given capacity
static inline size_t IntArray_allocation_size_for_capacity(int capacity) {
    if (capacity < 0) capacity = 0;
    return sizeof(IntArray) + (size_t)capacity * sizeof(int);
}

// Create a new IntArray with the given initial capacity. Elements are zero-initialized.
static inline IntArray *IntArray_Create(int capacity) {
    if (capacity < 0) capacity = 0;
    size_t bytes = IntArray_allocation_size_for_capacity(capacity);
    IntArray *arr = (IntArray *)malloc(bytes);
    if (!arr) {
        return NULL;
    }
    arr->count = 0;
    arr->capacity = capacity;
    // Zero-initialize the values region
    if (capacity > 0) {
        memset(arr->values, 0, (size_t)capacity * sizeof(int));
    }
    return arr;
}

// Destroys an IntArray allocated by IntArray_Create
static inline void IntArray_Destroy(IntArray *arr) {
    if (arr) {
        free(arr);
    }
}

// Push a value, growing the allocation if needed. Returns 0 on success, -1 on OOM.
static inline int IntArray_Push(IntArray **arrPtr, int value) {
    if (!arrPtr || !*arrPtr) return -1;
    IntArray *arr = *arrPtr;
    if (arr->count >= arr->capacity) {
        int newCap = arr->capacity > 0 ? arr->capacity * 2 : 4;
        size_t newBytes = IntArray_allocation_size_for_capacity(newCap);
        IntArray *newArr = (IntArray *)realloc(arr, newBytes);
        if (!newArr) {
            return -1;
        }
        // Zero the newly added capacity region
        if (newCap > arr->capacity) {
            memset(newArr->values + arr->capacity, 0, (size_t)(newCap - arr->capacity) * sizeof(int));
        }
        newArr->capacity = newCap;
        *arrPtr = newArr;
        arr = newArr;
    }
    arr->values[arr->count++] = value;
    return 0;
}

#endif /* IntArray_h */
