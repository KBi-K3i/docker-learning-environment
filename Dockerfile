# Dockerfile

# Java 21 (JDK) - Eclipse Temurin
# ビルドは、VScodeでこのコンテナにアクセスし、Spring Bootプロジェクトを作り、mvnwで行う。
FROM eclipse-temurin:21-jdk

# コンテナに/appを作成し、cd /app/java21した状態にする（作業場所を /app/java21 にする）
WORKDIR /app/java21

# gitとcurlをインストールする
RUN apt-get update \
 && apt-get install -y --no-install-recommends git curl \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# apt-get clean \ <-- ダウンロードした .deb パッケージを消す（イメージサイズを小さくする）
# rm -rf /var/lib/apt/lists/* <-- パッケージの詳細情報一覧（目録）を消す（イメージサイズを小さくする）

# sleep infinity を実行し、コンテナを常駐させる（VS Code からコンテナにつなぐ用途で使用）
CMD ["sleep", "infinity"]

# ---------- WSL 実行コマンド ----------
# 以下をWSLで実行する。
# 
# イメージのビルド
# > docker build --tag java21-image .
# 
# コンテナの実行
# > docker run --detach \
#   --name java21-practice-container \
#   --publish 8080:8080 \
#   --volume ~/docker-volume/java:/app/java21 \
#   --volume ~/.m2:/root/.m2 \
#   --workdir /app/java21 \
#   java21-image
# 
# 解説
# 1行目：コンテナ起動。stop時にコンテナを自動で削除。
# 2行目：ホストの8080ポートをコンテナの8080ポートにマッピング
# 3行目：WSL側のディレクトリをコンテナから見えるようにする（バインドマウント）。これによって、コンテナ側でファイルを編集すれば、それが WSL側にも反映される。
# 4行目：依存関係(jar)を毎回ダウンロードすると遅くなるので、ホストの依存関係を参照するようにする。
# 5行目：コンテナ起動時の「カレントディレクトリ」を指定する
# 6行目：ビルドしたイメージの名称（java21-imageをrun）
#
# ---------- コンテナ起動後に手動で実行 ----------
# 以下をコンテナ内で実行する。
#
# ビルドのテスト
# ./mvnw test
# 
# ビルド
# ./mvnw clean package
# 
# ./mvnw: Permission denied となった場合、実行権限を付与する。
# chmod +x mvnw
# 
# ---------- VSCodeの拡張機能 ----------
# Java
# Spring Boot Extension Pack
# 
# ---------- Spring Boot プロジェクトの作成
# F1キーを押下
# Spring Initializer:Create a Maven project を選択