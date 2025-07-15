# FROM 指令现在指向你刚刚推送到ACR的那个基础镜像
FROM crpi-y3hsqpqzq83olj2g.cn-shanghai.personal.cr.aliyuncs.com/caiyerz/mindie-base:latest
# 示例: FROM registry.cn-hangzhou.aliyuncs.com/myproject/mindie-base:latest

# 安装 code-server
RUN yum install -y curl && \
    curl -fsSL https://code-server.dev/install.sh | sh

# 设置工作目录
WORKDIR /data/home/3120240783

# 暴露端口
EXPOSE 8080

# 默认启动命令
CMD ["code-server", "--bind-addr", "0.0.0.0:8080", "--auth", "none", "."]
