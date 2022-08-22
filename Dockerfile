# ---- ビルドステージ ----
# ビルドステージ用にgo 1.18イメージを使用
# builderという名前にする
FROM golang:1.18 as builder

# 作業ディレクトリ指定
ENV APP_HOME /app
WORKDIR $APP_HOME

# 依存ライブラリファイルコピー
COPY go.* .
# 依存ライブラリダウンロード
RUN go mod download

# ソースファイルコピー
COPY . .
# ソースファイルを「app」という名前にビルド
RUN go build -v -o app

# ----- 実行ステージ ----
# 実行用にdebian buster-slim(普通のbusterより軽いやつ)を指定
FROM debian:buster-slim
# 作業ディレクトリを/appにする。
WORKDIR $APP_HOME
# ビルドステージコンテナからビルドしたアプリケーションをコピー
COPY --from=builder ./app ./
# 実行コマンド
CMD ./app