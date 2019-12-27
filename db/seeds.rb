# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
I18n.locale = :"zh-CN"

# Category.create(name: '职业', code_name: "occupation")
# Category.create(name: '兴趣爱好', code_name: "hobby")


# category = Category.find_by(name: '职业')

# %w(制图员与摄影测绘师 制图师 物流师 土木工程师 石油工程师 轮机工程师与造船师 勘测员 景观建筑师 建筑师 健康与安全工程师 机械工程师 环境工程师 化学工程师 
# 核工程师 航空航天工程师 工业工程师 电子工程师 电气与电子工程师 城市及区域规划师 材料工程师 运营分析师 预算分析师 统计师 市场分析师 精算师 金融审计师 
# 金融分析师 会计师与审计师 管理分析师 个人理财顾问 成本估算师 不动产估价师与评估师 保险理赔师 人力资源专员 信息安全分析师 网络与计算机系统管理员 计算机硬件工程师 
# 网站开发师 数据库管理员 计算机系统分析师 网络架构师 软件开发师 程序员 展览设计师 平面设计师 工业设计师 室内设计师 花艺设计师 摄影师 时装设计师 工艺美术家 舞台管理 
# 医师 药剂师 牙医 兽医（职业） 足医 注册护士 助理医生 职业治疗师 语音语言病理学家 心理医生 物理治疗师 听力学家 配镜师 生物医学工程师 社会工作者 康复咨询师 职教教师 
# 幼师及小学教师 学前教师 学生辅导员 图书馆员 特教教师 助教 高中教师 初中教师 职业顾问 大学教师 档案管理员 计算机科学家 医学家 野生动物生物学家 微生物学家 生物化学家与生物物理学家 
# 流行病学家 动物学家 土壤与植物学家 数学家 物理学家和天文学家 化学家 环境学家 地质学家 地理学家 水文学家 大气科学家 政治学家 社会学家 人类学家 历史学家 考古学家 经济学家 
# 律师 法医 法官 律师助理 法庭书记员 记者 播音员 翻译 会展策划 编辑 营养师 食品科学家 林务).each do |tag_name|
  
#   Tag.create( name: tag_name, category_id: category.id )

# end

Region::Country.where(name:'中国', code: 'CN').first_or_create

# comment notification template
NotificationTemplate.where(
  title: "有人@你了",
  body: '#{user.username}评论了你的帖子',
  tag: 'comment'
).first_or_create

# reply notification template
NotificationTemplate.where(
  title: "有人@你了",
  body: '#{user.username}回复了你的评论',
  tag: 'reply'
).first_or_create

# NotificationTemplate.create(
#   title: "欢迎加入多度"，
#   body: '#{user.username}回复了你的评论'
# )

(3.month.ago.to_date ... Time.now.to_date).each do |date|
  Warehouse::DateDimension.find_dimension_for(date)
end

survey = Survey.where(title: '提交错误', code_name: 'report_post').first_or_create
SurveyOption.where(body: 'TA是中介', position: 0, survey_id: survey.id).first_or_create
SurveyOption.where(body: '虚假房源', position: 1, survey_id: survey.id).first_or_create
SurveyOption.where(body: '其他', position: 2, custom_option: true, survey_id: survey.id).first_or_create
