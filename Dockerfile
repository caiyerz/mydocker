# -------------------- STAGE 1: Download Assets --------------------
# 使用一个轻量级的、网络通畅的镜像作为“下载器”
# 我们在这里使用一个基于 Alpine Linux 的镜像，因为它很小
FROM alpine:latest AS downloader

# 安装下载工具
RUN apk add --no-cache curl

# 设置工作目录
WORKDIR /downloads

# 从一个国内的镜像源下载 code-server，这会快很多且稳定
# 注意：你需要根据你的CPU架构选择正确的包 (amd64 vs arm64)
# 你的算力平台是 x86 架构，所以我们用 amd64
RUN curl -fL -o code-server.tar.gz https://github.com/coder/code-server/releases/download/v4.101.2/code-server-4.101.2-linux-amd64.tar.gz


# -------------------- STAGE 2: Main Build --------------------
# 回到你自己的 MindIE 基础镜像
FROM crpi-y3hsqpqzq83olj2g.cn-shanghai.personal.cr.aliyuncs.com/caiyerz/mindie-base:latest
# 示例: FROM registry.cn-hangzhou.aliyuncs.com/myproject/mindie-base:latest

# 创建安装目录
RUN mkdir -p /opt/code-server

# 从第一阶段 (downloader) 复制已经下载好的文件到当前阶段
COPY --from=downloader /downloads/code-server.tar.gz /opt/

# 进入目录并解压
RUN tar -xzf /opt/code-server.tar.gz -C /opt/code-server --strip-components=1

# (重要) 将 code-server 的可执行文件链接到系统路径，以便直接调用
RUN ln -s /opt/code-server/bin/code-server /usr/bin/code-server

# 设置工作目录
WORKDIR /data/home/3120240783

# 暴露端口
EXPOSE 8080

# 默认启动命令
CMD ["code-server", "--bind-addr", "0.0.0.0:8080", "--auth", "none", "."]
