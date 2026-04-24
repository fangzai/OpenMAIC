#!/bin/bash

# ==========================================
# OpenMAIC 自动重启与后台运行脚本
# ==========================================

TARGET_PORT=28002
LOG_FILE="maic_run.log"

echo "🔍 [1/3] 检查端口 $TARGET_PORT 的占用情况..."

# 使用 lsof 查找占用端口的进程 ID (PID)
PID=$(lsof -t -i:$TARGET_PORT)

if [ -n "$PID" ]; then
    echo "⚠️ 发现旧进程 (PID: $PID) 正在运行，准备终止..."
    kill -9 $PID
    echo "✅ 旧进程已成功清理。"
    sleep 2 # 稍微等待 2 秒，确保系统彻底释放该端口
else
    echo "ℹ️ 端口 $TARGET_PORT 当前空闲，无需清理。"
fi

echo "🚀 [2/3] 准备在端口 $TARGET_PORT 启动服务..."

# 使用 nohup 在后台运行，并注入 PORT 环境变量
# 日志会追加写入到 maic_run.log 文件中
nohup env PORT=$TARGET_PORT pnpm start > $LOG_FILE 2>&1 &

echo "🎉 [3/3] 服务已在后台成功启动！"
echo "------------------------------------------"
echo "📄 实时查看运行日志请输入命令: tail -f $LOG_FILE"
echo "🛑 如果要彻底停止服务，请再次运行此脚本，然后按 Ctrl+C 中断日志即可。"
echo "------------------------------------------"
