# This is Dockerfile.

# 公式Pythonイメージ：3.13を使用
FROM python:3.13-slim

# コンテナに/appを作成し、cd /appした状態にする（作業場所を /app にする）
WORKDIR /app

# requirements.txt を コンテナの /app にコピー
COPY requirements.txt ./
# 予め、requirements.txtに以下を書き込んでおく。
# Flask==3.0.2
# python-dotenv
# Flask-SQLAlchemy

# pipの更新を実行してから、pip installを実行。
# requirements.txt に書かれたライブラリを一括インストール。
# pipのダウンロードキャッシュをイメージ内に残さない（最終イメージを少し軽くする）。
RUN pip install --upgrade pip && pip install --no-cache-dir -r requirements.txt

# Pythonのstdout/stderrをバッファリングせず、docker logs等に即時出力されるようにする
ENV PYTHONUNBUFFERED=1

# 今いるフォルダの中身を、コンテナの作業ディレクトリに全部コピーする
# COPY . .
# docker run 実行時に、--volumeしたディレクトリで隠れるため、COPY不要。

# sleep infinity を実行し、コンテナを常駐させる（VS Code からコンテナにつなぐ用途で使用）
CMD ["sleep", "infinity"]

# ---------- WSL 実行コマンド ----------
# 以下をWSLで実行する。
# 
# イメージのビルド（Dockerfile から Docker image を生成する）
# > docker build --tag python:3.13-practice-image --file ./Dockerfile .
#
# コンテナの実行
# > docker run --detach \
#    --name python3.13-practice-container \
#    --volume ~/dev/python:/app \
#    --workdir /app \
#    python:3.13-practice-image
#    
# 解説
# 1行目：コンテナ起動。TTYからのdetachを行う（バックグラウンド起動）
# 2行目：コンテナに「python3.13」という名称をつける。
# 3行目：指定したWSL側のディレクトリを、コンテナから見えるようにする（バインドマウント）。これによって、コンテナ側でファイルを編集すれば、それが WSL側にも反映される（コードはWSLに残し、コードの実行はコンテナ内で行う方式になる）。
# 4行目：コンテナ内の作業ディレクトリを /app にする（attach 後のターミナル位置）
# 5行目：RUNコマンドの実行対象となるイメージ名。
#
# ログの確認（任意）
# > docker logs python3.13-practice-container
#
# 不要ファイルをビルドに入れない方法（イメージのビルド前に実施）
# touch .dockerignore   
# 以下を書き込む
# __pycache__/
# *.pyc
# .venv/
# .git/
# .DS_Store
#.pytest_cache/
# .mypy_cache/
# .ruff_cache/
# dist/
# build/
# .coverage
# *.log
# node_modules/
#
# ---------- VSCodeでDockerコンテナを開く方法 ----------
# 以下の拡張機能を入れる
# Dev Containers（必須）
# Python（コンテナ内）
# Docker（任意）
# サイドバーの「Containers」を選択。任意のコンテナを左クリックし、「Attach Visual Studio Code」を選択。
# 接続後、手動で/appを開く（デフォルトでは/rootがカレントディレクトリになっている）。