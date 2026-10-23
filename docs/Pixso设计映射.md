# Pixso 设计到 Flutter 页面映射

源文件：**Comuni Social Media app**。页面：**Comuni Social Media App**。读取到 31 个 414 × 896 的顶层手机画板，原稿的名称拼写保留在下表。

同一表单的 Empty / Info 状态合并为可填写页面。原稿中同名的 `Messages - Delete` 包含会话滑动、故事和直播三类画板，依据实际内容分别实现。

| 节点 | Pixso 画板 | 原始导出 | 应用运行截图 |
| --- | --- | --- | --- |
| 2:8 | Splash | [查看](design/2-8.png) | [启动页](screenshots/01-splash.png) |
| 2:15 | On-Baording 01 | [查看](design/2-15.png) | [引导页一](screenshots/02-onboarding-1.png) |
| 2:49 | On-Baording 02 | [查看](design/2-49.png) | [引导页二](screenshots/03-onboarding-2.png) |
| 2:85 | On-Baording 03 | [查看](design/2-85.png) | [引导页三](screenshots/04-onboarding-3.png) |
| 2:122 | Welcome | [查看](design/2-122.png) | [欢迎页](screenshots/05-welcome.png) |
| 2:138 | Register  - Empty State | [查看](design/2-138.png) | [注册（空白）](screenshots/06-register-empty.png) |
| 2:174 | Register - Info State | [查看](design/2-174.png) | [注册（已填写）](screenshots/07-register-filled.png) |
| 2:232 | Phone Number - Empty State | [查看](design/2-232.png) | [手机号（空白）](screenshots/08-phone-empty.png) |
| 2:299 | Phone Number - Info State | [查看](design/2-299.png) | [手机号（已填写）](screenshots/09-phone-filled.png) |
| 2:367 | Vreification - Empty Satte | [查看](design/2-367.png) | [验证码（空白）](screenshots/10-verify-empty.png) |
| 2:399 | Verification - Info State | [查看](design/2-399.png) | [验证码（已填写）](screenshots/11-verify-filled.png) |
| 2:424 | Login - Empty State | [查看](design/2-424.png) | [登录（空白）](screenshots/12-login-empty.png) |
| 2:452 | Login - Info State | [查看](design/2-452.png) | [登录（已填写）](screenshots/13-login-filled.png) |
| 2:491 | Forget - Empty Sate | [查看](design/2-491.png) | [忘记密码（空白）](screenshots/14-forgot-empty.png) |
| 2:504 | Forget - Info State | [查看](design/2-504.png) | [忘记密码（已填写）](screenshots/15-forgot-filled.png) |
| 2:544 | Home | [查看](design/2-544.png) | [首页动态](screenshots/16-home.png) |
| 2:2061 | Notification | [查看](design/2-2061.png) | [通知](screenshots/17-notifications.png) |
| 2:1887 | Comments | [查看](design/2-1887.png) | [评论](screenshots/18-comments.png) |
| 2:1551 | Search Reselts | [查看](design/2-1551.png) | [搜索结果](screenshots/19-search.png) |
| 2:920 | Profile | [查看](design/2-920.png) | [公开个人主页](screenshots/20-public-profile.png) |
| 2:742 | Messages - Delete | [查看](design/2-742.png) | [消息滑动删除](screenshots/38-message-swipe.png) |
| 2:837 | Messages - Chat | [查看](design/2-837.png) | [聊天会话](screenshots/22-chat.png) |
| 2:1033 | Post | [查看](design/2-1033.png) | [动态详情](screenshots/24-post-detail.png) |
| 2:656 | Messages | [查看](design/2-656.png) | [消息列表](screenshots/21-messages.png) |
| 2:1118 | Messages - Delete | [查看](design/2-1118.png) | [直播故事演示](screenshots/32-live-story.png) |
| 2:1392 | Create Group | [查看](design/2-1392.png) | [创建群组](screenshots/23-create-group.png) |
| 2:1198 | Personal Profile | [查看](design/2-1198.png) | [我的主页](screenshots/25-my-profile.png) |
| 2:1606 | Setting | [查看](design/2-1606.png) | [设置](screenshots/30-settings.png) |
| 2:1672 | Edit Profile | [查看](design/2-1672.png) | [编辑资料](screenshots/26-edit-profile.png) |
| 2:1732 | Uploab Photo | [查看](design/2-1732.png) | [发布动态（空白）](screenshots/27-compose-empty.png) |
| 2:1843 | Messages - Delete | [查看](design/2-1843.png) | [故事](screenshots/31-story.png) |

## 设计参数

- 基准画板：414 × 896。
- 渐变：`#7C6AF3` → `#44A5F5`。
- 正文主色：`#2F2F2F`，次要文字：`#A1A1A1`。
- Poppins Regular / SemiBold；Logo 直接导出原始图形。
- 照片、人物头像、故事封面与三张引导插画均从原稿导出为本地 PNG。
- 动态卡片使用白色与柔和阴影，照片采用约 16–20 的圆角；主页面水平留白约 35。

## 实现调整

增加了表单错误反馈、验证码演示说明、密码显隐、系统相册选择、群组成员选择、会话删除确认、无结果／收藏空状态，以及本地存储异常提示。

原始设计采用不可滚动的定高画板；应用改为安全区域与滚动布局，以支持真实键盘、窄屏和横屏。认证内容中的占位文案与部分拼写按原稿保留。短信、第三方认证、真实通话和直播未接入外部服务。

[返回项目说明](../README.md)
