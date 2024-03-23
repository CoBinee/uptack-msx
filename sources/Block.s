; Block.s : ブロック
;


; モジュール宣言
;
    .module Block

; 参照ファイル
;
    .include    "bios.inc"
    .include    "vdp.inc"
    .include    "System.inc"
    .include    "App.inc"
    .include    "Sound.inc"
    .include    "Game.inc"
    .include    "Field.inc"
    .include	"Block.inc"

; 外部変数宣言
;

; マクロの定義
;


; CODE 領域
;
    .area   _CODE

; ブロックを初期化する
;
_BlockInitialize::
    
    ; レジスタの保存
    
    ; ブロックの初期化
    ld      hl, #blockDefault
    ld      de, #_block
    ld      bc, #BLOCK_LENGTH
    ldir

    ; バッグに詰める
    ld      hl, #(_block + BLOCK_BAG_0_0)
    call    BlockPackBag
    ld      hl, #(_block + BLOCK_BAG_1_0)
    call    BlockPackBag

    ; 状態の設定
    ld      a, #BLOCK_STATE_PLAY
    ld      (_block + BLOCK_STATE), a
    
    ; レジスタの復帰
    
    ; 終了
    ret

; ブロックを更新する
;
_BlockUpdate::
    
    ; レジスタの保存

    ; 状態別の処理
    ld      hl, #10$
    push    hl
    ld      a, (_block + BLOCK_STATE)
    and     #0xf0
    rrca
    rrca
    rrca
    ld      e, a
    ld      d, #0x00
    ld      hl, #blockProc
    add     hl, de
    ld      e, (hl)
    inc     hl
    ld      d, (hl)
    ex      de, hl
    jp      (hl)
;   pop     hl
10$:

    ; レジスタの復帰
    
    ; 終了
    ret

; ブロックを描画する
;
_BlockRender::

    ; レジスタの保存

    ; スプライトの描画
    ld      a, (_block + BLOCK_POSITION_X)
    add     a, a
    add     a, a
    add     a, a
    add     a, #FIELD_VIEW_SPRITE_X
    ld      c, a
    ld      a, (_block + BLOCK_POSITION_Y)
    add     a, a
    add     a, a
    add     a, a
    add     a, #FIELD_VIEW_SPRITE_Y
    ld      b, a
    ld      a, (_block + BLOCK_TYPE)
    add     a, a
    add     a, a
    ld      e, a
    ld      a, (_block + BLOCK_ROTATE)
    add     a, e
    ld      d, #0x00
    add     a, a
    rl      d
    add     a, a
    rl      d
    add     a, a
    rl      d
    add     a, a
    rl      d
    ld      e, a
    ld      hl, #blockSprite
    add     hl, de
    ld      de, #(_sprite + GAME_SPRITE_BLOCK)
    ld      a, (_app + APP_MODE)
    or      a
    jr      nz, 110$

    ; NORMAL の描画
100$:
    ld      a, (hl)
    inc     hl
    add     a, b
    ld      (de), a
    inc     de
    ld      a, (hl)
    inc     hl
    add     a, c
    ld      (de), a
    inc     de
    ld      a, (hl)
    inc     hl
    ld      (de), a
    inc     de
    ld      a, (hl)
    inc     hl
    ld      (de), a
    inc     de
    ld      a, (hl)
    inc     hl
    add     a, b
    ld      (de), a
    inc     de
    ld      a, (hl)
    inc     hl
    add     a, c
    ld      (de), a
    inc     de
    ld      a, (hl)
    inc     hl
    ld      (de), a
    inc     de
    ld      a, (hl)
    inc     hl
    ld      (de), a
    inc     de
    ld      a, (hl)
    inc     hl
    add     a, b
    ld      (de), a
    inc     de
    ld      a, (hl)
    inc     hl
    add     a, c
    ld      (de), a
    inc     de
    ld      a, (hl)
    inc     hl
    ld      (de), a
    inc     de
    ld      a, (hl)
    inc     hl
    ld      (de), a
    inc     de
    ld      a, (hl)
    inc     hl
    add     a, b
    ld      (de), a
    inc     de
    ld      a, (hl)
    inc     hl
    add     a, c
    ld      (de), a
    inc     de
    ld      a, (hl)
    inc     hl
    ld      (de), a
    inc     de
    ld      a, (hl)
;   inc     hl
    ld      (de), a
;   inc     de
    jr      190$

    ; REVERSE の描画
110$:
    ld      a, #0xbe
    sub     b
    ld      b, a
    ld      a, #0xf8
    sub     c
    ld      c, a
    ld      a, b
    sub     (hl)
    inc     hl
    ld      (de), a
    inc     de
    ld      a, c
    sub     (hl)
    inc     hl
    ld      (de), a
    inc     de
    ld      a, #0x10
    add     a, (hl)
    inc     hl
    ld      (de), a
    inc     de
    ld      a, (hl)
    inc     hl
    ld      (de), a
    inc     de
    ld      a, b
    sub     (hl)
    inc     hl
    ld      (de), a
    inc     de
    ld      a, c
    sub     (hl)
    inc     hl
    ld      (de), a
    inc     de
    ld      a, #0x10
    add     a, (hl)
    inc     hl
    ld      (de), a
    inc     de
    ld      a, (hl)
    inc     hl
    ld      (de), a
    inc     de
    ld      a, b
    sub     (hl)
    inc     hl
    ld      (de), a
    inc     de
    ld      a, c
    sub     (hl)
    inc     hl
    ld      (de), a
    inc     de
    ld      a, #0x10
    add     a, (hl)
    inc     hl
    ld      (de), a
    inc     de
    ld      a, (hl)
    inc     hl
    ld      (de), a
    inc     de
    ld      a, b
    sub     (hl)
    inc     hl
    ld      (de), a
    inc     de
    ld      a, c
    sub     (hl)
    inc     hl
    ld      (de), a
    inc     de
    ld      a, #0x10
    add     a, (hl)
    inc     hl
    ld      (de), a
    inc     de
    ld      a, (hl)
;   inc     hl
    ld      (de), a
;   inc     de
;   jr      190$

    ; 描画の完了
190$:

    ; レジスタの復帰

    ; 終了
    ret

; 何もしない
;
BlockNull:

    ; レジスタの保存

    ; レジスタの復帰

    ; 終了
    ret

; ブロックを操作する
;
BlockPlay:

    ; レジスタの保存

    ; 初期化
    ld      a, (_block + BLOCK_STATE)
    and     #0x0f
    jr      nz, 09$

    ; ブロックの取得
    call    BlockTakeBag
    ld      a, #FIELD_START_X
    ld      (_block + BLOCK_POSITION_X), a
    ld      a, #FIELD_START_Y
    ld      (_block + BLOCK_POSITION_Y), a
    xor     a
    ld      (_block + BLOCK_ROTATE), a

    ; フラグのクリア
    ld      hl, #(_block + BLOCK_FLAG)
    res     #BLOCK_FLAG_LOCK_BIT, (hl)

    ; 操作のリセット
    ld      a, (_input + INPUT_KEY_LEFT)
    or      a
    jr      z, 00$
    ld      a, #(BLOCK_MOVE_REPEAT_BEGIN - 0x01)
00$:
    ld      (_block + BLOCK_MOVE_LEFT), a
    ld      a, (_input + INPUT_KEY_RIGHT)
    or      a
    jr      z, 01$
    ld      a, #(BLOCK_MOVE_REPEAT_BEGIN - 0x01)
01$:
    ld      (_block + BLOCK_MOVE_RIGHT), a

    ; ブロックが存在できるかどうか
    ld      de, (_block + BLOCK_POSITION_X)
    ld      a, (_block + BLOCK_ROTATE)
    ld      c, a
    ld      a, (_block + BLOCK_TYPE)
    ld      b, a
    call    BlockIsPlace
    jr      c, 08$

    ; フラグの更新
    ld      hl, #(_block + BLOCK_FLAG)
    set     #BLOCK_FLAG_OVER_BIT, (hl)

    ; 状態の更新
    ld      a, #BLOCK_STATE_OVER
    ld      (_block + BLOCK_STATE), a
    jp      90$

    ; 初期化の完了
08$:
    ld      hl, #(_block + BLOCK_STATE)
    inc     (hl)
09$:

    ; ブロックの存在（b = ブロックの種類）
    ld      a, (_block + BLOCK_TYPE)
    ld      b, a

    ; ←→の移動（de = Y/X 位置）
100$:
    xor     a
    ld      (_block + BLOCK_MOVE), a
    ld      hl, #(_block + BLOCK_MOVE_LEFT)
    ld      a, (_input + INPUT_KEY_LEFT)
    or      a
    jr      nz, 101$
;   xor     a
    ld      (hl), a
    jr      103$
101$:
    inc     (hl)
    ld      a, (hl)
    cp      #0x01
    jr      z, 102$
    cp      #BLOCK_MOVE_REPEAT_BEGIN
    jr      z, 102$
    cp      #(BLOCK_MOVE_REPEAT_BEGIN + BLOCK_MOVE_REPEAT_CONTINUE)
    jr      nz, 106$
    ld      (hl), #BLOCK_MOVE_REPEAT_BEGIN
;   jr      102$
102$:
    ld      a, #-0x01
    ld      (_block+ BLOCK_MOVE), a
    jr      106$
103$:
    ld      hl, #(_block + BLOCK_MOVE_RIGHT)
    ld      a, (_input + INPUT_KEY_RIGHT)
    or      a
    jr      nz, 104$
;   xor     a
    ld      (hl), a
    jr      106$
104$:
    inc     (hl)
    ld      a, (hl)
    cp      #0x01
    jr      z, 105$
    cp      #BLOCK_MOVE_REPEAT_BEGIN
    jr      z, 105$
    cp      #(BLOCK_MOVE_REPEAT_BEGIN + BLOCK_MOVE_REPEAT_CONTINUE)
    jr      nz, 106$
    ld      (hl), #BLOCK_MOVE_REPEAT_BEGIN
;   jr      105$
105$:
    ld      a, #0x01
    ld      (_block+ BLOCK_MOVE), a
;   jr      106$
106$:
    ld      a, (_app + APP_MODE)
    or      a
    ld      a, (_block + BLOCK_MOVE)
    jr      z, 107$
    neg
107$:
    ld      de, (_block + BLOCK_POSITION_X)
    add     a, e
    ld      e, a

    ; 回転（c = 回転）
110$:
    ld      a, (_block + BLOCK_ROTATE)
    ld      c, a
    ld      a, (_input + INPUT_BUTTON_SPACE)
    dec     a
    jr      nz, 111$
    call    BlockRotateClockwise
    jr      c, 113$
    ld      a, (_block + BLOCK_POSITION_X)
    ld      e, a
    call    BlockRotateClockwise
    jr      113$
111$:
    ld      a, (_input + INPUT_BUTTON_SHIFT)
    dec     a
    jr      nz, 112$
    ld      a, c
    call    BlockRotateCounterClockwise
    jr      c, 113$
    ld      a, (_block + BLOCK_POSITION_X)
    ld      e, a
    call    BlockRotateCounterClockwise
    jr      113$
112$:
    call    BlockIsPlace
    jr      c, 113$
    ld      a, (_block + BLOCK_POSITION_X)
    ld      e, a
;   jr      113$
113$:
    ld      hl, (_block + BLOCK_POSITION_X)
    ld      (_block + BLOCK_POSITION_X), de
    ld      a, l
    cp      e
    jr      nz, 114$
    ld      a, h
    cp      d
    jr      z, 115$
114$:
    xor     a
    ld      (_block + BLOCK_LOCK), a
;   jr      115$
115$:
    ld      a, (_block + BLOCK_ROTATE)
    cp      c
    jr      z, 116$
    ld      a, c
    ld      (_block + BLOCK_ROTATE), a
    xor     a
    ld      (_block + BLOCK_LOCK), a
;   jr      116$
116$:

    ; 落下（毎フレーム 2 ライン）
    jr      120$
;;
    ld      a, (_input + INPUT_KEY_UP)
    dec     a
    jr      nz, 1201$
    dec     d
    ld      a, d
    ld      (_block + BLOCK_POSITION_Y), a
    jr      129$
1201$:
    ld      a, (_input + INPUT_KEY_DOWN)
    dec     a
    jr      nz, 129$
    inc     d
    call    BlockIsPlace
    jr      nc, 122$
    ld      a, d
    ld      (_block + BLOCK_POSITION_Y), a
    jr      129$
;;

120$:
    ld      hl, #(_block + BLOCK_LOCK)
    inc     d
    call    BlockIsPlace
    jr      nc, 121$
    ld      a, d
    ld      (_block + BLOCK_POSITION_Y), a
    xor     a
    ld      (hl), a
    inc     d
    call    BlockIsPlace
    jr      nc, 121$
    ld      a, d
    ld      (_block + BLOCK_POSITION_Y), a
    xor     a
    ld      (hl), a
    jr      129$
121$:
    inc     (hl)
    ld      a, (hl)
    cp      #BLOCK_LOCK_DOWN
    jr      c, 129$
122$:

    ; ブロックの固定
    ld      de, (_block + BLOCK_POSITION_X)
    ld      a, (_block + BLOCK_ROTATE)
    ld      c, a
    ld      a, (_block + BLOCK_TYPE)
    ld      b, a
    call    BlockPlace

    ; フラグの更新
    ld      hl, #(_block + BLOCK_FLAG)
    set     #BLOCK_FLAG_LOCK_BIT, (hl)

    ; 状態の更新
    ld      a, #BLOCK_STATE_PLAY
    ld      (_block + BLOCK_STATE), a
;   jr      129$
129$:

    ; 操作の完了
90$:

    ; レジスタの復帰

    ; 終了
    ret

; ゲームオーバーになる
;
BlockOver:

    ; レジスタの保存

    ; 初期化
    ld      a, (_block + BLOCK_STATE)
    and     #0x0f
    jr      nz, 09$

    ; 初期化の完了
    ld      hl, #(_block + BLOCK_STATE)
    inc     (hl)
09$:

    ; レジスタの復帰

    ; 終了
    ret

; ゲームオーバーになったかどうかを判定する
;
_BlockIsOver::

    ; レジスタの保存

    ; cf > 1 = ゲームオーバー

    ; フラグの取得
    ld      a, (_block + BLOCK_FLAG)
    rlca

    ; レジスタの復帰

    ; 終了
    ret

; ブロックが固定されたかどうかを判定する
;
_BlockIsLock::

    ; レジスタの保存

    ; cf > 1 = 固定された

    ; フラグの取得
    ld      a, (_block + BLOCK_FLAG)
    rlca
    rlca

    ; レジスタの復帰

    ; 終了
    ret

; バッグにブロックを詰める
;
BlockPackBag:

    ; レジスタの保存
    push    hl
    push    bc
    push    de

    ; hl < バッグ

    ; バッグに詰める
    push    hl
    ld      bc, #((BLOCK_BAG_LENGTH << 8) | BLOCK_TYPE_O)
10$:
    ld      (hl), c
    inc     c
    inc     hl
    djnz    10$
    pop     de
    ld      bc, #((BLOCK_BAG_LENGTH << 8) | 0x00)
11$:
    call    _SystemGetRandom
    rrca
    rrca
    and     #0x07
    cp      #BLOCK_BAG_LENGTH
    jr      nc, 11$
    push    bc
    ld      l, c
    ld      h, #0x00
    add     hl, de
    ld      c, l
    ld      b, h
    ld      l, a
    ld      h, #0x00
    add     hl, de
    ld      a, (hl)
    push    af
    ld      a, (bc)
    ld      (hl), a
    pop     af
    ld      (bc), a
    pop     bc
    inc     c
    djnz    11$

    ; レジスタの復帰
    pop     de
    pop     bc
    pop     hl

    ; 終了
    ret

; バッグからブロックを取り出す
;
BlockTakeBag:

    ; レジスタの保存
    push    hl
    push    bc
    push    de

    ; バッグから取り出す
    ld      a, (_block + BLOCK_BAG_0_0)
    ld      (_block + BLOCK_TYPE), a

    ; バッグを詰める
    ld      hl, #(_block + BLOCK_BAG_0_1)
    ld      de, #(_block + BLOCK_BAG_0_0)
    ld      bc, #((BLOCK_BAG_LENGTH * 0x02) - 0x0001)
    ldir
    xor     a
    ld      (de), a
    ld      hl, #(_block + BLOCK_BAG_1_0)
    ld      a, (hl)
    or      a
    call    z, BlockPackBag

    ; レジスタの復帰
    pop     de
    pop     bc
    pop     hl

    ; 終了
    ret

; ブロックを時計回りに回転させる
;
BlockRotateClockwise:

    ; レジスタの保存
    push    hl
    push    ix

    ; de < Y/X 位置
    ; c  < 回転前
    ; b  < ブロックの種類
    ; de > Y/X 位置
    ; c  > 回転後
    ; cf > 1 = 回転できる

    ; オフセットの取得
    push    bc
    ld      a, b
    add     a, a
    add     a, a
    add     a, c
    ld      b, #0x00
    add     a, a
    rl      b
    add     a, a
    rl      b
    add     a, a
    rl      b
    add     a, a
    rl      b
    ld      c, a
    ld      ix, #(blockRotateOffset + 0x0000)
    add     ix, bc
    pop     bc

    ; 時計回りの回転
    ld      a, c
    inc     a
    and     #0x03
    ld      c, a

    ; POINT 1
    call    BlockIsPlace
    jr      c, 90$

    ; 位置の保存
    ex      de, hl

    ; POINT 2
    ld      a, l
    add     a, 0x00(ix)
    ld      e, a
    ld      a, h
    add     a, 0x01(ix)
    ld      d, a
    call    BlockIsPlace
    jr      c, 90$
    inc     ix
    inc     ix

    ; POINT 3
    ld      a, l
    add     a, 0x00(ix)
    ld      e, a
    ld      a, h
    add     a, 0x01(ix)
    ld      d, a
    call    BlockIsPlace
    jr      c, 90$
    inc     ix
    inc     ix

    ; POINT 4
    ld      a, l
    add     a, 0x00(ix)
    ld      e, a
    ld      a, h
    add     a, 0x01(ix)
    ld      d, a
    call    BlockIsPlace
    jr      c, 90$
    inc     ix
    inc     ix

    ; POINT 5
    ld      a, l
    add     a, 0x00(ix)
    ld      e, a
    ld      a, h
    add     a, 0x01(ix)
    ld      d, a
    call    BlockIsPlace
    jr      c, 90$
;   inc     ix
;   inc     ix

    ; 位置の復帰
    ex      de, hl

    ; 回転の復帰
    ld      a, c
    dec     a
    and     #0x03
    ld      c, a

    ; 回転不可
    or      a

    ; 回転の完了
90$:

    ; レジスタの復帰
    pop     ix
    pop     hl

    ; 終了
    ret

; ブロックを反時計回りに回転させる
;
BlockRotateCounterClockwise:

    ; レジスタの保存
    push    hl
    push    ix

    ; de < Y/X 位置
    ; c  < 回転前
    ; b  < ブロックの種類
    ; de > Y/X 位置
    ; c  > 回転後
    ; cf > 1 = 回転できる

    ; オフセットの取得
    push    bc
    ld      a, b
    add     a, a
    add     a, a
    add     a, c
    ld      b, #0x00
    add     a, a
    rl      b
    add     a, a
    rl      b
    add     a, a
    rl      b
    add     a, a
    rl      b
    ld      c, a
    ld      ix, #(blockRotateOffset + 0x0008)
    add     ix, bc
    pop     bc

    ; 反時計回りの回転
    ld      a, c
    dec     a
    and     #0x03
    ld      c, a

    ; POINT 1
    call    BlockIsPlace
    jr      c, 90$

    ; 位置の保存
    ex      de, hl

    ; POINT 2
    ld      a, l
    add     a, 0x00(ix)
    ld      e, a
    ld      a, h
    add     a, 0x01(ix)
    ld      d, a
    call    BlockIsPlace
    jr      c, 90$
    inc     ix
    inc     ix

    ; POINT 3
    ld      a, l
    add     a, 0x00(ix)
    ld      e, a
    ld      a, h
    add     a, 0x01(ix)
    ld      d, a
    call    BlockIsPlace
    jr      c, 90$
    inc     ix
    inc     ix

    ; POINT 4
    ld      a, l
    add     a, 0x00(ix)
    ld      e, a
    ld      a, h
    add     a, 0x01(ix)
    ld      d, a
    call    BlockIsPlace
    jr      c, 90$
    inc     ix
    inc     ix

    ; POINT 5
    ld      a, l
    add     a, 0x00(ix)
    ld      e, a
    ld      a, h
    add     a, 0x01(ix)
    ld      d, a
    call    BlockIsPlace
    jr      c, 90$
;   inc     ix
;   inc     ix

    ; 位置の復帰
    ex      de, hl
    
    ; 回転の復帰
    ld      a, c
    inc     a
    and     #0x03
    ld      c, a

    ; 回転不可
    or      a

    ; 回転の完了
90$:

    ; レジスタの復帰
    pop     ix
    pop     hl

    ; 終了
    ret

; ブロックをフィールドに置く
;
BlockPlace:

    ; レジスタの保存
    push    hl
    push    bc

    ; de < Y/X 位置
    ; c  < 回転
    ; b  < ブロックの種類

    ; ブロックの判定
    ld      a, b
    add     a, a
    add     a, a
    add     a, c
    ld      b, #0x00
    add     a, a
    rl      b
    add     a, a
    rl      b
    add     a, a
    rl      b
    ld      c, a
    ld      hl, #blockOffset
    add     hl, bc
    call    _FieldPlace

    ; レジスタの復帰
    pop     bc
    pop     hl

    ; 終了
    ret

; ブロックが置けるかどうかを判定する
;
BlockIsPlace:

    ; レジスタの保存
    push    hl
    push    bc

    ; de < Y/X 位置
    ; c  < 回転
    ; b  < ブロックの種類
    ; cf > 1 = 置ける

    ; ブロックの判定
    ld      a, b
    add     a, a
    add     a, a
    add     a, c
    ld      b, #0x00
    add     a, a
    rl      b
    add     a, a
    rl      b
    add     a, a
    rl      b
    ld      c, a
    ld      hl, #blockOffset
    add     hl, bc
    call    _FieldIsPlace

    ; レジスタの復帰
    pop     bc
    pop     hl

    ; 終了
    ret

; ブロックの色を取得する
;
_BlockGetColor::

    ; レジスタの保存
    push    hl
    push    de

    ; a < ブロックの種類
    ; a > 色

    ; 色の取得
    ld      e, a
    ld      d, #0x00
    ld      hl, #blockColor
    add     hl, de
    ld      a, (hl)

    ; レジスタの復帰
    pop     de
    pop     hl

    ; 終了
    ret

; 定数の定義
;

; 状態別の処理
;
blockProc:
    
    .dw     BlockNull
    .dw     BlockPlay
    .dw     BlockOver

; ブロックの初期値
;
blockDefault:

    .db     BLOCK_STATE_NULL
    .db     BLOCK_FLAG_NULL
    .db     BLOCK_TYPE_NULL
    .db     BLOCK_POSITION_NULL
    .db     BLOCK_POSITION_NULL
    .db     BLOCK_ROTATE_NORTH
    .db     BLOCK_MOVE_NULL
    .db     BLOCK_MOVE_NULL
    .db     BLOCK_MOVE_NULL
    .db     BLOCK_LOCK_NULL
    .dw     BLOCK_SPRITE_NULL
    .db     BLOCK_BAG_NULL
    .db     BLOCK_BAG_NULL
    .db     BLOCK_BAG_NULL
    .db     BLOCK_BAG_NULL
    .db     BLOCK_BAG_NULL
    .db     BLOCK_BAG_NULL
    .db     BLOCK_BAG_NULL
    .db     BLOCK_BAG_NULL
    .db     BLOCK_BAG_NULL
    .db     BLOCK_BAG_NULL
    .db     BLOCK_BAG_NULL
    .db     BLOCK_BAG_NULL
    .db     BLOCK_BAG_NULL
    .db     BLOCK_BAG_NULL

; オフセット
;
blockOffset:

    ; -
    .db      0,  0,  0,  0,  0,  0,  0,  0
    .db      0,  0,  0,  0,  0,  0,  0,  0
    .db      0,  0,  0,  0,  0,  0,  0,  0
    .db      0,  0,  0,  0,  0,  0,  0,  0
    ; O
    .db      0, -1,  1, -1,  0,  0,  1,  0  ; NORTH
    .db      0, -1,  1, -1,  0,  0,  1,  0  ; EAST
    .db      0, -1,  1, -1,  0,  0,  1,  0  ; SOUTH
    .db      0, -1,  1, -1,  0,  0,  1,  0  ; WEST
    ; I
    .db     -1,  0,  0,  0,  1,  0,  2,  0  ; NORTH
    .db      1, -1,  1,  0,  1,  1,  1,  2  ; EAST
    .db     -1,  1,  0,  1,  1,  1,  2,  1  ; SOUTH
    .db      0, -1,  0,  0,  0,  1,  0,  2  ; WEST
    ; T
    .db      0, -1, -1,  0,  0,  0,  1,  0  ; NORTH
    .db      0, -1,  0,  0,  1,  0,  0,  1  ; EAST
    .db     -1,  0,  0,  0,  1,  0,  0,  1  ; SOUTH
    .db      0, -1, -1,  0,  0,  0,  0,  1  ; WEST
    ; L
    .db      1, -1, -1,  0,  0,  0,  1,  0  ; NORTH
    .db      0, -1,  0,  0,  0,  1,  1,  1  ; EAST
    .db     -1,  0,  0,  0,  1,  0, -1,  1  ; SOUTH
    .db     -1, -1,  0, -1,  0,  0,  0,  1  ; WEST
    ; J
    .db     -1, -1, -1,  0,  0,  0,  1,  0  ; NORTH
    .db      0, -1,  1, -1,  0,  0,  0,  1  ; EAST
    .db     -1,  0,  0,  0,  1,  0,  1,  1  ; SOUTH
    .db      0, -1,  0,  0, -1,  1,  0,  1  ; WEST
    ; S
    .db      0, -1,  1, -1, -1,  0,  0,  0  ; NORTH
    .db      0, -1,  0,  0,  1,  0,  1,  1  ; EAST
    .db      0,  0,  1,  0, -1,  1,  0,  1  ; SOUTH
    .db     -1, -1, -1,  0,  0,  0,  0,  1  ; WEST
    ; Z
    .db     -1, -1,  0, -1,  0,  0,  1,  0  ; NORTH
    .db      1, -1,  0,  0,  1,  0,  0,  1  ; EAST
    .db     -1,  0,  0,  0,  0,  1,  1,  1  ; SOUTH
    .db      0, -1, -1,  0,  0,  0, -1,  1  ; WEST

; 回転
;
blockRotateOffset:

    ; -
    .db      0,   0,   0,   0,   0,   0,   0,   0   ; NORTH - clockwise
    .db      0,   0,   0,   0,   0,   0,   0,   0   ; NORTH - counter clockwise
    .db      0,   0,   0,   0,   0,   0,   0,   0   ; EAST  - clockwise
    .db      0,   0,   0,   0,   0,   0,   0,   0   ; EAST  - counter clockwise
    .db      0,   0,   0,   0,   0,   0,   0,   0   ; SOUTH - clockwise
    .db      0,   0,   0,   0,   0,   0,   0,   0   ; SOUTH - counter clockwise
    .db      0,   0,   0,   0,   0,   0,   0,   0   ; WEST  - clockwise
    .db      0,   0,   0,   0,   0,   0,   0,   0   ; WEST  - counter clockwise
    ; O
    .db      0,   0,   0,   0,   0,   0,   0,   0   ; NORTH - clockwise
    .db      0,   0,   0,   0,   0,   0,   0,   0   ; NORTH - counter clockwise
    .db      0,   0,   0,   0,   0,   0,   0,   0   ; EAST  - clockwise
    .db      0,   0,   0,   0,   0,   0,   0,   0   ; EAST  - counter clockwise
    .db      0,   0,   0,   0,   0,   0,   0,   0   ; SOUTH - clockwise
    .db      0,   0,   0,   0,   0,   0,   0,   0   ; SOUTH - counter clockwise
    .db      0,   0,   0,   0,   0,   0,   0,   0   ; WEST  - clockwise
    .db      0,   0,   0,   0,   0,   0,   0,   0   ; WEST  - counter clockwise
    ; I
    .db     -2,   0,   1,   0,  -2,   1,   1,  -2   ; NORTH - clockwise
    .db     -1,   0,   2,   0,  -1,  -2,   2,   1   ; NORTH - counter clockwise
    .db     -1,   0,   2,   0,  -1,  -2,   2,   1   ; EAST  - clockwise
    .db      2,   0,  -1,   0,   2,  -1,  -1,   2   ; EAST  - counter clockwise
    .db      2,   0,  -1,   0,   2,  -1,  -1,   2   ; SOUTH - clockwise
    .db      1,   0,  -2,   0,   1,   2,  -2,  -1   ; SOUTH - counter clockwise
    .db      1,   0,  -2,   0,   1,   2,  -2,  -1   ; WEST  - clockwise
    .db     -2,   0,   1,   0,  -2,   1,   1,  -2   ; WEST  - counter clockwise
    ; T
    .db     -1,   0,  -1,  -1,   0,   0,  -1,   2   ; NORTH - clockwise
    .db      1,   0,   1,  -1,   0,   0,   1,   2   ; NORTH - counter clockwise
    .db      1,   0,   1,   1,   0,  -2,   1,  -2   ; EAST  - clockwise
    .db      1,   0,   1,   1,   0,  -2,   1,  -2   ; EAST  - counter clockwise
    .db      1,   0,   0,   0,   0,   2,   1,   2   ; SOUTH - clockwise
    .db     -1,   0,   0,   0,   0,   2,  -1,   2   ; SOUTH - counter clockwise
    .db     -1,   0,  -1,   1,   0,  -2,  -1,  -2   ; WEST  - clockwise
    .db     -1,   0,  -1,   1,   0,  -2,  -1,  -2   ; WEST  - counter clockwise
    ; L
    .db     -1,   0,  -1,  -1,   0,   2,  -1,   2   ; NORTH - clockwise
    .db      1,   0,   1,  -1,   0,   2,   1,   2   ; NORTH - counter clockwise
    .db      1,   0,   1,   1,   0,  -2,   1,  -2   ; EAST  - clockwise
    .db      1,   0,   1,   1,   0,  -2,   1,  -2   ; EAST  - counter clockwise
    .db      1,   0,   1,  -1,   0,   2,   1,   2   ; SOUTH - clockwise
    .db     -1,   0,  -1,  -1,   0,   2,  -1,   2   ; SOUTH - counter clockwise
    .db     -1,   0,  -1,   1,   0,  -2,  -1,  -2   ; WEST  - clockwise
    .db     -1,   0,  -1,   1,   0,  -2,  -1,  -2   ; WEST  - counter clockwise
    ; J
    .db     -1,   0,  -1,  -1,   0,   2,  -1,   2   ; NORTH - clockwise
    .db      1,   0,   1,  -1,   0,   2,   1,   2   ; NORTH - counter clockwise
    .db      1,   0,   1,   1,   0,  -2,   1,  -2   ; EAST  - clockwise
    .db      1,   0,   1,   1,   0,  -2,   1,  -2   ; EAST  - counter clockwise
    .db      1,   0,   1,  -1,   0,   2,   1,   2   ; SOUTH - clockwise
    .db     -1,   0,  -1,  -1,   0,   2,  -1,   2   ; SOUTH - counter clockwise
    .db     -1,   0,  -1,   1,   0,  -2,  -1,  -2   ; WEST  - clockwise
    .db     -1,   0,  -1,   1,   0,  -2,  -1,  -2   ; WEST  - counter clockwise
    ; S
    .db     -1,   0,  -1,  -1,   0,   2,  -1,   2   ; NORTH - clockwise
    .db      1,   0,   1,  -1,   0,   2,   1,   2   ; NORTH - counter clockwise
    .db      1,   0,   1,   1,   0,  -2,   1,  -2   ; EAST  - clockwise
    .db      1,   0,   1,   1,   0,  -2,   1,  -2   ; EAST  - counter clockwise
    .db      1,   0,   1,  -1,   0,   2,   1,   2   ; SOUTH - clockwise
    .db     -1,   0,  -1,  -1,   0,   2,  -1,   2   ; SOUTH - counter clockwise
    .db     -1,   0,  -1,   1,   0,  -2,  -1,  -2   ; WEST  - clockwise
    .db     -1,   0,  -1,   1,   0,  -2,  -1,  -2   ; WEST  - counter clockwise
    ; Z
    .db     -1,   0,  -1,  -1,   0,   2,  -1,   2   ; NORTH - clockwise
    .db      1,   0,   1,  -1,   0,   2,   1,   2   ; NORTH - counter clockwise
    .db      1,   0,   1,   1,   0,  -2,   1,  -2   ; EAST  - clockwise
    .db      1,   0,   1,   1,   0,  -2,   1,  -2   ; EAST  - counter clockwise
    .db      1,   0,   1,  -1,   0,   2,   1,   2   ; SOUTH - clockwise
    .db     -1,   0,  -1,  -1,   0,   2,  -1,   2   ; SOUTH - counter clockwise
    .db     -1,   0,  -1,   1,   0,  -2,  -1,  -2   ; WEST  - clockwise
    .db     -1,   0,  -1,   1,   0,  -2,  -1,  -2   ; WEST  - counter clockwise

; スプライト
;
blockSprite:

    ; -
    .db      0x00 - 0x01,  0x00, 0x00, VDP_COLOR_TRANSPARENT    ; NORTH
    .db      0x00 - 0x01,  0x00, 0x00, VDP_COLOR_TRANSPARENT
    .db      0x00 - 0x01,  0x00, 0x00, VDP_COLOR_TRANSPARENT
    .db      0x00 - 0x01,  0x00, 0x00, VDP_COLOR_TRANSPARENT
    .db      0x00 - 0x01,  0x00, 0x00, VDP_COLOR_TRANSPARENT    ; EAST
    .db      0x00 - 0x01,  0x00, 0x00, VDP_COLOR_TRANSPARENT
    .db      0x00 - 0x01,  0x00, 0x00, VDP_COLOR_TRANSPARENT
    .db      0x00 - 0x01,  0x00, 0x00, VDP_COLOR_TRANSPARENT
    .db      0x00 - 0x01,  0x00, 0x00, VDP_COLOR_TRANSPARENT    ; SOUTH
    .db      0x00 - 0x01,  0x00, 0x00, VDP_COLOR_TRANSPARENT
    .db      0x00 - 0x01,  0x00, 0x00, VDP_COLOR_TRANSPARENT
    .db      0x00 - 0x01,  0x00, 0x00, VDP_COLOR_TRANSPARENT
    .db      0x00 - 0x01,  0x00, 0x00, VDP_COLOR_TRANSPARENT    ; WEST
    .db      0x00 - 0x01,  0x00, 0x00, VDP_COLOR_TRANSPARENT
    .db      0x00 - 0x01,  0x00, 0x00, VDP_COLOR_TRANSPARENT
    .db      0x00 - 0x01,  0x00, 0x00, VDP_COLOR_TRANSPARENT
    ; O
    .db     -0x08 - 0x01,  0x00, 0x15, VDP_COLOR_LIGHT_YELLOW   ; NORTH
    .db     -0x08 - 0x01,  0x08, 0x16, VDP_COLOR_LIGHT_YELLOW
    .db      0x00 - 0x01,  0x00, 0x19, VDP_COLOR_LIGHT_YELLOW
    .db      0x00 - 0x01,  0x08, 0x1a, VDP_COLOR_LIGHT_YELLOW
    .db     -0x08 - 0x01,  0x00, 0x15, VDP_COLOR_LIGHT_YELLOW   ; EAST
    .db     -0x08 - 0x01,  0x08, 0x16, VDP_COLOR_LIGHT_YELLOW
    .db      0x00 - 0x01,  0x00, 0x19, VDP_COLOR_LIGHT_YELLOW
    .db      0x00 - 0x01,  0x08, 0x1a, VDP_COLOR_LIGHT_YELLOW
    .db     -0x08 - 0x01,  0x00, 0x15, VDP_COLOR_LIGHT_YELLOW   ; SOUTH
    .db     -0x08 - 0x01,  0x08, 0x16, VDP_COLOR_LIGHT_YELLOW
    .db      0x00 - 0x01,  0x00, 0x19, VDP_COLOR_LIGHT_YELLOW
    .db      0x00 - 0x01,  0x08, 0x1a, VDP_COLOR_LIGHT_YELLOW
    .db     -0x08 - 0x01,  0x00, 0x15, VDP_COLOR_LIGHT_YELLOW   ; WEST
    .db     -0x08 - 0x01,  0x08, 0x16, VDP_COLOR_LIGHT_YELLOW
    .db      0x00 - 0x01,  0x00, 0x19, VDP_COLOR_LIGHT_YELLOW
    .db      0x00 - 0x01,  0x08, 0x1a, VDP_COLOR_LIGHT_YELLOW
    ; I
    .db      0x00 - 0x01, -0x08, 0x11, VDP_COLOR_CYAN           ; NORTH
    .db      0x00 - 0x01,  0x00, 0x13, VDP_COLOR_CYAN
    .db      0x00 - 0x01,  0x08, 0x13, VDP_COLOR_CYAN
    .db      0x00 - 0x01,  0x10, 0x12, VDP_COLOR_CYAN
    .db     -0x08 - 0x01,  0x08, 0x14, VDP_COLOR_CYAN           ; EAST
    .db      0x00 - 0x01,  0x08, 0x1c, VDP_COLOR_CYAN
    .db      0x08 - 0x01,  0x08, 0x1c, VDP_COLOR_CYAN
    .db      0x10 - 0x01,  0x08, 0x18, VDP_COLOR_CYAN
    .db      0x08 - 0x01, -0x08, 0x11, VDP_COLOR_CYAN           ; SOUTH
    .db      0x08 - 0x01,  0x00, 0x13, VDP_COLOR_CYAN
    .db      0x08 - 0x01,  0x08, 0x13, VDP_COLOR_CYAN
    .db      0x08 - 0x01,  0x10, 0x12, VDP_COLOR_CYAN    
    .db     -0x08 - 0x01,  0x00, 0x14, VDP_COLOR_CYAN           ; WEST
    .db      0x00 - 0x01,  0x00, 0x1c, VDP_COLOR_CYAN
    .db      0x08 - 0x01,  0x00, 0x1c, VDP_COLOR_CYAN
    .db      0x10 - 0x01,  0x00, 0x18, VDP_COLOR_CYAN    
    ; T
    .db     -0x08 - 0x01,  0x00, 0x14, VDP_COLOR_MAGENTA        ; NORTH
    .db      0x00 - 0x01, -0x08, 0x11, VDP_COLOR_MAGENTA
    .db      0x00 - 0x01,  0x00, 0x1b, VDP_COLOR_MAGENTA
    .db      0x00 - 0x01,  0x08, 0x12, VDP_COLOR_MAGENTA
    .db     -0x08 - 0x01,  0x00, 0x14, VDP_COLOR_MAGENTA        ; EAST
    .db      0x00 - 0x01,  0x00, 0x1d, VDP_COLOR_MAGENTA
    .db      0x00 - 0x01,  0x08, 0x12, VDP_COLOR_MAGENTA
    .db      0x08 - 0x01,  0x00, 0x18, VDP_COLOR_MAGENTA
    .db      0x00 - 0x01, -0x08, 0x11, VDP_COLOR_MAGENTA        ; SOUTH
    .db      0x00 - 0x01,  0x00, 0x17, VDP_COLOR_MAGENTA
    .db      0x00 - 0x01,  0x08, 0x12, VDP_COLOR_MAGENTA
    .db      0x08 - 0x01,  0x00, 0x18, VDP_COLOR_MAGENTA
    .db     -0x08 - 0x01,  0x00, 0x14, VDP_COLOR_MAGENTA        ; WEST
    .db      0x00 - 0x01, -0x08, 0x11, VDP_COLOR_MAGENTA
    .db      0x00 - 0x01,  0x00, 0x1e, VDP_COLOR_MAGENTA
    .db      0x08 - 0x01,  0x00, 0x18, VDP_COLOR_MAGENTA
    ; L
    .db     -0x08 - 0x01,  0x08, 0x14, VDP_COLOR_LIGHT_RED      ; NORTH
    .db      0x00 - 0x01, -0x08, 0x11, VDP_COLOR_LIGHT_RED
    .db      0x00 - 0x01,  0x00, 0x13, VDP_COLOR_LIGHT_RED
    .db      0x00 - 0x01,  0x08, 0x1a, VDP_COLOR_LIGHT_RED
    .db     -0x08 - 0x01,  0x00, 0x14, VDP_COLOR_LIGHT_RED      ; EAST
    .db      0x00 - 0x01,  0x00, 0x1c, VDP_COLOR_LIGHT_RED
    .db      0x08 - 0x01,  0x00, 0x19, VDP_COLOR_LIGHT_RED
    .db      0x08 - 0x01,  0x08, 0x12, VDP_COLOR_LIGHT_RED
    .db      0x00 - 0x01, -0x08, 0x15, VDP_COLOR_LIGHT_RED      ; SOUTH
    .db      0x00 - 0x01,  0x00, 0x13, VDP_COLOR_LIGHT_RED
    .db      0x00 - 0x01,  0x08, 0x12, VDP_COLOR_LIGHT_RED
    .db      0x08 - 0x01, -0x08, 0x18, VDP_COLOR_LIGHT_RED
    .db     -0x08 - 0x01, -0x08, 0x11, VDP_COLOR_LIGHT_RED      ; WEST
    .db     -0x08 - 0x01,  0x00, 0x16, VDP_COLOR_LIGHT_RED
    .db      0x00 - 0x01,  0x00, 0x1c, VDP_COLOR_LIGHT_RED
    .db      0x08 - 0x01,  0x00, 0x18, VDP_COLOR_LIGHT_RED
    ; J
    .db     -0x08 - 0x01, -0x08, 0x14, VDP_COLOR_DARK_BLUE      ; NORTH
    .db      0x00 - 0x01, -0x08, 0x19, VDP_COLOR_DARK_BLUE
    .db      0x00 - 0x01,  0x00, 0x13, VDP_COLOR_DARK_BLUE
    .db      0x00 - 0x01,  0x08, 0x12, VDP_COLOR_DARK_BLUE
    .db     -0x08 - 0x01,  0x08, 0x12, VDP_COLOR_DARK_BLUE      ; EAST
    .db     -0x08 - 0x01,  0x00, 0x15, VDP_COLOR_DARK_BLUE
    .db      0x00 - 0x01,  0x00, 0x1c, VDP_COLOR_DARK_BLUE
    .db      0x08 - 0x01,  0x00, 0x18, VDP_COLOR_DARK_BLUE
    .db      0x00 - 0x01, -0x08, 0x11, VDP_COLOR_DARK_BLUE      ; SOUTH
    .db      0x00 - 0x01,  0x00, 0x13, VDP_COLOR_DARK_BLUE
    .db      0x00 - 0x01,  0x08, 0x16, VDP_COLOR_DARK_BLUE
    .db      0x08 - 0x01,  0x08, 0x18, VDP_COLOR_DARK_BLUE
    .db     -0x08 - 0x01,  0x00, 0x14, VDP_COLOR_DARK_BLUE      ; WEST
    .db      0x00 - 0x01,  0x00, 0x1c, VDP_COLOR_DARK_BLUE
    .db      0x08 - 0x01, -0x08, 0x11, VDP_COLOR_DARK_BLUE
    .db      0x08 - 0x01,  0x00, 0x1a, VDP_COLOR_DARK_BLUE
    ; S
    .db     -0x08 - 0x01,  0x00, 0x15, VDP_COLOR_DARK_GREEN     ; NORTH
    .db     -0x08 - 0x01,  0x08, 0x12, VDP_COLOR_DARK_GREEN
    .db      0x00 - 0x01, -0x08, 0x11, VDP_COLOR_DARK_GREEN
    .db      0x00 - 0x01,  0x00, 0x1a, VDP_COLOR_DARK_GREEN
    .db     -0x08 - 0x01,  0x00, 0x14, VDP_COLOR_DARK_GREEN     ; EAST
    .db      0x00 - 0x01,  0x00, 0x19, VDP_COLOR_DARK_GREEN
    .db      0x00 - 0x01,  0x08, 0x16, VDP_COLOR_DARK_GREEN
    .db      0x08 - 0x01,  0x08, 0x18, VDP_COLOR_DARK_GREEN
    .db      0x00 - 0x01,  0x00, 0x15, VDP_COLOR_DARK_GREEN     ; SOUTH
    .db      0x00 - 0x01,  0x08, 0x12, VDP_COLOR_DARK_GREEN
    .db      0x08 - 0x01, -0x08, 0x11, VDP_COLOR_DARK_GREEN
    .db      0x08 - 0x01,  0x00, 0x1a, VDP_COLOR_DARK_GREEN
    .db     -0x08 - 0x01, -0x08, 0x14, VDP_COLOR_DARK_GREEN     ; WEST
    .db      0x00 - 0x01, -0x08, 0x19, VDP_COLOR_DARK_GREEN
    .db      0x00 - 0x01,  0x00, 0x16, VDP_COLOR_DARK_GREEN
    .db      0x08 - 0x01,  0x00, 0x18, VDP_COLOR_DARK_GREEN
    ; Z
    .db     -0x08 - 0x01, -0x08, 0x11, VDP_COLOR_DARK_RED       ; NORTH
    .db     -0x08 - 0x01,  0x00, 0x16, VDP_COLOR_DARK_RED
    .db      0x00 - 0x01,  0x00, 0x19, VDP_COLOR_DARK_RED
    .db      0x00 - 0x01,  0x08, 0x12, VDP_COLOR_DARK_RED
    .db     -0x08 - 0x01,  0x08, 0x14, VDP_COLOR_DARK_RED       ; EAST
    .db      0x00 - 0x01,  0x00, 0x15, VDP_COLOR_DARK_RED
    .db      0x00 - 0x01,  0x08, 0x1a, VDP_COLOR_DARK_RED
    .db      0x08 - 0x01,  0x00, 0x18, VDP_COLOR_DARK_RED
    .db      0x00 - 0x01, -0x08, 0x11, VDP_COLOR_DARK_RED       ; SOUTH
    .db      0x00 - 0x01,  0x00, 0x16, VDP_COLOR_DARK_RED
    .db      0x08 - 0x01,  0x00, 0x19, VDP_COLOR_DARK_RED
    .db      0x08 - 0x01,  0x08, 0x12, VDP_COLOR_DARK_RED
    .db     -0x08 - 0x01,  0x00, 0x14, VDP_COLOR_DARK_RED       ; WEST
    .db      0x00 - 0x01, -0x08, 0x15, VDP_COLOR_DARK_RED
    .db      0x00 - 0x01,  0x00, 0x1a, VDP_COLOR_DARK_RED
    .db      0x08 - 0x01, -0x08, 0x18, VDP_COLOR_DARK_RED

; 色
;
blockColor:

    .db     VDP_COLOR_LIGHT_GREEN
    .db     VDP_COLOR_LIGHT_YELLOW
    .db     VDP_COLOR_CYAN
    .db     VDP_COLOR_MAGENTA
    .db     VDP_COLOR_LIGHT_RED
    .db     VDP_COLOR_DARK_BLUE
    .db     VDP_COLOR_DARK_GREEN
    .db     VDP_COLOR_DARK_RED


; DATA 領域
;
    .area   _DATA

; 変数の定義
;

; ブロック
;
_block::
    
    .ds     BLOCK_LENGTH
