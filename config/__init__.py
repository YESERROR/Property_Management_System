import yaml
from urllib.parse import quote_plus
from datetime import timedelta
from pathlib import Path
from typing import Dict, Any


class AppConfig:
    """配置加载核心类"""
    _instance = None
    #单实例模式
    def __new__(cls):
        if cls._instance is None:
            cls._instance = super().__new__(cls)
            cls._instance._load_config()
        return cls._instance

    def _load_config(self) -> None:
        """加载YAML配置文件"""
        config_path = Path(__file__).parent / "app_config.yaml"
        with open(config_path, 'r', encoding='utf-8') as f:
            self._config = yaml.safe_load(f)

    def _build_db_uri(self) -> str:
        """构建数据库连接字符串"""
        if self._config['database']['default']=='sqlserver':
            db_config_SqlServer = self._config['database']['sqlserver']
            params = quote_plus(
                f"DRIVER={{{db_config_SqlServer['driver']}}};"
                f"SERVER={db_config_SqlServer['server']};"
                f"DATABASE={db_config_SqlServer['database']};"
                f"UID={db_config_SqlServer['username']};"
                f"PWD={db_config_SqlServer['password']}"
            )
            return f"mssql+pyodbc:///?odbc_connect={params}"
        else:
            db_config_mysql = self._config['database']['mysql']
            username = quote_plus(db_config_mysql['username'])
            password = quote_plus(db_config_mysql['password'])
            server = db_config_mysql['server']
            port = db_config_mysql['port']
            database = db_config_mysql['database']
            return  f"mysql+pymysql://{username}:{password}@{server}:{port}/{database}"

    @property
    def flask_config(self) -> Dict[str, Any]:
        """生成Flask配置字典"""
        jwt=self._config['security']['jwt']
        return {
            # 安全配置
            'SECRET_KEY': self._config['security']['secret_key'],
            'CSRF_ENABLED':self._config['security']['csrf_enable'],
            # JWT配置
            'JWT_SECRET_KEY': jwt['secret_key'],
            'JWT_TOKEN_LOCATION': jwt['token_location'],
            'JWT_ACCESS_COOKIE_NAME': jwt['access_cookie_name'],
            'JWT_COOKIE_CSRF_PROTECT': jwt['cookie_csrf_protect'],
            'JWT_ACCESS_TOKEN_EXPIRES': timedelta(
                seconds=jwt['access_token_expires']
            ),
            # 数据库配置
            'SQLALCHEMY_DATABASE_URI': self._build_db_uri(),
            'SQLALCHEMY_TRACK_MODIFICATIONS': False
        }

    @property
    def config(self):
        return self._config


config = AppConfig()

def get_flask_config() -> Dict[str, Any]:
    """供其他模块直接导入的快捷函数"""
    return config.flask_config
def get_JWT_cookie_config() -> str:
    """<UNK>JWT<UNK>"""
    return config.config['security']['jwt']['access_cookie_name']
def get_database_config() -> str:
    """<UNK>DB<UNK>"""
    return config.config['database']['default']