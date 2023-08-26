# equivalent_exchange_api
等価交換の法則API

[![CI](https://github.com/koba-masa/equivalent_exchange_api/actions/workflows/ci.yml/badge.svg)](https://github.com/koba-masa/equivalent_exchange_api/actions/workflows/ci.yml)

## 起動手順
```sh
docker-compose up -d
docker-compose exec app bundle install
```

## Scenic
### 作成
```sh
docker-compose exec app bundle exec rails g scenic:view <view_name>
```

## JWT
### 作成
```sh
openssl genrsa 2024 > auth/service.key
```

## ログイン
| ユーザー | パスワード |
|:--|:--|
| `testuser1` | `test123` |
| `testuser2` | `test123` |
| `testuser3` | `test123` |
