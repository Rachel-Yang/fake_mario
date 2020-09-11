#include "mario_move.h"
#include "block.h"
#include "keyboard/keyboard_util.h"

static int face_to(mario_move_t* mario) 
{
    if (mario->idx_last == STAND_RIGHT
     || mario->idx_last == RUN_RIGHT
     || mario->idx_last == JUMP_RIGHT
     )
        return FACE_RIGHT;
    return FACE_LEFT;
}

static void get_speed(mario_move_t* mario, int keycode, int acc_x, int acc_y, int level)
{
    int max_x = mario->speed_x_last + acc_x;
    int max_y = mario->speed_y_last + acc_y;
    int update_y = 0;
    if (max_y == 0)
    {
        update_y = 0;
    } else if (max_y < 0)
    {
        while (update_y > max_y && can_move(mario->pos_x_last, mario->pos_y_last + update_y, level))
            update_y --;
        if (update_y < 0)
            update_y ++;
    }
    else
    {
        while (update_y < max_y && can_move(mario->pos_x_last, mario->pos_y_last + update_y, level))
            update_y ++;
        if (update_y > 0) 
            update_y --;
    }

    int update_x = 0;
    if (max_x == 0)
    {
        update_x = 0;
    } 
    else if (max_x < 0)
    {
        while (update_x > max_x && can_move(mario->pos_x_last + update_x, mario->pos_y_last + update_y, level))
            update_x --;
        if (update_x < 0)
            update_x ++;
        if (update_x < -MARIO_X_SPEED_UPPER)
        {
            update_x = -MARIO_X_SPEED_UPPER;
        }
    }
    else
    {
        while (update_x < max_x && can_move(mario->pos_x_last + update_x, mario->pos_y_last + update_y, level))
            update_x ++;
        if (update_x > 0)
            update_x --;
        if (update_x > MARIO_X_SPEED_UPPER)
        {
            update_x = MARIO_X_SPEED_UPPER;
        }
    }
    mario->pos_x_curr = mario->pos_x_last + update_x;
    mario->pos_y_curr = mario->pos_y_last + update_y;
    mario->speed_x_curr = update_x;
    mario->speed_y_curr = update_y;
}

void mario_move_init(mario_move_t* mario, int level)
{
    switch (level)
    {
        case 0:
            mario->pos_x_curr = 0xFA;
            mario->pos_y_curr = 0x80;
            mario->idx = STAND_LEFT;
            mario->alive = MARIO_ALIVE;
            mario->level2_active = 2;
            break;
        case 1:
            mario->pos_x_curr = 5 * MARIO_X;
            mario->pos_y_curr = Y_UPPER - 4 * BLOCK_WIDTH - MARIO_Y;
            mario->idx = STAND_RIGHT;
            mario->alive = MARIO_ALIVE;
            mario->jump_ct = 0;
            mario->dir_ct = 0;
            mario->speed_x_curr = 0;
            mario->speed_y_curr = 0;
            mario->level2_active = RESET_LEVEL2;
            break;
        case 2:
            mario->pos_x_curr = X_UPPER - 3 * MARIO_X;
            mario->pos_y_curr = Y_UPPER - 10 * BLOCK_WIDTH - MARIO_Y - 1;
            mario->idx = STAND_LEFT;
            mario->alive = MARIO_ALIVE;
            mario->jump_ct = 0;
            mario->dir_ct = 0;
            mario->speed_x_curr = 0;
            mario->speed_y_curr = 0;
            mario->level2_active = RESET_LEVEL2;
            break;
        case 3:
            mario->pos_x_curr = 5 * BLOCK_WIDTH;
            mario->pos_y_curr = 5 * BLOCK_WIDTH;
            mario->idx = JUMP_RIGHT;
            mario->alive = MARIO_ALIVE;
            mario->jump_ct = 0;
            mario->dir_ct = 0;
            mario->speed_x_curr = 0;
            mario->speed_y_curr = 0;
            mario->level2_active = RESET_LEVEL2;
        default:
            break;
    }
    
}

int mario_move_update(mario_move_t* mario, int level, int keycode)
{
    // save last
    mario->pos_x_last = mario->pos_x_curr;
    mario->pos_y_last = mario->pos_y_curr;
    mario->idx_last = mario->idx;
    mario->speed_x_last = mario->speed_x_curr;
    mario->speed_y_last = mario->speed_y_curr;

    int acc_x, acc_y = 0;

    int keycode_group[2] = {keycode & 0x00FF, (keycode >> 8) & 0x00FF};
    int num = 0;

    if (keycode_group[0] == 0)
    {
        num = 1;
    } 
    else if (keycode_group[1] == 0) 
    {
        num = 1;
    }
    else
    {
        num = 2;
    }


    for (int i = 0; i < num; i++)
    {
        keycode = keycode_group[i];

    switch (keycode)
    {
    case KEYBOARD_A:
        if (is_ground(mario->pos_x_curr, mario->pos_y_curr))
        {
            acc_x = -(MARIO_X_ACC + MARIO_X_SPEED);
            acc_y = MARIO_Y_ACC;
        }
        else
        {
            acc_x = -(MARIO_X_ACC + MARIO_X_FLY_SPEED);
            acc_y = MARIO_Y_ACC;
        }
        break;
    case KEYBOARD_D:
        if (is_ground(mario->pos_x_curr, mario->pos_y_curr))
        {
            acc_x = MARIO_X_ACC + MARIO_X_SPEED;
            acc_y = MARIO_Y_ACC;
        }
        else
        {
            acc_x = MARIO_X_ACC + MARIO_X_FLY_SPEED;
            acc_y = MARIO_Y_ACC;
        }
        break;
    case KEYBOARD_W:
        if (mario->speed_x_last == 0)
            acc_x = 0;
        else
        {
            if (mario->speed_x_last > 0)
                acc_x = MARIO_X_ACC;
            else
                acc_x = -MARIO_X_ACC;
        }
        acc_y = MARIO_Y_ACC + MARIO_Y_SPEED;
        break;
    default:
        if (mario->speed_x_last == 0)
            acc_x = 0;
        else
        {
            if (mario->speed_x_last > 0)
            {
                if (mario->speed_x_last + MARIO_X_ACC > 0)
                    acc_x = MARIO_X_ACC;
                else 
                    acc_x = -mario->speed_x_last;
            }
            else
            {
                if (mario->speed_x_last - MARIO_X_ACC < 0)
                    acc_x = -MARIO_X_ACC;
                else
                    acc_x = -mario->speed_x_last;  
            }
        }
        acc_y = MARIO_Y_ACC;
        break;
    }
    
    // update speed and pos
    get_speed(mario, keycode, acc_x, acc_y, level);
    
    }

    // update idx
    switch (keycode)
    {
    case KEYBOARD_A:
        if (mario->idx_last != RUN_LEFT)
            mario->idx = RUN_LEFT;
        else
            mario->idx = STAND_LEFT;
        break;
    case KEYBOARD_D:
        if (mario->idx_last != RUN_RIGHT)
            mario->idx = RUN_RIGHT;
        else
            mario->idx = STAND_RIGHT;
        break;
    case KEYBOARD_W:
        if (face_to(mario) == FACE_RIGHT)
            mario->idx = JUMP_RIGHT;
        else
            mario->idx = JUMP_LEFT;
        break;
    default:
        if (face_to(mario) == FACE_RIGHT)
            mario->idx = STAND_RIGHT;
        else
            mario->idx = STAND_LEFT;
        break;
    }

    // not on ground
    if (!is_ground(mario->pos_x_curr, mario->pos_y_curr))
    {
        if (mario->speed_x_curr > 0)
            mario->idx = JUMP_RIGHT; 
        else if (mario->speed_x_curr < 0)
            mario->idx = JUMP_LEFT;
        else
        {
            if(face_to(mario) == FACE_RIGHT)
                mario->idx = JUMP_RIGHT;
            else
                mario->idx = JUMP_LEFT;
        }
    } 
    else
    {
        mario->jump_ct = 0;
        mario->dir_ct = 0;
    }

    return 0;
}
