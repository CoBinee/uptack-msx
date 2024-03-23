; Title.s : タイトル
;


; モジュール宣言
;
    .module Title

; 参照ファイル
;
    .include    "bios.inc"
    .include    "vdp.inc"
    .include    "System.inc"
    .include    "App.inc"
    .include    "Sound.inc"
    .include	"Title.inc"

; 外部変数宣言
;

; マクロの定義
;


; CODE 領域
;
    .area   _CODE

; タイトルを初期化する
;
_TitleInitialize::
    
    ; レジスタの保存
    
    ; スプライトのクリア
    call    _SystemClearSprite

    ; パターンネームのクリア
    xor     a
    call    _SystemClearPatternName

    ; タイトルの初期化
    ld      hl, #titleDefault
    ld      de, #_title
    ld      bc, #TITLE_LENGTH
    ldir

    ; パターンネームの転送
    ld      hl, #_flag
    set     #FLAG_PATTERN_NAME_UPDATE_BIT, (hl)

    ; 描画の開始
    ld      hl, #(_videoRegister + VDP_R1)
    set     #VDP_R1_BL, (hl)

    ; 状態の設定
    ld      a, #TITLE_STATE_LOOP
    ld      (_title + TITLE_STATE), a
    ld      a, #APP_STATE_TITLE_UPDATE
    ld      (_app + APP_STATE), a
    
    ; レジスタの復帰
    
    ; 終了
    ret

; タイトルを更新する
;
_TitleUpdate::
    
    ; レジスタの保存
    
    ; スプライトのクリア
    call    _SystemClearSprite

    ; 状態別の処理
    ld      hl, #10$
    push    hl
    ld      a, (_title + TITLE_STATE)
    and     #0xf0
    rrca
    rrca
    rrca
    ld      e, a
    ld      d, #0x00
    ld      hl, #titleProc
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
TitleNull:

    ; レジスタの保存

    ; レジスタの復帰

    ; 終了
    ret

; 待機する
;
TitleLoop:

    ; レジスタの保存

    ; 初期化
    ld      a, (_title + TITLE_STATE)
    and     #0x0f
    jr      nz, 09$

    ; ロゴの設定
    ld      a, #0x02
    ld      (_title + TITLE_LOGO), a

    ; フレームの設定
    xor     a
    ld      (_title + TITLE_FRAME), a

    ; タイトル画面の描画
    call    TitlePrintScreen

    ; BGM の再生
    ld      a, #SOUND_BGM_TITLE
    call    _SoundPlayBgm

    ; 初期化の完了
    ld      hl, #(_title + TITLE_STATE)
    inc     (hl)
09$:

    ; フレームの更新
    ld      hl, #(_title + TITLE_FRAME)
    inc     (hl)
    
    ; キーの入力

    ; ゲームの開始
    ld      a, (_input + INPUT_BUTTON_SPACE)
    dec     a
    jr      nz, 10$

    ; 状態の更新
    ld      a, #TITLE_STATE_START
    ld      (_title + TITLE_STATE), a
    jr      19$
10$:

    ; モードの切り替え
    ld      a, (_input + INPUT_BUTTON_ESC)
    dec     a
    jr      nz, 19$
    ld      hl, #(_app + APP_MODE)
    ld      a, #0x01
    sub     (hl)
    ld      (hl), a
;   jr      19$

    ; キー入力の完了
19$:

    ; ロゴの更新
    ld      hl, #(_title + TITLE_LOGO)
    inc     (hl)
    ld      a, (hl)
    cp      #TITLE_LOGO_LENGTH
    jr      c, 20$
    xor     a
20$:
    ld      (hl), a

    ; 点滅の更新
    ld      a, (_title + TITLE_FRAME)
    and     #0x20
    rlca
    rlca
    rlca
    ld      (_title + TITLE_BLINK), a

    ; ロゴの描画
    call    TitlePrintLogo

    ; HIT SPACE BAR の描画
    call    TitlePrintHitSpaceBar

    ; パターンネームの転送
    ld      hl, #_flag
    set     #FLAG_PATTERN_NAME_UPDATE_BIT, (hl)

    ; レジスタの復帰

    ; 終了
    ret

; ゲームを開始する
;
TitleStart:

    ; レジスタの保存

    ; 初期化
    ld      a, (_title + TITLE_STATE)
    and     #0x0f
    jr      nz, 09$

    ; フレームの設定
    ld      a, #0x60
    ld      (_title + TITLE_FRAME), a

    ; サウンドの停止
    call    _SoundStop

    ; SE の再生
    ld      a, #SOUND_SE_BOOT
    call    _SoundPlaySe

    ; 初期化の完了
    ld      hl, #(_title + TITLE_STATE)
    inc     (hl)
09$:

    ; フレームの更新
    ld      hl, #(_title + TITLE_FRAME)
    dec     (hl)
    jr      nz, 19$

    ; 状態の更新
    ld      a, #APP_STATE_GAME_INITIALIZE
    ld      (_app + APP_STATE), a
;   jr      19$
19$:

    ; ロゴの更新
    ld      hl, #(_title + TITLE_LOGO)
    inc     (hl)
    ld      a, (hl)
    cp      #TITLE_LOGO_LENGTH
    jr      c, 20$
    xor     a
20$:
    ld      (hl), a

    ; 点滅の更新
    ld      a, (_title + TITLE_FRAME)
    and     #0x04
    rrca
    rrca
    ld      (_title + TITLE_BLINK), a

    ; ロゴの描画
    call    TitlePrintLogo

    ; HIT SPACE BAR の描画
    call    TitlePrintHitSpaceBar

    ; パターンネームの転送
    ld      hl, #_flag
    set     #FLAG_PATTERN_NAME_UPDATE_BIT, (hl)

    ; パターンネームの転送
    ld      hl, #_flag
    set     #FLAG_PATTERN_NAME_UPDATE_BIT, (hl)

    ; レジスタの復帰

    ; 終了
    ret

; タイトル画面を描画する
;
TitlePrintScreen:

    ; レジスタの保存
    push    hl
    push    bc
    push    de

    ; 画面のクリア
;   xor     a
;   call    _SystemClearPatternName

    ; スコアの描画
    ld      hl, #titleScreenPatternName_TOP
    ld      de, #(_patternName + 0x01e9)
    ld      bc, #0x0006
    ldir
    ld      hl, #(_app + APP_SCORE_10000000)
    ld      b, #0x07
10$:
    ld      a, (hl)
    or      a
    jr      nz, 11$
    ld      (de), a
    inc     hl
    inc     de
    djnz    10$
11$:
    inc     b
12$:
    ld      a, (hl)
    add     a, #0x30
    ld      (de), a
    inc     hl
    inc     de
    djnz    12$

    ; レジスタの復帰
    pop     de
    pop     bc
    pop     hl

    ; 終了
    ret

; ロゴを描画する
;
TitlePrintLogo:

    ; レジスタの保存
    push    hl
    push    bc
    push    de

    ; スプライトの描画
    ld      a, (_app + APP_MODE)
    add     a, a
    add     a, a
    add     a, a
    ld      e, a
    add     a, a
    add     a, a
    add     a, e
    ld      d, #0x00
    add     a, a
    rl      d
    add     a, a
    rl      d
    ld      e, a
    ld      hl, #titleLogoSprite
    add     hl, de
    ld      de, #(_sprite + TITLE_SPRITE_LOGO)
    ld      a, (_app + APP_COLOR)
    ld      c, a
    ld      a, (_title + TITLE_LOGO)
    ld      b, #0x04
10$:
    push    af
    push    hl
    push    bc
    add     a, a
    add     a, a
    ld      c, a
    ld      b, #0x00
    add     hl, bc
    pop     bc
    ld      a, (hl)
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
    inc     de
    pop     hl
    pop     af
    dec     a
    cp      #-0x01
    jr      nz, 11$
    ld      a, #(TITLE_LOGO_LENGTH - 0x01)
11$:
    djnz    10$

    ; レジスタの復帰
    pop     de
    pop     bc
    pop     hl

    ; 終了
    ret

; HIT SPACE BAR を描画する
;
TitlePrintHitSpaceBar:

    ; レジスタの保存
    push    hl
    push    bc
    push    de

    ; HIT SPACE BAR の描画
    ld      a, (_title + TITLE_BLINK)
    add     a, a
    add     a, a
    add     a, a
    add     a, a
    ld      e, a
    ld      d, #0x00
    ld      hl, #titleHitSpaceBarPatternName
    add     hl, de
    ld      de, #(_patternName + 0x0248)
    ld      bc, #0x0010
    ldir

    ; レジスタの復帰
    pop     de
    pop     bc
    pop     hl

    ; 終了
    ret

; 定数の定義
;

; 状態別の処理
;
titleProc:
    
    .dw     TitleNull
    .dw     TitleLoop
    .dw     TitleStart

; タイトルの初期値
;
titleDefault:

    .db     TITLE_STATE_NULL
    .db     TITLE_FRAME_NULL
    .db     TITLE_LOGO_NULL
    .db     TITLE_BLINK_NULL

; タイトル画面
;
titleScreenPatternName_TOP:

    .ascii  "TOP - "

; ロゴ
;
titleLogoSprite:

    ; NORMAL
    .db     0x20 - 0x01, 0x50, 0x17, VDP_COLOR_DARK_GREEN
    .db     0x20 - 0x01, 0x58, 0x17, VDP_COLOR_DARK_GREEN
    .db     0x20 - 0x01, 0x60, 0x17, VDP_COLOR_DARK_GREEN
    .db     0x20 - 0x01, 0x68, 0x17, VDP_COLOR_DARK_GREEN
    .db     0x20 - 0x01, 0x70, 0x17, VDP_COLOR_DARK_GREEN
    .db     0x20 - 0x01, 0x78, 0x17, VDP_COLOR_DARK_GREEN
    .db     0x20 - 0x01, 0x80, 0x17, VDP_COLOR_DARK_GREEN
    .db     0x20 - 0x01, 0x88, 0x17, VDP_COLOR_DARK_GREEN
    .db     0x20 - 0x01, 0x90, 0x17, VDP_COLOR_DARK_GREEN
    .db     0x20 - 0x01, 0x98, 0x17, VDP_COLOR_DARK_GREEN
    .db     0x20 - 0x01, 0xa0, 0x17, VDP_COLOR_DARK_GREEN
    .db     0x20 - 0x01, 0xa8, 0x17, VDP_COLOR_DARK_GREEN
    .db     0x20 - 0x01, 0xa8, 0x1e, VDP_COLOR_DARK_GREEN
    .db     0x28 - 0x01, 0xa8, 0x1e, VDP_COLOR_DARK_GREEN
    .db     0x30 - 0x01, 0xa8, 0x1e, VDP_COLOR_DARK_GREEN
    .db     0x38 - 0x01, 0xa8, 0x1e, VDP_COLOR_DARK_GREEN
    .db     0x38 - 0x01, 0xa8, 0x1b, VDP_COLOR_DARK_GREEN
    .db     0x38 - 0x01, 0xa0, 0x1b, VDP_COLOR_DARK_GREEN
    .db     0x38 - 0x01, 0x98, 0x1b, VDP_COLOR_DARK_GREEN
    .db     0x38 - 0x01, 0x90, 0x1b, VDP_COLOR_DARK_GREEN
    .db     0x40 - 0x01, 0x88, 0x1e, VDP_COLOR_DARK_GREEN
    .db     0x48 - 0x01, 0x88, 0x1e, VDP_COLOR_DARK_GREEN
    .db     0x50 - 0x01, 0x88, 0x1e, VDP_COLOR_DARK_GREEN
    .db     0x58 - 0x01, 0x88, 0x1e, VDP_COLOR_DARK_GREEN
    .db     0x58 - 0x01, 0x88, 0x1b, VDP_COLOR_DARK_GREEN
    .db     0x58 - 0x01, 0x80, 0x1b, VDP_COLOR_DARK_GREEN
    .db     0x58 - 0x01, 0x78, 0x1b, VDP_COLOR_DARK_GREEN
    .db     0x58 - 0x01, 0x70, 0x1b, VDP_COLOR_DARK_GREEN
    .db     0x58 - 0x01, 0x70, 0x1d, VDP_COLOR_DARK_GREEN
    .db     0x50 - 0x01, 0x70, 0x1d, VDP_COLOR_DARK_GREEN
    .db     0x48 - 0x01, 0x70, 0x1d, VDP_COLOR_DARK_GREEN
    .db     0x40 - 0x01, 0x70, 0x1d, VDP_COLOR_DARK_GREEN
    .db     0x38 - 0x01, 0x68, 0x1b, VDP_COLOR_DARK_GREEN
    .db     0x38 - 0x01, 0x60, 0x1b, VDP_COLOR_DARK_GREEN
    .db     0x38 - 0x01, 0x58, 0x1b, VDP_COLOR_DARK_GREEN
    .db     0x38 - 0x01, 0x50, 0x1b, VDP_COLOR_DARK_GREEN
    .db     0x38 - 0x01, 0x50, 0x1d, VDP_COLOR_DARK_GREEN
    .db     0x30 - 0x01, 0x50, 0x1d, VDP_COLOR_DARK_GREEN
    .db     0x28 - 0x01, 0x50, 0x1d, VDP_COLOR_DARK_GREEN
    .db     0x20 - 0x01, 0x50, 0x1d, VDP_COLOR_DARK_GREEN

    ; REVERSE
    .db     0x58 - 0x01, 0x50, 0x1d, VDP_COLOR_DARK_GREEN
    .db     0x50 - 0x01, 0x50, 0x1d, VDP_COLOR_DARK_GREEN
    .db     0x48 - 0x01, 0x50, 0x1d, VDP_COLOR_DARK_GREEN
    .db     0x40 - 0x01, 0x50, 0x1d, VDP_COLOR_DARK_GREEN
    .db     0x40 - 0x01, 0x50, 0x17, VDP_COLOR_DARK_GREEN
    .db     0x40 - 0x01, 0x58, 0x17, VDP_COLOR_DARK_GREEN
    .db     0x40 - 0x01, 0x60, 0x17, VDP_COLOR_DARK_GREEN
    .db     0x40 - 0x01, 0x68, 0x17, VDP_COLOR_DARK_GREEN
    .db     0x38 - 0x01, 0x70, 0x1d, VDP_COLOR_DARK_GREEN
    .db     0x30 - 0x01, 0x70, 0x1d, VDP_COLOR_DARK_GREEN
    .db     0x28 - 0x01, 0x70, 0x1d, VDP_COLOR_DARK_GREEN
    .db     0x20 - 0x01, 0x70, 0x1d, VDP_COLOR_DARK_GREEN
    .db     0x20 - 0x01, 0x70, 0x17, VDP_COLOR_DARK_GREEN
    .db     0x20 - 0x01, 0x78, 0x17, VDP_COLOR_DARK_GREEN
    .db     0x20 - 0x01, 0x80, 0x17, VDP_COLOR_DARK_GREEN
    .db     0x20 - 0x01, 0x88, 0x17, VDP_COLOR_DARK_GREEN
    .db     0x20 - 0x01, 0x88, 0x1e, VDP_COLOR_DARK_GREEN
    .db     0x28 - 0x01, 0x88, 0x1e, VDP_COLOR_DARK_GREEN
    .db     0x30 - 0x01, 0x88, 0x1e, VDP_COLOR_DARK_GREEN
    .db     0x38 - 0x01, 0x88, 0x1e, VDP_COLOR_DARK_GREEN
    .db     0x40 - 0x01, 0x90, 0x17, VDP_COLOR_DARK_GREEN
    .db     0x40 - 0x01, 0x98, 0x17, VDP_COLOR_DARK_GREEN
    .db     0x40 - 0x01, 0xa0, 0x17, VDP_COLOR_DARK_GREEN
    .db     0x40 - 0x01, 0xa8, 0x17, VDP_COLOR_DARK_GREEN
    .db     0x40 - 0x01, 0xa8, 0x1e, VDP_COLOR_DARK_GREEN
    .db     0x48 - 0x01, 0xa8, 0x1e, VDP_COLOR_DARK_GREEN
    .db     0x50 - 0x01, 0xa8, 0x1e, VDP_COLOR_DARK_GREEN
    .db     0x58 - 0x01, 0xa8, 0x1e, VDP_COLOR_DARK_GREEN
    .db     0x58 - 0x01, 0xa8, 0x1b, VDP_COLOR_DARK_GREEN
    .db     0x58 - 0x01, 0xa0, 0x1b, VDP_COLOR_DARK_GREEN
    .db     0x58 - 0x01, 0x98, 0x1b, VDP_COLOR_DARK_GREEN
    .db     0x58 - 0x01, 0x90, 0x1b, VDP_COLOR_DARK_GREEN
    .db     0x58 - 0x01, 0x88, 0x1b, VDP_COLOR_DARK_GREEN
    .db     0x58 - 0x01, 0x80, 0x1b, VDP_COLOR_DARK_GREEN
    .db     0x58 - 0x01, 0x78, 0x1b, VDP_COLOR_DARK_GREEN
    .db     0x58 - 0x01, 0x70, 0x1b, VDP_COLOR_DARK_GREEN
    .db     0x58 - 0x01, 0x68, 0x1b, VDP_COLOR_DARK_GREEN
    .db     0x58 - 0x01, 0x60, 0x1b, VDP_COLOR_DARK_GREEN
    .db     0x58 - 0x01, 0x58, 0x1b, VDP_COLOR_DARK_GREEN
    .db     0x58 - 0x01, 0x50, 0x1b, VDP_COLOR_DARK_GREEN

; HIT SPACE BAR
;
titleHitSpaceBarPatternName:

    .db     0x00, 0x60, 0x61, 0x62, 0x63, 0x64, 0x65, 0x66, 0x67, 0x68, 0x69, 0x6a, 0x6b, 0x6c, 0x6d, 0x00
    .db     0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00


; DATA 領域
;
    .area   _DATA

; 変数の定義
;

; タイトル
;
_title::
    
    .ds     TITLE_LENGTH
