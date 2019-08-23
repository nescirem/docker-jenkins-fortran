# docker-jenkins-fortran



这是一个带fortran开发环境的jenkins docker镜像，基于[Docker版jenkins](https://hub.docker.com/_/jenkins)。

| Tags       | Packages                                                     |
| ---------- | ------------------------------------------------------------ |
| latest     | build-essential gfortran makedepf90 python3-pip python3-venv python-dev |
| mpich      | build-essential gfortran makedepf90 python3-pip python3-venv python-dev  mpich |
| mpich_cgns | build-essential gfortran makedepf90 python3-pip python3-venv python-dev  mpich libcgns3.3 libcgns-dev |

附加软件：

| Name                                                     | Introduction            |
| -------------------------------------------------------- | ----------------------- |
| [ford](https://github.com/Fortran-FOSS-Programmers/ford) | Fortran项目文档自动生成 |
| [FoBiS.py](https://github.com/szaghi/FoBiS)              | Fortran项目构建懒人工具 |

其他分支：mpich_cgns-3.2.1版本基于mpich，但固定使用cgns-3.2.1而非较新的cgns-3.3

> 注意：由于笔者参与的开发项目并不需要hdf5，所以该镜像在安装cgns时并未开启hdf5支持，如有需要请自行修改相关Dockerfile。

## 链接

* Docker Hub: https://hub.docker.com/r/nescirem/docker-jenkins-fortran

## 依赖

请确保本机已经正常安装Docker。推荐Docker Engine版本不低于18.09.2。

## 使用

根据需要下载相应版本的Docker镜像

```shell
docker pull nescirem/docker-jenkins-fortran:[tag]
```

运行该镜像并命名容器为jenkins，这里我们将宿主机的目录与jenkins工作目录做了映射，以方便后续的升级以及移植。你也可以根据自己的喜好将镜像的8080端口映射到宿主机的任意非占用端口。

```shell
docker run -d -p 80:8080 -p 50000:50000 -v /your/path/jenkins:/var/jenkins_home --name jenkins nescirem/docker-jenkins-fortran:[tag]
```

打开宿主机的浏览器（如果有的话）访问：`http://127.0.0.1/`，如果宿主机没有浏览器那就用宿主机所在局域网的任意主机访问宿主机相应端口。等待jenkins完成初始化[[1](media/wait_jenkins_service.png)]完成[[2](media/jenkins_input_pwd.png)]，在宿主机上执行以下命令以获取Jenkins管理员密码，你也可以直接访问宿主机映射目录相应文件来获取。

```shell
docker exec jenkins tail /var/jenkins_home/secrets/initialAdminPassword
```

请确保当前宿主机已经联网。如何将其移植到离线环境将会在【[离线环境示例](#离线环境示例)】中进行介绍。选择“安装推荐的插件”[[3](media/jenkins_install_plugins.png)]等待安装完成[[4](media/jenkins_install_plugins_default.png)]后进入实例配置界面[[5](media/jekins_instance_configuration.png)]，此处无需修改配置直接保存并完成进入下一步。

接下来创建管理员账户[[6](media/jenkins_admin_add.png)]，完成后如图[[7](media/jenkins_first_mission.png)]。

新建任务"test-fortran"为自由风格的软件项目，添加描述“fortran持续集成测试(SVN)”。源代码管理选择Subversion或者git，配置相应fortran代码库的源地址与认证账户[[8](media/jenkins_svn_config.png)]。

为了偷懒，我们选择构建触发器为轮询SCM并设置为每分钟查询一次相应代码库是否变化[[9](media/jenkins_svn_SCM.png)]。当然，我更推荐使用版本管理的hooks来触发构建，详细设置方式请自行查询相关资料。

在构建中增加构建步骤为“执行 Shell”，在这里输入相应的编译测试指令即可[[10](media/jenkins_svn_buildWithShell.png)]。

在构建后操作中读取构建生成的xml报告[[11](media/jenkins_svn_postBuild.png)]。

保存后点击立即构建测试是否构建成功。

### 离线环境示例

1. [VisualSVN + Jenkins Self-Hosted CI for fortran projects (include MPICH and CGNS libraries)](Self-Hosted_CI_Jenkins+VisualSVN.md)

## 参考

1. Docker版本Jenkins的使用: https://www.jianshu.com/p/0391e225e4a6
2. 建立擁有 C++ 編譯環境及 Jenkins Agent 的 Docker Image: https://ithelp.ithome.com.tw/articles/10201114
3. Jenkins 配置svn自动部署: https://blog.csdn.net/Jasonliujintao/article/details/70812639
4. 持续集成工具Jenkins结合SVN的安装和使用: https://blog.csdn.net/zxd1435513775/article/details/80618640
