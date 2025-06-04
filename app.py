from flask import *
from flask_jwt_extended import *
from flask_sqlalchemy import SQLAlchemy
from sqlalchemy.ext.declarative import declared_attr
from flask_wtf import FlaskForm
from wtforms import StringField, PasswordField, SubmitField
from wtforms.validators import DataRequired
import datetime
from sqlalchemy import func
from functools import wraps
from config import get_flask_config,get_JWT_cookie_config,get_database_config
app = Flask(__name__)
# app.config['SECRET_KEY'] = 'your-very-secret-key'
# app.config['JWT_TOKEN_LOCATION'] = ['cookies']
# app.config['JWT_ACCESS_COOKIE_NAME'] = 'access_token_cookie'
# app.config['JWT_COOKIE_CSRF_PROTECT'] = False
# app.config['JWT_SECRET_KEY'] = 'your-jwt-secret'
# app.config['JWT_ACCESS_TOKEN_EXPIRES'] = datetime.timedelta(hours=1)  # Token有效期

app.config.update(get_flask_config())
# 开启全局 CSRF 保护
jwt = JWTManager(app)
#连接数据库
# params = urllib.parse.quote_plus(
#     "DRIVER={ODBC Driver 17 for SQL Server};"
#     "SERVER=localhost;"            # 替换为你的 SQL Server 地址
#     "DATABASE=PM_DataBase;"      # 替换为你的数据库
#     "UID=sa;"           # 替换为你的用户名
#     "PWD=123456"            # 替换为你的密码
# )
# app.config['SQLALCHEMY_DATABASE_URI'] = "mssql+pyodbc:///?odbc_connect=%s" % params
# app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
db = SQLAlchemy(app)

def MySQL_SQLServer():
    if 'sqlserver' == get_database_config():
        return True
    else:
        return False

def MySQL_SQLServer_str():
    if MySQL_SQLServer():
        return 'db.'
    else:
        return ''

class BaseModel(db.Model):
    __abstract__ = True
    @declared_attr
    def __table_args__(cls):
        # 如果当前数据库是 SQL Server，指定 schema 为 "db"
        if MySQL_SQLServer:
            return {"schema": "db"}
        return {}

#User表
class User(BaseModel):
    __tablename__ = "User"
    # __table_args__ = {"schema": "db"}
    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String(80), unique=True, nullable=False)
    password = db.Column(db.String(80), nullable=False)
    role = db.Column(db.String(80),nullable=False)
    user_info = db.relationship(
        "User_info",
        backref=db.backref("user", uselist=False),
        uselist=False,
        cascade="all, delete-orphan",
        single_parent = True
    )
    user_property = db.relationship(
        "Property_Info",
        backref=db.backref("user", uselist=False),
        uselist=False,
        single_parent = True
    )
    # billID = db.relationship("Property_Fee_Bill", backref="user", uselist=False)

#User_info表
class User_info(BaseModel):
    __tablename__ = "User_info"
    # __table_args__ = {"schema": "db"}
    id = db.Column(db.Integer, db.ForeignKey(MySQL_SQLServer_str()+"User.id",ondelete='CASCADE'), primary_key=True)
    telephone = db.Column(db.String(20), nullable=False)
    id_card = db.Column(db.String(20), nullable=False)
    name = db.Column(db.String(80), nullable=False)
    # user = db.relationship("User", back_populates="user_info")
#apply_user表
class apply_user(BaseModel):
    __tablename__ = "apply_user"
    # __table_args__ = {"schema": "db"}
    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String(80), unique=True, nullable=False)
    password = db.Column(db.String(80), nullable=False)
    role = db.Column(db.String(80), nullable=False)
    name = db.Column(db.String(80), nullable=False)
    BuildingNo = db.Column(db.String(80), nullable=False)
    RoomNo = db.Column(db.String(80),nullable=False)
    telephone = db.Column(db.String(20), nullable=False)
    IDCard = db.Column(db.String(20), nullable=False)
    Area = db.Column(db.Integer, nullable=False)
    Property_Type = db.Column(db.String(80), nullable=False)

#费用标准表
class Fee_Standard(BaseModel):
    __tablename__ = "Fee_Standard"
    # __table_args__ = {"schema": "db"}
    StandardID = db.Column(db.Integer, primary_key=True,autoincrement=True)
    Property_name=db.Column(db.String(80), nullable=False)
    PropertyType=db.Column(db.String(80), nullable=False)
    FreeType=db.Column(db.String(80), nullable=False)
    UnitPrice=db.Column(db.Numeric(10, 2), nullable=False)
    StartDate=db.Column(db.DateTime, default=datetime.datetime.utcnow,nullable=False)
    EndDate=db.Column(db.DateTime,default=datetime.datetime.utcnow,nullable=False)

#Property_Fee_Bill
class Property_Fee_Bill(BaseModel):
    __tablename__ = "Property_Fee_Bill"
    BillID = db.Column(db.Integer, primary_key=True,autoincrement=True)
    PersonID=db.Column(db.Integer, db.ForeignKey(MySQL_SQLServer_str()+"User.id",ondelete='CASCADE') ,nullable=False)
    BillingCycle=db.Column(db.DateTime, nullable=False)
    TotalAmount=db.Column(db.Numeric(10, 2), nullable=False)
    Status=db.Column(db.String(80), nullable=False)
    GenerateDate=db.Column(db.DateTime, default=datetime.datetime.utcnow,nullable=False)
    DueDate=db.Column(db.DateTime, default=datetime.datetime.utcnow,nullable=False)

    user=db.relationship("User", backref="bills")

#TokenBlacklist表
class TokenBlacklist(BaseModel):
    id = db.Column(db.Integer, primary_key=True)
    jti = db.Column(db.String(36), nullable=False, unique=True)
    created_at = db.Column(db.DateTime, nullable=False, default=datetime.datetime.utcnow)
    expires_at = db.Column(db.DateTime, nullable=False)

#房产信息表
class Property_Info(BaseModel):
    __tablename__ = "Property_Info"
    PropertyID = db.Column(db.Integer, primary_key=True,autoincrement=True)
    OwnerID = db.Column(db.Integer,db.ForeignKey(MySQL_SQLServer_str()+"User.id") ,nullable=False)
    BuildingNo = db.Column(db.Integer, nullable=False)
    RoomNo = db.Column(db.Integer, nullable=False)
    Area = db.Column(db.Integer, nullable=False)
    PropertyType=db.Column(db.String(80), nullable=False)
#公告表
class Notice(BaseModel):
    __tablename__ = "Notice"
    NoticeID = db.Column(db.Integer, primary_key=True,autoincrement=True)
    Notice_name=db.Column(db.String(80), nullable=False)
    Notice_date=db.Column(db.DateTime, nullable=False, default=datetime.datetime.utcnow)
    Notice_Content = db.Column(db.String(200), nullable=False)

#维修表
class Repair_Order(BaseModel):
    __tablename__ = "Repair_Order"
    OrderID =  db.Column(db.Integer, primary_key=True,autoincrement=True)
    ReporterID = db.Column(db.Integer,nullable=False)
    RepairType =db.Column(db.String(200), nullable=False)
    Title=db.Column(db.String(200), nullable=False)
    Description=db.Column(db.String(200), nullable=False)
    Urgency=db.Column(db.Integer, nullable=False)
    Status=db.Column(db.String(200), nullable=False)
    CreateTime=db.Column(db.DateTime, nullable=False, default=datetime.datetime.utcnow)
    ExpectedTime=db.Column(db.DateTime, nullable=False, default=datetime.datetime.utcnow)
    ActualFinishTime=db.Column(db.DateTime)

#登入表单
class LoginForm(FlaskForm):
    username = StringField('用户名', validators=[DataRequired()])
    password = PasswordField('密码', validators=[DataRequired()])

#限制特定用户
def admin_required(fn):
    @wraps(fn)
    @jwt_required()
    def wrapper(*args, **kwargs):
        current_user = get_jwt_identity()
        if current_user != 'admin':  # 假设token中有role字段
            return render_template('403.html'), 403
        return fn(*args, **kwargs)
    return wrapper

# 检查token是否在黑名单中
@jwt.token_in_blocklist_loader
def check_if_token_revoked(jwt_header, jwt_payload):
    jti = jwt_payload['jti']
    token = TokenBlacklist.query.filter_by(jti=jti).first()
    return token is not None

# 对于缺少token的情况
@jwt.unauthorized_loader
def unauthorized_callback(callback):
    return render_template('401.html'), 401

# # 对于缺少token过期的情况
# @jwt.expired_token_loader
# def expired_token_callback(jwt_header, jwt_payload):
#     response = make_response(render_template('401.html'), 401)
#     unset_jwt_cookies(response)  # 清除 Cookie
#     return response

#登入验证
@app.route('/login',methods=['GET','POST'])
# @clear_auth_cookie
def login():
    form = LoginForm()
    if form.validate_on_submit():
        username = form.username.data
        password = form.password.data
        user=User.query.filter_by(username=username, password=password).first()
        if user:
            # 创建JWT Token
            access_token = create_access_token(
                identity=str(user.role.split()[0]),
                additional_claims={"username":username,
                                   "id":user.id}
            )
            # 存储Token到Cookie (安全配置)
            response = redirect(url_for('home'))
            response.set_cookie(
                get_JWT_cookie_config(),
                value=access_token,
                httponly=True,
                secure=False,  # 生产环境必须启用HTTPS
                samesite='Lax'
            )
            return response
        else:
            response = make_response(render_template('login.html', form=form,error="用户名或密码错误"))
            response.set_cookie('auth_token', '', expires=0)  # 清除cookie
            return response
    else:

        response = make_response(render_template('login.html', form=form))
        response.set_cookie('auth_token', '', expires=0)  # 清除cookie
        return response

#登出
@app.route('/logout', methods=['POST'])
@jwt_required()
def logout():
    jti = get_jwt()['jti']
    expires_at = datetime.datetime.utcnow() + app.config['JWT_ACCESS_TOKEN_EXPIRES']
    # 将token加入黑名单
    blacklisted_token = TokenBlacklist(jti=jti,expires_at=expires_at)
    db.session.add(blacklisted_token)
    db.session.commit()
    #返回到login
    response = redirect(url_for('login'))
    unset_jwt_cookies(response)
    return response

#概况
@app.route('/home/')
@jwt_required()
def home():
    current_user = get_jwt_identity()
    row_count = db.session.query(apply_user).count()#查询注册用户申请数量
    row_user = db.session.query(User).count()
    total_paid = db.session.query(
        func.sum(Property_Fee_Bill.TotalAmount)
    ).filter(
        Property_Fee_Bill.Status == "已缴费"
    ).scalar()
    sum_bill=db.session.query(func.sum(Property_Fee_Bill.TotalAmount)).filter().scalar()
    person = Property_Fee_Bill.query.filter_by(Status="已缴费").count()
    person_sum =Property_Fee_Bill.query.filter_by().count()
    claims = get_jwt()
    if not total_paid and not person:
        total_paid=0
        person=0
    return render_template('home.html',username=current_user,apply_row=row_count,row_user=row_user
                           ,total_paid=total_paid,fraction=round(total_paid/sum_bill,2),
                           person_fraction=round(person/person_sum,2))

#业主管理
@app.route('/home/property_manager')
@admin_required
def property_manager():
    users=User.query.all()
    return render_template('property_manager.html',users=users)

#业主管理-编辑
@app.route('/home/property_manager/edit',methods=['POST'])
@admin_required
def property_manager_edit():
    data = request.get_json()
    ID=data.get('id')
    username = data.get('username')
    name = data.get('name')
    import re
    room = re.split(r'[栋室]',data.get('room'))
    user = User.query.get(ID)
    if not user:
        return jsonify({"status": "error"}), 404
    try:
        user.username = username
        user.user_info.name=name
        user.user_property.BuildingNo=room[0]
        user.user_property.RoomNo=room[1]
        db.session.commit()
        return jsonify({"status": "success"})
    except Exception as e:
        db.session.rollback()
        return jsonify({"status": "error", "message": f"更新失败：{str(e)}"}), 500

#业主管理-删除
@app.route('/home/property_manager/delete',methods=['POST'])
@admin_required
def property_manager_delete():
    data = request.get_json()
    ID = data.get('id')
    Property_Fee_Bill.query.filter_by(PersonID=ID).delete()
    Property_Info.query.filter_by(PropertyID=ID).delete()
    User_info.query.filter(User_info.id==ID).delete()
    User.query.filter(User.id == ID).delete()
    try:
        db.session.commit()
        return jsonify({"status": "success"})
    except Exception as e:
        db.session.rollback()
        return jsonify({"status": "error", "message": f"更新失败：{str(e)}"}), 500

#注册
@app.route('/signup',methods=['GET','POST'])
def signup():
    if request.method == 'POST':
        username = request.form.get('userName')
        password = request.form.get('password')
        telephone = request.form.get('telephone')
        IDCard = request.form.get('IDCard')
        Area = request.form.get('Area')
        Property_Type = request.form.get('Property_Type')
        name = request.form.get('name')
        import re
        room = re.split(r'[栋室]',request.form.get('room'))
        role = request.form.get('role')
        new_user = apply_user(username=username, password=password, name=name,
                              BuildingNo=room[0],RoomNo=room[1], role=role,
                              telephone=telephone,
                              IDCard=IDCard,
                              Area=Area,Property_Type=Property_Type)
        try:
            db.session.add(new_user)
            db.session.commit()
            return jsonify({'message': '注册成功'})
        except Exception as e:
            import traceback
            db.session.rollback()
            traceback.print_exc()
            return jsonify({'error': traceback.format_exc()}), 500
    else:
        return render_template('sign_up.html')

#注册审核-选择
@app.route('/home/registration_assessment/edit',methods=['POST'])
@admin_required
def registration_assessment_edit():
    data = request.get_json()
    user_id = data['id']
    action = data['action']  # 'accept' 或 'refuse'
    if action == 'accept':
        user = apply_user.query.filter(apply_user.id == user_id).first()
        new_user = User(username=user.username, password=user.password,role=user.role,
                        user_info = User_info(telephone=user.telephone,id_card=user.IDCard,name=user.name),
                        user_property=Property_Info(BuildingNo=user.BuildingNo,RoomNo=user.RoomNo,Area=user.Area,PropertyType=user.Property_Type))
        apply_user.query.filter(apply_user.id == user_id).delete()
        try:
            db.session.add(new_user)
            db.session.commit()
            return jsonify({"status": "success"})
        except Exception as e:
            db.session.rollback()
            return jsonify({'status': 'error','message':str(e)}), 500
    elif action == 'refuse':
        apply_user.query.filter(apply_user.id == user_id).delete()
        try:
            db.session.commit()
            return jsonify({"status": "success"})
        except Exception as e:
            db.session.rollback()
            return jsonify({'error': str(e)}), 500
    else:
        return jsonify({'error': '无条件'}), 500

#注册审核
@app.route('/home/registration_assessment/')
@admin_required
def registration_assessment():
    users = apply_user.query.all()
    return render_template('registration_assessment.html', users=users)

@app.route('/home/registration_assessment/add',methods=['POST'])
@admin_required
def registration_assessment_add():
    import re
    data = request.get_json()
    ls=re.split(r'[栋室]',data['room'])
    try:
        new_user=User(username=data['username'],password=data['password'],role=data['role'])
        db.session.add(new_user)
        db.session.commit()
        try:
            user_info=User_info(id=new_user.id,telephone="".join(data['telephone'].split('-')),id_card="".join(data['idcard'].split('-')),name=data['name'])
            db.session.add(user_info)
            property_info=Property_Info(OwnerID=new_user.id,BuildingNo=ls[0],RoomNo=ls[1],Area=data['Area'],PropertyType=data['PropertyType'])
            db.session.add(property_info)
            db.session.commit()
        except Exception as e:
            db.session.rollback()
            return jsonify({
                'success': False,
                'message': '错误' + str(e)
            })
        return jsonify({
            'success': True,
            'message': '添加成功'
        })
    except Exception as e:
        db.session.rollback()
        return jsonify({
            'success': False,
            'message': '错误'+str(e)
        })

#个人信息更改
@app.route('/home/personal_user/')
@jwt_required(optional=False)
def personal_user():
    current_user = get_jwt_identity()#获取用户名/email
    claims = get_jwt()
    user = db.session.query(User).filter_by(id=claims['id']).first()
    print()
    return render_template("profile.html",
                           id=claims['id'],
                           emile=user.username,
                           name=user.user_info.name,
                           room=user.user_property.BuildingNo+'栋'+user.user_property.RoomNo+'室',
                           telephone=user.user_info.telephone,
                           id_card=user.user_info.id_card,
                           username=current_user,Area=user.user_property.Area)

#修改个人数据
@app.route('/home/personal_user/change_user',methods=['POST'])
@jwt_required(optional=False)
def personal_user_change():
    data = request.get_json()
    # id=data['id']
    claims = get_jwt()
    id = claims['id']
    email=data['email']
    password=data['password']
    user=User.query.filter_by(id=id).first()
    if user:
        try:
            user.username=email
            user.password=password
            db.session.commit()
            return jsonify({
                    'success': True,
                    'message': '邮箱和密码修改成功'
                })
        except Exception as e:
            db.session.rollback()
            print(str(e))
            return jsonify({
                'success': False,
                'message': str(e)
            })
    else:
        return jsonify({
            'success': False,
            'message': '未找到该用户'
        })

#修改个人信息
@app.route('/home/personal_user/change_person',methods=['POST'])
@jwt_required(optional=False)
def change_person():
    data = request.get_json()
    # id=data['id'] 漏洞
    claims = get_jwt()
    ID=claims['id']
    name=data['name']
    Area=data['Area']
    import re
    room=re.split(r'[栋室]',data['room'])
    telephone="".join(data['telephone'].split('-'))
    idcard="".join(data['idcard'].split('-'))
    try:
        User_info.query.filter_by(id=ID).update({'name':name,
                                            'telephone':telephone,
                                            'id_card':idcard})
        Property_Info.query.filter_by(OwnerID=ID).update({
            'BuildingNo':room[0],
            'RoomNo':room[1],
            'Area':Area
        })
        db.session.commit()
        return jsonify({
            'success': True,
            'message': '个人信息更新成功'
        })
    except Exception as e:
        db.session.rollback()
        print(e)
        return jsonify({
            'success': False,
            'message': str(e)
        })

#创建账单
@app.route('/home/pushbill/')
@admin_required
def push_bill():
    current_user = get_jwt_identity()
    bills = Fee_Standard.query.all()
    return render_template("Push_bill.html",bills=bills,datetime=datetime,username=current_user)

#建立账单
@app.route('/home/pushbill/create',methods=['POST'])
@admin_required
def push_bill_create():
    data = request.get_json()
    Property_name=data['Property_name']
    FreeType=data['FreeType']
    UnitPrice=data['UnitPrice']
    PropertyType=data['PropertyType']
    StartDate=data['StartDate']
    EndDate=data['EndDate']
    # print(f"{Property_name},{FreeType},{UnitPrice},{PropertyType},{StartDate},{EndDate}")
    new_Fee = Fee_Standard(Property_name=Property_name,
                 PropertyType=PropertyType,
                 FreeType=FreeType,
                 UnitPrice=UnitPrice,
                 StartDate=StartDate,
                 EndDate=EndDate)
    try:
        db.session.add(new_Fee)
        db.session.commit()
        return jsonify({
            'success': True,
            'message': '添加成功'
        })
    except Exception as e:
        db.session.rollback()
        print(e)
        return jsonify({
            'success': False,
            'message': "添加失败"+str(e)
        })

#删除账单
@app.route('/home/pushbill/delete',methods=['POST'])
@admin_required
def push_bill_delete():
    data = request.get_json()
    ID = data.get('id')
    Fee_Standard.query.filter_by(StandardID= ID).delete()
    try:
        db.session.commit()
        return jsonify({
            'success': True,
            'message': '删除成功'
        })
    except Exception as e:
        print(e)
        return jsonify({
            'success': False,
            'message': "删除失败"
        })

#发布账单
@app.route('/home/createbill/')
@admin_required
def create_bill():
    Fee_bills = Fee_Standard.query.all()
    bills = Property_Fee_Bill.query.all()
    return  render_template("Create_bill.html",Fee_bills=Fee_bills,bills=bills,datetime=datetime)

@app.route('/home/createbill/push',methods=['POST'])
@admin_required
def create_bill_push():
    data = request.get_json()
    selectBill = data['selectBill']
    deadline = data['deadline']
    fee_cycle = data['fee_cycle']
    Property_Type = data['Property_Type']
    fee=Fee_Standard.query.filter_by(StandardID=selectBill).first()
    try:
        for one in Property_Info.query.filter_by(PropertyType=Property_Type).all():
            newFee_Bill=Property_Fee_Bill(PersonID=one.OwnerID,
                              BillingCycle=fee_cycle,
                              TotalAmount=fee.UnitPrice*one.Area,
                              Status='未缴费',GenerateDate=str(datetime.datetime.now().date()),
                              DueDate=deadline)
            db.session.add(newFee_Bill)
            db.session.commit()
        return jsonify({
            'success': True,
            'message': '添加成功'
        })
    except Exception as e:
        db.session.rollback()
        print(e)
        return jsonify({
            'success': False,
            'message': "添加失败"+str(e)
        })

@app.route('/home/createbill/search',methods=['POST'])
@admin_required
def create_bill_search():
    bill_id = request.json.get('bill_id')
    bill = Fee_Standard.query.get(bill_id)
    return jsonify({
            'charge_type': bill.FreeType if bill else '',
            'rate': bill.UnitPrice if bill else 0  # 示例：同时返回费率
        })

#公告展示
@app.route('/home/bulletin/')
@admin_required
def bulletin():
    notices=Notice.query.all()
    return render_template("placard.html",notices=notices)

#创建公告
@app.route('/home/placard/crate/',methods=['POST'])
@admin_required
def placard_creat():
    data = request.get_json()
    title = data.get('title')
    expiry = data.get('expiry')
    content = data.get('content')
    print('标题:', title)
    print('有效期:', expiry)
    print('内容:', content)
    notice=Notice(Notice_name=title,Notice_Content=content,Notice_date=expiry)
    try:
        db.session.add(notice)
        db.session.commit()
        return jsonify({
            'success': True,
            'message': '发布成功'
        })
    except Exception as e:
        db.session.rollback()
        print(e)
        return jsonify({
            'success': False,
            'message': '添加失败'+str(e)
        })

#删除公告
@app.route('/home/placard/delete/',methods=['POST'])
@admin_required
def placard_delete():
    data = request.get_json()
    ID = data.get('id')
    Notice.query.filter_by(NoticeID=ID).delete()
    try:
        db.session.commit()
        return jsonify({
            'success': True,
            'message': '删除成功'
        })
    except Exception as e:
        print(e)
        return jsonify({
            'success': False,
            'message': "删除失败"
        })

#公告展示
@app.route('/api/recent_notices')
def get_latest_notice():
    # 获取最新公告
    notices = Notice.query.order_by(Notice.Notice_date.desc()).all()
    if notices:
        notices_data = [{
            "id": n.NoticeID,
            "title": n.Notice_name,
            "content": n.Notice_Content,
            "date": n.Notice_date.strftime("%Y-%m-%d")
        } for n in notices]
        return jsonify(notices_data)
    return jsonify({})

#付费账单
@app.route('/home/payFee/')
@jwt_required(optional=False)
def payFee():
    claims = get_jwt()
    print(claims)
    bills = db.session.query(Property_Fee_Bill).filter_by(PersonID=claims['id']).all()
    return render_template('payFee.html',bills=bills,datetime=datetime)

#付费账单-付费
@app.route('/home/payFee/pay/',methods=['POST'])
@jwt_required(optional=False)
def payFee_pay():
    data = request.get_json()
    BillID = data.get('id')
    try:
        Property_Fee_Bill.query.filter_by(BillID=BillID).update({'Status':'已缴费'})
        db.session.commit()
        return jsonify({
            'success': True,
            'message': '缴费成功'
        })
    except Exception as e:
        print(e)
        return jsonify({
            'success': False,
            'message': "缴费失败"
        })

#维修模块
@app.route('/home/repair_manager/')
@jwt_required(optional=False)
def repair_manager():
    repairs=Repair_Order.query.all()
    return render_template('repair_manager.html',repairs=repairs)

@app.route('/home/repair_user/')
@jwt_required(optional=False)
def repair_user():
    claims = get_jwt()
    ReporterID = claims['id']
    repairs=Repair_Order.query.filter_by(ReporterID=ReporterID).all()
    print(repairs)
    return render_template('repair_managr_user.html',repairs=repairs)

#添加维修
@app.route('/home/repair_manager/edit/',methods=['POST'])
@jwt_required()
def repair_manager_edit():
    claims = get_jwt()
    ReporterID=claims['id']
    data = request.get_json()
    repairTitle = data['repairTitle']
    selectType = data['selectType']
    Description = data['Description']
    Urgency = data['Urgency']
    Expected_date = data['Expected_date']
    repair = Repair_Order(ReporterID=ReporterID,Title=repairTitle,RepairType=selectType,Description=Description,
                 Urgency=Urgency, ExpectedTime=Expected_date,CreateTime=str(datetime.datetime.now().strftime("%Y/%m/%d %H:%M:%S")),
                          Status='待受理')
    try:
        db.session.add(repair)
        db.session.commit()
        return jsonify({
            'success': True,
            'message': '添加成功'
        })
    except Exception as e:
        db.session.rollback()
        print(e)
        return jsonify({
            'success': False,
            'message': '添加失败' + str(e)
        })

@app.route('/home/repair_manager/finish/',methods=['POST'])
@jwt_required(optional=False)
def repair_manager_finish():
    data = request.get_json()
    ID = data.get('id')
    Repair_Order.query.filter_by(OrderID=ID).update({'Status':'已完成',
                                                     'ActualFinishTime':str(datetime.datetime.now().strftime("%Y/%m/%d %H:%M:%S"))})
    try:
        db.session.commit()
        return jsonify({
            'success': True,
            'message': '成功'
        })
    except Exception as e:
        print(e)
        return jsonify({
            'success': False,
            'message': "失败"
        })

#应对访客
@app.context_processor
def inject_user():
    # try:
    verify_jwt_in_request(optional=True, locations=["cookies"])  # 安全检测，无 token 不报错
    #     claims = get_jwt()
    #     username = claims.get('name', '访客').strip("[]'")
    # except Exception:
    #     username = "访客"
    #     print('[*]没有token!!!')
    current_user = get_jwt_identity()
    apply_count = db.session.query(apply_user).count()
    Repair_count = db.session.query(Repair_Order).count()
    return dict(username=current_user, apply_row=apply_count,Reapir_count=Repair_count)
# 404
@app.errorhandler(404)
def page_not_found(e):
    return render_template('404.html'), 404
# 505
@app.errorhandler(500)
def page_not_found(e):
    return render_template('500.html'), 500
# 401
@app.errorhandler(401)
def page_not_found(e):
    return render_template('401.html'), 401

@app.route('/')
def root():
    return redirect(url_for('login'))

@app.route('/submit',methods=['GET','POST'])
def get():
    if request.method == 'POST':
        # a=request.form.get('a')
        return f"post"
    else:
        a = request.form.get('a')
        return f"Search get: {a}"


if __name__ == '__main__':
    app.run(debug=True)
