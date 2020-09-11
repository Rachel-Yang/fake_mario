#ifndef MARIO_MOVE_H
#define MARIO_MOVE_H

// Screen Info
#define X_UPPER 640
#define X_LOWER 0
#define Y_UPPER 480
#define Y_LOWER 0

// Level Info
#define MARIO_LOWER_LIMIT 10
#define MARIO_UPPER_LIMIT (Y_UPPER - MARIO_LOWER_LIMIT)
#define MARIO_LV1_LEFT_LIMIT 5
#define MARIO_LV1_RIGHT_LIMIT (X_UPPER - MARIO_LV1_LEFT_LIMIT)

// Mario Info
#define MARIO_X  20
#define MARIO_Y  24
#define MARIO_X_FLY_SPEED +33
#define MARIO_X_SPEED 15
#define MARIO_Y_SPEED -30
#define MARIO_X_ACC   -8
#define MARIO_Y_ACC   +8
#define MARIO_X_SPEED_UPPER 20
#define MARIO_ALIVE   1

// Active
#define ACTIVE_LEVEL2 1
#define RESET_LEVEL2 2

#define STAND_RIGHT 0
#define RUN_RIGHT 1
#define STAND_LEFT 2
#define RUN_LEFT 3
#define JUMP_RIGHT 4
#define JUMP_LEFT 5
#define FACE_LEFT 6
#define FACE_RIGHT 7
#define LEVEL_0 8
#define LEVEL_BEFORE 9
#define LEVEL_CURR 10
#define LEVEL_NEXT 11
#define LEVEL_RESTART 12
#define LEVEL_SWITCH 13

struct mario_move_t
{
    int pos_x_last, pos_y_last, pos_x_curr, pos_y_curr;
    int idx_last, idx, alive;
    int jump_ct, dir_ct;
    int speed_x_last, speed_y_last, speed_x_curr, speed_y_curr;
    int level2_active;
};
typedef struct mario_move_t mario_move_t;

void mario_move_init(mario_move_t* mario, int level);
int mario_move_update(mario_move_t* mario, int level, int keycode);

#endif
