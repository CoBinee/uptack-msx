; Field.inc : フィールド
;


; マクロの定義
;

; フィールド
FIELD_NULL                      =   0x00
FIELD_BLOCK_BIT                 =   0x07
FIELD_BLOCK                     =   (1 << FIELD_BLOCK_BIT)
FIELD_PATTERN_MASK              =   0x0f
FIELD_PATTERN_TOP_BIT           =   0x03
FIELD_PATTERN_TOP               =   (1 << FIELD_PATTERN_TOP_BIT)
FIELD_PATTERN_BOTTOM_BIT        =   0x02
FIELD_PATTERN_BOTTOM            =   (1 << FIELD_PATTERN_BOTTOM_BIT)
FIELD_PATTERN_LEFT_BIT          =   0x01
FIELD_PATTERN_LEFT              =   (1 << FIELD_PATTERN_LEFT_BIT)
FIELD_PATTERN_RIGHT_BIT         =   0x00
FIELD_PATTERN_RIGHT             =   (1 << FIELD_PATTERN_RIGHT_BIT)

; 大きさ
FIELD_SIZE_X                    =   0x10
FIELD_SIZE_Y                    =   0x20

; プレイ
FIELD_PLAY_LEFT                 =   0x03
FIELD_PLAY_TOP                  =   0x05
FIELD_PLAY_RIGHT                =   0x0c
FIELD_PLAY_BOTTOM               =   0x1c
FIELD_PLAY_WIDTH                =   0x0a
FIELD_PLAY_HEIGHT               =   0x18

; 視界
FIELD_VIEW_LEFT                 =   0x02
FIELD_VIEW_TOP                  =   0x09
FIELD_VIEW_RIGHT                =   0x0d
FIELD_VIEW_BOTTOM               =   0x1d
FIELD_VIEW_WIDTH                =   0x0c
FIELD_VIEW_HEIGHT               =   0x15
FIELD_VIEW_SPRITE_X             =   0x40
FIELD_VIEW_SPRITE_Y             =   (0x18 - (FIELD_VIEW_TOP * 0x08))

; 更新
FIELD_UPDATE_LEFT               =   0x02
FIELD_UPDATE_TOP                =   0x05
FIELD_UPDATE_RIGHT              =   0x0d
FIELD_UPDATE_BOTTOM             =   0x1d
FIELD_UPDATE_WIDTH              =   0x0c
FIELD_UPDATE_HEIGHT             =   0x19

; 開始位置
FIELD_START_X                   =   0x07
FIELD_START_Y                   =   0x08

; 揃ったライン
FIELD_MATCH_NULL                =   0xff

; アラート
FIELD_ALERT_Y                   =   0x0f

; 外部関数宣言
;

    .globl  _FieldInitialize
    .globl  _FieldUpdate
    .globl  _FieldRender
    .globl  _FieldUpdatePattern
    .globl  _FieldPrintPattern
    .globl  _FieldPlace
    .globl  _FieldIsPlace
    .globl  _FieldIsMatch
    .globl  _FieldGetMatchTopLine
    .globl  _FieldEliminate
    .globl  _FieldReduce
    .globl  _FieldFillLine
    .globl  _FieldIsAlert

; 外部変数宣言
;

    .globl  _field
