# Fake_Mario
 This is our final project of ECE385

# introduction

We design a game “I Wanna Be the Fake Mario”, which is based on two famous games – Super Mario Bros and I Wanna. Using System Verilog, we implement the draw engine, which controls the display and decides which existing map should be shown. The hardware also controls the movement of spines. The NIOS II is used to interface with the USB keyboard as in lab8, and control the movement of the Mario. The judgement of mario’s state is also accomplished by the NIOS II. It sends signals to the hardware, and then hardware using draw engine decides what to be shown on the screen.

Our game includes the following features. Two background images, one for play and the other for success. There are two levels in our game, which have different degree of difficulty. When users die or success, we have information printed on screen to notify them how to continue or restart. Visuals include some basic graphics, such as bricks, Mario, spines and save points. In level 2, there is a group of spines which can be triggered by Mario. For interface, we connect the NIOS II Keyboard, which allows users to control the movement of Mario, including jump, forward and backward. We also add a background music for the game.


