; Block.inc : ブロック
;


; マクロの定義
;

; ブロック
BLOCK_STATE                     =   0x00
BLOCK_FLAG                      =   0x01
BLOCK_TYPE                      =   0x02
BLOCK_POSITION_X                =   0x03
BLOCK_POSITION_Y                =   0x04
BLOCK_ROTATE                    =   0x05
BLOCK_MOVE                      =   0x06
BLOCK_MOVE_LEFT                 =   0x07
BLOCK_MOVE_RIGHT                =   0x08
BLOCK_LOCK                      =   0x09
BLOCK_SPRITE_L                  =   0x0a
BLOCK_SPRITE_H                  =   0x0b
BLOCK_BAG_0_0                   =   0x0c
BLOCK_BAG_0_1                   =   0x0d
BLOCK_BAG_0_2                   =   0x0e
BLOCK_BAG_0_3                   =   0x0f
BLOCK_BAG_0_4                   =   0x10
BLOCK_BAG_0_5                   =   0x11
BLOCK_BAG_0_6                   =   0x12
BLOCK_BAG_1_0                   =   0x13
BLOCK_BAG_1_1                   =   0x14
BLOCK_BAG_1_2                   =   0x15
BLOCK_BAG_1_3                   =   0x16
BLOCK_BAG_1_4                   =   0x17
BLOCK_BAG_1_5                   =   0x18
BLOCK_BAG_1_6                   =   0x19
BLOCK_LENGTH                    =   0x1a

; 状態
BLOCK_STATE_NULL                =   0x00
BLOCK_STATE_PLAY                =   0x10
BLOCK_STATE_OVER                =   0x20

; フラグ
BLOCK_FLAG_NULL                 =   0x00
BLOCK_FLAG_OVER_BIT             =   0x07
BLOCK_FLAG_OVER                 =   (1 << BLOCK_FLAG_OVER_BIT)
BLOCK_FLAG_LOCK_BIT             =   0x06
BLOCK_FLAG_LOCK                 =   (1 << BLOCK_FLAG_LOCK_BIT)

; 種類
BLOCK_TYPE_NULL                 =   0x00
BLOCK_TYPE_O                    =   0x01
BLOCK_TYPE_I                    =   0x02
BLOCK_TYPE_T                    =   0x03
BLOCK_TYPE_L                    =   0x04
BLOCK_TYPE_J                    =   0x05
BLOCK_TYPE_S                    =   0x06
BLOCK_TYPE_Z                    =   0x07

; 位置
BLOCK_POSITION_NULL             =   0x00

; 回転
BLOCK_ROTATE_NORTH              =   0x00
BLOCK_ROTATE_EAST               =   0x01
BLOCK_ROTATE_SOUTH              =   0x02
BLOCK_ROTATE_WEST               =   0x03

; 移動
BLOCK_MOVE_NULL                 =   0x00
BLOCK_MOVE_REPEAT_BEGIN         =   0x12
BLOCK_MOVE_REPEAT_CONTINUE      =   0x04

; ロック
BLOCK_LOCK_NULL                 =   0x00
BLOCK_LOCK_DOWN                 =   0x1e

; スプライト
BLOCK_SPRITE_NULL               =   0x00

; バッグ
BLOCK_BAG_NULL                  =   0x00
BLOCK_BAG_LENGTH                =   0x07

; 大きさ
BLOCK_SIZE                      =   0x04

; 外部関数宣言
;

    .globl  _BlockInitialize
    .globl  _BlockUpdate
    .globl  _BlockRender
    .globl  _BlockIsOver
    .globl  _BlockIsLock
    .globl  _BlockGetColor

; 外部変数宣言
;

    .globl  _block
