; App.inc : アプリケーション
;


; マクロの定義
;

; ビデオ
APP_COLOR_TABLE                 =   0x2000
APP_COLOR_TABLE_O               =   0x2040
APP_COLOR_TABLE_I               =   0x2080
APP_COLOR_TABLE_T               =   0x20c0
APP_COLOR_TABLE_L               =   0x2100
APP_COLOR_TABLE_J               =   0x2140
APP_COLOR_TABLE_S               =   0x2180
APP_COLOR_TABLE_Z               =   0x21c0
APP_PATTERN_NAME_TABLE          =   0x1800
APP_PATTERN_GENERATOR_TABLE     =   0x0000
APP_SPRITE_ATTRIBUTE_TABLE      =   0x1b00
APP_SPRITE_GENERATOR_TABLE      =   0x3800

; アプリケーション
APP_STATE                       =   0x00
APP_MODE                        =   0x01
APP_FRAME                       =   0x02
APP_COLOR                       =   0x03
APP_SCORE_10000000              =   0x04
APP_SCORE_01000000              =   0x05
APP_SCORE_00100000              =   0x06
APP_SCORE_00010000              =   0x07
APP_SCORE_00001000              =   0x08
APP_SCORE_00000100              =   0x09
APP_SCORE_00000010              =   0x0a
APP_SCORE_00000001              =   0x0b
APP_LINE_10000000               =   0x0c
APP_LINE_01000000               =   0x0d
APP_LINE_00100000               =   0x0e
APP_LINE_00010000               =   0x0f
APP_LINE_00001000               =   0x10
APP_LINE_00000100               =   0x11
APP_LINE_00000010               =   0x12
APP_LINE_00000001               =   0x13
APP_DEBUG_0                     =   0x14
APP_DEBUG_1                     =   0x15
APP_DEBUG_2                     =   0x16
APP_DEBUG_3                     =   0x17
APP_DEBUG_4                     =   0x18
APP_DEBUG_5                     =   0x19
APP_DEBUG_6                     =   0x1a
APP_DEBUG_7                     =   0x1b
APP_LENGTH                      =   0x1c

; 状態
APP_STATE_NULL                  =   0x00
APP_STATE_TITLE_INITIALIZE      =   0x01
APP_STATE_TITLE_UPDATE          =   0x02
APP_STATE_GAME_INITIALIZE       =   0x03
APP_STATE_GAME_UPDATE           =   0x04

; モード
APP_MODE_NORMAL                 =   0x00
APP_MODE_REVERSE                =   0x01

; フレーム
APP_FRAME_NULL                  =   0x00

; 色
APP_COLOR_NULL                  =   0x00

; スコア
APP_SCORE_NULL                  =   0x00

; ライン
APP_LINE_NULL                   =   0x00

; デバッグ
APP_DEBUG_NULL                  =   0x00
APP_DEBUG_LENGTH                =   0x08

; 外部関数宣言
;

    .globl  _AppInitialize
    .globl  _AppUpdate
    .globl  _AppNull
    .globl  _AppDump

; 外部変数宣言
;

    .globl  _app
    