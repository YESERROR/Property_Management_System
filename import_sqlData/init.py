import pyodbc
from config import get_pyodbc_config

# 创建连接
conn_str = get_pyodbc_config()
conn = pyodbc.connect(conn_str)
cursor = conn.cursor()

# 读取 .sql 文件
with open('init.sql', 'r', encoding='utf-8') as f:
    sql_script = f.read()

# 多条语句分开执行（根据情况分割）
sql_commands = sql_script.strip().split(';')

for command in sql_commands:
    command = command.strip()
    if command:  # 跳过空语句
        try:
            cursor.execute(command)
        except Exception as e:
            print(f"执行出错：{e}\n语句：{command}")

# 提交更改
conn.commit()

# 关闭连接
cursor.close()
conn.close()

print("SQL 脚本执行完毕。")
