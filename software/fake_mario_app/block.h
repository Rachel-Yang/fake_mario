#ifndef BLOCK_H
#define BLOCK_H

// Block Info
#define BLOCK_WIDTH 20
#define BLOCK_X_NUM 32
#define BLOCK_Y_NUM 24
#define BLOCK_NUM   (BLOCK_X_NUM * BLOCK_Y_NUM)
#define BLOCK_SET   1
#define BLOCK_UNSET 0

int out_screen(int pos_x, int pos_y);
int is_block(int pos_x, int pos_y);
int is_wall(int pos_x, int pos_y);
int is_ground(int pos_x, int pos_y);
int can_move(int pos_x, int pos_y, int level);

void set_block(int x_start, int x_num, int y_start, int y_num, char set);
void level_block_info_init(int level);

#endif
