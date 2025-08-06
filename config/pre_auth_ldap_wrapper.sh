#!/bin/bash
# 该脚本从环境变量获取 LDAP 配置和用户凭据
# 环境变量 RAD_USERNAME 和 RAD_USER_PASSWORD 由 FreeRADIUS 的 exec 模块设置
# 环境变量 ldap_server 和 ldap_basedn 从 .env 文件加载（通过 docker-compose）

USERNAME="$RAD_USERNAME"
PASSWORD="$RAD_USER_PASSWORD"
# 从环境变量获取 LDAP 配置
LDAP_SERVER="${ldap_server:-127.0.0.1}" # 默认值作为后备
BASE_DN="${ldap_basedn:-dc=example,dc=com}" # 默认值作为后备

# 检查必要变量是否存在
if [[ -z "$USERNAME" || -z "$PASSWORD" ]]; then
    echo "Error: Username or password not provided by FreeRADIUS." >&2
    exit 1 # 脚本失败，但 exec 模块配置为 wait=yes 且在 authorize 早期，可能影响流程
         # 更稳妥的做法是总是返回 0，让 FreeRADIUS 继续处理，日志记录错误即可
fi

if [[ -z "$LDAP_SERVER" || -z "$BASE_DN" ]]; then
    echo "Warning: LDAP_SERVER or BASE_DN not set from environment. Using defaults or script may fail." >&2
    # 可以选择退出或使用默认值（已在变量赋值时设置）
fi

echo "Pre-auth trigger: Attempting to bind user '$USERNAME' to LDAP server '$LDAP_SERVER'"

# 使用 ldapwhoami 或 ldapsearch 进行一次简单的绑定操作
# 这会触发 AzureAD-LDAP-wrapper 的认证逻辑
# 注意：需要在 Docker 容器内安装 ldap-utils (libldap-common ldap-utils on Ubuntu/Debian)
# -x: 简单认证 (Simple Bind)
# -D: Bind DN (这里直接用用户名，假设它可以直接用于绑定)
# -w: 密码
# -H: LDAP URI
# 重定向输出到 /dev/null，只关心返回码
ldapwhoami -x -D "$USERNAME" -w "$PASSWORD" -H "ldap://$LDAP_SERVER" > /dev/null 2>&1
BIND_RESULT=$?

if [ $BIND_RESULT -eq 0 ]; then
    echo "Pre-auth trigger: LDAP bind for '$USERNAME' successful (or at least attempted)."
    # 成功触发了 LDAP-wrapper 的流程（无论最终认证成功与否）
else
    # 绑定失败很常见（尤其是密码错误），这里仅记录日志
    # 关键是触发了 LDAP-wrapper 去检查/更新 sambaNTPassword
    echo "Pre-auth trigger: LDAP bind for '$USERNAME' failed (exit code $BIND_RESULT). This might be expected if it triggers the wrapper's first-time logic."
fi

# 无论 ldapwhoami 的结果如何，脚本都应返回成功，
# 以确保 FreeRADIUS 继续执行后续的 authorize 阶段 (ldap 模块会再次查询)
# FreeRADIUS 会根据 ldap 模块查询到的更新后的 sambaNTPassword 来判断最终认证结果
exit 0
