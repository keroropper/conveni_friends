# 刹那フレンド

瞬間的に付き合ってくれる人を探す、マッチングアプリです。

マッチングが成立するとその相手とチャットでやり取りをすることができます。

<img width="1440" alt="スクリーンショット 2023-08-13 15 13 46" src="https://github.com/keroropper/conveni_friends/assets/75570114/d675f23a-f825-4874-85b8-0844763dc4fd">

# 主な機能一覧

## 投稿機能

![投稿機能](https://github.com/keroropper/conveni_friends/assets/75570114/ae41a927-e350-4c2e-a0ab-acfbc1899dc8)

## 一覧ページ

![一覧ページ](https://github.com/keroropper/conveni_friends/assets/75570114/b5986e61-eef7-4d17-ace6-a3147af85b15)

## チャット機能

![チャット機能](https://github.com/keroropper/conveni_friends/assets/75570114/0a88d9ff-bc19-43ee-99c7-97abbee3e9db)

## ユーザー評価機能

![評価機能](https://github.com/keroropper/conveni_friends/assets/75570114/c3d7e8f0-7581-41bb-a28c-2123b3219ca3)

# URL
https://moment-friends.xyz/

画面右上の簡単ログインから、メールアドレスとパスワードを入力せずにログインできます。

# 使用技術

* Ruby3.1.1
* Ruby on Rails 6.1.7.3
* MySQL 5.7
* Nginx
* Puma
* AWS
  * VPC
  * ALB
  * RDS
  * S3
  * ECS
  * ECR
  * ElastiChache for Redis
  * Route 53
  * ACM
* Docker/Docker-compose
* GitHub Actions
* kaminari(ページネーション)
* RSpec
* Google Maps API

# AWS構成図
![AWS構成図](https://github.com/keroropper/conveni_friends/assets/75570114/471c6649-8803-4edf-92f8-0f596ababeb5)

## Github Actions
* githubへのプッシュ時に、RSpecとRubocopが自動で実行されます。
* RSpecとRubocop実行後にイメージをビルドしてECRへプッシュし、新しいイメージでECSタスクを更新します。

# 機能一覧
* ユーザー登録、ログイン、メール認証、パスワードリセット(devise)
* ユーザープロフィール編集機能
* ユーザー評価機能
* 投稿機能
  * 画像投稿(ActiveStorage)
  * 日程入力欄にカレンダーを表示(Flatpickr)
  * ジオコーディング(Google Maps API)
  * 投稿編集機能
* 応募機能
* 応募者を承認する機能(マッチング)
* チャット機能(ActionCable)
* いいね機能(Ajax)
* コメント機能(Ajax)
* ページネーション(kaminari)
* 通知機能(いいね、応募、承認、コメント、チャット)
* 投稿検索機能

# テスト
* RSpec
  * 単体テスト(model)
  * 機能テスト(request)
  * 統合テスト(system)
