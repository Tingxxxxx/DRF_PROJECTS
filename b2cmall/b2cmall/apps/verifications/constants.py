# verifications用到的所有常量

EMAIL_REGEX = r"^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$"
EMAIL_FIELD_REQUIRED_ERROR = 'email欄位為必填'
INVALID_EMAIL_ERROR = '無效的email'
REPEAT_EMAIL_CODE_ERROR = '驗證碼已發送，請稍後再試'
EMAIL_CODE_TIMEOUT = 60*5
RE_SEND_TIMEOUT = 60*2
SUCCESS_SEND_CODE_REPONSE = '驗證碼已發送，請檢查您的電子信箱'
