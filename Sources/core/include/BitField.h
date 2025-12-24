//
//  Header.h
//  ExperimentsEverything
//
//  Created by Anbalagan on 19/12/25.
//

#include <stdint.h>

#ifndef BITFIELD_H
#define BITFIELD_H

typedef struct __attribute__((__packed__)) unix_permission {
    uint8_t read    : 1;
    uint8_t write   : 1;
    uint8_t execute : 1;
    uint8_t reserved: 5;
} unix_permission_t;

unix_permission_t unix_permission_create() {
    unix_permission_t perm = { .read = 1, .write = 1, .execute = 0, .reserved = 0 };
    return perm;
}

#endif /* BITFIELD_H */

