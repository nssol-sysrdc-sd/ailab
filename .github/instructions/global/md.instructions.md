---
applyTo: '**/*.md'
---

このファイルはOSごとのVSCode User Data Folder に配置することを想定している。
利用者は、 `.vscode/settings.json` の `chat.instructionsFilesLocations` のパスにこのファイルを追加してください。

## Markdown 記法

Markdownを記述する際は、必要最小限の装飾のみを使用してください。

OK例

```markdown
- 強調表示: 説明文で無駄な太字指定を避ける
```

NG例

```markdown
- **強調表示**: 説明文
```
