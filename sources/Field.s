; Field.s : フィールド
;


; モジュール宣言
;
    .module Field

; 参照ファイル
;
    .include    "bios.inc"
    .include    "vdp.inc"
    .include    "System.inc"
    .include    "App.inc"
    .include    "Sound.inc"
    .include    "Game.inc"
    .include	"Field.inc"

; 外部変数宣言
;

; マクロの定義
;


; CODE 領域
;
    .area   _CODE

; フィールドを初期化する
;
_FieldInitialize::
    
    ; レジスタの保存
    
    ; フィールドの初期化
    ld      hl, #fieldDefault
    ld      de, #_field
    ld      bc, #(FIELD_SIZE_X * FIELD_SIZE_Y)
    ldir

    ; レジスタの復帰
    
    ; 終了
    ret

; フィールドを更新する
;
_FieldUpdate::
    
    ; レジスタの保存
    
    ; レジスタの復帰
    
    ; 終了
    ret

; フィールドを描画する
;
_FieldRender::

    ; レジスタの保存

    ; レジスタの復帰

    ; 終了
    ret

; フィールドのパターンを更新する
;
_FieldUpdatePattern::

    ; レジスタの保存
    push    hl
    push    bc
    push    de

    ; パターンの更新
    ld      hl, #(_field + FIELD_UPDATE_TOP * FIELD_SIZE_X + FIELD_UPDATE_LEFT)
    ld      de, #FIELD_SIZE_X
    ld      b, #FIELD_UPDATE_HEIGHT
10$:
    push    bc
    ld      b, #FIELD_UPDATE_WIDTH
11$:
    xor     a
    ld      c, a
    sbc     hl, de
    ld      a, (hl)
    rlca
    rl      c
    add     hl, de
    add     hl, de
    ld      a, (hl)
    rlca
    rl      c
    or      a
    sbc     hl, de
    dec     hl
    ld      a, (hl)
    rlca
    rl      c
    inc     hl
    inc     hl
    ld      a, (hl)
    rlca
    rl      c
    dec     hl
    ld      a, (hl)
    and     #~FIELD_PATTERN_MASK
    or      c
    ld      (hl), a
    inc     hl
    djnz    11$
    ld      bc, #(FIELD_SIZE_X - FIELD_UPDATE_WIDTH)
    add     hl, bc
    pop     bc
    djnz    10$

    ; レジスタの復帰
    pop     de
    pop     bc
    pop     hl

    ; 終了
    ret

; フィールドのパターンを描画する
;
_FieldPrintPattern::

    ; レジスタの保存
    push    hl
    push    bc
    push    de

    ; パターンの描画
    ld      a, (_app + APP_MODE)
    or      a
    jr      nz, 110$

    ; NORMAL の描画
100$:
    ld      hl, #(_field + FIELD_VIEW_TOP * FIELD_SIZE_X + FIELD_VIEW_LEFT)
    ld      de, #(_patternName + 0x006a)
    ld      b, #FIELD_VIEW_HEIGHT
101$:
    push    bc
    ld      b, #FIELD_VIEW_WIDTH
102$:
    ld      a, (hl)
    and     #(FIELD_BLOCK | FIELD_PATTERN_MASK)
    ld      (de), a
    inc     hl
    inc     de
    djnz    102$
    ld      bc, #(FIELD_SIZE_X - FIELD_VIEW_WIDTH)
    add     hl, bc
    ex      de, hl
    ld      bc, #(0x0020 - FIELD_VIEW_WIDTH)
    add     hl, bc
    ex      de, hl
    pop     bc
    djnz    101$
    jr      190$

    ; REVERSE の描画
110$:
    ld      hl, #(_field + FIELD_VIEW_TOP * FIELD_SIZE_X + FIELD_VIEW_LEFT)
    ld      de, #(_patternName + 0x02b5)
    ld      bc, #((FIELD_VIEW_HEIGHT << 8) | 0x10)
111$:
    push    bc
    ld      b, #FIELD_VIEW_WIDTH
112$:
    ld      a, (hl)
    and     #(FIELD_BLOCK | FIELD_PATTERN_MASK)
    add     a, c
    ld      (de), a
    inc     hl
    dec     de
    djnz    112$
    ld      bc, #(FIELD_SIZE_X - FIELD_VIEW_WIDTH)
    add     hl, bc
    ex      de, hl
    ld      bc, #-(0x0020 - FIELD_VIEW_WIDTH)
    add     hl, bc
    ex      de, hl
    pop     bc
    djnz    111$
;   jr      190$

    ; 描画の完了
190$:

    ; レジスタの復帰
    pop     de
    pop     bc
    pop     hl

    ; 終了
    ret

; フィールドにブロックを置く
;
_FieldPlace::

    ; レジスタの保存
    push    hl
    push    bc

    ; de < Y/X 位置
    ; hl < オフセット

    ; ブロックを置く
    ld      b, #0x04
10$:
    push    bc
    ld      a, e
    add     a, (hl)
    inc     hl
    ld      c, a
    ld      a, d
    add     a, (hl)
    inc     hl
    ld      b, #0x00
    add     a, a
    rl      b
    add     a, a
    rl      b
    add     a, a
    rl      b
    add     a, a
    rl      b
    add     a, c
    ld      c, a
    push    hl
    ld      hl, #_field
    add     hl, bc
    set     #FIELD_BLOCK_BIT, (hl)
    pop     hl
    pop     bc
    djnz    10$

    ; レジスタの復帰
    pop     bc
    pop     hl

    ; 終了
    ret

; フィールドにブロックが置けるかどうかを判定する
;
_FieldIsPlace::

    ; レジスタの保存
    push    hl
    push    bc

    ; de < Y/X 位置
    ; hl < オフセット
    ; cf > 1 = 置ける

    ; ブロックの判定
    ld      b, #0x04
10$:
    push    bc
    ld      a, e
    add     a, (hl)
    inc     hl
    ld      c, a
    ld      a, d
    add     a, (hl)
    inc     hl
    ld      b, #0x00
    add     a, a
    rl      b
    add     a, a
    rl      b
    add     a, a
    rl      b
    add     a, a
    rl      b
    add     a, c
    ld      c, a
    push    hl
    ld      hl, #_field
    add     hl, bc
    bit     #FIELD_BLOCK_BIT, (hl)
    pop     hl
    pop     bc
    jr      nz, 11$
    djnz    10$
    scf
    jr      19$
11$:
    or      a
;   jr      19$
19$:

    ; レジスタの復帰
    pop     bc
    pop     hl

    ; 終了
    ret

; ラインが揃ったかどうかを判定する
;
_FieldIsMatch::

    ; レジスタの保存
    push    hl
    push    bc
    push    de

    ; a > 揃ったライン数

    ; 揃ったラインの初期化
    ld      hl, #(fieldMatch + 0x0000)
    ld      de, #(fieldMatch + 0x0001)
    ld      bc, #(0x0004 - 0x0001)
    ld      (hl), #FIELD_MATCH_NULL
    ldir

    ; ラインの走査
    ld      hl, #(_field + FIELD_PLAY_TOP * FIELD_SIZE_X + FIELD_PLAY_LEFT)
    ld      de, #fieldMatch
    ld      c, #FIELD_PLAY_TOP
10$:
    ld      a, #FIELD_PLAY_WIDTH
    ld      b, a
11$:
    bit     #FIELD_BLOCK_BIT, (hl)
    jr      z, 12$
    dec     a
12$:
    inc     hl
    djnz    11$
    or      a
    jr      nz, 13$
    ld      a, c
    ld      (de), a
    inc     de
13$:
    push    bc
    ld      bc, #(FIELD_SIZE_X - FIELD_PLAY_WIDTH)
    add     hl, bc
    pop     bc
    inc     c
    ld      a, c
    cp      #(FIELD_PLAY_BOTTOM + 0x01)
    jr      c, 10$

    ; 揃ったライン数の取得
    ld      hl, #fieldMatch
    ld      bc, #0x0400
20$:
    ld      a, (hl)
    cp      #FIELD_MATCH_NULL
    jr      z, 21$
    inc     c
21$:
    inc     hl
    djnz    20$
    ld      a, c

    ; レジスタの復帰
    pop     de
    pop     bc
    pop     hl

    ; 終了
    ret

; 揃ったラインの一番上の位置を取得する
;
_FieldGetMatchTopLine::

    ; レジスタの保存
    
    ; a > ライン

    ; ラインの取得
    ld      a, (fieldMatch)

    ; レジスタの復帰

    ; 終了
    ret

; フィールドから揃ったラインを除去する
;
_FieldEliminate::

    ; レジスタの保存

    ; cf > 1 = ライン除去の完了

    ; ラインの除去
    ld      hl, #fieldMatch
    ld      bc, #0x0400
10$:
    ld      a, (hl)
    cp      #FIELD_MATCH_NULL
    jr      z, 19$
    push    hl
    ld      d, #0x00
    add     a, a
    rl      d
    add     a, a
    rl      d
    add     a, a
    rl      d
    add     a, a
    rl      d
    add     a, #(FIELD_PLAY_LEFT + (FIELD_PLAY_WIDTH / 2))
    ld      e, a
    ld      hl, #_field
    add     hl, de
    ld      e, l
    ld      d, h
    dec     de
    ld      a, #(FIELD_PLAY_WIDTH / 2)
11$:
    bit     #FIELD_BLOCK_BIT, (hl)
    jr      nz, 12$
    inc     hl
    dec     de
    dec     a
    jr      nz, 11$
    inc     c
    jr      13$
12$:
    res     #FIELD_BLOCK_BIT, (hl)
    ex      de, hl
    res     #FIELD_BLOCK_BIT, (hl)
    ex      de, hl
;   jr      13$
13$:
    pop     hl
19$:
    inc     hl
    djnz    10$

    ; 除去の完了
    ld      a, c
    or      a
    jr      z, 90$
    scf
90$:

    ; レジスタの復帰

    ; 終了
    ret

; フィールドの空いたラインを詰める
;
_FieldReduce::

    ; レジスタの保存
    push    hl
    push    bc
    push    de

    ; ブロックを詰める
    ld      de, #(_field + FIELD_PLAY_BOTTOM * FIELD_SIZE_X + FIELD_PLAY_LEFT)
    ld      b, #FIELD_PLAY_BOTTOM
100$:

    ; 空行の判定
    ld      l, e
    ld      h, d
    xor     a
    ld      c, #FIELD_PLAY_WIDTH
110$:
    or      (hl)
    inc     hl
    dec     c
    jr      nz, 110$
    rlca
    jr      c, 130$

    ; １ライン詰める
120$:
    ld      l, e
    ld      h, d
    ld      c, b
121$:
    push    de
    ld      de, #-FIELD_SIZE_X
    add     hl, de
    pop     de
    dec     c
    push    hl
    push    bc
    xor     a
    ld      b, #FIELD_PLAY_WIDTH
122$:
    or      (hl)
    inc     hl
    djnz    122$
    pop     bc
    pop     hl
    rlca
    jr      c, 123$
    ld      a, c
    or      a
    jr      nz, 121$
    jr      190$
123$:
    push    de
    push    bc
    push    hl
    ld      bc, #FIELD_PLAY_WIDTH
    ldir
    pop     hl
    ld      e, l
    ld      d, h
    inc     de
    ld      bc, #(FIELD_PLAY_WIDTH - 0x0001)
    ld      (hl), #0x00
    ldir
    pop     bc
    pop     de
;   jr      130$

    ; 次のラインへ
130$:
    ex      de, hl
    ld      de, #-FIELD_SIZE_X
    add     hl, de
    ex      de, hl
    dec     b
    jr      nz, 100$
;   jr      190$

    ; 詰めの完了
190$:

    ; レジスタの復帰
    pop     de
    pop     bc
    pop     hl

    ; 終了
    ret

; １行埋める
;
_FieldFillLine::

    ; レジスタの保存
    push    hl
    push    bc
    push    de

    ; a < ライン

    ; 1 ライン埋める
    ld      d, #0x00
    add     a, a
    rl      d
    add     a, a
    rl      d
    add     a, a
    rl      d
    add     a, a
    rl      d
    add     a, #FIELD_PLAY_LEFT
    ld      e, a
    ld      hl, #_field
    add     hl, de
    ld      e, l
    ld      d, h
    inc     de
    ld      bc, #(FIELD_PLAY_WIDTH - 0x01)
    ld      (hl), #FIELD_BLOCK
    ldir

    ; レジスタの復帰
    pop     de
    pop     bc
    pop     hl

    ; 終了
    ret

; フィールドが警戒ラインを超えているかを判定する
;
_FieldIsAlert::

    ; レジスタの保存
    push    hl
    push    bc

    ; cf > 1 = 警戒ライン

    ; フィールドの監視
    ld      hl, #(_field + FIELD_ALERT_Y * FIELD_SIZE_X + FIELD_PLAY_LEFT)
    ld      b, #FIELD_PLAY_WIDTH
10$:
    bit     #FIELD_BLOCK_BIT, (hl)
    jr      nz, 18$
    inc     hl
    djnz    10$
    or      a
    jr      19$
18$:
    scf
;   jr      19$
19$:

    ; レジスタの復帰
    pop     bc
    pop     hl

    ; 終了
    ret

; 定数の定義
;

; フィールドの初期値
;
fieldDefault:

    .db     0x80, 0x80, 0x80, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x80, 0x80, 0x80
    .db     0x80, 0x80, 0x80, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x80, 0x80, 0x80
    .db     0x80, 0x80, 0x80, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x80, 0x80, 0x80
    .db     0x80, 0x80, 0x80, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x80, 0x80, 0x80
    .db     0x80, 0x80, 0x80, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x80, 0x80, 0x80
    .db     0x80, 0x80, 0x80, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x80, 0x80, 0x80  ; PLAY TOP
    .db     0x80, 0x80, 0x80, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x80, 0x80, 0x80
    .db     0x80, 0x80, 0x80, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x80, 0x80, 0x80
    .db     0x80, 0x80, 0x80, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x80, 0x80, 0x80  ; START Y
    .db     0x80, 0x80, 0x80, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x80, 0x80, 0x80  ; VIEW TOP
    .db     0x80, 0x80, 0x80, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x80, 0x80, 0x80
    .db     0x80, 0x80, 0x80, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x80, 0x80, 0x80
    .db     0x80, 0x80, 0x80, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x80, 0x80, 0x80
    .db     0x80, 0x80, 0x80, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x80, 0x80, 0x80
    .db     0x80, 0x80, 0x80, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x80, 0x80, 0x80
    .db     0x80, 0x80, 0x80, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x80, 0x80, 0x80
    .db     0x80, 0x80, 0x80, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x80, 0x80, 0x80
    .db     0x80, 0x80, 0x80, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x80, 0x80, 0x80
    .db     0x80, 0x80, 0x80, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x80, 0x80, 0x80
    .db     0x80, 0x80, 0x80, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x80, 0x80, 0x80
    .db     0x80, 0x80, 0x80, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x80, 0x80, 0x80
    .db     0x80, 0x80, 0x80, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x80, 0x80, 0x80
    .db     0x80, 0x80, 0x80, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x80, 0x80, 0x80
    .db     0x80, 0x80, 0x80, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x80, 0x80, 0x80
    .db     0x80, 0x80, 0x80, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x80, 0x80, 0x80
    .db     0x80, 0x80, 0x80, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x80, 0x80, 0x80
    .db     0x80, 0x80, 0x80, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x80, 0x80, 0x80
    .db     0x80, 0x80, 0x80, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x80, 0x80, 0x80
    .db     0x80, 0x80, 0x80, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x80, 0x80, 0x80  ; PLAY BOTTOM
    .db     0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80  ; VIEW BOTTOM
    .db     0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80
    .db     0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80


; DATA 領域
;
    .area   _DATA

; 変数の定義
;

; フィールド
;
_field::
    
    .ds     FIELD_SIZE_X * FIELD_SIZE_Y

; 揃ったライン
;
fieldMatch:

    .ds     0x04
