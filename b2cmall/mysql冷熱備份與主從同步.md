# MySQL 冷熱備份與主從同步 (Master-Slave Replication)
	( 以下以WSL2+docker 主從都在同一個IP為例)


## 1. 主機設定 (Master)

編輯MySql主機設定檔：

 `sudo vim /etc/mysql/mysql.conf.d/mysqld.cnf`
```bash
server-id               = 1
skip_name_resolve       = 1
log_bin                 = /var/lib/mysql/mysql-bin
binlog_format           = ROW
# binlog_do_db          = drf_mall   # 如要全庫同步，建議註解掉
```

## 2. 從機設定 (Slave)

在ubuntu中建立一個資料目錄，給從機 MySQL 容器掛載使用來持久化資料：
```bash
mkdir -p /my/mysql-slave/data
```

建立MySql從機設定資料夾與設定檔：
```bash
mkdir -p /my/mysql-slave/conf
sudo vim /my/mysql-slave/conf/my.cnf
```

從機my.cnf 範例如下:

 `sudo vim /my/mysql-slave/conf/my.cnf`
```bash
[mysqld]
port=3307            # 避免與主機的3306衝突
server-id=2          # 主機為1
log_bin=mysql-bin    #　打開binlog（二進制日誌）功能
relay-log=relay-bin　# 指定 relay log（中繼日誌） 的檔名前綴。
read_only=1          # 唯讀,除了root，其他帳號都不能直接寫入資料庫。
```

拉取鏡像檔，並建立從機MySql容器：
```bash
docker pull mysql:8.0.43

docker run -d --name mysql-slave \
  -e MYSQL_ROOT_PASSWORD=自訂 \
  --network host \                          # 主機與從機共用一個網路
  -v /my/mysql-slave/data:/var/lib/mysql \  # 掛載資料目錄，來持久化資料
  -v /my/mysql-slave/conf/my.cnf:/etc/mysql/conf.d/my.cnf \ # 掛載準備好的從機MySql設定檔
  mysql:8.0.43
```

## 3. 冷備份 (Dump 主機資料)

在主機執行：
```bash
mysqldump -u root -p drf_mall > drfbackup.sql  # 這裡只備份指定資料庫
```

若從機沒有該資料庫，需先建立：
```sql
CREATE DATABASE drf_mall;
```

匯入資料庫到從機：
```bashs
mysql -uroot -p -h xxx --port=3307 drf_mall < ~/drf_backup.sql
```

## 4. 在MySql主機建立從機用戶

在主機 MySQL 建立帳號：
```sql
CREATE USER 'slave-user'@'%' IDENTIFIED WITH mysql_native_password BY '自訂';
GRANT REPLICATION SLAVE ON *.* TO 'slave-user'@'%';
FLUSH PRIVILEGES;
```
- 注意: '%'→ 從任何ip都能用 slave-user'@'% 登錄,方便之後從機連線到主機

檢查主機 binlog 狀態,確認File與Position：
```sql
SHOW MASTER STATUS;

+------------------+----------+--------------+------------------+
| File             | Position | Binlog_Do_DB | Binlog_Ignore_DB |
+------------------+----------+--------------+------------------+
| mysql-bin.000001 |      154 |              |                  |
+------------------+----------+--------------+------------------+
```
## 5. 熱備份-進入從機設定同步

進入從機容器：
```bash
docker exec -it mysql-slave mysql -uroot -p
```

設定主機資訊：
```sql
CHANGE MASTER TO
  MASTER_HOST='主機ip',
  MASTER_USER='slave-user', # 之前在主機創建的用戶名
  MASTER_PASSWORD='自訂',
  MASTER_LOG_FILE='mysql-bin.000003', # 主機 SHOW MASTER STATUS 的 File
  MASTER_LOG_POS=1951;                # 主機 SHOW MASTER STATUS 的 Position
```

啟動複製：
```sql
START SLAVE;
```

## 6. 驗證同步狀態

驗證從機同步狀態：
```sql
SHOW SLAVE STATUS\G
```
關鍵欄位,如果兩個都是 Yes → 主從同步成功 ✅
**Slave_IO_Running: Yes**
**Slave_SQL_Running: Yes**

---
