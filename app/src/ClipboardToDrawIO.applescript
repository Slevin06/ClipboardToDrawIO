on run
	try
		-- クリップボード内容のプレビュー表示（最初の200文字）
		set clipContent to the clipboard as «class utf8»
		set previewText to ""
		if (count clipContent) > 200 then
			set previewText to (characters 1 through 200 of clipContent as string) & "..."
		else
			set previewText to clipContent
		end if
		
		-- 簡易XMLチェック
		if clipContent does not contain "<mxfile" and clipContent does not contain "<diagram" then
			set proceedAnyway to button returned of (display dialog "クリップボード内容にDraw.ioのXML要素が見つかりません。
このままファイルを作成しますか？" buttons {"キャンセル", "続行"} default button "キャンセル" with icon caution)
			
			if proceedAnyway is "キャンセル" then
				return
			end if
		end if
		
		-- 確認ダイアログを表示
		set confirmResult to display dialog "クリップボードからdraw.ioファイルを作成します：

プレビュー(200文字以降切り落とし): " & previewText buttons {"キャンセル", "続行"} default button "続行" with icon note
		
		if button returned of confirmResult is "続行" then
			-- ファイル名入力とバリデーション
			set isValidFileName to false
			set defaultFileName to "diagram"
			
			-- 保存先の選択（デスクトップかカスタム）
			set saveLocationChoice to button returned of (display dialog "保存先を選択してください：" buttons {"キャンセル", "カスタム", "デスクトップ"} default button "デスクトップ")
			
			if saveLocationChoice is "キャンセル" then
				return
			end if
			
			-- 保存先パスの設定
			if saveLocationChoice is "デスクトップ" then
				set savePath to POSIX path of (path to desktop folder)
			else
				set folderRef to choose folder with prompt "保存先フォルダを選択："
				set savePath to POSIX path of folderRef
			end if
			
			-- POSIX パスが / で終わることを確認
			if character -1 of savePath is not "/" then
				set savePath to savePath & "/"
			end if
			
			repeat until isValidFileName
				set fileName to text returned of (display dialog "ファイル名を入力:" default answer defaultFileName buttons {"キャンセル", "保存"} default button "保存")
				
				-- キャンセルまたは空白の場合は終了
				if fileName is "" or fileName is missing value then
					return
				end if
				
				-- 文字数制限のチェック (macOSの最大ファイル名長は255文字)
				if (count fileName) > 255 then
					display dialog "ファイル名が長すぎます。255文字以内で入力してください。" buttons {"OK"} default button "OK" with icon caution
				else if (count fileName) < 1 then
					display dialog "ファイル名を入力してください。" buttons {"OK"} default button "OK" with icon caution
				else
					-- 非推奨文字のチェック
					set invalidChars to ":/\\*?\"<>|"
					set hasInvalidChar to false
					set invalidCharFound to ""
					
					repeat with i from 1 to (count fileName)
						set currentChar to character i of fileName
						if invalidChars contains currentChar then
							set hasInvalidChar to true
							set invalidCharFound to currentChar
							exit repeat
						end if
					end repeat
					
					if hasInvalidChar then
						display dialog "ファイル名に使用できない文字が含まれています: " & invalidCharFound & "
次の文字は使用できません: : / \\ * ? \" < > |" buttons {"OK"} default button "OK" with icon caution
					else
						set isValidFileName to true
					end if
				end if
			end repeat
			
			-- POSIX形式でファイルパスを構築
			set fullFilePath to savePath & fileName & ".drawio"
			
			-- 既存ファイルの確認（POSIXパスを使用）
			set fileExists to false
			try
				do shell script "test -e " & quoted form of fullFilePath & " && echo 'YES' || echo 'NO'"
				set fileExists to (result is "YES")
			end try
			
			if fileExists then
				set overwriteChoice to button returned of (display dialog "'" & fileName & ".drawio'は既に存在します。上書きしますか？" buttons {"キャンセル", "新しい名前", "上書き"} default button "新しい名前" with icon caution)
				
				if overwriteChoice is "キャンセル" then
					return
				else if overwriteChoice is "新しい名前" then
					set isValidFileName to false
					set defaultFileName to fileName & "_copy"
					repeat until isValidFileName
						set fileName to text returned of (display dialog "新しいファイル名を入力:" default answer defaultFileName buttons {"キャンセル", "保存"} default button "保存")
						
						if fileName is "" then
							return
						end if
						
						-- 文字数と禁止文字のチェック（簡略化）
						if (count fileName) > 255 or (count fileName) < 1 then
							display dialog "ファイル名は1～255文字で入力してください。" buttons {"OK"} default button "OK" with icon caution
						else
							-- 禁止文字チェック（簡略化のため省略）
							set isValidFileName to true
							set fullFilePath to savePath & fileName & ".drawio"
							
							-- 再度ファイル存在チェック
							try
								do shell script "test -e " & quoted form of fullFilePath & " && echo 'YES' || echo 'NO'"
								set fileExists to (result is "YES")
							end try
							
							if fileExists then
								set isValidFileName to false
								set defaultFileName to fileName & "_copy"
								display dialog "そのファイル名も既に存在します。別の名前を入力してください。" buttons {"OK"} default button "OK" with icon caution
							end if
						end if
					end repeat
				end if
			end if
			
			-- XMLヘッダを追加（まだない場合）
			set xmlData to clipContent as string
			if xmlData does not start with "<?xml" then
				set xmlData to "<?xml version=\"1.0\" encoding=\"UTF-8\"?>" & return & xmlData
			end if
			
			-- 改良：シェルスクリプトを使用してファイルに書き込み
			try
				-- 一時ファイルを作成し、それをmvコマンドで移動（より安全な方法）
				set tempFile to "/tmp/temp_drawio_" & do shell script "date +%s"
				do shell script "echo " & quoted form of xmlData & " > " & quoted form of tempFile
				do shell script "mv " & quoted form of tempFile & " " & quoted form of fullFilePath
				
				display notification "ファイルが保存されました: " & fileName & ".drawio" with title "Draw.io変換"
			on error fileErrMsg
				display dialog "ファイル書き込みエラー: " & fileErrMsg buttons {"OK"} default button "OK" with icon stop
			end try
		end if
		
	on error errMsg
		display dialog "エラーが発生しました: " & errMsg buttons {"OK"} default button "OK" with icon stop
	end try
end run