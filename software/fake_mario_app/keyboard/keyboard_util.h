#ifndef KEYBOARD_UTIL_H
#define KEYBOARD_UTIL_H

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <io.h>
#include <fcntl.h>

#include "system.h"
#include "alt_types.h"
#include <unistd.h>  // usleep
#include "sys/alt_irq.h"
#include "io_handler.h"

#include "cy7c67200.h"
#include "usb.h"
#include "lcp_cmd.h"
#include "lcp_data.h"

#define KEYBOARD_A 4
#define KEYBOARD_S 22
#define KEYBOARD_W 26
#define KEYBOARD_D 7
#define KEYBOARD_R 21
#define KEYBOARD_ENTER 40
#define KEYBOARD_SPACE 44
#define KEYBOARD_ESC 41
#define KEYBOARD_NONE 240

int keyboard_init(void);
int get_keycode(void);

#endif