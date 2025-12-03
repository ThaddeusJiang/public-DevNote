# 这是开发笔记，使用 TiddlyWiki 格式编写

## TiddlyWiki WikiText 语法指南

本文档帮助 AI 理解和使用 TiddlyWiki WikiText 语法来编写 tiddler 内容。

### 基础文本格式

#### 标题

```
! 一级标题
!! 二级标题
!!! 三级标题
!!!! 四级标题
!!!!! 五级标题
!!!!!! 六级标题
```

#### 强调

```
//斜体文本//
''粗体文本''
__下划线文本__
~~删除线文本~~
```

#### 水平线

**注意**：在 `.tid` 文件中不要使用 `---`，这可能导致渲染问题。

### 列表

#### 无序列表

**重要**：列表前后必须预留空行，否则可能导致 WikiText 渲染问题。

```
* 项目 1
* 项目 2
** 子项目 2.1
** 子项目 2.2
* 项目 3
```

#### 有序列表

**重要**：列表前后必须预留空行，否则可能导致 WikiText 渲染问题。

```
# 第一项
# 第二项
## 子项 2.1
## 子项 2.2
# 第三项
```

#### 定义列表

```
; 术语1
: 定义1
; 术语2
: 定义2
```

### 链接

#### 内部链接（Tiddler 链接）

```
[[目标 Tiddler 标题]]
[[显示文本|目标 Tiddler 标题]]
[[显示文本|目标 Tiddler 标题|工具提示文本]]
```

#### 外部链接

```
https://example.com
[[链接文本|https://example.com]]
```

### 图片

```
[img[图片 Tiddler 标题]]
[img[图片 Tiddler 标题|宽度x高度]]
[img[https://example.com/image.png]]
[img[https://example.com/image.png|宽度x高度]]
```

### 代码

#### 行内代码

```
`代码内容`
```

#### 代码块

使用三个反引号包围代码，可以指定语言类型：

**重要**：代码块前后必须预留空行，否则可能导致 WikiText 渲染问题。

JavaScript 代码块示例：

````
```js
// JavaScript 代码
function hello() {
    console.log("Hello");
}
````

```

Python 代码块示例：

```

```python
# Python 代码
def hello():
    print("Hello")
```

```

### 引用块

```

<<<.tc-big-quote
引用内容
<<< 引用来源

```

### 表格

```

|! 列 1 |! 列 2 |! 列 3 |
| 数据 1 | 数据 2 | 数据 3 |
| 数据 4 | 数据 5 | 数据 6 |

```

### Macro（宏）

Macro 是文本替换机制，使用 `<<` 和 `>>` 包围。

#### 调用 Macro
```

<<macroName>>
<<macroName parameter>>
<<macroName "参数 1" "参数 2">>
<<macroName filter:"[tag[Example]]">>

```

#### 定义 Macro
```

\define myMacro(text)
<b>$text$</b>
\end

<<myMacro "Hello">>

```

#### 常用 Macro 示例
```

<<list-links filter:"[tag[TiddlyWiki]]">>
<<tag TiddlyWiki>>
<<currentTiddler>>

```

**注意**：Macro 参数使用 `:` 而不是 `=`，例如 `filter:"[tag[Example]]"` 而不是 `filter="[tag[Example]]"`

### Widget（小部件）

Widget 是动态渲染组件，使用 `<$` 和 `/>` 或 `</$widgetName>` 包围。

#### 基本 Widget 语法
```

<$widgetName attribute="value" />
<$widgetName attribute="value">
内容
</$widgetName>

```

#### 常用 Widget

**文本 Widget**
```

<$text text="Hello World" />
<$text text={{$:/SiteTitle}} />
<$text text=<<currentTiddler>> />

```

**列表 Widget**
```

<$list filter="[tag[TiddlyWiki]sort[title]]">
<$text text=<<currentTiddler>> />
</$list>

```

**按钮 Widget**
```

<$button message="tm-close-tiddler">关闭</$button>

```

**链接 Widget**
```

<$link to="目标 Tiddler">链接文本</$link>

```

**变量引用**
```

{{$:/变量名}}
{{!!字段名}}

```

### 过滤器语法

过滤器用于查询和筛选 Tiddlers。

```

[tag[TiddlyWiki]]
[tag[TiddlyWiki]sort[title]]
[!is[system]search[TiddlyWiki]]
[prefix[J]]
[tag[Core Macros]]

```

### 转义字符

在 WikiText 中，某些字符有特殊含义，需要转义：

```

\* 转义的星号
\# 转义的井号
\[ 转义的左方括号
\] 转义的右方括号

```

### 注释

```

<!-- HTML 注释 -->

```

### 重要提示

1. **Macro vs Widget**：
   - Macro：文本替换，使用 `<<>>`
   - Widget：动态渲染，使用 `<$ />`

2. **参数语法**：
   - Macro 参数使用 `:` 分隔，如 `filter:"[tag[Example]]"`
   - Widget 属性使用 `=` 分隔，如 `filter="[tag[Example]]"`

3. **变量引用**：
   - 使用 `{{$:/变量名}}` 引用系统变量
   - 使用 `{{!!字段名}}` 引用当前 tiddler 的字段
   - 使用 `<<currentTiddler>>` 获取当前 tiddler 标题

4. **代码块**：使用三个反引号包围代码，可以指定语言类型。代码块前后必须预留空行。

5. **链接**：内部链接使用 `[[标题]]`，外部链接使用 `[文本|URL]`

6. **格式要求**：
   - 代码块、列表、表格等块级元素前后必须预留空行，避免 WikiText 渲染问题
   - 在 `.tid` 文件中不要使用 `---` 水平线，这可能导致渲染问题

### 参考资源

- 官方文档：https://tiddlywiki.com/#WikiText
- 示例代码：查看项目中的 `tiddlers/` 目录下的 `.tid` 文件
```
