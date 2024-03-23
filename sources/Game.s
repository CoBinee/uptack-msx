; Game.s : ゲーム
;


; モジュール宣言
;
    .module Game

; 参照ファイル
;
    .include    "bios.inc"
    .include    "vdp.inc"
    .include    "System.inc"
    .include    "App.inc"
    .include    "Sound.inc"
    .include	"Game.inc"
    .include    "Field.inc"
    .include    "Block.inc"

; 外部変数宣言
;

; マクロの定義
;


; CODE 領域
;
    .area   _CODE

; ゲームを初期化する
;
_GameInitialize::
    
    ; レジスタの保存
    
    ; スプライトのクリア
    call    _SystemClearSprite

    ; パターンネームのクリア
    xor     a
    call    _SystemClearPatternName

    ; フィールドの初期化
    call    _FieldInitialize

    ; ブロックの初期化
    call    _BlockInitialize
    
    ; ゲームの初期化
    ld      hl, #gameDefault
    ld      de, #_game
    ld      bc, #GAME_LENGTH
    ldir

    ; パターンネームの転送
    ld      hl, #_flag
    set     #FLAG_PATTERN_NAME_UPDATE_BIT, (hl)

    ; 描画の開始
    ld      hl, #(_videoRegister + VDP_R1)
    set     #VDP_R1_BL, (hl)

    ; 状態の設定
    ld      a, #GAME_STATE_START
    ld      (_game + GAME_STATE), a
    ld      a, #APP_STATE_GAME_UPDATE
    ld      (_app + APP_STATE), a
    
    ; レジスタの復帰
    
    ; 終了
    ret

; ゲームを更新する
;
_GameUpdate::
    
    ; レジスタの保存
    
    ; スプライトのクリア
    call    _SystemClearSprite

    ; 状態別の処理
    ld      hl, #10$
    push    hl
    ld      a, (_game + GAME_STATE)
    and     #0xf0
    rrca
    rrca
    rrca
    ld      e, a
    ld      d, #0x00
    ld      hl, #gameProc
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

; 何もしない
;
GameNull:

    ; レジスタの保存

    ; レジスタの復帰

    ; 終了
    ret

; ゲームを開始する
;
GameStart:

    ; レジスタの保存

    ; 初期化
    ld      a, (_game + GAME_STATE)
    and     #0x0f
    jr      nz, 09$

    ; 画面の描画
    call    GamePrintScreen
    call    GamePrintScore
    call    GamePrintRate
    ld      hl, #(_block + BLOCK_BAG_0_0)
    call    GamePrintNext
    call    GamePrintStart

    ; パターンネームの転送
    ld      hl, #_flag
    set     #FLAG_PATTERN_NAME_UPDATE_BIT, (hl)

    ; BGM の再生
    ld      a, #SOUND_BGM_START
    call    _SoundPlayBgm

    ; 初期化の完了
    ld      hl, #(_game + GAME_STATE)
    inc     (hl)
09$:

    ; BGM の監視
    call    _SoundIsPlayBgm
    jr      c, 19$

    ; 状態の更新
    ld      a, #GAME_STATE_PLAY
    ld      (_game + GAME_STATE), a
;   jr      19$
19$:

    ; レジスタの復帰

    ; 終了
    ret
    
; ゲームをプレイする
;
GamePlay:

    ; レジスタの保存

    ; 初期化
    ld      a, (_game + GAME_STATE)
    and     #0x0f
    jr      nz, 09$

    ; レートの設定
    ld      hl, #(gameDefault + GAME_RATE_100)
    ld      de, #(_game + GAME_RATE_100)
    ld      bc, #0x03
    ldir

    ; フィールドパターンの更新
    call    _FieldUpdatePattern

    ; フィールドパターンの描画
    call    _FieldPrintPattern

    ; ネクストブロックの描画
    ld      hl, #(_block + BLOCK_BAG_0_1)
    call    GamePrintNext

    ; パターンネームの転送
    ld      hl, #_flag
    set     #FLAG_PATTERN_NAME_UPDATE_BIT, (hl)
    
    ; 初期化の完了
    ld      hl, #(_game + GAME_STATE)
    inc     (hl)
09$:

    ; ブロックの更新
    call    _BlockUpdate

    ; ブロックの描画
    call    _BlockRender

    ; ゲームオーバーの監視
    call    _BlockIsOver
    jr      nc, 10$
    ld      a, #GAME_STATE_OVER
    ld      (_game + GAME_STATE), a
    jr      90$
10$:

    ; ブロックが固定されたかの監視
    call    _BlockIsLock
    jr      nc, 11$
    ld      a, #GAME_STATE_LOCK
    ld      (_game + GAME_STATE), a
    jr      90$
11$:

    ; レートの更新
    ld      hl, #(_game + GAME_RATE_001)
    ld      b, #0x03
20$:
    ld      a, (hl)
    or      a
    jr      nz, 21$
    ld      (hl), #0x09
    dec     hl
    djnz    20$
    jr      22$
21$:
    dec     (hl)
;   jr      22$
22$:
    ld      de, (_game + GAME_RATE_100)
    ld      a, d
    or      e
    jr      nz, 23$
    ld      hl, #(_game + GAME_RATE_100)
    ld      (hl), #0x00
    inc     hl
    ld      (hl), #0x01
    inc     hl
    ld      (hl), #0x00
23$:
    call    GamePrintRate

    ; パターンネームの転送
    ld      hl, #_flag
    set     #FLAG_PATTERN_NAME_UPDATE_BIT, (hl)

    ; プレイの完了
90$:

    ; BGM の再生
    call    GamePlayBgm
    
    ; レジスタの復帰

    ; 終了
    ret

; ブロックが固定される
;
GameLock:

    ; レジスタの保存

    ; フィールドパターンの更新
    call    _FieldUpdatePattern

    ; フィールドパターンの描画
    call    _FieldPrintPattern

    ; 色の変更
    ld      a, (_block + BLOCK_TYPE)
    call    GameSetColor

    ; パターンネームの転送
    ld      hl, #_flag
    set     #FLAG_PATTERN_NAME_UPDATE_BIT, (hl)

    ; SE の再生
    ld      a, #SOUND_SE_LOCK
    call    _SoundPlaySe

    ; ラインの判定
    call    _FieldIsMatch
    ld      (_game + GAME_MATCH), a
    or      a
    jr      nz, 10$
    ld      a, #GAME_STATE_PLAY
    ld      (_game + GAME_STATE), a
    jr      19$
10$:
    ld      a, #GAME_STATE_MATCH
    ld      (_game + GAME_STATE), a
    jr      19$
19$:

    ; BGM の再生
    call    GamePlayBgm
    
    ; レジスタの復帰

    ; 終了
    ret

; 揃ったラインを消す
;
GameMatch:

    ; レジスタの保存

    ; 初期化
    ld      a, (_game + GAME_STATE)
    and     #0x0f
    jr      nz, 09$
    
    ; 初期化の完了
    ld      hl, #(_game + GAME_STATE)
    inc     (hl)
09$:

    ; ラインの除去
    call    _FieldEliminate
    jr      nc, 19$

    ; 状態の更新
    ld      a, #GAME_STATE_REDUCE
    ld      (_game + GAME_STATE), a
;   jr      19$
19$:

    ; フィールドパターンの更新
    call    _FieldUpdatePattern

    ; フィールドパターンの描画
    call    _FieldPrintPattern

    ; パターンネームの転送
    ld      hl, #_flag
    set     #FLAG_PATTERN_NAME_UPDATE_BIT, (hl)

    ; BGM の再生
    call    GamePlayBgm
    
    ; レジスタの復帰

    ; 終了
    ret

; 空いたラインを詰める
;
GameReduce:

    ; レジスタの保存

    ; 初期化
    ld      a, (_game + GAME_STATE)
    and     #0x0f
    jr      nz, 09$

    ; ラインを詰める
    call    _FieldReduce

    ; ラインの加算
    call    GameAddLine

    ; スコアの加算
    call    GameAddScore

    ; アニメーションの設定
    ld      a, #GAME_ANIMATION_MATCH
    ld      (_game + GAME_ANIMATION), a

    ; フィールドパターンの更新
    call    _FieldUpdatePattern

    ; フィールドパターンの描画
    call    _FieldPrintPattern

    ; スコアの描画
    call    GamePrintScore

    ; パターンネームの転送
    ld      hl, #_flag
    set     #FLAG_PATTERN_NAME_UPDATE_BIT, (hl)

    ; SE の再生
    ld      a, #SOUND_SE_REDUCE
    call    _SoundPlaySe

    ; 初期化の完了
    ld      hl, #(_game + GAME_STATE)
    inc     (hl)
09$:

    ; アニメーションの更新
    ld      hl, #(_game + GAME_ANIMATION)
    dec     (hl)
    jr      nz, 19$

    ; 状態の更新
    ld      a, #GAME_STATE_PLAY
    ld      (_game + GAME_STATE), a
19$:

    ; 揃ったライン数の描画
    call    GamePrintMatch

    ; BGM の再生
    call    GamePlayBgm
    
    ; レジスタの復帰

    ; 終了
    ret

; ゲームオーバーになる
;
GameOver:

    ; レジスタの保存

    ; 初期化
    ld      a, (_game + GAME_STATE)
    and     #0x0f
    jr      nz, 09$

    ; アニメーションの設定
    ld      a, #FIELD_PLAY_BOTTOM
    ld      (_game + GAME_ANIMATION), a

    ; サウンドの停止
    call    _SoundStop

    ; 初期化の完了
    ld      hl, #(_game + GAME_STATE)
    inc     (hl)
09$:

    ; フィールドを埋める
    ld      hl, #(_game + GAME_ANIMATION)
    ld      a, (hl)
    cp      #FIELD_PLAY_TOP
    jr      c, 19$

    ; 1 ライン埋める
    call    _FieldFillLine
    dec     (hl)

    ; ブロックの描画
    call    _BlockRender

    ; フィールドパターンの更新
    call    _FieldUpdatePattern

    ; フィールドパターンの描画
    call    _FieldPrintPattern

    ; ゲームオーバーの描画
    ld      a, (_game + GAME_ANIMATION)
    cp      #FIELD_PLAY_TOP
    jr      nc, 10$
    call    GamePrintOver

    ; BGM の再生
    ld      a, #SOUND_BGM_OVER
    call    _SoundPlayBgm
10$:
    
    ; パターンネームの転送
    ld      hl, #_flag
    set     #FLAG_PATTERN_NAME_UPDATE_BIT, (hl)
    jr      90$
19$:

    ; キーの入力
    ld      a, (_input + INPUT_BUTTON_SPACE)
    dec     a
    jr      nz, 29$

    ; SE の再生
    ld      a, #SOUND_SE_CLICK
    call    _SoundPlaySe

    ; 状態の更新
    ld      a, #GAME_STATE_RESULT
    ld      (_game + GAME_STATE), a
    jr      90$
29$:

    ; ゲームオーバーの完了
90$:

    ; レジスタの復帰

    ; 終了
    ret

; 結果を表示する
;
GameResult:

    ; レジスタの保存

    ; 初期化
    ld      a, (_game + GAME_STATE)
    and     #0x0f
    jr      nz, 09$

    ; ラインの更新
    call    GameUpdateTopLine

    ; スコアの更新
    call    GameUpdateTopScore
    jr      nc, 10$

    ; 結果の描画
    call    GamePrintResult

    ; スコアの描画
    call    GamePrintScore

    ; パターンネームの転送
    ld      hl, #_flag
    set     #FLAG_PATTERN_NAME_UPDATE_BIT, (hl)

    ; 初期化の完了
    ld      hl, #(_game + GAME_STATE)
    inc     (hl)
09$:

    ; キーの入力
    ld      a, (_input + INPUT_BUTTON_SPACE)
    dec     a
    jr      nz, 19$

    ; SE の再生
    ld      a, #SOUND_SE_CLICK
    call    _SoundPlaySe

    ; 状態の更新
10$:
    ld      a, #APP_STATE_TITLE_INITIALIZE
    ld      (_app + APP_STATE), a
    jr      90$
19$:

    ; 結果の完了
90$:

    ; レジスタの復帰

    ; 終了
    ret

; スコアを加算する
;
GameAddScore:

    ; レジスタの保存
    push    hl
    push    bc
    push    de

    ; ポイントの取得
    ld      a, (_game + GAME_MATCH)
    ld      e, a
    ld      d, #0x00
    ld      hl, #gameMatchPoint
    add     hl, de
    ld      b, (hl)

    ; ポイント分のレートの加算
    ld      de, #0x0a01
10$:
    ld      hl, #(_game + GAME_SCORE_00000001)
    ld      a, (_game + GAME_RATE_001)
    add     a, (hl)
    ld      c, e
    sub     d
    jr      nc, 11$
    add     a, d
    dec     c
11$:
    ld      (hl), a
    dec     hl
    ld      a, (_game + GAME_RATE_010)
    add     a, (hl)
    add     a, c
    ld      c, e
    sub     d
    jr      nc, 12$
    add     a, d
    dec     c
12$:
    ld      (hl), a
    dec     hl
    ld      a, (_game + GAME_RATE_100)
    add     a, (hl)
    add     a, c
    ld      c, e
    sub     d
    jr      nc, 13$
    add     a, d
    dec     c
13$:
    ld      (hl), a
    dec     hl
    ld      a, (hl)
    add     a, c
    ld      c, e
    sub     d
    jr      nc, 14$
    add     a, d
    dec     c
14$:
    ld      (hl), a
    dec     hl
    ld      a, (hl)
    add     a, c
    ld      c, e
    sub     d
    jr      nc, 15$
    add     a, d
    dec     c
15$:
    ld      (hl), a
    dec     hl
    ld      a, (hl)
    add     a, c
    ld      c, e
    sub     d
    jr      nc, 16$
    add     a, d
    dec     c
16$:
    ld      (hl), a
    dec     hl
    ld      a, (hl)
    add     a, c
    ld      c, e
    sub     d
    jr      nc, 17$
    add     a, d
    dec     c
17$:
    ld      (hl), a
    dec     hl
    ld      a, (hl)
    add     a, c
    ld      c, e
    sub     d
    jr      nc, 18$
    add     a, d
    dec     c
18$:
    ld      (hl), a
    ld      a, c
    or      a
    jr      z, 19$
    ld      a, #0x09
    ld      (hl), a
    inc     hl
    ld      (hl), a
    inc     hl
    ld      (hl), a
    inc     hl
    ld      (hl), a
    inc     hl
    ld      (hl), a
    inc     hl
    ld      (hl), a
    inc     hl
    ld      (hl), a
    inc     hl
    ld      (hl), a
;   inc     hl
19$:
    djnz    10$

    ; レジスタの復帰
    pop     de
    pop     bc
    pop     hl

    ; 終了
    ret

; トップスコアを更新する
;
GameUpdateTopScore:

    ; レジスタの保存
    push    hl
    push    bc
    push    de

    ; cf > 1 = 更新

    ; スコアの比較
    ld      hl, #(_game + GAME_SCORE_10000000)
    ld      de, #(_app + APP_SCORE_10000000)
    ld      b, #0x08
10$:
    ld      a, (de)
    cp      (hl)
    jr      c, 11$
    jr      nz, 18$
    inc     hl
    inc     de
    djnz    10$
    jr      18$
11$:
    ld      hl, #(_game + GAME_SCORE_10000000)
    ld      de, #(_app + APP_SCORE_10000000)
    ld      bc, #0x0008
    ldir
    scf
    jr      19$
18$:
    or      a
;   jr      19$
19$:

    ; レジスタの復帰
    pop     de
    pop     bc
    pop     hl

    ; 終了
    ret

; ライン数を加算する
;
GameAddLine:

    ; レジスタの保存
    push    hl
    push    de

    ; 揃ったライン数の加算
    ld      hl, #(_game + GAME_LINE_00000001)
    ld      d, #0x0a
    ld      a, (_game + GAME_MATCH)
    add     a, (hl)
    ld      (hl), a
    sub     d
    jr      c, 19$
    ld      (hl), a
    dec     hl
    inc     (hl)
    ld      a, (hl)
    sub     d
    jr      c, 19$
    ld      (hl), a
    dec     hl
    inc     (hl)
    ld      a, (hl)
    sub     d
    jr      c, 19$
    ld      (hl), a
    dec     hl
    inc     (hl)
    ld      a, (hl)
    sub     d
    jr      c, 19$
    ld      (hl), a
    dec     hl
    inc     (hl)
    ld      a, (hl)
    sub     d
    jr      c, 19$
    ld      (hl), a
    dec     hl
    inc     (hl)
    ld      a, (hl)
    sub     d
    jr      c, 19$
    ld      (hl), a
    dec     hl
    inc     (hl)
    ld      a, (hl)
    sub     d
    jr      c, 19$
    ld      (hl), a
    dec     hl
    inc     (hl)
    ld      a, (hl)
    sub     d
    jr      c, 19$
    ld      a, #0x09
    ld      (hl), a
    inc     hl
    ld      (hl), a
    inc     hl
    ld      (hl), a
    inc     hl
    ld      (hl), a
    inc     hl
    ld      (hl), a
    inc     hl
    ld      (hl), a
    inc     hl
    ld      (hl), a
    inc     hl
    ld      (hl), a
;   inc     hl
19$:

    ; レジスタの復帰
    pop     de
    pop     hl

    ; 終了
    ret

; トップライン数を更新する
;
GameUpdateTopLine:

    ; レジスタの保存
    push    hl
    push    bc
    push    de

    ; cf > 1 = 更新

    ; スコアの比較
    ld      hl, #(_game + GAME_LINE_10000000)
    ld      de, #(_app + APP_LINE_10000000)
    ld      b, #0x08
10$:
    ld      a, (de)
    cp      (hl)
    jr      c, 11$
    jr      nz, 18$
    inc     hl
    inc     de
    djnz    10$
    jr      18$
11$:
    ld      hl, #(_game + GAME_LINE_10000000)
    ld      de, #(_app + APP_LINE_10000000)
    ld      bc, #0x0008
    ldir
    scf
    jr      19$
18$:
    or      a
;   jr      19$
19$:

    ; レジスタの復帰
    pop     de
    pop     bc
    pop     hl

    ; 終了
    ret

; 画面の色を変える
;
GameSetColor:

    ; レジスタの保存
    
    ; a < 色（ブロックの種類）

    ; 色の設定
    push    af
    add     a, #(APP_COLOR_TABLE >> 6)
    ld      (_videoRegister + VDP_R3), a
    pop     af

    ; 色の保存
    call    _BlockGetColor
    ld      (_app + APP_COLOR), a

    ; レジスタの復帰

    ; 終了
    ret

; ゲーム画面を描画する
;
GamePrintScreen:

    ; レジスタの保存
    push    hl
    push    bc
    push    de

    ; 画面のクリア
;   xor     a
;   call    _SystemClearPatternName

    ; SCORE の描画
    ld      hl, #gameScreenPatternName_SCORE
    ld      de, #(_patternName + 0x0000)
    ld      bc, #0x0005
    ldir
    ld      hl, #(_patternName + 0x0020)
    ld      de, #(_patternName + 0x0021)
    ld      bc, #(0x0009 - 0x0001)
    ld      (hl), #GAME_PATTERN_NAME_UNDERLINE
    ldir

    ; TOP の描画
    ld      hl, #gameScreenPatternName_TOP
    ld      de, #(_patternName + 0x0080)
    ld      bc, #0x0003
    ldir
    ld      hl, #(_patternName + 0x00a0)
    ld      de, #(_patternName + 0x00a1)
    ld      bc, #(0x0009 - 0x0001)
    ld      (hl), #GAME_PATTERN_NAME_UNDERLINE
    ldir

    ; LINE の描画
    ld      hl, #gameScreenPatternName_LINE
    ld      de, #(_patternName + 0x0220)
    ld      bc, #0x0004
    ldir
    ld      hl, #(_patternName + 0x0240)
    ld      de, #(_patternName + 0x0241)
    ld      bc, #(0x0009 - 0x0001)
    ld      (hl), #GAME_PATTERN_NAME_UNDERLINE
    ldir

    ; RATE の描画
    ld      hl, #gameScreenPatternName_RATE
    ld      de, #(_patternName + 0x02a0)
    ld      bc, #0x0004
    ldir
    ld      hl, #(_patternName + 0x02c0)
    ld      de, #(_patternName + 0x02c1)
    ld      bc, #(0x0009 - 0x0001)
    ld      (hl), #GAME_PATTERN_NAME_UNDERLINE
    ldir

    ; NEXT の描画
    ld      hl, #gameScreenPatternName_NEXT
    ld      de, #(_patternName + 0x0018)
    ld      bc, #0x0004
    ldir
    ld      hl, #(_patternName + 0x0017)
    ld      (hl), #GAME_PATTERN_NAME_TOP_LEFT
    ld      hl, #(_patternName + 0x001c)
    ld      (hl), #GAME_PATTERN_NAME_TOP_RIGHT
    ld      hl, #(_patternName + 0x0037)
    ld      (hl), #GAME_PATTERN_NAME_MIDDLE_LEFT
    ld      hl, #(_patternName + 0x003c)
    ld      (hl), #GAME_PATTERN_NAME_MIDDLE_RIGHT
    ld      hl, #(_patternName + 0x0057)
    ld      (hl), #GAME_PATTERN_NAME_MIDDLE_LEFT
    ld      hl, #(_patternName + 0x005c)
    ld      (hl), #GAME_PATTERN_NAME_MIDDLE_RIGHT
    ld      hl, #(_patternName + 0x0077)
    ld      (hl), #GAME_PATTERN_NAME_BOTTOM_LEFT
    inc     hl
    ld      a, #GAME_PATTERN_NAME_BOTTOM_CENTER
    ld      (hl), a
    inc     hl
    ld      (hl), a
    inc     hl
    ld      (hl), a
    inc     hl
    ld      (hl), a
    inc     hl
    ld      (hl), #GAME_PATTERN_NAME_BOTTOM_RIGHT

    ; レジスタの復帰
    pop     de
    pop     bc
    pop     hl

    ; 終了
    ret

; スコアを描画する
;
GamePrintScore:

    ; レジスタの保存
    push    hl
    push    bc
    push    de

    ; スコアの描画
    ld      hl, #(_game + GAME_SCORE_10000000)
    ld      de, #(_patternName + 0x0041)
    call    10$
    ld      hl, #(_app + APP_SCORE_10000000)
    ld      de, #(_patternName + 0x00c1)
    call    10$
    ld      hl, #(_game + GAME_LINE_10000000)
    ld      de, #(_patternName + 0x0261)
    call    10$
    jr      19$
10$:
    ld      b, #0x07
11$:
    ld      a, (hl)
    or      a
    jr      nz, 12$
    ld      (de), a
    inc     hl
    inc     de
    djnz    11$
12$:
    inc     b
13$:
    ld      a, (hl)
    add     a, #0x30
    ld      (de), a
    inc     hl
    inc     de
    djnz    13$
    ret
19$:

    ; レジスタの復帰
    pop     de
    pop     bc
    pop     hl

    ; 終了
    ret

; レートを描画する
;
GamePrintRate:

    ; レジスタの保存
    push    hl
    push    de

    ; レートの描画
    ld      hl, #(_game + GAME_RATE_100)
    ld      de, #(_patternName + 0x02e5)
    ld      a, (hl)
    or      a
    jr      z, 10$
    add     a, #0x30
10$:
    ld      (de), a
    inc     hl
    inc     de
    ld      a, (hl)
    add     a, #0x30
    ld      (de), a
    inc     hl
    inc     de
    ld      a, #'.
    ld      (de), a
    inc     de
    ld      a, (hl)
    add     a, #0x30
    ld      (de), a

    ; レジスタの復帰
    pop     de
    pop     hl

    ; 終了
    ret

; ネクストブロックを描画する
;
GamePrintNext:

    ; レジスタの保存
    push    hl
    push    bc
    push    de

    ; hl < バッグ

    ; ブロックの描画
    ld      de, #(_patternName + 0x0038)
    call    10$
    inc     hl
    ld      de, #(_patternName + 0x00b8)
    call    10$
    inc     hl
    ld      de, #(_patternName + 0x0118)
    call    10$
    inc     hl
    ld      de, #(_patternName + 0x0178)
    call    10$
    jr      19$
10$:
    push    hl
    push    de
    ld      a, (hl)
    add     a, a
    add     a, a
    add     a, a
    ld      c, a
    ld      b, #0x00
    ld      hl, #gameNextPatternName
    add     hl, bc
    ld      bc, #0x0004
    ldir
    ex      de, hl
    ld      bc, #(0x0020 - 0x0004)
    add     hl, bc
    ex      de, hl
    ld      bc, #0x0004
    ldir
    pop     de
    pop     hl
    ret
19$:

    ; レジスタの復帰
    pop     de
    pop     bc
    pop     hl

    ; 終了
    ret

; 消したライン数を描画する
;
GamePrintMatch:

    ; レジスタの保存
    push    hl
    push    bc
    push    de

    ; スプライトの描画
    ld      c, #VDP_COLOR_WHITE
    ld      a, (_game + GAME_MATCH)
    dec     a
    add     a, a
    add     a, a
    add     a, a
    add     a, a
    ld      e, a
    ld      d, #0x00
    ld      hl, #gameMatchSprite
    add     hl, de
    ld      de, #(_sprite + GAME_SPRITE_MATCH)
    ld      a, (_app + APP_MODE)
    or      a
    jr      nz, 110$

    ; NORMAL の描画
100$:
    call    _FieldGetMatchTopLine
    add     a, a
    add     a, a
    add     a, a
    add     a, #FIELD_VIEW_SPRITE_Y
    sub     #(GAME_ANIMATION_MATCH >> 1)
    ld      b, a
    ld      a, (_game + GAME_ANIMATION)
    srl     a
    add     a, b
    ld      b, a
    ld      a, (hl)
    add     a, b
    ld      (de), a
    inc     hl
    inc     de
    ld      a, (hl)
    ld      (de), a
    inc     hl
    inc     de
    ld      a, (hl)
    ld      (de), a
    inc     hl
    inc     de
    ld      a, c
    ld      (de), a
    inc     hl
    inc     de
    ld      a, (hl)
    add     a, b
    ld      (de), a
    inc     hl
    inc     de
    ld      a, (hl)
    ld      (de), a
    inc     hl
    inc     de
    ld      a, (hl)
    ld      (de), a
    inc     hl
    inc     de
    ld      a, c
    ld      (de), a
    inc     hl
    inc     de
    ld      a, (hl)
    add     a, b
    ld      (de), a
    inc     hl
    inc     de
    ld      a, (hl)
    ld      (de), a
    inc     hl
    inc     de
    ld      a, (hl)
    ld      (de), a
    inc     hl
    inc     de
    ld      a, c
    ld      (de), a
    inc     hl
    inc     de
    ld      a, (hl)
    add     a, b
    ld      (de), a
    inc     hl
    inc     de
    ld      a, (hl)
    ld      (de), a
    inc     hl
    inc     de
    ld      a, (hl)
    ld      (de), a
    inc     hl
    inc     de
    ld      a, c
    ld      (de), a
;   inc     hl
;   inc     de
    jr      190$

    ; REVERSE の描画
110$:
    call    _FieldGetMatchTopLine
    add     a, a
    add     a, a
    add     a, a
    add     a, #FIELD_VIEW_SPRITE_Y
    add     a, #(GAME_ANIMATION_MATCH >> 1)
    ld      b, a
    ld      a, (_game + GAME_ANIMATION)
    srl     a
    sub     b
    neg
    ld      b, a
    ld      a, #0xbe
    sub     b
    ld      b, a
    ld      a, b
    sub     (hl)
    ld      (de), a
    inc     hl
    inc     de
    ld      a, (hl)
    ld      (de), a
    inc     hl
    inc     de
    ld      a, (hl)
    ld      (de), a
    inc     hl
    inc     de
    ld      a, c
    ld      (de), a
    inc     hl
    inc     de
    ld      a, b
    sub     (hl)
    ld      (de), a
    inc     hl
    inc     de
    ld      a, (hl)
    ld      (de), a
    inc     hl
    inc     de
    ld      a, (hl)
    ld      (de), a
    inc     hl
    inc     de
    ld      a, c
    ld      (de), a
    inc     hl
    inc     de
    ld      a, b
    sub     (hl)
    ld      (de), a
    inc     hl
    inc     de
    ld      a, (hl)
    ld      (de), a
    inc     hl
    inc     de
    ld      a, (hl)
    ld      (de), a
    inc     hl
    inc     de
    ld      a, c
    ld      (de), a
    inc     hl
    inc     de
    ld      a, b
    sub     (hl)
    ld      (de), a
    inc     hl
    inc     de
    ld      a, (hl)
    ld      (de), a
    inc     hl
    inc     de
    ld      a, (hl)
    ld      (de), a
    inc     hl
    inc     de
    ld      a, c
    ld      (de), a
;   inc     hl
;   inc     de
;   jr      190$

    ; 描画の完了
190$:

    ; レジスタの復帰
    pop     de
    pop     bc
    pop     hl

    ; 終了
    ret

; 開始を描画する
;
GamePrintStart:

    ; レジスタの保存
    push    hl
    push    bc
    push    de

    ; GAME START の描画
    ld      hl, #gameStartPatternName
    ld      de, #(_patternName + 0x016b)
    ld      bc, #0x000a
    ldir

    ; レジスタの復帰
    pop     de
    pop     bc
    pop     hl

    ; 終了
    ret

; ゲームオーバーを描画する
;
GamePrintOver:

    ; レジスタの保存
    push    hl
    push    bc
    push    de

    ; GAME OVER の描画
    ld      hl, #gameOverPatternName
    ld      de, #(_patternName + 0x016b)
    ld      bc, #0x000a
    ldir

    ; レジスタの復帰
    pop     de
    pop     bc
    pop     hl

    ; 終了
    ret

; 結果を描画する
;
GamePrintResult:

    ; レジスタの保存
    push    hl
    push    bc
    push    de

    ; TOP SCORE! の描画
    ld      hl, #gameResultPatternName
    ld      de, #(_patternName + 0x016b)
    ld      bc, #0x000a
    ldir

    ; レジスタの復帰
    pop     de
    pop     bc
    pop     hl

    ; 終了
    ret

; BGM を演奏する
;
GamePlayBgm:

    ; レジスタの保存
    push    bc

    ; BGM の再生
    call    _SoundIsPlayBgm
    jr      c, 19$
    ld      a, (_game + GAME_BGM)
    inc     a
    cp      #GAME_BGM_LENGTH
    jr      c, 10$
    xor     a
10$:
    ld      (_game + GAME_BGM), a
    ld      b, a
    call    _FieldIsAlert
    ld      a, #SOUND_BGM_GAME_NORMAL_0
    jr      nc, 11$
    ld      a, #SOUND_BGM_GAME_ALERT_0
11$:
    add     a, b
    call    _SoundPlayBgm
19$:

    ; レジスタの復帰
    pop     bc

    ; 終了
    ret

; 定数の定義
;

; 状態別の処理
;
gameProc:
    
    .dw     GameNull
    .dw     GameStart
    .dw     GamePlay
    .dw     GameLock
    .dw     GameMatch
    .dw     GameReduce
    .dw     GameOver
    .dw     GameResult

; ゲームの初期値
;
gameDefault:

    .db     GAME_STATE_NULL
    .db     GAME_FRAME_NULL
    .db     GAME_SCORE_NULL
    .db     GAME_SCORE_NULL
    .db     GAME_SCORE_NULL
    .db     GAME_SCORE_NULL
    .db     GAME_SCORE_NULL
    .db     GAME_SCORE_NULL
    .db     GAME_SCORE_NULL
    .db     GAME_SCORE_NULL
    .db     GAME_LINE_NULL
    .db     GAME_LINE_NULL
    .db     GAME_LINE_NULL
    .db     GAME_LINE_NULL
    .db     GAME_LINE_NULL
    .db     GAME_LINE_NULL
    .db     GAME_LINE_NULL
    .db     GAME_LINE_NULL
    .db     0x01 ; GAME_RATE_NULL
    .db     0x00 ; GAME_RATE_NULL
    .db     0x00 ; GAME_RATE_NULL
    .db     GAME_MATCH_NULL
    .db     GAME_ANIMATION_NULL
    .db     GAME_BGM_LENGTH - 0x01 ; GAME_BGM_NULL

; 揃ったライン数に対するポイント
;
gameMatchPoint:

    .db     0x00, 0x01, 0x03, 0x05, 0x08

; ゲーム画面
;
gameScreenPatternName_SCORE:

    .ascii  "SCORE"

gameScreenPatternName_TOP:

    .ascii  "TOP"

gameScreenPatternName_LINE:

    .ascii  "LINE"

gameScreenPatternName_RATE:

    .ascii  "RATE"

gameScreenPatternName_NEXT:

    .ascii  "NEXT"

; ネクスト
;
gameNextPatternName:

    .db     0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
    .db     0xc0, 0xc1, 0xc2, 0xc3, 0xc4, 0xc5, 0xc6, 0xc7
    .db     0xc8, 0xc9, 0xca, 0xcb, 0xcc, 0xcd, 0xce, 0xcf
    .db     0xd0, 0xd1, 0xd2, 0xd3, 0xd4, 0xd5, 0xd6, 0xd7
    .db     0xd8, 0xd9, 0xda, 0xdb, 0xdc, 0xdd, 0xde, 0xdf
    .db     0xe0, 0xe1, 0xe2, 0xe3, 0xe4, 0xe5, 0xe6, 0xe7
    .db     0xe8, 0xe9, 0xea, 0xeb, 0xec, 0xed, 0xee, 0xef
    .db     0xf0, 0xf1, 0xf2, 0xf3, 0xf4, 0xf5, 0xf6, 0xf7

; 揃ったライン数
;
gameMatchSprite:

    ; SINGLE
    .db     0x00 - 0x01, 0x70, 0x30, VDP_COLOR_WHITE
    .db     0x00 - 0x01, 0x78, 0x31, VDP_COLOR_WHITE
    .db     0x00 - 0x01, 0x80, 0x32, VDP_COLOR_WHITE
    .db     0x00 - 0x01, 0x88, 0x33, VDP_COLOR_WHITE
    ; DOUBLE
    .db     0x00 - 0x01, 0x70, 0x34, VDP_COLOR_WHITE
    .db     0x00 - 0x01, 0x78, 0x35, VDP_COLOR_WHITE
    .db     0x00 - 0x01, 0x80, 0x36, VDP_COLOR_WHITE
    .db     0x00 - 0x01, 0x88, 0x37, VDP_COLOR_WHITE
    ; TRIPLE
    .db     0x00 - 0x01, 0x70, 0x38, VDP_COLOR_WHITE
    .db     0x00 - 0x01, 0x78, 0x39, VDP_COLOR_WHITE
    .db     0x00 - 0x01, 0x80, 0x3a, VDP_COLOR_WHITE
    .db     0x00 - 0x01, 0x88, 0x3b, VDP_COLOR_WHITE
    ; QUAD
    .db     0x00 - 0x01, 0x70, 0x3c, VDP_COLOR_WHITE
    .db     0x00 - 0x01, 0x78, 0x3d, VDP_COLOR_WHITE
    .db     0x00 - 0x01, 0x80, 0x3e, VDP_COLOR_WHITE
    .db     0x00 - 0x01, 0x88, 0x3f, VDP_COLOR_WHITE

; 開始
;
gameStartPatternName:

    .ascii  "GAME START"

; ゲームオーバー
;
gameOverPatternName:

    .ascii  "GAME  OVER"

; 結果
;
gameResultPatternName:

    .ascii  "TOP SCORE!"


; DATA 領域
;
    .area   _DATA

; 変数の定義
;

; ゲーム
;
_game::
    
    .ds     GAME_LENGTH
