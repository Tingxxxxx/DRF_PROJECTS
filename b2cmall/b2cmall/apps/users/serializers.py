from django_redis import get_redis_connection 
from rest_framework_simplejwt.tokens import RefreshToken
from rest_framework import serializers
from rest_framework_simplejwt.serializers import TokenObtainPairSerializer
from .models import User # 導入自訂義的用戶模型
from celery_tasks.verifycode.tasks import send_verification_email
import re
import logging



logger = logging.getLogger('django')

# 註冊視圖的序列化器
class CreateUserSerializer(serializers.ModelSerializer):
    """用戶註冊的序列化器"""
    # 新增當前 user 模型中沒有的 [password2、email_code、allow ] 三個欄位，這些欄位只在註冊時需要,不會存到用戶模型中
    # 設置 write_only=True 代表只能反序列化,接受來自用戶端的數據，但不會在返回數據時包含在序列化的結果中
    # 設置 read_only=True 代表只能序列化，該欄位會被序列化並包含在 API 的回應中
    password2 = serializers.CharField(label='確認密碼', write_only=True)
    email_code = serializers.CharField(label='驗證碼', write_only=True)
    allow = serializers.BooleanField(label='同意條款', write_only=True) 
    access = serializers.CharField(label= 'access_token', read_only=True) # 只做序列化，返回給前端
    refresh = serializers.CharField(label= 'refresh_token', read_only=True)  # 只做序列化，返回給前端

    def validate_allow(self, value):
        """驗證是否勾選同意條款"""
        if not value:
            raise serializers.ValidationError('必須同意條款才能註冊')
        return value

    def validate_mobile(self, value):
        """驗證手機格式"""
        if not re.match(r'^09\d{8}$', value):
            raise serializers.ValidationError('手機格式有誤') # 後端的 API 返回給前端的響應會是 {"non_field_errors": ['手機格式有誤']}
        return value # 驗證成功返回手機號
    
    def validate_email(self, value):
        """驗證信箱格式"""
        if not re.match(r'^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$', value):
            raise serializers.ValidationError('無效的email') 
        return value
    
    
    def validate(self, attrs):
        """密碼與驗證碼的驗證"""
        
        # 1. 驗證密碼是否一致
        if attrs['password'] != attrs['password2']:
            raise serializers.ValidationError('兩次輸入的密碼不相同')

        # 2. 獲取前端提交的 Email 和驗證碼
        email = attrs.get('email')
        code1 = attrs.get('email_code')

        # 3. 從 Redis 快取中獲取存儲的驗證碼
        # 注意: caches[''].get() 預設返回 str（如果存入時是字串），數字/列表會保持原類型
        # redis_conn = get_redis_connection("verify") 則會返回bytes
        # 存或取驗證碼兩邊要統一方式，get_redis_connection() or caches['']
        
        redis_conn = get_redis_connection('verify')
        code2 = redis_conn.get(f'verify_code_{email}') # 取出會是bytes類型

        if isinstance(code2, bytes):  # 只有 bytes 才decode()解碼
            code2 = code2.decode().strip() 

        # 4. 驗證碼檢查
        if not code2 or code1 != code2:  # code2=None代表該key過期了
            raise serializers.ValidationError('無效的驗證碼')

        # 5. 返回檢驗通過的完整字典
        return attrs
    
    def create(self, validated_data):
        """重寫新增User物件時的邏輯"""
        # 1. 前端提交過來的數據，驗證通過後刪除不需要的欄位
        del validated_data['email_code']
        del validated_data['allow']
        del validated_data['password2']
        
        # 2. 其餘欄位新增User模型物件  ['username','email', 'mobile', 'password']

        # 方式1 使用 objects.create_user() 自動處加密與保存
        # 前提:使用內建的User模型 或是 在自訂的User模型中有模型中有指定 objects = UserManager()      
        user = User.objects.create_user(**validated_data) # **解包字典，並用關鍵字參數方式傳參

        # 方式2: 使用set_password()
        # user = User(**validated_data)
        # pwd = validated_data.pop('password') # 從字典中移除並返回指定鍵對應的值
        # user.set_password(pwd) # 設置並加密密碼
        # user.save()

        # 3. 生成jwt token(refresh 與 access token)
        refresh = RefreshToken.for_user(user) # 這行代碼會根據使用者創建一對 JWT token
        user.access = str(refresh.access_token) # 有設定read_only,故只會返回給前端，但不會保存到資料庫
        user.refresh = str(refresh) # 有設定read_only,故只會返回給前端，但不會保存到資料庫

        return user
    
    class Meta:
        # 原本User模型中映射過來的欄位['id', 'username','email', 'moblie', 'password'] 
        # 在序列化中新增的欄位['password2', 'email_code','allow']
        model = User
        fields = ['id', 'username','email', 'mobile', 'password', 'password2', 'email_code','allow', 'access', 'refresh' ]

        # extra_kwargs 主要用來修改或擴展某些欄位的屬性，而不需要重新定義這些欄位
        extra_kwargs = {
            'username':{
                'min_length':5,
                'max_length':20,
                # 資料驗證失敗時，返回的錯誤訊息
                'error_messages':{ 
                   'min_length': '用戶名5~20 個字符', 
                   'max_length': '用戶名5~20 個字符'
                },   
            },
            'password':{
                    'min_length':8,
                    'max_length':30,
                    'write_only': True, # 只做反序列化,即接收前端傳來的數據
                    # 資料驗證失敗時，返回的錯誤訊息
                    'error_messages':{  
                       'min_length': '密碼長度8~20位',
                       'max_length': '密碼長度8~20位'
                    },
                }
        }
        
# 擴寫 simple_jwt 登入視圖所使用的序列化器
class MyTokenObtainPairSerializer(TokenObtainPairSerializer):

    def validate(self, attrs):
        # 父類 TokenObtainPairSerializer 繼承自 TokenObtainSerializer，
        # 而其 validate 方法中會執行以下邏輯：
        # self.user = authenticate(**authenticate_kwargs)
        # → authenticate 會驗證帳密是否正確，並回傳對應的 User 實例，
        #    最後會將該 User 物件賦值給 self.user
        
        # 調用父類的 validate 方法，會回傳一個包含 access 和 refresh token 的字典：
        # data = {"refresh": "...", "access": "..."}
        data = super().validate(attrs)

        # 在原本的 token 響應資料中，擴充回傳使用者的基本資訊
        data['username'] = self.user.username 
        data['user_id'] = self.user.id

        return data

class UserDetailSerializer(serializers.ModelSerializer):
    """用戶個人中心詳情序列化器"""
    class Meta:
        model = User
        fields = ['id', 'username', 'mobile', 'email', 'email_is_active'] # 只有這幾個欄位需要在用戶中心顯示


"""更新信箱並發送認證信 單獨視圖+單獨序列化器寫法，另用視圖集簡化重寫"""
# class EmailSerializer(serializers.ModelSerializer):
#     """信箱專用，既做序列化也做反序列化"""

#     def update(self, instance, validated_data):
#         """重寫此方法，是為了趁此時機順便發送激活連結"""
#         instance = super().update(instance, validated_data)
#         logger.info(f"使用者 {instance.username} 已修改信箱為 {instance.email}")
        
#         # 將發信任務添加到任務隊列
#         send_verification_email.delay(instance.email, '激活連結')
#         logger.info(f"使用者 {instance.username} 認證信件已發送")

#         return instance

#     class Meta:
#         model = User
#         fields = ['id', 'email']
