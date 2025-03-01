# ClipboardToDrawIO

クリップボードにあるXML（Draw.io形式）から.drawioファイルを簡単に作成するmacOSアプリケーションです。特にClaudeなどのAIアシスタントから生成されたDraw.io XMLを扱う際に便利です。

## 機能

- クリップボードの内容を検知してDraw.ioファイルに変換
- 簡易的なXML検証
- ファイル名と保存先の指定
- ファイル上書き確認
- 詳細なエラーハンドリング

## インストール方法

1. [リリースページ](https://github.com/Slevin06/ClipboardToDrawIO/releases)から最新版の `ClipboardToDrawIO.zip` をダウンロード
2. ダウンロードしたZIPファイルを展開
3. `ClipboardToDrawIO.app` をアプリケーションフォルダに移動（任意）

初回起動時は「開発元を検証できません」という警告が表示される場合があります。その場合は、アプリを右クリック→「開く」→「開く」を選択して実行してください。

## 使用方法

1. Draw.io形式のXMLをクリップボードにコピー
    - AIアシスタント（Claude等）から生成されたXML
    - 既存のDraw.ioファイルから抽出したXML
    - その他のDraw.io互換XML
2. `ClipboardToDrawIO.app` を起動
3. ダイアログの指示に従って操作
    - クリップボード内容の確認
    - 保存先の選択
    - ファイル名の入力
4. デスクトップ（または指定した場所）に.drawioファイルが生成されます

## スクリーンショット

![使用例](images/screenshot1.png)

## 開発背景

MermaidからDraw.ioへの変換ワークフローを効率化するために開発しました。AIアシスタントが生成したDraw.io形式のXMLを直接ファイルとして保存することで、手動でのテキストエディタの操作を省略できます。

## 技術情報

- 言語: AppleScript
- 対応OS: macOS Catalina以降推奨

## ライセンス

[MIT](LICENSE)