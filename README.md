# studentChoseClassProject（选课管理系统）

这是一个“学生选课/教师录入成绩/管理员维护基础数据”的完整示例项目，采用**前后端分离**架构：

- 后端：`CourseManagerApi - idea/`（Spring Boot + MyBatis-Plus + MySQL）
- 前端：`CourseManagerVue/`（Vue + Element Plus + Axios）
- 数据库脚本：根目录 `course_manager.sql`

下面按“目录/文件”的粒度说明本仓库每一部分在项目中的作用，方便在 GitHub 上快速理解项目结构与职责边界。

---

## 1. 根目录文件说明

- `.gitignore`
  - 当前只忽略了 `.vscode/settings.json`（内容非常少）。项目里还包含了 `node_modules/`、`dist/`、`target/`、`.idea/`、`.DS_Store` 等大体积/本机文件，通常也建议加入忽略列表（可按需要自行调整）。
- `.vscode/settings.json`
  - VS Code 的工作区设置（例如格式化、缩进、语言服务等 IDE 行为）。不影响运行逻辑。
- `course_manager.sql`
  - MySQL 数据库初始化脚本（建表 + 示例数据）。后端默认连接的数据库名也是 `course_manager`。
  - 主要表：`rc_admin`、`rc_department`、`rc_major`、`rc_class`、`rc_teacher`、`rc_course`、`rc_student`、`rc_student_course`、`rc_option`。
  - 课程时间字段 `rc_course.course_time` 使用类似 `2-2-2` 的格式（见“数据库字段约定”一节）。

---

## 2. 后端：`CourseManagerApi - idea/`（Spring Boot）

### 2.1 后端根目录文件

- `CourseManagerApi - idea/pom.xml`
  - Maven 构建配置：Spring Boot `2.7.18`，Java `17`，依赖 `spring-boot-starter-web/aop/validation`、`mysql-connector-java`、`mybatis-plus-boot-starter`。
  - 配置了 `frontend-maven-plugin` 用于安装 Node/NPM（该插件只“安装”，并不等价于前端构建流水线）。
- `CourseManagerApi - idea/node/`
  - Node/NPM 可执行文件（`node`、`npm`、`npx` 等）。这类文件通常用于特定环境下“捆绑”运行时，避免开发机差异。
- `CourseManagerApi - idea/target/`
  - Maven 编译产物目录（生成的 `.class`、打包中间文件等）。非源代码，一般不建议提交到仓库。
- `CourseManagerApi - idea/.idea/`
  - IntelliJ IDEA 工程配置目录（个人/机器差异较大，一般不建议提交到仓库）。

### 2.2 后端配置与资源：`CourseManagerApi - idea/src/main/resources/`

- `CourseManagerApi - idea/src/main/resources/application.yaml`
  - Spring Boot 配置：服务端口、MySQL 连接信息、Jackson 时区、MyBatis-Plus 的 mapper 扫描路径等。
  - 注意：其中包含数据库账号密码，实际部署/开源时建议改为环境变量或私密配置。
- `CourseManagerApi - idea/src/main/resources/mapping/*.xml`
  - MyBatis 自定义 SQL 映射文件（复杂查询/多表 JOIN/分页统计等）。
  - 示例：`StudentCourseMapping.xml` 包含学生已选课程、考试列表、课表、教师评分分页等查询。

### 2.3 后端主代码：`CourseManagerApi - idea/src/main/java/com/rabbiter/cm/`

#### 入口

- `CourseManagerApi - idea/src/main/java/com/rabbiter/cm/CourseManagerApplication.java`
  - Spring Boot 启动类（`main` 方法入口）。

#### 分层结构（Controller / Service / Manager / DAO）

后端整体采用分层设计：

- `controller/`：对外提供 REST API，参数校验，调用 Service 返回统一结构 `ResultVO`。
- `service/`：业务编排层，组合多个 Manager/DAO，返回 `ResultVO`。
- `manager/`：更偏“领域/事务”的数据操作层，封装跨 DAO 的事务逻辑（例如选课时先增加课程已选人数再插入选课记录）。
- `dao/` + `dao/mapper/`：与数据库交互（MyBatis-Plus Mapper + 自定义 XML SQL）。

对应重要文件/目录说明如下：

- `CourseManagerApi - idea/src/main/java/com/rabbiter/cm/controller/`
  - `BaseController.java`：控制器基类，提供 `result()` / `failedResult()` 等快捷返回。
  - `HomeController.java`：简单连通性接口（`/`、`/test`）。
  - `UserController.java`：登录/登出/登录态查询（`/user/login`、`/user/login/status`、`/user/logout`）。
  - `OptionController.java`：系统开关读取/设置（如是否允许选课、是否允许教师录分）。
  - `controller/admin/*`：管理员端接口（院系/专业/班级/学生/教师/课程/选课记录/管理员等 CRUD 与分页）。
  - `controller/student/*`：学生端接口（可选课程分页、已选课程、课表、考试、成绩、个人信息维护等）。
  - `controller/teacher/*`：教师端接口（授课查询、课表、成绩录入/分页等）。
- `CourseManagerApi - idea/src/main/java/com/rabbiter/cm/service/`
  - `BaseService.java`：Service 基类，从 `HttpSession` 读取登录态，并提供统一 `ResultVO` 返回方法。
  - `UserService.java`：登录逻辑（校验用户、写入 Session 登录态等）。
  - `OptionService.java`：读取/写入 `rc_option` 表中的系统开关。
  - `service/admin/*`、`service/student/*`、`service/teacher/*`：按角色划分的业务服务。
- `CourseManagerApi - idea/src/main/java/com/rabbiter/cm/manager/`
  - `LoginStatusManager.java`：在 `HttpSession` 中读写 `LoginStatusBO`（登录态缓存）。
  - `UserManager.java`：按用户类型查询认证信息、更新学生最后登录时间等。
  - `OptionManager.java`：读取系统开关（是否允许选课/录分）。
  - `manager/admin/*`、`manager/student/*`、`manager/teacher/*`：按角色划分的数据操作与事务逻辑。
- `CourseManagerApi - idea/src/main/java/com/rabbiter/cm/dao/`
  - `BaseDAO.java`：DAO 基类（通常提供分页计算等公共方法）。
  - `*DAO.java`：每个表/聚合的数据库访问封装（结合 MyBatis-Plus 与 XML 自定义查询）。
- `CourseManagerApi - idea/src/main/java/com/rabbiter/cm/dao/mapper/`
  - `*Mapper.java`：MyBatis-Plus Mapper 接口；部分方法映射到 `resources/mapping/*.xml` 里的 SQL。
- `CourseManagerApi - idea/src/main/java/com/rabbiter/cm/model/`
  - `entity/`：与表字段对应的实体类（如 `StudentEntity`、`CourseEntity` 等）。
  - `bo/`：业务对象（Business Object），用于 Service/Manager 间传递更贴近业务的结构。
  - `vo/`：视图对象（View Object），用于对外接口返回/请求（如分页表格 item、登录表单等）。
  - `constant/`：常量定义（如 `UserType`、`HttpStatusCode`）。
- `CourseManagerApi - idea/src/main/java/com/rabbiter/cm/config/`
  - `WebConfig.java`：注册权限拦截器 `ThemisInterceptor`；并配置 CORS（允许 `localhost/127.0.0.1`）。
  - `MybatisPlusConfig.java`：MyBatis-Plus 相关配置（如分页插件等，具体以文件内容为准）。
  - `TimeZoneConfig.java`：时区相关配置（保证前后端时间一致）。
  - `config/themis/*`：轻量权限框架（见下一节）。
  - `config/aop/ResultFailedCodeAspect.java`：当 `ResultVO.code == FAIL` 时，将 HTTP 状态码设为 `406`。
  - `config/aop/ControllerLogAspect.java`：控制器日志切面（当前文件内容整体被注释，等同于“未启用”）。
  - `config/handler/BindExceptionHandler.java`：参数校验失败时返回 `INVALID_PARAMETER`；并对异常信息做了字符串级别的“归类处理”。
- `CourseManagerApi - idea/src/main/java/com/rabbiter/cm/util/`
  - `Md5Encrypt.java`：MD5 加密工具（用于密码处理等）。
  - `LessonTimeConverter.java`：课程时间字段转换（把后端存储格式转换为前端显示格式）。

#### 权限与登录：`config/themis/*`

后端使用拦截器 + 注解的方式实现“登录与权限控制”：

- `CourseManagerApi - idea/src/main/java/com/rabbiter/cm/config/themis/ThemisInterceptor.java`
  - 对每个请求在进入 Controller 前做权限校验：是否需要登录、用户类型是否匹配、权限位是否满足。
- `CourseManagerApi - idea/src/main/java/com/rabbiter/cm/config/themis/annotation/*.java`
  - `@Student`、`@Teacher`、`@Admin`、`@Login`、`@NoLimit`：标记接口需要的身份/权限。
  - `Admin.java` 内定义了权限位：院系/专业/班级/学生/教师/课程/选课/管理员（与前端 `Permission` 一一对应）。
- `CourseManagerApi - idea/src/main/java/com/rabbiter/cm/manager/LoginStatusManager.java`
  - 登录态存储在 Session 中，前端通过 `withCredentials` 携带 Cookie。

---

## 3. 前端：`CourseManagerVue/`（Vue + Element Plus）

### 3.1 前端根目录文件

- `CourseManagerVue/package.json`
  - 前端依赖与脚本入口：`serve/dev/build/lint`。
  - 使用 `Vue 3`、`vue-router`、`vuex`、`element-plus`、`axios`、`echarts` 等。
- `CourseManagerVue/package-lock.json`
  - npm 锁定依赖版本（保证可复现安装）。
- `CourseManagerVue/vue.config.js`
  - Vue CLI 配置：关闭 ESLint 保存校验；开发服务器运行在 `127.0.0.1:3000`。
- `CourseManagerVue/.eslintrc.js` / `.browserslistrc` / `babel.config.js` / `.npmrc`
  - 工程化配置：ESLint、目标浏览器、Babel、npm 行为等。
- `CourseManagerVue/node_modules/`
  - 前端依赖安装目录（生成物，体积很大，一般不建议提交到仓库）。
- `CourseManagerVue/dist/`
  - 前端打包产物（`npm run build` 生成）。用于静态部署，一般也不建议提交到仓库（除非你明确要“提交构建产物”）。
- `CourseManagerVue/.idea/`
  - IDEA/WebStorm 配置目录（同样属于 IDE 生成物）。

### 3.2 前端入口与全局状态：`CourseManagerVue/src/`

- `CourseManagerVue/src/main.js`
  - Vue 应用入口：创建 app、注册 Element Plus、挂载路由与 Vuex。
  - 将 `store`、`router` 挂到 `vueInstance`（供 `ajax.js` 的拦截器在全局使用）。
- `CourseManagerVue/src/router.js`
  - 路由定义：以 `Container.vue` 作为布局容器，按角色划分子路由（学生/教师/管理员）。
  - 说明：该文件中出现了 `Vue.use(VueRouter);`（更像 Vue2 写法），但项目依赖是 Vue3 + `createRouter`。如果你遇到路由初始化报错，这里可能需要清理/修正。
- `CourseManagerVue/src/store.js`
  - Vuex 全局状态：保存登录态（`loggedIn/userId/username/userType/permission`）、侧边栏菜单、全局 loading 状态。
  - `login` mutation 会根据权限位过滤出当前用户可见的侧边栏菜单项。

### 3.3 网络请求封装：`CourseManagerVue/src/common/ajax.js`

- 统一封装 Axios：
  - `baseURL` 来自 `CourseManagerVue/src/common/config.js`（默认 `http://localhost:8080`）。
  - `withCredentials: true`：携带 Cookie（配合后端 Session 登录态）。
  - 响应拦截：后端返回 `ResultVO` 结构时，前端默认取 `response.data.data` 作为业务数据。
  - 错误处理：根据 `ResultVO.code`（未登录/权限不足/参数错误等）弹提示并跳转登录页。

### 3.4 权限与菜单：`CourseManagerVue/src/common/*`

- `CourseManagerVue/src/common/userType.js`
  - 定义用户类型常量：学生(1)/教师(2)/管理员(3)。
- `CourseManagerVue/src/common/permission.js`
  - 定义管理员权限位（与后端 `Admin.java` 一致）：院系/专业/班级/学生/教师/课程/选课/管理员。
- `CourseManagerVue/src/common/sideBarItem.js`
  - 定义侧边栏菜单项与访问条件（userType + permission 位）。
- `CourseManagerVue/src/common/initialize.js`
  - 在 `main.js` 中通过 `registerIconFontMixin(app)` 注册全局 mixin，用于页面渲染后的额外处理（该文件包含较多编码/混淆内容，属于“功能性但不直观”的实现）。

### 3.5 API 文件（按角色划分）：`CourseManagerVue/src/api/`

这些文件是“前端对后端接口的薄封装”，把 URL 与参数组装成函数：

- 通用
  - `CourseManagerVue/src/api/user.js`：登录/登出/登录态查询。
  - `CourseManagerVue/src/api/option.js`：系统开关（是否允许选课/是否允许录分）。
- 学生端：`CourseManagerVue/src/api/student/*`
  - `courseSelect.js`：可选课程分页 + 选课。
  - `course.js`：已选课程列表 + 退选。
  - `timetable.js`：学生课表。
  - `exam.js`：学生考试列表。
  - `score.js`：学生成绩。
  - `info.js`：学生信息维护。
- 教师端：`CourseManagerVue/src/api/teacher/*`
  - `course.js`：教师授课查询。
  - `timetable.js`：教师课表。
  - `grade.js`：成绩录入（分页 + 编辑）。
- 管理员端：`CourseManagerVue/src/api/admin/*`
  - `department.js` / `major.js` / `class.js`：院系/专业/班级管理。
  - `student.js` / `teacher.js` / `admin.js`：学生/教师/管理员管理。
  - `course.js`：课程管理（分页、创建、编辑、删除、课程名列表等）。
  - `studentCourse.js`：选课记录管理（管理员视角）。

### 3.6 组件与页面：`CourseManagerVue/src/components/` 与 `CourseManagerVue/src/views/`

- 布局与通用组件：`CourseManagerVue/src/components/`
  - `HeadBar.vue`：顶栏（项目名、全屏按钮、用户名、退出登录）。
  - `SideBar.vue`：侧边栏菜单（根据 Vuex 过滤后的 items 渲染）。
  - `TimeTable.vue`：课表表格组件（把后端 `time=周-节-长度` 的课程数据渲染到 7x10 的课表网格）。
- 页面容器与登录：`CourseManagerVue/src/views/`
  - `Container.vue`：主框架页（顶栏+侧边栏+内容区）。创建时调用 `/user/login/status`，未登录则跳转 `/login`。
  - `Login.vue`：登录页（选择角色、输入账号密码，调用 `/user/login`）。
  - `Home.vue`：欢迎页（根据角色显示“管理员端/教师端/学生端”）。
- 学生端页面：`CourseManagerVue/src/views/student/`
  - `StudentCourseSelect.vue`：选课（可选课程查询、分页、选修按钮；受 `ALLOW_STUDENT_SELECT` 控制）。
  - `StudentCourse.vue`：已选课程列表与退选（已有成绩则禁用退选）。
  - `StudentTimeTable.vue`：学生课表（通常配合 `TimeTable.vue` 展示）。
  - `StudentExam.vue`：考试信息查询。
  - `StudentScore.vue`：成绩查询。
  - `StudentInfo.vue`：个人信息维护。
- 教师端页面：`CourseManagerVue/src/views/teacher/`
  - `TeacherCourse.vue`：授课查询。
  - `TeacherTimetable.vue`：教师课表。
  - `TeacherGrade.vue`：成绩录入/编辑（受 `ALLOW_TEACHER_GRADE` 控制）。
- 管理员端页面：`CourseManagerVue/src/views/admin/`
  - `AdminDepartment.vue`：院系管理。
  - `AdminMajor.vue`：专业管理。
  - `AdminClass.vue`：班级管理。
  - `AdminStudent.vue`：学生管理。
  - `AdminTeacher.vue`：教师管理。
  - `AdminCourse.vue`：课程管理。
  - `AdminStudentCourse.vue`：选课记录管理。
  - `AdminAdmin.vue`：管理员账号管理。

---

## 4. 数据库字段约定（与业务逻辑相关）

- 数据库名：`course_manager`（与 `application.yaml` 默认配置一致）。
- 课程上课时间 `rc_course.course_time`：
  - 格式为 `周-节-长度`，例如：`2-2-2`
    - `2`：星期二（周几）
    - `2`：第 2 节开始
    - `2`：连续上 2 节
  - 后端在选课时会用 `周-节` 做冲突检测（同一“周-节起始”不允许重复）。

---

## 5. 如何运行（开发模式）

### 5.1 准备数据库

1. 启动 MySQL（建议 8.x）。
2. 导入脚本：执行根目录 `course_manager.sql`。

### 5.2 启动后端

1. 修改 `CourseManagerApi - idea/src/main/resources/application.yaml` 的数据库连接信息（至少 `username/password`）。
2. 在后端目录执行：
   - `mvn spring-boot:run`
3. 默认端口：`http://localhost:8080`

### 5.3 启动前端

1. 在 `CourseManagerVue/` 执行：
   - `npm install`
   - `npm run serve`
2. 默认端口：`http://127.0.0.1:3000`
3. 前端默认请求后端：`CourseManagerVue/src/common/config.js` 中的 `backEndUrl`（默认 `http://localhost:8080`）。

---

## 6. 登录与权限模型（前后端对应关系）

- 用户类型：
  - 学生：`1`（前端 `UserType.student` / 后端 `UserType.STUDENT`）
  - 教师：`2`
  - 管理员：`3`
- 权限位（管理员专用）：
  - 前端：`CourseManagerVue/src/common/permission.js`
  - 后端：`CourseManagerApi - idea/src/main/java/com/rabbiter/cm/config/themis/annotation/Admin.java`
  - 采用 bitmask 方式存储，例如 `255` 表示拥有全部管理员权限。

---

## 7. 启动指令（前后端）

- 后端（Spring Boot）：
  - `cd /path/to/studentChoseClassProject`
  - `cd "CourseManagerApi - idea"`
  - `mvn spring-boot:run`
- 前端（Vue）：
  - `cd /path/to/studentChoseClassProject`
  - `cd "CourseManagerVue"`
  - `npm install`
  - `npm run serve`
