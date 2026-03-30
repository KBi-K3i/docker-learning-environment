# This is Dockerfile.

# 公式Pythonイメージ：3.13を使用
FROM continuumio/miniconda3:latest

# コンテナに/appを作成し、cd /appした状態にする（作業場所を /app にする）
WORKDIR /app

# requirements.txt を コンテナの /app にコピー
COPY requirements.txt ./
# 予め、requirements.txtに以下を書き込んでおく。
# Flask==3.0.2
# python-dotenv
# Flask-SQLAlchemy

# （任意）condaを高速化＆安定化
RUN conda config --set channel_priority strict

# Python 3.13 の環境を作る（環境名: app）
# ※ 3.13 が解決できないタイミングもあるため、その場合は 3.12 に落とすと確実
RUN conda create -y -n app python=3.13 && \
    conda clean -afy

# conda環境を使って pip install
# 重要: conda環境に入ったpipで入れる
RUN conda run -n app python -m pip install --upgrade pip && \
    conda run -n app pip install --no-cache-dir -r requirements.txt

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
# > docker build --tag miniconda:py313-practice --file ./Dockerfile .
#
# コンテナの実行
# > docker run --detach \
#    --name miniconda-py313-practice-container \
#    --volume ~/dev/python:/app \
#    --workdir /app \
#    miniconda:py313-practice
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