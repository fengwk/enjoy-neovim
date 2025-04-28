import json
import sys


def compress_json(formatted_json):
    # 解析格式化JSON为Python对象
    parsed_data = json.loads(formatted_json)

    # 将数据转换回JSON，压缩为单行并处理转义
    # 使用separators参数去除多余空格
    compressed = json.dumps(
        parsed_data,
        ensure_ascii=False,
        separators=(',', ':'),
        indent=None
    )
    return compressed


if __name__ == '__main__':
    input = sys.stdin.read().strip()
    try:
        print(compress_json(input))
    except Exception:
        # 如果json格式错误则不处理
        print(input)
