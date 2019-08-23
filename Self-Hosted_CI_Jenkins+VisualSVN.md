# VisualSVN + Jenkins Self-Hosted CI for fortran projects (include MPICH and CGNS libraries

本文介绍局域网搭建Fortran持续集成环境及其调试、维护与升级。

## 移植到局域网

确保局域网相关主机已经安装Docker。推荐使用Linux作为宿主机，若使用Windows作为宿主机则请确保已开启Hyper-V并共享相关磁盘。

1. 归档docker-jenkins-fortran镜像

   ```shell
   docker save -o docker-jenkins-fortran_v1.tar nescirem/docker-jenkins-fortran:[tags]
   ```

2. 将已经配置好插件的jenkins工作目录整个打包，记得先将占用该目录的container停用。

   ```shell
   zip -r jenkins ./jenkins
   ```

3. 将上述两个文件拷贝到局域网宿主机上。

4. 离线加载docker镜像

   ```shell
   docker load -i docker-jenkins-fortran_v1.tar
   ```

5. 解压jenkins工作目录到某一无空格与中文字符的目录，如：`D:\Ci\`

6. 将解压进来的工作目录映射到docker容器内jenkins工作目录并启动

   ```shell
   docker run -d -p 8080:8080 -p 50000:50000 -v /d/CI/jenkins:/var/jenkins_home --name jenkins nescirem/docker-jenkins-fortran:[tag]
   ```

7. 使用浏览器访问宿主机相应端口即可。

## 调试维护

如果你希望手动调试程序的话可以以交互模式运行容器（这并不是docker的正统用法）：

```shell
docker run -it -v /d/share:/home/share nescirem/docker-jenkins-fortran:[tag] /bin/bash
```

