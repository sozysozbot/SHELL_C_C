# シェルスクリプトで C コンパイラ

## 2023-05-26
ということでステップ 2 は完了。

## 2023-07-16
さーてこのプロジェクトを 2 ヶ月弱寝かせてしまっていた。次にやるべきは「ステップ5：四則演算のできる言語の作成」かな。

### ステップ 3
とはいえ、トークナイザは正直あったほうが便利な気もしている。あー `配列名+=(値1 値2 値3)` で append できるのか。楽だな。
じゃあステップ 3 をやるか。
とりあえず、既存の出力機構をそのままトークナイザにできた。OK

次にやるべきは、トークナイザと出力を切り分けること。分けた。

そしてトークナイザで切り分けたトークンをもとにコード生成するのもできた。意外と簡単だな。

### ステップ 5
さて今度は構文木を生やしていかなきゃならん。とりあえず、現状の `5+20-4-7+3` とかを構文木へと変換していかなきゃいかんわな。

とりあえずファイルシステム上に木を作るのは確実として、どういうふうに構築してどういうふうに出力するかを考えなければいけない。

まず、作業ディレクトリを tmp_parsetree とすると、`5` を読んだ時点で tree tmp_parsetree/ がこうあるべき

```
tmp_parsetree/
└── 5
```

そして、`5+20` を読んだらこうなるべき

```
tmp_parsetree/
├── add
├── left
│   └── 5
└── right
    └── 20
```

さらに、`5+20-4` を読んだらこうなるべき

```
tmp_parsetree/
├── left
│   ├── add
│   ├── left
│   │   └── 5
│   └── right
│       └── 20
├── right
│   └── 4
└── sub
```

えーと、current directory を tmp_parsetree/ に置いたとき、一段階掘り進めるために打つべきコマンドを模索するか。

```
mkdir left_
mv -t left_ *
```

をすると `cannot move 'left_' to a subdirectory of itself, 'left_/left_'` とは言われるが一応全部突っ込んでくれて、

```
.
└── left_
    ├── left
    │   ├── add
    │   ├── left
    │   │   └── 5
    │   └── right
    │       └── 20
    ├── right
    │   └── 4
    └── sub
```

になってくれる。

なるほど、StackOverflow で調べたら

```
mv * subfolder | mkdir subfolder
```

でいけるらしい。やってみるか。https://stackoverflow.com/questions/43260052/bash-move-to-subfolder-fail-cannot-move-to-a-subdirectory-of-itself

えーとさっきの状態に戻して、

```
mv * left_ | mkdir left_
```

いや？うまくいかないが？？

んー、フォルダの階層構造を変えるか。tmp_parsetree はすべてのための作業場であり、そこからこぼさないようにしたいので、その下に value/ を作って、

```
.
└── value
    ├── left
    │   ├── add
    │   ├── left
    │   │   └── 5
    │   └── right
    │       └── 20
    ├── right
    │   └── 4
    └── sub
```

からスタートすることにしよう。この場合は、

```
mkdir left
mv -t left value/*
mv left value
touch value/sub
mkdir value/right
touch value/right/7
```

とすると `tree .` が

```
.
└── value
    ├── left
    │   ├── left
    │   │   ├── add
    │   │   ├── left
    │   │   │   └── 5
    │   │   └── right
    │   │       └── 20
    │   ├── right
    │   │   └── 4
    │   └── sub
    ├── right
    │   └── 7
    └── sub
```

になってくれる。なるほどなぁ。

