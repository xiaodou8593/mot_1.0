import os
import re
import sys
import time

# 模块文件夹预设
current_dir = os.getcwd().split('\\')
# 搜索模块的命名空间和路径
anchor_found = False
sub_folders = []
for folder in current_dir[::-1]:
    
    # 找到functions/function文件夹停止
    if folder in ('functions', 'function'):
        anchor_found = True
        continue
    
    # functions以外文件夹的处理
    if anchor_found:
        namespace = folder
        break
    else:
        sub_folders.insert(0, folder)
if not anchor_found:
    print("路径不满足要求！")
    time.sleep(5)
    raise ValueError('path error')
# 生成函数前缀
prefix = f'{namespace}:' + '/'.join(sub_folders)
if sub_folders:
    prefix += '/'
print(f'\n已生成函数前缀: {prefix}\n')
module_name = namespace
if sub_folders:
    module_name = sub_folders[-1]

# 定义空白符
space_chars = {' ', '\n', '\t', '\r'}
# 定义标识符
identifier_chars = set()
identifier_chars |= {'a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z'}
identifier_chars |= {'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z'}
identifier_chars |= {'0','1','2','3','4','5','6','7','8','9'}
identifier_chars |= {'-','_','#','$','%','/','\\','+','*','@','&','?','!','[',']', '\'', '"'}

# 文档全局变量
doc = None
doc_index = 0
doc_line = 1
doc_path = 'doc.mcfo'
# 读入文档
def doc_read():
    global doc, doc_index, doc_line, doc_path
    with open(doc_path,'r',encoding='utf-8') as file:
        doc = file.read()
    doc_index = 0
    doc_line = 1
    MCFObject.object_cre = True
# 模拟文档
def doc_simulate(doc_str):
    global doc, doc_index, doc_line, doc_path
    doc_path = None
    doc = doc_str
    doc_index = 0
    doc_line = 1
    MCFObject.object_cre = True
# 一瞥文档
def doc_glance():
    global doc, doc_index
    if doc_index > len(doc):
        return None
    return doc[doc_index]
# 一瞥文档(忽略空白符)
def doc_glancel():
    while True:
        char = doc_glance()
        if char is None:
            return None
        if char not in space_chars:
            return char
        doc_scan()
# 扫描文档
def doc_scan():
    global doc, doc_index, doc_line
    if doc_index >= len(doc):
        return None
    if doc[doc_index] == '\n':
        doc_line += 1
    doc_index += 1
    return doc[doc_index-1]
# 扫描文档(忽略空白符)
def doc_scanl():
    while True:
        char = doc_scan()
        if char is None:
            return None
        if char not in space_chars:
            return char
# 文档扫描回退
def doc_backspace():
    global doc, doc_index, doc_line
    doc_index -= 1
    if doc[doc_index] == '\n':
        doc_line -= 1
    if doc_index >= 0:
        return True
    else:
        doc_index = 0
        return False
# 文档错误输出
def doc_error():
    global doc, doc_index, doc_line, doc_path
    print("\n对象格式错误！请重新解析")
    start_index = doc_index - 30
    if start_index < 0: start_index = 0
    error_segment = doc[start_index:doc_index]
    error_line = doc_line
    if '\n' in error_segment:
        error_line -= 1
    print(f'compose stack: {MCFObject.relative_path}')
    error = f'{doc_path}第{error_line}行: ' + error_segment
    print(error)
    print('\n')
# 解析文档
def doc_interpret():
    global space_chars, dic_objects, lst_objects, cnt_objects
    rec_word = ''
    cnt_code_sep = 0
    code_sep = False
    while True:
        char = doc_scan()
        if char is None:
            break
        # 记录代码分割区域
        if char == '`':
            cnt_code_sep += 1
            if cnt_code_sep == 3:
                cnt_code_sep = 0
                code_sep = not code_sep
        if code_sep:
            rec_word = ''
            continue
        # 跳过空白符
        if char in space_chars:
            rec_word = ''
        # 遇到冒号创建对象
        elif char == ':':
            obj = MCFObject(rec_word)
            # 替换已有对象
            if obj.name in dic_objects:
                dic_objects[obj.name] = obj
            # 全局列表增加新对象
            else:
                dic_objects[obj.name] = obj
                lst_objects.append(obj.name)
                cnt_objects += 1
            rec_word = ''
        # 创建匿名对象
        elif char in ('{', '[', '<'):
            doc_backspace()
            rec_word = None
            obj = MCFObject(rec_word)
            dic_objects[obj.name] = obj
            lst_objects.append(obj.name)
            cnt_objects += 1
            rec_word = ''
        # 读取名称
        elif char in identifier_chars:
            rec_word += char
        else:
            rec_word = ''
        # 遇到对象创建失败的情况
        if not MCFObject.object_cre:
            break
    if not MCFObject.object_cre:
        doc_error()

# 支持的NBT类型
data_type_supported = set()
data_type_supported |= {'ListByte', 'ListShort', 'ListInt', 'ListLong'}
data_type_supported |= {'ListFloat', 'ListDouble', 'ListString'}
data_type_supported |= {'ListList', 'ListCompound', 'ListVoid'}
data_type_supported |= {'Compound', 'String', 'Double', 'Float'}
data_type_supported |= {'Byte', 'Short', 'Int', 'Long', 'Void'}
# 列表支持的初始值
init_elms = {}
init_elms |= {'ListByte':'0b', 'ListShort':'0s', 'ListInt':'0', 'ListLong':'0l'}
init_elms |= {'ListFloat':'0.0f', 'ListDouble':'0.0d', 'ListString':'""'}
init_elms |= {'ListList':'[]', 'ListCompound':'{}'}
# 决定列表是否展平
lst_flatten = {'$assign'}
# 类型映射
type_table = {'Byte':'byte', 'Short':'short', 'Int': 'int', 'Long':'long', 'Float':'float', 'Double':'double', 'Void':'int', 'String':'int', 'ListVoid':'int', 'Compound':'int'}
# 普通元素的初始值
init_elem = {}
init_elem |= {'Byte':'0b', 'Short':'0s', 'Int':'0', 'Long':'0l'}
init_elem |= {'Float':'0.0f', 'Double':'0.0d', 'String':'""'}
init_elem |= {'ListVoid':'[]', 'Compound':'{}', 'Void':'0b'}

# 全局临时对象表
dic_objects = {}
lst_objects = []
cnt_objects = 0
# 临时对象类
class MCFObject:
    relative_path = []
    object_cnt = 0
    object_cre = True
    def __init__(self, name, char=None):
        self.dic_objects = {}
        self.lst_objects = []
        self.cnt_objects = 0
        MCFObject.object_cnt += 1
        if name is None:
            self.name = f'MCFObject_{MCFObject.object_cnt}'
        else:
            self.name = name
        if char is None:
            char = doc_scanl()
        # 读到文件末尾则对象格式错误
        if char is None:
            MCFObject.object_cre = False
        # 判断对象的类型，调用对应的初始化函数
        if char == '<':
            self.init_score()
        elif char == '[':
            self.init_nbt()
        elif char == '{':
            self.init_compose()
        elif char in identifier_chars:
            ex_chars = set()
            if char in ('\'', '"'):
                ex_chars.add(':')
            if not MCFObject.relative_path:
                ex_chars.add('.')
            self.init_word(char, ex_chars=ex_chars)
        elif char == '.':
            self.init_compose_dot()
        else:
            MCFObject.object_cre = False
    
    def __eq__(self, other):
        if self.type != other.type:
            return False
        if self.type == 'compose':
            return False
        if other.type == 'compose':
            return False
        return self.segment == other.segment
    
    def __str__(self):
        if self.type == 'score':
            return self.str_score()
        elif self.type == 'nbt':
            return self.str_nbt()
        elif self.type == 'compose':
            return self.str_compose()
        else:
            return self.str_word()

    def json(self):
        if self.type == 'score':
            return self.json_score()
        elif self.type == 'nbt':
            return self.json_nbt()
        elif self.type == 'compose':
            return self.json_compose()
        else:
            return self.json_word()
    
    def gen_code(self, env=None):
        if self.type == 'score':
            return self.code_score(env)
        elif self.type == 'nbt':
            return self.code_nbt(env)
        elif self.type == 'compose':
            return self.code_compose(env)
        else:
            return self.code_word(env)
    
    def add_object(self, obj):
        if obj.name in self.dic_objects:
            self.dic_objects[obj.name] = obj
        else:
            self.lst_objects.append(obj.name)
            self.dic_objects[obj.name] = obj
            self.cnt_objects += 1
    def pop_object(self, name):
        if name in self.dic_objects:
            self.lst_objects.remove(name)
            self.cnt_objects -= 1
            return self.dic_objects.pop(name)
        return None
    
    def init_score(self):
        self.type = 'score'
        segment = ''
        while True:
            char = doc_scanl()
            # 读到文件末尾则对象格式错误
            if char is None:
                MCFObject.object_cre = False
                break
            # 结束符号
            if char == '>':
                break
            # 拼接片段
            segment += char
        # score的参数
        score_args = segment.split(',')
        if len(score_args)==0:
            MCFObject.object_cre = False
            return
        # 读取玩家名
        self.player = score_args[0]
        # 读取记分板名
        if len(score_args)>=2:
            self.objective = score_args[1]
        else:
            self.objective = 'int'
        # 读取倍率
        if len(score_args)>=3:
            scale = score_args[2].replace('k', '000')
            scale = scale.replace('w', '0000')
            try:
                scale = int(scale)
                self.scale = scale
            except:
                MCFObject.object_cre = False
                return
        else:
            self.scale = 1
        segment = f'{self.player},{self.objective},{self.scale}'
        self.segment = segment
    def str_score(self):
        return f'(score) {self.name}: <{self.segment}>'
    def json_score(self):
        res = '{"score":{"name":"$(1)", "objective":"$(2)"}}'
        res = res.replace('$(1)', f'{self.player}')
        res = res.replace('$(2)', f'{self.objective}')
        return res
    def code_score(self, env):
        if env is None:
            return f'{self.player} {self.objective}'
        if env == 'print':
            return self.json()
        if env == 'init':
            return f'{self.player} {self.objective}'
        if env == 'create':
            return f'{self.objective}'
    
    def init_nbt(self):
        self.type = "nbt"
        segment = ''
        cnt_left = 1
        while True:
            char = doc_scan()
            # 读到文件末尾则对象格式错误
            if char is None:
                MCFObject.object_cre = False
                break
            # 结束符号
            if char == '[':
                cnt_left += 1
            elif char == ']':
                cnt_left -= 1
                if cnt_left == 0:
                    break
            # 拼接片段
            segment += char
        # 读取nbt参数
        nbt_args = segment.split(',')
        if len(nbt_args) == 0:
            MCFObject.object_cre = False
            return
        # 读取nbt路径
        self.path = nbt_args[0].strip()
        # 相对nbt的机制设计
        self.relative = False
        if self.path.startswith('~'):
            pre_part = ''
            if len(MCFObject.relative_path)>1:
                pre_part = '.'.join(MCFObject.relative_path[1:])+'.'
            parts = self.path.split(' ')
            last_part = parts.pop()
            self.path = ' '.join(parts)[1:] + ' ' + pre_part + last_part
        # 读取nbt数据类型
        if len(nbt_args) >= 2:
            data_type = nbt_args[1]
            data_type = ''.join([char for char in data_type if char not in space_chars])
            self.data_type = data_type
        else:
            self.data_type = 'Void'
        segment = f'{self.path},{self.data_type}'
        # TODO: 初始值的NBT解析问题（暂时把参数换成n解决，只能初始化列表）
        self.init_value = None
        self.init_num = 0
        if self.data_type in init_elms:
            self.init_value = '[]'
        # 列表类型的初始值
        if len(nbt_args) >= 3 and self.data_type in init_elms:
            try:
                init_num = int(nbt_args[2])
                self.init_num = init_num
                init_value = '['
                if init_num > 0:
                    init_value += init_elms[self.data_type]
                i = 1
                while i < init_num:
                    init_value += ', '
                    init_value += init_elms[self.data_type]
                    i += 1
                init_value += ']'
                self.init_value = init_value
                segment = f'{self.path},{self.data_type},{self.init_num}'
            except:
                pass
        # 其它类型的初始值
        elif self.data_type in init_elem:
            self.init_value = init_elem[self.data_type]
        self.segment = segment
    def str_nbt(self):
        return f'(nbt) {self.name}: [{self.segment}]'
    def json_nbt(self):
        res = '{"nbt":"$(1)", "$(2)":"$(3)"}'
        store = self.path.split(' ')
        store_type = store.pop(0)
        path = store.pop()
        store = ' '.join(store)
        res = res.replace('$(1)', f'{path}')
        res = res.replace('$(2)', f'{store_type}')
        res = res.replace('$(3)', f'{store}')
        return res
    def code_nbt(self, env):
        if env is None:
            return self.path
        if env == 'print':
            return self.json()
        if env == 'init':
            return f'{self.path} set value {self.init_value}'
        if env == 'create':
            return f'{self.path} set value {self.init_value}'
    def prefix_and_surfix_path(self):
        temp_lst = self.path.split(' ')
        res = ' '.join(temp_lst[0:-1])
        temp_lst = temp_lst[-1].split('.')
        res = res + ' ' + temp_lst[0]
        return res, '.'.join(temp_lst[1:])

    def init_compose_dot(self):
        self.type = "compose"
        MCFObject.relative_path.append(self.name)
        obj = MCFObject(None)
        if not MCFObject.object_cre:
            return
        if obj.type == "word":
            rec_word = obj.segment
            char = doc_scan()
            if char == '.':
                obj = MCFObject(rec_word, char='.')
                self.add_object(obj)
            elif char == ':':
                obj = MCFObject(rec_word)
                self.add_object(obj)
            else:
                MCFObject.object_cre = False
        else:
            MCFObject.object_cre = False
        if MCFObject.object_cre:
            MCFObject.relative_path.pop()
    def init_compose(self):
        self.type = "compose"
        rec_word = None
        MCFObject.relative_path.append(self.name)
        while True:
            if doc_glancel() == '}':
                doc_scanl()
                break
            obj = MCFObject(rec_word)
            # 遇到对象创建失败的情况
            if not MCFObject.object_cre:
                break
            char = doc_scanl()
            # 读到文件末尾则对象格式错误
            if char is None:
                MCFObject.object_cre = False
                break
            if char == ':':
                if obj.type == 'word':
                    rec_word = obj.segment
                else:
                    MCFObject.object_cre = False
                    break
            # compose语法糖
            elif char == '.':
                if obj.type == 'word':
                    rec_word = obj.segment
                    obj = MCFObject(rec_word, char='.')
                    self.add_object(obj)
                    rec_word = None
                    char = doc_scanl()
                    if char == ',':
                        continue
                    elif char == '}':
                        break
                    else:
                        MCFObject.object_cre = False
                        break
                else:
                    MCFObject.object_cre = False
                    break
            else:
                self.add_object(obj)
                rec_word = None
                # 遇到逗号继续读取对象
                if char == ',':
                    continue
                # 遇到右括号结束读取
                elif char == '}':
                    break
                else:
                    MCFObject.object_cre = False
                    break
        if MCFObject.object_cre:
            MCFObject.relative_path.pop()
    def str_compose(self):
        # 开头字符串
        string_form = f'(compose) {self.name}: ' + '{'
        # 第一个子对象字符串
        if self.cnt_objects>0:
            obj = self.lst_objects[0]
            obj = self.dic_objects[obj]
            string_row = '\n\t' + obj.__str__().replace('\n', '\n\t')
            string_form += string_row
        # 剩余子对象字符串
        i = 1
        while i<self.cnt_objects:
            obj = self.lst_objects[i]
            obj = self.dic_objects[obj]
            string_row = ',\n\t' + obj.__str__().replace('\n', '\n\t')
            string_form += string_row
            i += 1
        if self.cnt_objects>0:
            string_form += '\n'
        string_form += '}'
        return string_form
    def json_compose(self):
        pass
    def code_compose(self, env):
        return ''
    def flatten(self):
        # 普通元素返回自身的列表
        if self.type != "compose":
            return [self]
        # 复合对象的展平
        flatten_pool = []
        for obj_name in self.lst_objects:
            sub_obj = self.dic_objects[obj_name]
            flatten_pool += sub_obj.flatten()
        return flatten_pool
    def flatten_lst(self):
        # 特殊情况下需要展平列表
        temp_lst = []
        data_type = self.data_type[4:]
        relative = False
        for i in range(self.init_num):
            path = f'{self.path}[{i}]'
            name = f'{self.name}_{i}'
            segment = f'{path},{data_type}'
            obj = new_object({'type':'nbt', 'name':name, 'data_type':data_type, 'path':path, 'segment':segment, 'relative':relative})
            temp_lst.append(obj)
        return temp_lst

    def init_word(self, start_char, ex_chars = None):
        char_set = identifier_chars.copy()
        if ex_chars:
            char_set |= ex_chars
        self.type = "word"
        segment = start_char
        while True:
            char = doc_scan()
            # 读到非标识符结束，并回退指针
            if char not in char_set:
                doc_backspace()
                break
            if char in ('\'', '"'):
                if ':' in char_set:
                    char_set.remove(':')
                else:
                    char_set.add(':')
            # 添加标识符
            segment += char
        self.segment = segment
    def str_word(self):
        return f'(word) {self.name}: {self.segment}'
    def json_word(self):
        return f'"{self.segment}"'
    def code_word(self, env):
        if env == 'print':
            return self.json()
        return self.segment
# 获取自定义初始化的MCFObject
def new_object(dic):
    obj = MCFObject.__new__(MCFObject)
    obj.lst_objects = []
    obj.dic_objects = {}
    obj.cnt_objects = 0
    for key in dic:
        setattr(obj, key, dic[key])
    return obj
# 添加MCFObject到全局
def add_object(obj):
    global lst_objects, dic_objects, cnt_objects
    if obj.name in lst_objects:
        dic_objects[obj.name] = obj
    else:
        lst_objects.append(obj.name)
        dic_objects[obj.name] = obj
        cnt_objects += 1
# 移除MCFObject
def pop_object(name):
    global lst_objects, dic_objects, cnt_objects
    if name in dic_objects:
        lst_objects.remove(name)
        cnt_objects -= 1
        return dic_objects.pop(name)
    return None
# 清空全局对象
def clear_objects():
    global dic_objects, lst_objects, cnt_objects
    dic_objects = {}
    lst_objects = []
    cnt_objects = 0
    MCFObject.object_cnt = 0
    MCFObject.object_cre = True
# 检查compose是不是一个向量
def is_vec_compose(compose:MCFObject):
    for obj_name in compose.lst_objects:
        obj:MCFObject = compose.dic_objects[obj_name]
        if obj.type != 'score':
            return False
    return True
# 普通compose数据模板转换
def plate_compose(compose:MCFObject, name='_input_plate', nbt_path='input', project_name='_'):
    temp_lst = [compose.dic_objects[obj_name] for obj_name in compose.lst_objects]
    lst_objects = []
    dic_objects = {}
    cnt_objects = 0
    while temp_lst:
        obj:MCFObject = temp_lst.pop(0)
        # 添加普通元素
        if obj.type == 'score':
            data_type = 'Int'
            path = f'storage {project_name}:io {nbt_path}.{obj.player}'
            segment = f'{path},{data_type}'
            input_dic = {'name':obj.name, 'type':'nbt', 'relative':False}
            input_dic |= {'data_type':'Int', 'init_value':'0'}
            input_dic |= {'segment':segment, 'path':path, 'init_num':0}
            input_dic |= {'lst_objects':[], 'dic_objects':{},'cnt_objects':0}
            sub_obj:MCFObject = new_object(input_dic)
            if sub_obj.name in dic_objects:
                dic_objects[sub_obj.name] = sub_obj
            else:
                lst_objects.append(sub_obj.name)
                dic_objects[sub_obj.name] = sub_obj
                cnt_objects += 1
            continue
        if obj.type == 'nbt':
            pre_path = obj.path.split(' ')[-1]
            data_type = obj.data_type
            init_value = obj.init_value
            init_num = obj.init_num
            path = f'storage {project_name}:io {nbt_path}.{pre_path}'
            segment = f'{path},{data_type}'
            input_dic = {'name':obj.name, 'type':'nbt', 'relative':False}
            input_dic |= {'data_type':data_type, 'init_value':init_value}
            input_dic |= {'segment':segment, 'path':path, 'init_num':init_num}
            input_dic |= {'lst_objects':[], 'dic_objects':{},'cnt_objects':0}
            sub_obj:MCFObject = new_object(input_dic)
            if sub_obj.name in dic_objects:
                dic_objects[sub_obj.name] = sub_obj
            else:
                lst_objects.append(sub_obj.name)
                dic_objects[sub_obj.name] = sub_obj
                cnt_objects += 1
            continue
        if obj.type == 'word':
            sub_obj = obj
            if sub_obj.name in dic_objects:
                dic_objects[sub_obj.name] = sub_obj
            else:
                lst_objects.append(sub_obj.name)
                dic_objects[sub_obj.name] = sub_obj
                cnt_objects += 1
            continue
        # 向量compose的处理
        if is_vec_compose(obj):
            init_num = obj.cnt_objects
            init_value = '['
            if init_num > 0:
                init_value += init_elms['ListDouble']
            i = 1
            while i < init_num:
                init_value += ', '
                init_value += init_elms['ListDouble']
                i += 1
            init_value += ']'
            data_type = 'ListDouble'
            if init_num == 2 or init_num == 4:
                data_type = 'ListFloat'
            path = f'storage {project_name}:io {nbt_path}.{obj.name}'
            segment = f'{path},{data_type},{init_num}'
            input_dic = {'name':obj.name, 'type':'nbt', 'relative':False}
            input_dic |= {'data_type':'ListDouble', 'init_value':init_value, 'init_num':init_num}
            input_dic |= {'segment':segment, 'path':path}
            input_dic |= {'lst_objects':[], 'dic_objects':{},'cnt_objects':0}
            sub_obj:MCFObject = new_object(input_dic)
            if sub_obj.name in dic_objects:
                dic_objects[sub_obj.name] = sub_obj
            else:
                lst_objects.append(sub_obj.name)
                dic_objects[sub_obj.name] = sub_obj
                cnt_objects += 1
        # 普通compose的处理
        else:
            sub_obj = plate_compose(obj, name=obj.name, nbt_path=nbt_path, project_name=project_name)
            if sub_obj.name in dic_objects:
                dic_objects[sub_obj.name] = sub_obj
            else:
                lst_objects.append(sub_obj.name)
                dic_objects[sub_obj.name] = sub_obj
                cnt_objects += 1
    input_dic = {'name':name, 'type':'compose'}
    input_dic |= {'lst_objects':lst_objects, 'dic_objects':dic_objects,'cnt_objects':cnt_objects}
    new_obj = new_object(input_dic)
    return new_obj
# 转化为数据模板
def compose_to_plate(compose:MCFObject, name='_input_plate', nbt_path='input', project_name='_'):
    temp_lst = [compose.dic_objects[obj_name] for obj_name in compose.lst_objects]
    lst_objects = []
    dic_objects = {}
    cnt_objects = 0
    while temp_lst:
        obj:MCFObject = temp_lst.pop(0)
        # 添加普通元素
        if obj.type == 'score':
            data_type = 'Int'
            path = f'storage {project_name}:io {nbt_path}.{obj.player}'
            segment = f'{path},{data_type}'
            input_dic = {'name':obj.name, 'type':'nbt', 'relative':False}
            input_dic |= {'data_type':'Int', 'init_value':'0'}
            input_dic |= {'segment':segment, 'path':path, 'init_num':0}
            input_dic |= {'lst_objects':[], 'dic_objects':{},'cnt_objects':0}
            sub_obj:MCFObject = new_object(input_dic)
            if sub_obj.name in dic_objects:
                dic_objects[sub_obj.name] = sub_obj
            else:
                lst_objects.append(sub_obj.name)
                dic_objects[sub_obj.name] = sub_obj
                cnt_objects += 1
            continue
        if obj.type == 'nbt':
            pre_path = obj.path.split(' ')[-1]
            data_type = obj.data_type
            init_value = obj.init_value
            init_num = obj.init_num
            path = f'storage {project_name}:io {nbt_path}.{pre_path}'
            segment = f'{path},{data_type}'
            input_dic = {'name':obj.name, 'type':'nbt', 'relative':False}
            input_dic |= {'data_type':data_type, 'init_value':init_value}
            input_dic |= {'segment':segment, 'path':path, 'init_num':init_num}
            input_dic |= {'lst_objects':[], 'dic_objects':{},'cnt_objects':0}
            sub_obj:MCFObject = new_object(input_dic)
            if sub_obj.name in dic_objects:
                dic_objects[sub_obj.name] = sub_obj
            else:
                lst_objects.append(sub_obj.name)
                dic_objects[sub_obj.name] = sub_obj
                cnt_objects += 1
            continue
        if obj.type == 'word':
            sub_obj = obj
            if sub_obj.name in dic_objects:
                dic_objects[sub_obj.name] = sub_obj
            else:
                lst_objects.append(sub_obj.name)
                dic_objects[sub_obj.name] = sub_obj
                cnt_objects += 1
            continue
        # 向量compose的处理
        if is_vec_compose(obj):
            init_num = obj.cnt_objects
            init_value = '['
            if init_num > 0:
                init_value += init_elms['ListDouble']
            i = 1
            while i < init_num:
                init_value += ', '
                init_value += init_elms['ListDouble']
                i += 1
            init_value += ']'
            data_type = 'ListDouble'
            if init_num == 2 or init_num == 4:
                data_type = 'ListFloat'
            path = f'storage {project_name}:io {nbt_path}.{obj.name}'
            segment = f'{path},{data_type},{init_num}'
            input_dic = {'name':obj.name, 'type':'nbt', 'relative':False}
            input_dic |= {'data_type':'ListDouble', 'init_value':init_value, 'init_num':init_num}
            input_dic |= {'segment':segment, 'path':path}
            input_dic |= {'lst_objects':[], 'dic_objects':{},'cnt_objects':0}
            sub_obj:MCFObject = new_object(input_dic)
            if sub_obj.name in dic_objects:
                dic_objects[sub_obj.name] = sub_obj
            else:
                lst_objects.append(sub_obj.name)
                dic_objects[sub_obj.name] = sub_obj
                cnt_objects += 1
        # 普通compose的处理
        else:
            #temp_lst = [temp_obj for temp_name,temp_obj in obj.dic_objects.items()] + temp_lst
            sub_obj = plate_compose(obj, name=obj.name, nbt_path=nbt_path, project_name=project_name)
            if sub_obj.name in dic_objects:
                dic_objects[sub_obj.name] = sub_obj
            else:
                lst_objects.append(sub_obj.name)
                dic_objects[sub_obj.name] = sub_obj
                cnt_objects += 1
    input_dic = {'name':name, 'type':'compose'}
    input_dic |= {'lst_objects':lst_objects, 'dic_objects':dic_objects,'cnt_objects':cnt_objects}
    new_obj = new_object(input_dic)
    add_object(new_obj)
# 普通compose实体转换
def entity_compose(compose:MCFObject, name='_entity', entity_store_path='data'):
    temp_lst = [compose.dic_objects[obj_name] for obj_name in compose.lst_objects]
    lst_objects = []
    dic_objects = {}
    cnt_objects = 0
    while temp_lst:
        obj:MCFObject = temp_lst.pop(0)
        # 添加普通元素
        if obj.type == 'score':
            player = obj.player
            scale = obj.scale
            segment = f'@s,{player},{scale}'
            input_dic = {'name':obj.name, 'type':'score', 'scale':scale}
            input_dic |= {'player':'@s', 'objective':player,'segment':segment}
            input_dic |= {'lst_objects':[], 'dic_objects':{},'cnt_objects':0}
            sub_obj:MCFObject = new_object(input_dic)
            if sub_obj.name in dic_objects:
                dic_objects[sub_obj.name] = sub_obj
            else:
                lst_objects.append(sub_obj.name)
                dic_objects[sub_obj.name] = sub_obj
                cnt_objects += 1
            continue
        if obj.type == 'nbt':
            pre_path = obj.path.split(' ')[-1]
            data_type = obj.data_type
            init_value = obj.init_value
            init_num = obj.init_num
            path = f'entity @s {entity_store_path}.{pre_path}'
            segment = f'{path},{data_type}'
            input_dic = {'name':obj.name, 'type':'nbt', 'relative':False}
            input_dic |= {'data_type':data_type, 'init_value':init_value}
            input_dic |= {'segment':segment, 'path':path, 'init_num':init_num}
            input_dic |= {'lst_objects':[], 'dic_objects':{},'cnt_objects':0}
            sub_obj:MCFObject = new_object(input_dic)
            if sub_obj.name in dic_objects:
                dic_objects[sub_obj.name] = sub_obj
            else:
                lst_objects.append(sub_obj.name)
                dic_objects[sub_obj.name] = sub_obj
                cnt_objects += 1
            continue
        if obj.type == 'word':
            sub_obj = obj
            if sub_obj.name in dic_objects:
                dic_objects[sub_obj.name] = sub_obj
            else:
                lst_objects.append(sub_obj.name)
                dic_objects[sub_obj.name] = sub_obj
                cnt_objects += 1
            continue
        sub_obj = entity_compose(obj, name=obj.name, entity_store_path=entity_store_path)
        if sub_obj.name in dic_objects:
            dic_objects[sub_obj.name] = sub_obj
        else:
            lst_objects.append(sub_obj.name)
            dic_objects[sub_obj.name] = sub_obj
            cnt_objects += 1
    input_dic = {'name':name, 'type':'compose'}
    input_dic |= {'lst_objects':lst_objects, 'dic_objects':dic_objects,'cnt_objects':cnt_objects}
    new_obj = new_object(input_dic)
    return new_obj
# 转化为实体对象
def compose_to_entity(compose:MCFObject, name='_entity', entity_store_path='data'):
    temp_lst = [compose.dic_objects[obj_name] for obj_name in compose.lst_objects]
    lst_objects = []
    dic_objects = {}
    cnt_objects = 0
    while temp_lst:
        obj:MCFObject = temp_lst.pop(0)
        # 添加普通元素
        if obj.type == 'score':
            player = obj.player
            scale = obj.scale
            segment = f'@s,{player},{scale}'
            input_dic = {'name':obj.name, 'type':'score', 'scale':scale}
            input_dic |= {'player':'@s', 'objective':player,'segment':segment}
            input_dic |= {'lst_objects':[], 'dic_objects':{},'cnt_objects':0}
            sub_obj:MCFObject = new_object(input_dic)
            if sub_obj.name in dic_objects:
                dic_objects[sub_obj.name] = sub_obj
            else:
                lst_objects.append(sub_obj.name)
                dic_objects[sub_obj.name] = sub_obj
                cnt_objects += 1
            continue
        if obj.type == 'nbt':
            pre_path = obj.path.split(' ')[-1]
            data_type = obj.data_type
            init_value = obj.init_value
            init_num = obj.init_num
            path = f'entity @s {entity_store_path}.{pre_path}'
            segment = f'{path},{data_type}'
            input_dic = {'name':obj.name, 'type':'nbt', 'relative':False}
            input_dic |= {'data_type':data_type, 'init_value':init_value}
            input_dic |= {'segment':segment, 'path':path, 'init_num':init_num}
            input_dic |= {'lst_objects':[], 'dic_objects':{},'cnt_objects':0}
            sub_obj:MCFObject = new_object(input_dic)
            if sub_obj.name in dic_objects:
                dic_objects[sub_obj.name] = sub_obj
            else:
                lst_objects.append(sub_obj.name)
                dic_objects[sub_obj.name] = sub_obj
                cnt_objects += 1
            continue
        if obj.type == 'word':
            sub_obj = obj
            if sub_obj.name in dic_objects:
                dic_objects[sub_obj.name] = sub_obj
            else:
                lst_objects.append(sub_obj.name)
                dic_objects[sub_obj.name] = sub_obj
                cnt_objects += 1
            continue
        #temp_lst = obj.flatten() + temp_lst
        sub_obj = entity_compose(obj, name=obj.name, entity_store_path=entity_store_path)
        if sub_obj.name in dic_objects:
            dic_objects[sub_obj.name] = sub_obj
        else:
            lst_objects.append(sub_obj.name)
            dic_objects[sub_obj.name] = sub_obj
            cnt_objects += 1
    input_dic = {'name':name, 'type':'compose'}
    input_dic |= {'lst_objects':lst_objects, 'dic_objects':dic_objects,'cnt_objects':cnt_objects}
    new_obj = new_object(input_dic)
    add_object(new_obj)
# 输出对象
def print_objects():
    for obj_name in user_input[1:]:
        if obj_name in lst_objects:
            print(dic_objects[obj_name])
# 按索引输出对象
def print_index_object():
    try:
        index = int(user_input[1])
        obj_name = lst_objects[index-1]
        obj = dic_objects[obj_name]
        print(obj)
    except:
        return
# 输出全局对象名字
def print_object_names():
    print('\n---list objects---')
    index = 1
    for obj_name in lst_objects:
        print(f'{index}.'+obj_name)
        index += 1
    print('---')

# flatten的全nbt的lst转换NBT
def lst_to_nbtvalue(lst):
    prefix_paths = {}
    obj:MCFObject
    SEPERATOR = ', '
    COMMA = ':'
    # 递归解析字典生成复合标签
    def del_quotes(d):
        if not isinstance(d, dict):
            return d
        return '{' + SEPERATOR.join([f'{k}{COMMA}{del_quotes(v)}' for k,v in d.items()]) + '}'
    # 记录有哪些不同的前缀路径
    lst_nbt = []
    for obj in lst:
        prefix_path, surfix_path = obj.prefix_and_surfix_path()
        if prefix_path not in prefix_paths:
            prefix_paths[prefix_path] = []
            prefix_paths[prefix_path].append((surfix_path,obj))
        else:
            prefix_paths[prefix_path].append((surfix_path,obj))
    keys = [key for key in prefix_paths]
    for prefix_path in keys:
        # 路径压缩
        surfix_paths = prefix_paths.pop(prefix_path)
        # 单值提前返回
        if len(surfix_paths) == 1:
            lst_nbt.append(surfix_paths[0][1])
            continue
        split_surfix_paths = [surfix_path.split('.') for surfix_path,obj in surfix_paths]
        rec_objs = [obj for _,obj in surfix_paths]
        # 寻找公共前缀
        min_len = min([len(temp_lst) for temp_lst in split_surfix_paths])
        cnt_lst = len(split_surfix_paths)
        prefix_upd = []
        for j in range(min_len):
            is_prefix = True
            for i in range(1, cnt_lst):
                if split_surfix_paths[i][j] != split_surfix_paths[0][j]:
                    is_prefix = False
            if not is_prefix:
                break
            else:
                prefix_upd.append(split_surfix_paths[0][j])
        # 更新后缀路径列表
        j = len(prefix_upd)
        surfix_paths = ['.'.join(temp_lst[j:]) for temp_lst in split_surfix_paths]
        prefix_upd = '.'.join(prefix_upd)
        if prefix_upd:
            prefix_path = prefix_path+'.'+prefix_upd
        # 路径合并
        res = {}
        for k,v in zip(surfix_paths, [obj.init_value for obj in rec_objs]):
            parts = k.split('.')
            last_part = parts.pop()
            layer = res
            for part in parts:
                part_value = layer.get(part, {})
                if not isinstance(part_value, dict):
                    part_value = {}
                layer[part] = part_value
                layer = layer[part]
            layer[last_part] = v
        init_value = del_quotes(res)
        data_type = 'Compound'
        path = prefix_path
        segment = f'{path},{data_type}'
        input_dict = {}
        input_dict |= {'type':'nbt', 'init_value':init_value, 'init_num':0}
        input_dict |= {'path':path, 'relative':False, 'data_type':data_type}
        input_dict |= {'segment':segment, 'dict_inited':True}
        lst_nbt.append(new_object(input_dict))
    return lst_nbt

# 提取路径捕获组
def match_pattern(lst_patterns, test_string):
    global template_name
    # 将集合中的模式转换为正则表达式
    def pattern_to_regex(pattern):
        # 将 (name) 这样的参数替换为命名捕获组 (?P<name>[\w]+)
        regex = re.sub(r'\((\w+)\)', lambda m: f'(?P<{m.group(1)}>[\\w]+)', pattern)
        # 将其他特殊字符转义
        regex = regex.replace('/', '\/').replace('.', '\.')
        return f'^{regex}$'
    # 遍历所有模式
    for pattern in lst_patterns:
        # 转换为正则表达式
        regex_pattern = pattern_to_regex(pattern)
        # 尝试匹配
        match = re.match(regex_pattern, test_string)
        if match:
            # 如果匹配成功，返回捕获的参数
            template_name = pattern
            return match.groupdict()
    return None


# 模板全局变量
template_name = '_get'
function_name = '_get'
template_line = 0
# 模板生成错误
def gen_error():
    global template_name
    print('\n')
    print('模板生成错误！请重新同步代码')
    error = f'.mot_memory/templates/{template_name}.mcfi第{template_line}行: '
    print(error)
    print('\n')
# json添加项
def json_prepend(json_string:str, prepend_string:str):
    if json_string.startswith('['):
        res = '[' + prepend_string + ', ' + json_string[1:]
        return res
    res = '[' + prepend_string + ', ' + json_string + ']'
    return res
# json追加项
def json_append(json_string:str, append_string:str):
    if json_string.endswith(']'):
        res = json_string[0:-1] + ', ' + append_string + ']'
        return res
    res = '[' + json_string + ', ' + append_string + ']'
    return res
# tellraw内容
def tellraw_content(obj:MCFObject):
    res = []
    if obj.type != 'compose':
        res.append(obj.json())
        return res
    if is_vec_compose(obj):
        json = [obj.dic_objects[obj_name].json() for obj_name in obj.lst_objects]
        json = ', ", " ,'.join(json)
        json = '[' + '"[", ' + json + ', "]"' + ']'
        res.append(json)
        return res
    res.append('"{"')
    cnt_obj = 0
    for obj_name in obj.lst_objects:
        cnt_obj += 1
        sub_obj = obj.dic_objects[obj_name]
        sub_content = tellraw_content(sub_obj)
        if not obj_name.startswith('MCFObject_'):
            sub_content[0] = json_prepend(sub_content[0], f'"{obj_name}: "')
        for i in range(len(sub_content)):
            sub_content[i] = json_prepend(sub_content[i], '"    "')
        if cnt_obj != obj.cnt_objects:
            sub_content[-1] = json_append(sub_content[-1], '","')
        res += sub_content
    res.append('"}"')
    return res
# 模板宏生成动态命令
def macro_line(macro, args, cur_index, pre_args, cnt_lines):
    if macro == '$print':
        if len(args) < 1:
            return ''
        json_content = tellraw_content(args[0])
        obj_name = args[0].name
        if not obj_name.startswith('MCFObject_'):
            json_content[0] = json_prepend(json_content[0], f'"{obj_name}: "')
        return '\n'.join(['tellraw @a '+content for content in json_content])
    if macro == '$swap':
        if len(args) < 3:
            return ''
        # 需要时展平列表nbt
        if args[0].type == 'nbt' and args[0].data_type in init_elms and args[1].type == 'score':
            i = cur_index%len(pre_args[0])
            pre_args[0] = pre_args[0][0:i] + args[0].flatten_lst() + pre_args[0][i+1:]
            new_len = len(pre_args[0])
            if new_len > cnt_lines[0]:
                cnt_lines[0] = new_len
            if i < new_len:
                args[0] = pre_args[0][i]
            else:
                return ''
        # 需要时展平列表nbt
        if args[1].type == 'nbt' and args[1].data_type in init_elms and args[0].type == 'score':
            i = cur_index%len(pre_args[1])
            pre_args[1] = pre_args[1][0:i] + args[1].flatten_lst() + pre_args[1][i+1:]
            new_len = len(pre_args[1])
            if new_len > cnt_lines[0]:
                cnt_lines[0] = new_len
            if i < new_len:
                args[1] = pre_args[1][i]
            else:
                return ''
        if args[0].type == 'nbt' and args[1].type == 'nbt':
            return f'data modify storage $(3):io temp set from $(1)\ndata modify $(1) set from $(2)\ndata modify $(2) set from storage $(3):io temp'
        if args[0].type == 'score' and args[1].type == 'score':
            return f'scoreboard players operation $(1) >< $(2)'
        if args[0].type == 'nbt' and args[1].type == 'score':
            res =  f'execute store result $(1) {type_table[args[0].data_type]} '
            temp_res = '{:.15f}'.format(1/args[1].scale).rstrip('0')
            if temp_res.endswith('.'):
                temp_res = temp_res[0:-1]
            res += temp_res
            res += ' run scoreboard players get $(2)'
            res = 'data modify storage $(3):io temp set from $(1)\n' + res
            if args[1].scale == 1:
                res += f'\nexecute store result score $(2) run data get storage $(3):io temp'
            else:
                res += f'\nexecute store result score $(2) run data get storage $(3):io temp {args[1].scale}'
            return res
        if args[0].type == 'score' and args[1].type == 'nbt':
            res =  f'execute store result $(2) {type_table[args[1].data_type]} '
            temp_res = '{:.15f}'.format(1/args[0].scale).rstrip('0')
            if temp_res.endswith('.'):
                temp_res = temp_res[0:-1]
            res += temp_res
            res += ' run scoreboard players get $(1)'
            res = 'data modify storage $(3):io temp set from $(2)\n' + res
            if args[0].scale == 1:
                res += f'\nexecute store result score $(1) run data get storage $(3):io temp'
            else:
                res += f'\nexecute store result score $(1) run data get storage $(3):io temp {args[0].scale}'
            return res
        return ''
    if macro == '$create':
        if len(args) < 1:
            return ''
        # 特殊需要时聚集NBT
        if args[0].type == 'nbt' and not hasattr(args[0], 'dict_inited'):
            i = cur_index%len(pre_args[0])
            pre_part = pre_args[0][0:i]
            res_part = pre_args[0][i:]
            lst_nbt = [arg for arg in res_part if (arg.type == 'nbt' and not hasattr(arg, 'dict_inited'))]
            res_part = [arg for arg in res_part if not (arg.type == 'nbt' and not hasattr(arg, 'dict_inited'))]
            lst_nbt = lst_to_nbtvalue(lst_nbt)
            pre_args[0] = pre_part + lst_nbt + res_part
            cnt_lines[0] = min([len(_args) for _args in pre_args])
        if args[0].type == 'nbt':
            return f'data modify $(1)'
        if args[0].type == 'score':
            return f'scoreboard objectives add $(1) dummy'
        return ''
    if macro == '$init':
        if len(args) < 1:
            return ''
        # 特殊需要时聚集NBT
        if args[0].type == 'nbt' and not hasattr(args[0], 'dict_inited'):
            i = cur_index%len(pre_args[0])
            pre_part = pre_args[0][0:i]
            res_part = pre_args[0][i:]
            lst_nbt = [arg for arg in res_part if (arg.type == 'nbt' and not hasattr(arg, 'dict_inited'))]
            res_part = [arg for arg in res_part if not (arg.type == 'nbt' and not hasattr(arg, 'dict_inited'))]
            lst_nbt = lst_to_nbtvalue(lst_nbt)
            pre_args[0] = pre_part + lst_nbt + res_part
            cnt_lines[0] = min([len(_args) for _args in pre_args])
        if args[0].type == 'nbt':
            return f'data modify $(1)'
        if args[0].type == 'score':
            return f'scoreboard players set $(1) 0'
        return ''
    if macro == '$assign':
        if len(args) < 2:
            return ''
        # 需要时展平列表nbt
        if args[0].type == 'nbt' and args[0].data_type in init_elms and args[1].type == 'score':
            i = cur_index%len(pre_args[0])
            pre_args[0] = pre_args[0][0:i] + args[0].flatten_lst() + pre_args[0][i+1:]
            new_len = len(pre_args[0])
            if new_len > cnt_lines[0]:
                cnt_lines[0] = new_len
            if i < new_len:
                args[0] = pre_args[0][i]
            else:
                return ''
        if args[1].type == 'nbt' and args[1].data_type in init_elms and args[0].type == 'score':
            i = cur_index%len(pre_args[1])
            pre_args[1] = pre_args[1][0:i] + args[1].flatten_lst() + pre_args[1][i+1:]
            new_len = len(pre_args[1])
            if new_len > cnt_lines[0]:
                cnt_lines[0] = new_len
            if i < new_len:
                args[1] = pre_args[1][i]
            else:
                return ''
        if args[0].type == 'score' and args[1].type == 'score':
            return 'scoreboard players operation $(1) = $(2)'
        if args[0].type == 'nbt' and args[1].type == 'nbt':
            return 'data modify $(1) set from $(2)'
        if args[0].type == 'nbt' and args[1].type == 'score':
            res =  f'execute store result $(1) {type_table[args[0].data_type]} '
            temp_res = '{:.15f}'.format(1/args[1].scale).rstrip('0')
            if temp_res.endswith('.'):
                temp_res = temp_res[0:-1]
            res += temp_res
            res += ' run scoreboard players get $(2)'
            return res
        if args[0].type == 'score' and args[1].type == 'nbt':
            if args[0].scale == 1:
                return f'execute store result score $(1) run data get $(2)'
            return f'execute store result score $(1) run data get $(2) {args[0].scale}'
        return ''
# 模板生成文件
def gen_mcfunction():
    global template_name, template_line, function_name, update_funcs
    global pre_content, new_content
    templt = open(f'.mot_memory/templates/{template_name}.mcfi', 'r', encoding='utf-8')
    mcfunc = open(f'{function_name}.mcfunction', 'r', encoding='utf-8')
    pre_content = mcfunc.read()
    mcfunc.close()
    mcfunc = open(f'{function_name}.mcfunction', 'w', encoding='utf-8')
    mcfunc.truncate(0)
    env_map = {'$assign':None, '$init':'init', '$create':'create', '$swap':None, 'print':'print'}
    not_flatten_map = {'$print'}
    template_line = 0
    for line in templt:
        template_line += 1
        # 获取参数环境
        macro = None
        env = None
        not_flatten = False
        if line.startswith('$'):
            macro = line.split(' ')[0]
            if macro in env_map:
                env = env_map[macro]
            if macro in not_flatten_map:
                not_flatten = True
        # 获取参数
        line_modify = line
        pattern = r'\$\(.*?\)'
        args = re.findall(pattern, line_modify)
        # 解析参数
        temp_args = []
        for arg in args:
            arg_segments = arg[2:-1].split(' ')
            res_lst = []
            for arg_segment in arg_segments:
                if arg_segment in ('or', 'and', 'not', 'nbt', 'score'):
                    res_lst.append(arg_segment)
                else:
                    # 解析全部成员运算符
                    obj_names = arg_segment.split('.')
                    obj_find = lst_objects, dic_objects
                    obj = None
                    for obj_name in obj_names:
                        if obj_name in obj_find[0]:
                            obj = obj_find[1][obj_name]
                            obj_find = obj.lst_objects, obj.dic_objects
                        else:
                            obj = None
                            break
                    if not_flatten:
                        res = [] if obj is None else [obj]
                    else:
                        res = [] if obj is None else obj.flatten()
                    res_lst.append(res)
            arg_segments = res_lst
            # 获得全集
            uset = []
            for arg_segment in arg_segments:
                if isinstance(arg_segment, list):
                    for obj in arg_segment:
                        if obj not in uset:
                            uset.append(obj)
            # 解析全部nbt运算符
            res_lst = []
            op_rec = None
            for arg_segment in arg_segments:
                if arg_segment == 'nbt':
                    op_rec = 'nbt'
                elif isinstance(arg_segment, list):
                    if op_rec:
                        # 从列表中过滤非nbt参数
                        temp_lst = [obj for obj in arg_segment if obj.type=='nbt']
                        res_lst.append(temp_lst)
                        op_rec = None
                    else:
                        res_lst.append(arg_segment)
                else:
                    res_lst.append(arg_segment)
                    op_rec = None
            arg_segments = res_lst
            # 解析全部score运算符
            res_lst = []
            op_rec = None
            for arg_segment in arg_segments:
                if arg_segment == 'score':
                    op_rec = 'score'
                elif isinstance(arg_segment, list):
                    if op_rec:
                        # 从列表中过滤非score参数
                        temp_lst = [obj for obj in arg_segment if obj.type=='score']
                        res_lst.append(temp_lst)
                        op_rec = None
                    else:
                        res_lst.append(arg_segment)
                else:
                    res_lst.append(arg_segment)
                    op_rec = None
            arg_segments = res_lst
            # 解析全部not运算符
            res_lst = []
            op_rec = None
            for arg_segment in arg_segments:
                if arg_segment == 'not':
                    op_rec = 'not'
                elif isinstance(arg_segment, list):
                    if op_rec:
                        # 从全集中过滤参数
                        temp_lst = [obj for obj in uset if obj not in arg_segment]
                        res_lst.append(temp_lst)
                        op_rec = None
                    else:
                        res_lst.append(arg_segment)
                else:
                    res_lst.append(arg_segment)
                    op_rec = None
            # 解析全部and运算符
            arg_segments = res_lst
            res_lst = []
            op_rec = None
            lst_rec = None
            for arg_segment in arg_segments:
                if arg_segment == 'and':
                    op_rec = 'and'
                elif arg_segment == 'or':
                    if lst_rec:
                        res_lst.append(lst_rec)
                        lst_rec = None
                    op_rec = None
                    res_lst.append(arg_segment)
                elif isinstance(arg_segment, list):
                    if op_rec:
                        # 计算交集
                        temp_lst = [obj for obj in lst_rec if obj in arg_segment]
                        op_rec = None
                        lst_rec = temp_lst
                    else:
                        lst_rec = arg_segment
            if lst_rec:
                res_lst.append(lst_rec)
            # 解析全部or运算符
            arg_segments = res_lst
            lst_rec = []
            for arg_segment in arg_segments:
                if isinstance(arg_segment, list):
                    # 计算并集
                    lst_rec = lst_rec + [obj for obj in arg_segment if obj not in lst_rec]
            temp_args.append(lst_rec)
        # 生成行占位符
        i = 1
        for arg in args:
            line_modify = line_modify.replace(arg, f'$({i})', 1)
            i += 1
        args = temp_args
        # 检查是不是空参数行
        if len(args)==0:
            mcfunc.write(line)
            continue
        # 检查有没有空的参数
        if any(len(arg) == 0 for arg in args):
            continue
        end_char = ''
        if line_modify.endswith('\n'):
            end_char = '\n'
            line_modify = line_modify[0:-1]
        next_line = False
        cnt_lines = [max(len(arg) for arg in args)]
        i = 0
        while i < cnt_lines[0]:
            # 根据替换行或者宏行，生成行模板
            line_gen = line_modify
            if macro:
                line_gen = macro_line(macro, [arg[i%len(arg)] for arg in args], i, args, cnt_lines)
            arg_index = 1
            for arg in args:
                line_gen = line_gen.replace(f'$({arg_index})', arg[i%len(arg)].gen_code(env))
                arg_index += 1
            if next_line:
                mcfunc.write('\n'+line_gen)
            else:
                mcfunc.write(line_gen)
                next_line = True
            i += 1
        mcfunc.write(end_char)
    mcfunc.close()
    templt.close()
    mcfunc = open(f'{function_name}.mcfunction', 'r', encoding='utf-8')
    new_content = mcfunc.read()
    mcfunc.close()
    if pre_content != new_content:
        update_funcs.append(f'{function_name}')
# 同步代码
def sync_code():
    global template_name, function_name, update_funcs
    update_funcs = []
    lst_functions = []
    for folder_path, _, files in os.walk('./'):
        path = folder_path[2:].replace('\\', '/')
        if path:
            path += '/'
        lst_functions += [path+file[0:-11] for file in files if file.endswith('.mcfunction')]
    lst_templates = []
    for folder_path, _, files in os.walk('./.mot_memory/templates'):
        path = folder_path[24:].replace('\\', '/')
        if path:
            path += '/'
        lst_templates += [path+file[0:-5] for file in files if file.endswith('.mcfi')]
    lst_templates = [file for file in lst_templates if '(' not in file] + [file for file in lst_templates if '(' in file]
    print('code syncing...')
    cnt_interfaces = 0
    for file_name in lst_functions:
        if file_name in whitelist:
            continue
        res_dict = match_pattern(lst_templates, file_name)
        if res_dict is not None:
            for word_name, word_segment in res_dict.items():
                obj = new_object({'name':word_name, 'type':'word', 'segment':word_segment})
                add_object(obj)
            function_name = file_name
            gen_mcfunction()
            cnt_interfaces += 1
    print(f'code synced ({cnt_interfaces} interfaces)')
    to_detect = [word.segment+'init' for word in dic_objects['sub_modules'].flatten()]
    to_detect += ['init', '_init', '_class', '_consts']
    print(f'interfaces updated: {update_funcs}')
    if any(func in update_funcs for func in to_detect):
        print('\n检测到初始化接口发生更新，请别忘记在游戏中重新执行！')

# 函数接口
def del_function(name):
    try:
        os.remove(f'{name}.mcfunction')
        print(f'removed interface: {name}.mcfunction')
    except:
        pass
def del_functions():
    for name in user_input[1:]:
        del_function(name)
def cre_function(name):
    path = name.split('/')
    path.pop()
    if path:
        try:
            os.makedirs('/'.join(path))
        except:
            pass
    mcfunc = open(f'{name}.mcfunction', 'w', encoding='utf-8')
    mcfunc.truncate(0)
    mcfunc.close()
    print(f'created interface: {name}.mcfunction')
def cre_functions():
    global template_name
    lst_templates = []
    for folder_path, _, files in os.walk('./.mot_memory/templates'):
        path = folder_path[24:].replace('\\', '/')
        if path:
            path += '/'
        lst_templates += [path+file[0:-5] for file in files if file.endswith('.mcfi')]
    for name in user_input[1:]:
        folders = name.split('/')
        if len(folders)<=1:
            continue
        interface_name = folders.pop()
        interface_prefix = '/'.join(folders)
        res_dict = match_pattern(lst_templates, name)
        # 找到匹配的组
        if res_dict is not None:
            match_prefix = template_name.split('/')
            match_prefix.pop()
            match_prefix = '/'.join(match_prefix)
            for template_name in lst_templates:
                template_prefix = template_name.split('/')
                template_surfix = template_prefix.pop()
                template_prefix = '/'.join(template_prefix)
                if '(' in template_surfix:
                    continue
                if template_prefix == match_prefix and template_surfix != interface_name:
                    user_input.append(interface_prefix + '/' + template_name.split('/')[-1])
    for name in user_input[1:]:
        cre_function(name)
def init_functions():
    if 'init_interfaces' in dic_objects:
        [cre_function(obj.segment) for obj in dic_objects['init_interfaces'].flatten() if obj.type=='word']

# 接口白名单
def save_whitelist():
    global whitelist
    file = open('.mot_memory/objects/whitelist.mcfo', 'w', encoding='utf-8')
    file.truncate(0)
    file.write('mot_whitelist: {')
    if whitelist:
        sep_flag = False
        for name in whitelist:
            part = f'\n\t{name}'
            if sep_flag:
                part = ',' + part
            file.write(part)
            sep_flag = True
        file.write('\n')
    file.write('}')
    file.close()
def protect_function(name):
    global whitelist
    if name not in whitelist:
        input_dic = {'type':'word', 'segment':name, 'name':name}
        obj = new_object(input_dic)
        if 'mot_whitelist' in dic_objects:
            dic_objects['mot_whitelist'].add_object(obj)
        whitelist.append(name)
        print(f'protected interface: {name}.mcfunction')
def protect_functions():
    for name in user_input[1:]:
        protect_function(name)
    save_whitelist()
def unprotect_function(name):
    global whitelist
    if name in whitelist:
        whitelist.remove(name)
        if 'mot_whitelist' in dic_objects:
            dic_objects['mot_whitelist'].pop_object(name)
        print(f'unprotected interface: {name}.mcfunction')
def unprotect_functions():
    for name in user_input[1:]:
        unprotect_function(name)
    save_whitelist()

# mot全局运行协调程序
# 解析对象程序
def interpret():
    global doc_path, project_name, entity_store_path, whitelist
    clear_objects()
    print('doc interpreting...')
    # 生成特殊对象
    obj = new_object({'name':'module_prefix', 'type':'word', 'segment':prefix})
    add_object(obj)
    # 扫描记忆文件
    doc_paths = []
    for folder_path, _, files in os.walk('.mot_memory/objects'):
        doc_paths += [os.path.join(folder_path, file) for file in files if file.endswith('.mcfo')]
    doc_paths += [filename for filename in os.listdir('./') if filename.endswith('.mcfo')]
    for doc_path in doc_paths:
        doc_read()
        doc_interpret()
    # 生成项目名称
    if 'project_name' not in dic_objects:
        obj = new_object({'name':'project_name', 'type':'word', 'segment':namespace})
        add_object(obj)
    project_name = dic_objects['project_name'].segment
    # 生成模块名称
    if 'module_name' not in dic_objects:
        obj = new_object({'name':'module_name', 'type':'word', 'segment':module_name})
        add_object(obj)
    # TODO 生成所有子模块
    lst_objs = []
    dic_objs = {}
    cnt_objs = 0
    for folder_path, _, files in os.walk('./'):
        if 'init.mcfunction' in files:
            obj_name = folder_path[2:].replace('\\', '/')+'/'
            obj = new_object({'name':obj_name, 'type':'word', 'segment':obj_name})
            if obj_name in dic_objs:
                dic_objs[obj_name] = obj
            else:
                lst_objs.append(obj_name)
                dic_objs[obj_name] = obj
                cnt_objs += 1
    input_dic = {'name':'sub_modules', 'type':'compose'}
    input_dic |= {'lst_objects':lst_objs, 'dic_objects':dic_objs,'cnt_objects':cnt_objs}
    new_obj = new_object(input_dic)
    add_object(new_obj)
    # 生成实体存储路径
    entity_store_path = 'data'
    if 'entity_store_path' in dic_objects:
        entity_store_path = dic_objects['entity_store_path'].segment
    # 自动生成数据模板
    if '_input_plate' not in dic_objects and '_this' in dic_objects:
        compose_to_plate(dic_objects['_this'], name='_input_plate', nbt_path='input', project_name=project_name)
    if '_result_plate' not in dic_objects and '_this' in dic_objects:
        compose_to_plate(dic_objects['_this'], name='_result_plate', nbt_path='result', project_name=project_name)
    # 自动生成实体对象
    if '_entity' not in dic_objects and '_this' in dic_objects:
        compose_to_entity(dic_objects['_this'], name='_entity', entity_store_path=entity_store_path)
    # 生成白名单
    whitelist = []
    if 'mot_whitelist' in dic_objects:
        whitelist = dic_objects['mot_whitelist'].flatten()
        whitelist = [obj.segment for obj in whitelist if obj.type=='word']
    print(f'doc interpreted ({cnt_objects} objects)')
    
# 解析并同步代码
def interpret_and_sync():
    interpret()
    sync_code()

# 创建并解析同步代码
def creis():
    cre_functions()
    interpret_and_sync()

# 创建并解析同步保护代码
def creisp():
    cre_functions()
    interpret_and_sync()
    protect_functions()

# 结束程序
def stop():
    sys.exit(0)

# 运行初始操作
interpret()
print('\n')

# 命令映射表
command_table = {'':interpret_and_sync, 'interpret':interpret, 'sync':sync_code, 'stop':stop}
command_table |= {'list':print_object_names, 'print':print_objects, 'printi':print_index_object}
command_table |= {'cre':cre_functions, 'init':init_functions, 'del':del_functions}
command_table |= {'protect':protect_functions, 'unprotect':unprotect_functions}
command_table |= {'creis':creis, 'creisp':creisp}
# 主程序
while True:
    user_input = input().split(' ')
    #user_input = ['stop']
    command = user_input[0]
    if command in command_table:
        command_table[command]()
    elif command in lst_objects:
        print(dic_objects[command])
    else:
        print(f'未识别命令: {command}')
    print('\n')