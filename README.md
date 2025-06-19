# 基于flask的物业管理系统

## 项目简介

本项目是一个基于 Python Flask 框架的 Web 版物业管理系统，旨在解决传统物业管理模式中效率低下、错误率高、管理成本大等问题。系统采用 MVC 架构模式，结合 Jinja2 模板引擎构建前端界面，使用 SQLAlchemy 进行数据库操作，实现了物业管理的数字化和网络化。

## 技术栈

### 后端技术
* Python Flask：轻量级 Web 框架，用于构建后端服务
* SQLAlchemy：ORM 工具，实现数据库操作
* Flask-Login：用户认证管理
* Flask-WTF：表单验证处理
* JWT：JSON Web Token 认证机制

### 前端技术

* Jinja2：模板引擎，构建动态页面
* Bootstrap：响应式布局设计
* JavaScript：前端交互逻辑
* CSS/HTML：页面样式与结构

### 数据库

* SQL Server/MySQL：支持两种数据库配置

## 功能模块

### 用户权限管理

* 基于 RBAC 模型的多级权限控制（管理员、业主、维修工）
* 用户认证与授权机制
* 角色权限动态分配

### 房产信息管理

* 房产基础信息登记与管理
* 房产类型（住宅、商铺、车位）管理
* 业主与房产关联关系维护

### 费用收缴管理

* 收费标准创建与发布
* 账单生成与批量发布
* 在线缴费与状态跟踪
* 缴费记录查询与统计

### 设备报修管理

* 报修单创建与提交
* 维修任务分配与跟踪
* 维修状态更新与完成确认
* 报修历史记录查询

### 社区公告管理

* 公告创建与发布
* 公告有效期管理
* 公告内容 HTML 渲染
* 公告查询与展示

## 系统架构

### 项目结构

```text
├── config/                  # 配置文件
│   ├── __init__.py          # 配置加载
│   └── app_config.yaml      # 系统配置
├── static/                  # 静态资源
│   ├── css/                 # 样式表
│   ├── js/                  # JavaScript
│   └── img/                 # 图片资源
├── templates/               # 模板文件
│   ├── base.html            # 基础模板
│   ├── home.html            # 主页
│   ├── login.html           # 登录页面
│   ├── payFee.html          # 缴费页面
│   └── ...                  # 其他功能页面
├── app.py                   # 应用入口
├── models.py                # 数据模型
├── requirements.txt         # 依赖列表
└── run.py                   # 启动脚本
```

### 数据库设计

| 表名                | 功能描述       |
|-------------------|------------|
| User              | 用户基本信息表    |
| User_info         | 用户详细信息表    |
| Property_Info     | 房产信息表      |
| Fee_Standard      | 收费标准表      |
| Property_Fee_Bill | 账单缴交表      |
| Repair_Order      | 维修订单表      |
| Notice            | 公告表        |
| Token_blacklist   | Token 黑名单表 |
| Apply_user        | 申请用户表      |

## 安装与运行

### 环境要求

* Python 3.6+
* SQL Server 或 MySQL 数据库

### 安装步骤

1. 创建虚拟环境

```bash
python -m venv venv
```

2. 激活虚拟环境

```bash
# Windows
venv\Scripts\activate.bat

# Linux/Mac
source venv/bin/activate
```

3. 安装依赖

```bash
pip install -r requirements.txt
```

4. 配置数据库

    修改config/app_config.yaml中的数据库连接信息：
```yaml
database:
    default: "sqlserver"  # 可选 'mysql'
    sqlserver:
        server: "localhost"
        database: "PM_DataBase"
        username: "sa"
        password: "123456"
    mysql:
        server: "192.168.31.130"
        database: "PM_DataBase"
        username: "username"
        password: "@123456ZHANzhan"
```

5. 初始化数据库
```bash
cd import_sqlData
python init.py
```
6. 启动应用
```bash
flask run
```

## 使用说明
### 访问地址
* 本地访问：http://127.0.0.1:5000

## 角色权限
1. 管理员（admin）

   * 管理所有用户信息
   * 创建与发布收费标准
   * 管理报修单与分配维修任务
   * 发布社区公告

2. 业主（user）

   * 查看与修改个人信息
   * 查看与缴纳物业费用
   * 提交设备报修申请
   * 查看社区公告

3. 维修工（repair）

   * 查看与处理分配的维修任务
   * 更新维修状态与结果

## 主要功能流程

1. 费用收缴流程
   * 管理员创建收费标准 → 发布账单 → 业主查看并缴费 → 管理员跟踪缴费状态
2. 报修处理流程
    * 业主提交报修单 → 管理员分配维修任务 → 维修工处理并更新状态 → 业主查看进度
3. 公告发布流程
    * 管理员创建公告 → 设置有效期 → 发布公告 → 业主与维修工查看
