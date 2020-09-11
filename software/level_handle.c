#include "level_handle.h"
#include "keyboard/keyboard_util.h"

static int out_screen(int pos_x, int pos_y)
{
    int flag = 0;
    if (pos_y < MARIO_LOWER_LIMIT
     || pos_y > MARIO_UPPER_LIMIT)
        flag = 1;
    return flag;
}

static int die_state(mario_move_t* mario)
{
    mario->alive = 0;
    printf("[FAKE MARIO INFO] Please press 'R' to retry. \n");
    while (get_keycode() != KEYBOARD_R) {}
    return LEVEL_RESTART;
}

static void handle_level_2(mario_move_t* mario)
{
    int i = 0;
    
}

int handle_level(mario_move_t* mario, int level)
{
    // determine alive
    if (is_spike(mario->pos_x_curr, mario->pos_y_curr)
     || out_screen(mario->pos_x_curr, mario->pos_y_curr))
    {
         return die_state(mario);
    }

    switch (level)
    {
    case 1:
        if (mario->pos_x_curr + MARIO_X > MARIO_LV1_RIGHT_LIMIT)
        {
            return die_state(mario);
        }
        if (mario->pos_x_curr < MARIO_LV1_LEFT_LIMIT)
        {
            mario->pos_x_curr = X_UPPER - MARIO_X;
            return LEVEL_NEXT;
        }
        break;
    case 2:
        if (mario->pos_x_curr + MARIO_X > MARIO_LV1_RIGHT_LIMIT)
        {
            mario->pos_x_curr = 0;
            return LEVEL_BEFORE;
        }

        if (mario->pos_x_curr < MARIO_LV1_LEFT_LIMIT)
        {
            return LEVEL_NEXT;
        }
        handle_level_2(mario);
        break;
    default: 
        break;
    }
    return LEVEL_CURR;
}

int handle_keycode(mario_move_t* mario, int level, int keycode)
{
    switch (keycode)
        {
            case KEYBOARD_ESC:
                return LEVEL_0;
                break;
            case KEYBOARD_S:
                return LEVEL_NEXT;
            case 0:
                mario_move_update(mario, level, KEYBOARD_NONE);
                break;
            case KEYBOARD_W:
                if (mario->jump_ct == 0 || mario->jump_ct == 1)
                {
                    mario->jump_ct += 1;
                    printf("[FAKE MARIO INFO] keycode: %x\n", keycode);
                    mario_move_update(mario, level, keycode);
                }
                else
                {
                    printf("[FAKE MARIO INFO] Sorry, you can only jump twice.");
                }
                break;
            default:
                printf("[FAKE MARIO INFO] keycode: %x\n", keycode);
                mario_move_update(mario, level, keycode);
                break;
        }

    return LEVEL_CURR;
}
