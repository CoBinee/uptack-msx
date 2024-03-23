; Sound.inc : サウンド
;


; マクロの定義
;

; BGM
SOUND_BGM_NULL                  =   0x00
SOUND_BGM_TITLE                 =   0x01
SOUND_BGM_START                 =   0x02
SOUND_BGM_OVER                  =   0x03
SOUND_BGM_GAME_NORMAL_0         =   0x04
SOUND_BGM_GAME_NORMAL_1         =   0x05
SOUND_BGM_GAME_NORMAL_2         =   0x06
SOUND_BGM_GAME_NORMAL_3         =   0x07
SOUND_BGM_GAME_ALERT_0          =   0x08
SOUND_BGM_GAME_ALERT_1          =   0x09
SOUND_BGM_GAME_ALERT_2          =   0x0a
SOUND_BGM_GAME_ALERT_3          =   0x0b

; SE
SOUND_SE_NULL                   =   0x00
SOUND_SE_BOOT                   =   0x01
SOUND_SE_CLICK                  =   0x02
SOUND_SE_LOCK                   =   0x03
SOUND_SE_REDUCE                 =   0x04

; 外部関数宣言
;

    .globl  _SoundPlayBgm
    .globl  _SoundPlaySe
    .globl  _SoundStop
    .globl  _SoundIsPlayBgm
    .globl  _SoundIsPlaySe

; 外部変数宣言
;
