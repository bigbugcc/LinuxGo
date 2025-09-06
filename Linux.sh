#!/bin/bash
# Debian 13 系统清理与优化脚本
# 使用前请确认风险 - 该脚本会删除大量系统记录和缓存文件

export root=

# 显示确认提示
echo "警告: 此脚本将执行系统深度清理，删除日志、缓存和临时文件"
echo "按 ENTER 继续或 CTRL+C 取消..."
read

# 系统更新
echo "=== 更新系统软件包 ==="
apt update
apt upgrade -y

# 卸载孤立包并清理不需要的依赖
echo "=== 卸载孤立软件包 ==="
apt autoremove --purge -y
apt clean -y

# 清理 systemd 日志 (Debian 13 增强版)
echo "=== 清理系统日志 ==="
journalctl --vacuum-time=1d
systemctl reset-failed

# 清空登录提示
echo "=== 清空登录提示 ==="
> $root/etc/motd
> $root/run/motd.dynamic
> $root/etc/issue.net

# 清空登录记录
echo "=== 清空登录记录 ==="
> $root/var/log/wtmp
> $root/var/log/btmp
> $root/var/log/lastlog
> $root/var/log/faillog

# 重置机器特征
echo "=== 重置机器特征 ==="
> $root/etc/machine-id
> $root/var/lib/dbus/machine-id
systemd-machine-id-setup

# 删除邮件名称和缓存
echo "=== 清理邮件相关文件 ==="
rm -f $root/etc/mailname
rm -rf $root/var/spool/mail/*
rm -rf $root/var/mail/*

# 删除命令历史和用户缓存
echo "=== 清理命令历史和用户缓存 ==="
rm -f $root/root/.bash_history
rm -f $root/root/.lesshst
rm -f $root/root/.viminfo
rm -f $root/root/.python_history
find $root/home -name .bash_history -delete
find $root/home -name .lesshst -delete
find $root/home -name .viminfo -delete
find $root/home -name .python_history -delete

# 删除包缓存 (Debian 13 增强版)
echo "=== 清理软件包缓存 ==="
rm -rf $root/var/cache/apt/*
rm -rf $root/var/lib/apt/lists/*
rm -rf $root/var/lib/dpkg/available*
rm -rf $root/var/cache/debconf/*
rm -rf $root/var/cache/fontconfig/*

# 删除安装记录
echo "=== 清理安装记录 ==="
rm -f $root/var/log/apt/*
rm -f $root/var/log/dpkg.log*
rm -f $root/var/log/bootstrap.log*
rm -f $root/var/log/alternatives.log*
rm -f $root/var/log/install_packages.list
rm -f $root/etc/apt/sources.list.d/localdebs.list

# 删除系统日志
echo "=== 清理系统日志 ==="
rm -f $root/var/log/debug*
rm -f $root/var/log/messages*
rm -f $root/var/log/syslog*
rm -rf $root/var/log/journal/*
find $root/var/log -name "*.log" -delete

# 删除归档和备份文件
echo "=== 清理归档和备份文件 ==="
find $root/etc -type f -name "*~" -delete
find $root/etc -type f -name "*-" -delete
find $root/var -type f -name "*-old" -delete
find $root/var/log -type f -name "*.[0-9]" -delete
find $root/var/log -type f -name "*.gz" -delete
find $root/var/log -type f -name "*.xz" -delete

# 清理临时文件 (Debian 13 增强版)
echo "=== 清理临时文件 ==="
rm -rf $root/tmp/*
rm -rf $root/var/tmp/*
rm -rf $root/var/cache/man/*
find $root/var/cache -type f -name "*.tmp" -delete
rm -rf $root/root/.cache/*
find $root/home -path "*/cache/*" -delete 2>/dev/null
find $root/home -path "*/.cache/*" -delete 2>/dev/null

# 清理CoreDump文件
echo "=== 清理CoreDump文件 ==="
rm -rf $root/var/lib/systemd/coredump/*

# 清理快照和备份
echo "=== 清理系统快照和备份 ==="
rm -rf $root/var/cache/apt/archives/*.deb
rm -rf $root/var/cache/debconf/*-old
rm -rf $root/var/backups/*

# 清理缩略图缓存
echo "=== 清理缩略图缓存 ==="
find $root/home -path "*/.thumbnails/*" -delete 2>/dev/null
find $root/home -path "*/.cache/thumbnails/*" -delete 2>/dev/null

echo "=== 系统清理完成 ==="