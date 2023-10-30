# 这个脚本读取标准输入流中的json串并将将其格式化
# 如果发生异常将原样输出标准输入流中的json串
import sys


pairs = {'{': '}', '[': ']'}


def next_not_empty(s, i):
    while i < len(s) and (s[i] == ' ' or s[i] == '\n'):
        i += 1
    return i < len(s) and s[i] or None


def prev_not_empty(s, i):
    while i >= 0 and (s[i] == ' ' or s[i] == '\n'):
        i -= 1
    return i >= 0 and s[i] or None


def format_json(json, indent):
    indent_lv = 0
    formated = ""
    instr = False
    for i in range(len(json)):

        if json[i] == '"' and (i == 0 or json[i-1] != '\\'):
            instr = not instr

        if not instr:
            if json[i] == '{' or json[i] == '[':
                indent_lv += 1
                formated += json[i]
                c = next_not_empty(json, i+1)
                if pairs.get(json[i]) != c:
                    formated += '\n' + ' ' * indent_lv * indent
            elif json[i] == '}' or json[i] == ']':
                indent_lv -= 1
                c = prev_not_empty(json, i-1)
                if pairs.get(c) != json[i]:
                    formated += '\n' + ' ' * indent_lv * indent
                formated += json[i]
                if indent_lv == 0:
                    c = next_not_empty(json, i+1)
                    if c == '{' or c == '[':
                        formated += '\n'
            elif json[i] == ',':
                formated += ',\n' + ' ' * indent_lv * indent
            elif json[i] == ':':
                formated += ': '
            elif json[i] != ' ' and json[i] != '\n':
                formated += json[i]
        else:
            formated += json[i]

    return formated


try:
    input = sys.stdin.read().strip()
    print(format_json(input, 4))
except Exception as e:
    print(e)
