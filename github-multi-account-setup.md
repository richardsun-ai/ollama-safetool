# GitHub多账户SSH配置指南

## 问题背景

当您需要在同一台计算机上使用多个GitHub账户时（例如个人账户和工作账户），会遇到SSH密钥认证的冲突问题，因为：

1. 一个SSH密钥只能关联到一个GitHub账户
2. 默认情况下，Git使用同一个SSH密钥连接到GitHub

## 解决方案

通过创建多个SSH密钥并配置SSH客户端，可以让不同的仓库使用不同的GitHub账户进行认证。

## 详细步骤

### 1. 为每个GitHub账户生成独立的SSH密钥

```bash
# 为第一个账户生成密钥（如果已有可跳过）
ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519_account1 -C "account1@example.com"

# 为第二个账户生成新密钥
ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519_account2 -C "account2@example.com"
```

### 2. 将SSH公钥添加到对应的GitHub账户

```bash
# 查看并复制第一个账户的公钥
cat ~/.ssh/id_ed25519_account1.pub

# 查看并复制第二个账户的公钥
cat ~/.ssh/id_ed25519_account2.pub
```

然后：
1. 登录第一个GitHub账户
2. 前往 Settings > SSH and GPG keys > New SSH key
3. 粘贴第一个公钥并保存
4. 对第二个账户重复相同步骤

### 3. 创建SSH配置文件

编辑或创建 `~/.ssh/config` 文件：

```bash
nano ~/.ssh/config
```

添加以下内容：

```
# 默认GitHub账户（account1）
Host github.com
  HostName github.com
  User git
  IdentityFile ~/.ssh/id_ed25519_account1

# 第二个GitHub账户（account2）
Host github.com-account2
  HostName github.com
  User git
  IdentityFile ~/.ssh/id_ed25519_account2
```

### 4. 测试SSH连接

```bash
# 测试第一个账户连接
ssh -T git@github.com

# 测试第二个账户连接
ssh -T git@github.com-account2
```

成功的响应应该是：
```
Hi accountname! You've successfully authenticated, but GitHub does not provide shell access.
```

### 5. 配置Git仓库使用正确的SSH密钥

#### 克隆新仓库

```bash
# 使用第一个账户克隆仓库
git clone git@github.com:account1/repo.git

# 使用第二个账户克隆仓库
git clone git@github.com-account2:account2/repo.git
```

#### 更新现有仓库的远程URL

```bash
# 更新为第一个账户的URL格式
git remote set-url origin git@github.com:account1/repo.git

# 更新为第二个账户的URL格式
git remote set-url origin git@github.com-account2:account2/repo.git
```

### 6. 验证配置

```bash
# 检查远程URL配置
git remote -v

# 尝试推送
git push -u origin main
```

## 常见问题排查

### 权限错误

如果遇到 "Permission denied" 错误：
1. 确认SSH密钥已添加到正确的GitHub账户
2. 检查远程URL是否使用了正确的Host别名
3. 验证SSH配置文件语法是否正确

### 测试特定密钥

```bash
# 强制使用特定密钥测试连接
ssh -i ~/.ssh/id_ed25519_account2 -T git@github.com
```

### 查看详细连接信息

```bash
# 显示详细的SSH连接过程
ssh -vT git@github.com-account2
```

## 使用示例

### 场景：在个人账户和工作账户之间切换

```bash
# 个人项目
mkdir ~/projects/personal
cd ~/projects/personal
git clone git@github.com:personal-account/project.git
cd project
git config user.email "personal@example.com"

# 工作项目
mkdir ~/projects/work
cd ~/projects/work
git clone git@github.com-work:work-account/project.git
cd project
git config user.email "work@example.com"
```

## 优势

1. 安全：每个账户使用独立的SSH密钥
2. 便捷：无需手动切换密钥或凭证
3. 清晰：仓库URL直观显示使用的是哪个账户
4. 可扩展：可以添加任意数量的GitHub账户

## 注意事项

1. 确保SSH配置文件权限正确：`chmod 600 ~/.ssh/config`
2. 记得为每个仓库设置正确的用户名和邮箱
3. 主机别名可以自定义，但要保持一致性 