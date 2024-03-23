; Title.inc : タイトル
;


; マクロの定義
;

; スプライト
TITLE_SPRITE_NULL               =   0x00
TITLE_SPRITE_LOGO               =   0x00

; ゲーム
TITLE_STATE                     =   0x00
TITLE_FRAME                     =   0x01
TITLE_LOGO                      =   0x02
TITLE_BLINK                     =   0x03
TITLE_LENGTH                    =   0x04

; 状態
TITLE_STATE_NULL                =   0x00
TITLE_STATE_LOOP                =   0x10
TITLE_STATE_START               =   0x20

; フレーム
TITLE_FRAME_NULL                =   0x00

; ロゴ
TITLE_LOGO_NULL                 =   0x00
TITLE_LOGO_LENGTH               =   0x28

; 点滅
TITLE_BLINK_NULL                =   0x00

; 外部関数宣言
;

    .globl  _TitleInitialize
    .globl  _TitleUpdate

; 外部変数宣言
;

    .globl  _title
