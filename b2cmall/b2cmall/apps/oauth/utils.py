# utils.py
from rest_framework.response import Response
import hashlib

def jwt_response(user, refresh, message):
    """生成jwt響應資料給前端"""
    response = {
        'status': 'success',
        'message': message,
        'username': user.username,
        'email': user.email,
        'user_id': user.id,
        'access': str(refresh.access_token),
        'refresh': str(refresh)
    }
    return response

def hash_uid(uid:str):
    """加密uid"""
    # uid.encode() 把 uid（原本是文字）編碼成 bytes（因為 hash 函數只接受 bytes）
    # hashlib.sha256(...).hexdigest()  對這個 bytes 進行 SHA256 雜湊運算，然後轉成十六進位格式的字串（64 字元）
    return hashlib.sha256(uid.encode()).hexdigest() # 輸出類似：'6c56fc9c7e3c2f2ac6c2e511979cf5b1e9cb2f90cc0ad8dc3d98efb9b9e90c85

