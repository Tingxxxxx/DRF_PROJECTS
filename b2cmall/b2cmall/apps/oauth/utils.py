# utils.py
from rest_framework.response import Response


def jwt_response(user, refresh, message):
    """生成jwt響應資料給前端"""
    response = {
        'status': 'success',
        'message': message,
        'username': user.username,
        'email': user.email,
        'user_id': user.id,
        'access_token': str(refresh.access_token),
        'refresh_token': str(refresh)
    }
    return response
