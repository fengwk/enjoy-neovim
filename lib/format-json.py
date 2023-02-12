# 这个脚本读取标准输入流中的json串并将将其格式化
# 如果发生异常将原样输出标准输入流中的json串
import json,sys
from collections import OrderedDict

input = ""
try:
  input = sys.stdin.read().strip()
  json_obj = json.loads(input, object_pairs_hook=OrderedDict)
  formatted = json.dumps(json_obj, ensure_ascii=False, indent=2)
  print(formatted)
except Exception as e:
  print(input)