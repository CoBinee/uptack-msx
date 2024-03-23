; Sound.s : サウンド
;


; モジュール宣言
;
    .module Sound

; 参照ファイル
;
    .include    "bios.inc"
    .include    "System.inc"
    .include    "App.inc"
    .include	"Sound.inc"

; 外部変数宣言
;

; マクロの定義
;


; CODE 領域
;
    .area   _CODE

; BGM を再生する
;
_SoundPlayBgm::

    ; レジスタの保存
    push    hl
    push    bc
    push    de

    ; a < BGM

    ; 現在再生している BGM の取得
    ld      bc, (_soundChannel + SOUND_CHANNEL_A + SOUND_CHANNEL_HEAD)

    ; サウンドの再生
    add     a, a
    ld      e, a
    add     a, a
    add     a, e
    ld      e, a
    ld      d, #0x00
    ld      hl, #soundBgm
    add     hl, de
    ld      e, (hl)
    inc     hl
    ld      d, (hl)
    inc     hl
    ld      a, e
    cp      c
    jr      nz, 10$
    ld      a, d
    cp      b
    jr      z, 19$
10$:
    ld      (_soundChannel + SOUND_CHANNEL_A + SOUND_CHANNEL_REQUEST), de
    ld      e, (hl)
    inc     hl
    ld      d, (hl)
    inc     hl
    ld      (_soundChannel + SOUND_CHANNEL_B + SOUND_CHANNEL_REQUEST), de
    ld      e, (hl)
    inc     hl
    ld      d, (hl)
;   inc     hl
    ld      (_soundChannel + SOUND_CHANNEL_C + SOUND_CHANNEL_REQUEST), de
19$:

    ; レジスタの復帰
    pop     de
    pop     bc
    pop     hl

    ; 終了
    ret

; SE を再生する
;
_SoundPlaySe::

    ; レジスタの保存
    push    hl
    push    de

    ; a < SE

    ; サウンドの再生
    add     a, a
    ld      e, a
    ld      d, #0x00
    ld      hl, #soundSe
    add     hl, de
    ld      e, (hl)
    inc     hl
    ld      d, (hl)
;   inc     hl
    ld      (_soundChannel + SOUND_CHANNEL_D + SOUND_CHANNEL_REQUEST), de

    ; レジスタの復帰
    pop     de
    pop     hl

    ; 終了
    ret

; サウンドを停止する
;
_SoundStop::

    ; レジスタの保存

    ; サウンドの停止
    call    _SystemStopSound

    ; レジスタの復帰

    ; 終了
    ret

; BGM が再生中かどうかを判定する
;
_SoundIsPlayBgm::

    ; レジスタの保存
    push    hl

    ; cf > 0/1 = 停止/再生中

    ; サウンドの監視
    ld      hl, (_soundChannel + SOUND_CHANNEL_A + SOUND_CHANNEL_REQUEST)
    ld      a, h
    or      l
    jr      nz, 10$
    ld      hl, (_soundChannel + SOUND_CHANNEL_A + SOUND_CHANNEL_PLAY)
    ld      a, h
    or      l
    jr      nz, 10$
    or      a
    jr      19$
10$:
    scf
19$:

    ; レジスタの復帰
    pop     hl

    ; 終了
    ret

; SE が再生中かどうかを判定する
;
_SoundIsPlaySe::

    ; レジスタの保存
    push    hl

    ; cf > 0/1 = 停止/再生中

    ; サウンドの監視
    ld      hl, (_soundChannel + SOUND_CHANNEL_D + SOUND_CHANNEL_REQUEST)
    ld      a, h
    or      l
    jr      nz, 10$
    ld      hl, (_soundChannel + SOUND_CHANNEL_D + SOUND_CHANNEL_PLAY)
    ld      a, h
    or      l
    jr      nz, 10$
    or      a
    jr      19$
10$:
    scf
19$:

    ; レジスタの復帰
    pop     hl

    ; 終了
    ret

; 共通
;
soundNull:

    .ascii  "T1@0"
    .db     0x00

; BGM
;
soundBgm:

    .dw     soundNull, soundNull, soundNull
    .dw     soundBgmTitle_0, soundBgmTitle_1, soundBgmTitle_2
    .dw     soundBgmStart_0, soundBgmStart_1, soundBgmStart_2
    .dw     soundBgmOver_0, soundNull, soundNull
    .dw     soundBgmGameNormal_0_0, soundBgmGameNormal_0_1, soundBgmGameNormal_0_2
    .dw     soundBgmGameNormal_1_0, soundBgmGameNormal_1_1, soundBgmGameNormal_1_2
    .dw     soundBgmGameNormal_2_0, soundBgmGameNormal_2_1, soundBgmGameNormal_2_2
    .dw     soundBgmGameNormal_3_0, soundBgmGameNormal_3_1, soundBgmGameNormal_3_2
    .dw     soundBgmGameAlert_0_0, soundBgmGameAlert_0_1, soundBgmGameAlert_0_2
    .dw     soundBgmGameAlert_1_0, soundBgmGameAlert_1_1, soundBgmGameAlert_1_2
    .dw     soundBgmGameAlert_2_0, soundBgmGameAlert_2_1, soundBgmGameAlert_2_2
    .dw     soundBgmGameAlert_3_0, soundBgmGameAlert_3_1, soundBgmGameAlert_3_2

; タイトル
soundBgmTitle_0:

    .ascii  "T3@0V15,3"
    .ascii  "L3O4EBABGBF+BEBABGBF+BEBABGBF+BEBABGBF+E"
    .ascii  "L3O4DAGAF+AEADAGAF+AEADAGAF+AEADAGAF+AED"
    .db     0xff

soundBgmTitle_1:

    .ascii  "T3@0V13,3"
    .ascii  "L1O3E3EEE3EEE3EEE3EEE3EEE3EEE3EEE3EEE3EEE3EEE3EEE3EEE3EEE3EEE3EEE3EE"
    .ascii  "L1O3D3DDD3DDD3DDD3DDD3DDD3DDD3DDD3DDD3DDD3DDD3DDD3DDD3DDD3DDD3DDD+3D+D+"
    .db     0xff

soundBgmTitle_2:

    .ascii  "T3@0V13,8"
    .ascii  "L9O4EEEE"
    .ascii  "L9O4DDDD7E1F+1G1B1O5D5"
    .db     0xff

; スタート
soundBgmStart_0:

    .ascii  "T3@0V15,3"
    .ascii  "L1O4BO5CO4BAO4BO5CO4BAO4BO5CO4BAO4BO5CO4BAO5D+8R5"
    .db     0x00

soundBgmStart_1:

    .ascii  "T3@0V15,6"
    .ascii  "O4F+9B8R5"
    .db     0x00

soundBgmStart_2:

    .ascii  "T3@0V15,6"
    .ascii  "O4D+9F+8R5"
    .db     0x00

; ゲームオーバー
soundBgmOver_0:

    .ascii  "T3@0V15L7O4DCRR"
    .db     0x00

; ゲーム（通常）
soundBgmGameNormal_0_0:

    .ascii  "T3@0V15,3"
    .ascii  "L5O4EBEB"
    .ascii  "L3O5E4E1DCDO4BG5"
    .db     0x00

soundBgmGameNormal_1_0:

    .ascii  "T3@0V15,3"
    .ascii  "L3O5C4C1O4BABGE5"
    .ascii  "L3O4AGF+ED+5B5"
    .db     0x00

soundBgmGameNormal_2_0:

    .ascii  "T3@0V15,3"
    .ascii  "L5O4EBEB"
    .ascii  "L3O5E4E1DCDO4BG5"
    .db     0x00

soundBgmGameNormal_3_0:

    .ascii  "T3@0V15,3"
    .ascii  "L3O5C4C1O4BABGE5"
    .ascii  "L3O4BAGF+E8R5"
    .db     0x00

soundBgmGameNormal_0_1:

    .ascii  "T3@0V13,3"
    .ascii  "L1O3E3EEE3EEE3EE"
    .ascii  "L1O3C3CCC3CCO2G3GGG3GG"
    .db     0x00

soundBgmGameNormal_1_1:

    .ascii  "T3@0V13,3"
    .ascii  "L1O2A3AAA3AAO3E3EEE3EE"
    .ascii  "L1O2A3AAA+3A+A+B3BBB3BB"
    .db     0x00

soundBgmGameNormal_2_1:

    .ascii  "T3@0V13,3"
    .ascii  "L1O3E3EEE3EEE3EE"
    .ascii  "L1O3C3CCC3CCO2G3GGG3GG"
    .db     0x00

soundBgmGameNormal_3_1:

    .ascii  "T3@0V13,3"
    .ascii  "L1O2A3AAA3AAO3E3EEE3EE"
    .ascii  "L1O2B3O3C3C+3D+3E3EEE3EEE3EEE3EE"
    .db     0x00

soundBgmGameNormal_0_2:

    .ascii  "T3@0V15,5"
    .ascii  "L5O3E7GB"
    .ascii  "L7O4ED"
    .db     0x00

soundBgmGameNormal_1_2:

    .ascii  "T3@0V15,5"
    .ascii  "L7O4CO3B"
    .ascii  "L5O3AA+BF+"
    .db     0x00

soundBgmGameNormal_2_2:

    .ascii  "T3@0V15,5"
    .ascii  "L5O3E7GB"
    .ascii  "L7O4ED"
    .db     0x00

soundBgmGameNormal_3_2:

    .ascii  "T3@0V15,5"
    .ascii  "L7O4CO3B"
    .ascii  "L3O3BAGF+E8R5"
    .db     0x00

; ゲーム（警戒）
soundBgmGameAlert_0_0:

    .ascii  "T2@0V15,3"
    .ascii  "L5O4EBEB"
    .ascii  "L3O5E4E1DCDO4BG5"
    .db     0x00

soundBgmGameAlert_1_0:

    .ascii  "T2@0V15,3"
    .ascii  "L3O5C4C1O4BABGE5"
    .ascii  "L3O4AGF+ED+5B5"
    .db     0x00

soundBgmGameAlert_2_0:

    .ascii  "T2@0V15,3"
    .ascii  "L5O4EBEB"
    .ascii  "L3O5E4E1DCDO4BG5"
    .db     0x00

soundBgmGameAlert_3_0:

    .ascii  "T2@0V15,3"
    .ascii  "L3O5C4C1O4BABGE5"
    .ascii  "L3O4BAGF+E8R5"
    .db     0x00

soundBgmGameAlert_0_1:

    .ascii  "T2@0V13,3"
    .ascii  "L1O3E3EEE3EEE3EE"
    .ascii  "L1O3C3CCC3CCO2G3GGG3GG"
    .db     0x00

soundBgmGameAlert_1_1:

    .ascii  "T2@0V13,3"
    .ascii  "L1O2A3AAA3AAO3E3EEE3EE"
    .ascii  "L1O2A3AAA+3A+A+B3BBB3BB"
    .db     0x00

soundBgmGameAlert_2_1:

    .ascii  "T2@0V13,3"
    .ascii  "L1O3E3EEE3EEE3EE"
    .ascii  "L1O3C3CCC3CCO2G3GGG3GG"
    .db     0x00

soundBgmGameAlert_3_1:

    .ascii  "T2@0V13,3"
    .ascii  "L1O2A3AAA3AAO3E3EEE3EE"
    .ascii  "L1O2B3O3C3C+3D+3E3EEE3EEE3EEE3EE"
    .db     0x00

soundBgmGameAlert_0_2:

    .ascii  "T2@0V15,5"
    .ascii  "L5O3E7GB"
    .ascii  "L7O4ED"
    .db     0x00

soundBgmGameAlert_1_2:

    .ascii  "T2@0V15,5"
    .ascii  "L7O4CO3B"
    .ascii  "L5O3AA+BF+"
    .db     0x00

soundBgmGameAlert_2_2:

    .ascii  "T2@0V15,5"
    .ascii  "L5O3E7GB"
    .ascii  "L7O4ED"
    .db     0x00

soundBgmGameAlert_3_2:

    .ascii  "T2@0V15,5"
    .ascii  "L7O4CO3B"
    .ascii  "L3O3BAGF+E8R5"
    .db     0x00

; SE
;
soundSe:

    .dw     soundNull
    .dw     soundSeBoot
    .dw     soundSeClick
    .dw     soundSeLock
    .dw     soundSeReduce

; ブート
soundSeBoot:

    .ascii  "T2@0V15L3O6BO5BR9"
    .db     0x00

; クリック
soundSeClick:

    .ascii  "T2@0V15O4B0"
    .db     0x00

; ロックダウン
soundSeLock:

    .ascii  "T1@0V15L1O3B"
    .db     0x00

; 詰め
soundSeReduce:

    .ascii  "T1@0V15,3L7O2C"
    .db     0x00


; DATA 領域
;
    .area   _DATA

; 変数の定義
;
