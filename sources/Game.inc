; Game.inc : ゲーム
;


; マクロの定義
;

; スプライト
GAME_SPRITE_NULL                =   0x00
GAME_SPRITE_BLOCK               =   0x00
GAME_SPRITE_MATCH               =   0x10

; ゲーム
GAME_STATE                      =   0x00
GAME_FRAME                      =   0x01
GAME_SCORE_10000000             =   0x02
GAME_SCORE_01000000             =   0x03
GAME_SCORE_00100000             =   0x04
GAME_SCORE_00010000             =   0x05
GAME_SCORE_00001000             =   0x06
GAME_SCORE_00000100             =   0x07
GAME_SCORE_00000010             =   0x08
GAME_SCORE_00000001             =   0x09
GAME_LINE_10000000              =   0x0a
GAME_LINE_01000000              =   0x0b
GAME_LINE_00100000              =   0x0c
GAME_LINE_00010000              =   0x0d
GAME_LINE_00001000              =   0x0e
GAME_LINE_00000100              =   0x0f
GAME_LINE_00000010              =   0x10
GAME_LINE_00000001              =   0x11
GAME_RATE_100                   =   0x12
GAME_RATE_010                   =   0x13
GAME_RATE_001                   =   0x14
GAME_MATCH                      =   0x15
GAME_ANIMATION                  =   0x16
GAME_BGM                        =   0x17
GAME_LENGTH                     =   0x18

; 状態
GAME_STATE_NULL                 =   0x00
GAME_STATE_START                =   0x10
GAME_STATE_PLAY                 =   0x20
GAME_STATE_LOCK                 =   0x30
GAME_STATE_MATCH                =   0x40
GAME_STATE_REDUCE               =   0x50
GAME_STATE_OVER                 =   0x60
GAME_STATE_RESULT               =   0x70

; フレーム
GAME_FRAME_NULL                 =   0x00

; スコア
GAME_SCORE_NULL                 =   0x00

; ライン
GAME_LINE_NULL                  =   0x00

; レート
GAME_RATE_NULL                  =   0x00

; 揃ったライン数
GAME_MATCH_NULL                 =   0x00

; アニメーション
GAME_ANIMATION_NULL             =   0x00
GAME_ANIMATION_MATCH            =   0x10

; BGM
GAME_BGM_NULL                   =   0x00
GAME_BGM_LENGTH                 =   0x04

; パターンネーム
GAME_PATTERN_NAME_UNDERLINE     =   0xa0
GAME_PATTERN_NAME_TOP_LEFT      =   0xa1
GAME_PATTERN_NAME_TOP_CENTER    =   0xa2
GAME_PATTERN_NAME_TOP_RIGHT     =   0xa3
GAME_PATTERN_NAME_MIDDLE_LEFT   =   0xa4
GAME_PATTERN_NAME_MIDDLE_CENTER =   0xa0
GAME_PATTERN_NAME_MIDDLE_RIGHT  =   0xa5
GAME_PATTERN_NAME_BOTTOM_LEFT   =   0xa6
GAME_PATTERN_NAME_BOTTOM_CENTER =   0xa7
GAME_PATTERN_NAME_BOTTOM_RIGHT  =   0xa8

; 外部関数宣言
;

    .globl  _GameInitialize
    .globl  _GameUpdate

; 外部変数宣言
;

    .globl  _game
