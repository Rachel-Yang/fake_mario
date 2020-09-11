#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <io.h>
#include <fcntl.h>

#include "system.h"
#include "alt_types.h"
#include <unistd.h>  // usleep
#include "sys/alt_irq.h"

#include "keyboard/keyboard_util.h"
#include "draw_screen.h"
#include "block.h"
#include "spike.h"
#include "mario_move.h"

int handle_level(mario_move_t* mario, int level)
{
    switch (level)
    {
    case 1:
        // level1 - right
        if (mario->pos_x_curr + MARIO_X > MARIO_LV1_RIGHT_LIMIT)
        {
            mario->alive = 0;
            return LEVEL_RESTART;
        }
        // level1 - left
        if (mario->pos_x_curr < MARIO_LV1_LEFT_LIMIT)
        {
            mario->pos_x_curr = X_UPPER - 2 * MARIO_X;
            if (mario->pos_y_curr > 16 * BLOCK_WIDTH)
                mario->pos_y_curr = 18 * BLOCK_WIDTH;
            else
                mario->pos_y_curr = 14 * BLOCK_WIDTH;
            return LEVEL_SWITCH;
        }
        break;
    case 2:
        // right - down
        if (mario->pos_x_curr > 26 * BLOCK_WIDTH
         && mario->pos_y_curr + MARIO_Y > MARIO_UPPER_LIMIT)
        {
            mario->alive = 0;
            return LEVEL_BEFORE;
        }
        // right - up
        if (mario->pos_x_curr + MARIO_X > MARIO_LV1_RIGHT_LIMIT)
        {
            mario->pos_x_curr = MARIO_X;
            return LEVEL_SWITCH;
        }
        // left
        if (mario->pos_x_curr < MARIO_LV1_LEFT_LIMIT)
            if (mario->pos_y_curr < 13 * BLOCK_WIDTH)
            {
                mario->alive = 0;
                return LEVEL_RESTART;
            }
            else
            {
                return LEVEL_NEXT;
            }
        // active spike
        if (mario->pos_x_curr + MARIO_X < 5 * BLOCK_WIDTH
         && mario->pos_y_curr + MARIO_Y < 8 * BLOCK_WIDTH
         && mario->pos_y_curr + MARIO_Y > 7 * BLOCK_WIDTH)
            mario->level2_active = ACTIVE_LEVEL2;
        break;
    default: 
        break;
    }
    
    if (is_spike(mario->pos_x_curr, mario->pos_y_curr, level)
     || out_screen(mario->pos_x_curr, mario->pos_y_curr))
    {
         mario->alive = 0;
         return LEVEL_RESTART;
    }
    return LEVEL_CURR;
}

int handle_keycode(mario_move_t* mario, int level, int keycode)
{
    keycode = keycode & 0x00FF;
    if (keycode == KEYBOARD_D
     || keycode == KEYBOARD_A
     || keycode == KEYBOARD_W)
    {
        if (mario->dir_ct < 4)
        {
            mario->dir_ct += 1;
        }
        else
        {
            keycode = KEYBOARD_NONE;
        }
    }
    if (keycode == KEYBOARD_W)
    {
        if (mario->jump_ct < 2)
        {
            mario->jump_ct += 1;
        }
        else
        {
            keycode = KEYBOARD_NONE;
        }
    }
    switch (keycode)
        {
            case KEYBOARD_R:
                return LEVEL_RESTART;
                break;
            case KEYBOARD_ESC:
                return LEVEL_0;
                break;
            // case KEYBOARD_S:
            //     return LEVEL_NEXT;
            case 0:
                mario_move_update(mario, level, KEYBOARD_NONE);
                break;
            default:
                mario_move_update(mario, level, keycode);
                break;
        }

    return LEVEL_CURR;
}

int main()
{
    mario_move_t mario_move;
    int bg_idx, level;
    int keycode, keycode_last, keycode_curr;
    keyboard_init();

LEVEL0:
    level = 0; bg_idx = 0;
    level_block_info_init(level);
    level_spike_info_init(level);
    
    mario_move_init(&mario_move, level);
    while (get_keycode() != KEYBOARD_ENTER) {
        mario_move.idx = (STAND_LEFT + RUN_LEFT) - mario_move.idx;
        draw_screen(bg_idx, level, &mario_move);
    }

LEVEL1:
    level = 1; bg_idx = 0;
    mario_move_init(&mario_move, level);
    handle_keycode(&mario_move, level, KEYBOARD_NONE);
    draw_screen(bg_idx, level, &mario_move);

LEVEL1_SWITCH:
    level = 1; bg_idx = 0;
    level_block_info_init(level);
    level_spike_info_init(level);
    keycode_last = 0;
    while(1)
    {
        keycode_last = keycode_curr;
        keycode_curr = get_keycode();
        if (keycode_curr == KEYBOARD_R
         && keycode_curr == keycode_last)
            keycode = KEYBOARD_NONE;
        else
            keycode = keycode_curr;
        int flag = 0;
        flag = handle_keycode(&mario_move, level, keycode);
        draw_screen(bg_idx, level, &mario_move);
        switch (flag)
        {
            case LEVEL_RESTART:
                draw_screen(bg_idx, level, &mario_move);
                while (get_keycode() != KEYBOARD_R) {}
                goto LEVEL1;
                break;
            case LEVEL_0:
                goto LEVEL0;
                break;
            case LEVEL_NEXT:
                goto LEVEL2;
                break;
            default:
                break;
        }
        flag = handle_level(&mario_move, level);
        switch (flag)
        {
            case LEVEL_RESTART:
                draw_screen(bg_idx, level, &mario_move);
                while (get_keycode() != KEYBOARD_R) {}
                goto LEVEL1;
                break;
            case LEVEL_SWITCH:
                goto LEVEL2_SWITCH;
                break;
            default:
                break;
        }
        draw_screen(bg_idx, level, &mario_move);
    }
    
LEVEL2:
    level = 2; bg_idx = 0;
    mario_move_init(&mario_move, level);
    handle_keycode(&mario_move, level, KEYBOARD_NONE);
    draw_screen(bg_idx, level, &mario_move);
    
LEVEL2_SWITCH:
    level = 2; bg_idx = 0;
    level_block_info_init(level);
    level_spike_info_init(level);
    keycode_last = 0;
    while(1)
    {
        keycode_last = keycode_curr;
        keycode_curr = get_keycode();
        if (keycode_curr == KEYBOARD_R
         && keycode_curr == keycode_last)
            keycode = KEYBOARD_NONE;
        else
            keycode = keycode_curr;
        int flag = 0;
        flag = handle_keycode(&mario_move, level, keycode);
        draw_screen(bg_idx, level, &mario_move);
        switch (flag)
        {
            case LEVEL_RESTART:
                draw_screen(bg_idx, level, &mario_move);
                while (get_keycode() != KEYBOARD_R) {}
                goto LEVEL2;
                break;
            case LEVEL_0:
                goto LEVEL0;
                break;
            case LEVEL_NEXT:
                goto LEVEL1;
                break;
            default:
                break;
        }
        flag = handle_level(&mario_move, level);
        switch (flag)
        {
            case LEVEL_RESTART:
                draw_screen(bg_idx, level, &mario_move);
                while (get_keycode() != KEYBOARD_R) {}
                goto LEVEL2;
                break;
            case LEVEL_SWITCH:
                goto LEVEL1_SWITCH;
                break;
            case LEVEL_BEFORE:
                draw_screen(bg_idx, level, &mario_move);
                while (get_keycode() != KEYBOARD_R) {}
                goto LEVEL1;
                break;
            case LEVEL_NEXT:
                goto LEVEL3;
                break;
            default:
                break;
        }
        draw_screen(bg_idx, level, &mario_move);
    }

LEVEL3:
    level = 3; bg_idx = 1;
    mario_move_init(&mario_move, level);
    draw_screen(bg_idx, level, &mario_move);
    while(get_keycode() != KEYBOARD_ENTER) {}
    goto LEVEL0;

    /*//Unit Test 1: test keyboard
    keyboard_init();
    while(1)
        printf("keycode is:%d\n", get_keycode());
    */
   
    /*//Unit Test 0: test key, leds, sw
	volatile unsigned int *LEDR_PIO = (unsigned int*)0xE0; //make a pointer to access the PIO block
    volatile unsigned int *LEDG_PIO = (unsigned int*)0xF0;
    volatile unsigned int *KEY_PIO = (unsigned int*)0xD0;
    volatile unsigned int *SW_PIO = (unsigned int*)0x100;

    *LEDR_PIO = 0; //clear all LEDRs
    *LEDG_PIO = 0; //clear all LEDGs

    while ( (1+1) != 3) //infinite loop
    {
        *LEDR_PIO = *SW_PIO;
        *LEDG_PIO = *KEY_PIO & (0x0F);
    }*/
	return 0; //never gets here

}
