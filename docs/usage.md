# 使用方法

ClipboardToDrawIOアプリは、クリップボードにコピーしたDraw.io形式のXMLデータからDrawioファイルを簡単に作成できます。

## 基本的な使い方

1. **XMLデータを準備する**
    - AIアシスタント（ClaudeやChatGPTなど）からDraw.io形式のXMLを生成してもらう
    - または既存の.drawioファイルをテキストエディタで開き、内容をコピー

2. **XMLをクリップボードにコピー**
    - 生成されたXMLデータを選択して、コピー (Cmd+C)

3. **ClipboardToDrawIOアプリを起動**
    - Applicationフォルダから、または
    - Spotlight (Cmd+Space) で「ClipboardToDrawIO」を検索して起動

4. **ダイアログに従って操作**
    - 最初のダイアログでクリップボードの内容を確認し「続行」をクリック
    - 保存先を「デスクトップ」または「カスタム」から選択
    - ファイル名を入力して「保存」をクリック

5. **Draw.ioファイルを使用**
    - 生成されたファイルをDraw.ioアプリまたはブラウザ版で開く
    - 必要に応じて編集を行う

## 詳細設定

### XMLヘッダーの自動追加
クリップボードの内容に有効なXMLヘッダーがない場合、自動的に以下のヘッダーが追加されます：
```xml
<?xml version="1.0" encoding="UTF-8"?>
```

### 既存ファイルの上書き確認
同じ名前のファイルが既に存在する場合、以下の選択肢が表示されます：

キャンセル: 処理を中止
新しい名前: 別の名前でファイルを保存
上書き: 既存のファイルを上書き

### エラー処理
ファイル作成中にエラーが発生した場合、詳細なエラーメッセージが表示されます。よくあるエラーとしては：

ファイル書き込み権限の問題
不正なXML構造
ディスク容量不足

### トラブルシューティング

#### 「XMLが検出されませんでした」というメッセージが表示される
コピーした内容にDraw.io形式のXML要素が含まれているか確認してください。少なくとも <mxfile> または <diagram> タグを含む必要があります。
#### ファイルが正常に保存されたと表示されるが、Draw.ioで開けない
コピーしたXMLデータが完全であることを確認してください。Draw.ioの最新バージョンを使用しているか確認してください。
##### アプリが起動しない、またはクラッシュする
macOSを最新バージョンに更新してください。それでも問題が解決しない場合は、GitHubのIssueページで報告してください。