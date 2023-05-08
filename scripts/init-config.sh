#! /bin/bash

case $AutoDLRegion in
  #内蒙 A
  neimeng-A | neimeng-C | neimeng-D)
    proxy=http://192.168.1.174:12798
    ;;
  #北京 A
  beijing-A | beijing-B | beijing-D | beijing-E)
    proxy=http://100.72.64.19:12798
    ;;
  #芜湖区
  wuhu-A)
    proxy=http://192.168.0.91:12798
    ;;
  #西北A区
  west-A)
    proxy=http://192.168.1.174:12798
    ;;
  #毕业
  stu-A)
    proxy=http://10.0.0.7:12798
    ;;
  #宿迁企业区
  suqian-C)
    proxy=http://10.0.0.7:12798
    ;;
  *)
    echo "不知道你是哪个区的机器"
    exit 1
    ;;
esac

echo 'git 科学加速启动'
git config --global http.proxy $proxy

if [ "$1" = "global" ]; then
  echo '开启全局加速'
  export http_proxy=$proxy
  export https_proxy=$proxy
  export no_proxy=localhost,127.0.0.0/8,10.0.0.0/8,172.16.0.0/12,192.168.0.0/16
fi
