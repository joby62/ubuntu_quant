echo "正在修改时区"
sudo timedatectl set-timezone Etc/UTC

echo "正在系统更新..."
sudo apt-get update

echo "安装npm,ubuntu版本为20.04时, npm版本为6.14.4"
sudo apt install npm

echo "全局安装pm2"
sudo npm install -g pm2@5.2.2

echo "为pm2安装个日志管理"
pm2 install pm2-logrotate@2.7.0

echo "下载安装mysql客户端和服务"
sudo apt install mysql-server
sudo apt install mysql-client

echo "下载安装grafana客户端"
sudo apt-get install -y adduser libfontconfig1
wget https://dl.grafana.com/oss/release/grafana_9.4.3_amd64.deb
sudo dpkg -i grafana_9.4.3_amd64.deb
sudo /bin/systemctl daemon-reload
sudo /bin/systemctl enable grafana-server
sudo systemctl status grafana-server
sudo systemctl enable grafana-server.service
sudo service grafana-server start
sudo service grafana-server status
sudo update-rc.d grafana-server defaults

echo "下载miniconda"
wget https://repo.anaconda.com/miniconda/Miniconda3-py38_4.12.0-Linux-x86_64.sh

echo "安装miniconda, 记得最后init时选择yes"
sh Miniconda3-py38_4.12.0-Linux-x86_64.sh

echo "生效base的conda环境"
__conda_setup="$('/home/ubuntu/miniconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/ubuntu/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/home/ubuntu/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/ubuntu/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup

echo "使用conda创建python虚拟环境alpha_admin"
conda create -n alpha_admin python==3.8.5

echo "生效平台所需conda环境"
conda activate alpha_admin

echo "先安装不容易安装的包"
conda install -c conda-forge ta-lib==0.4.19

echo "卸载ta-lib附带安装的numpy"
pip uninstall numpy

echo "下载安装requirements.txt"
wget -N --no-check-certificate https://raw.githubusercontent.com/joby62/ubuntu_quant/main/requirements.txt
pip install -r requirements.txt -i https://mirrors.bfsu.edu.cn/pypi/web/simple

echo "删除本地无用文件"
rm -r Miniconda3-py38_4.12.0-Linux-x86_64.sh
rm -r requirements.txt
rm -r https://dl.grafana.com/oss/release/grafana_9.4.3_amd64.deb

echo "查看时区, 请检查是否切换为UTC时间"
timedatectl

# echo "检查grafana server状态, ctrl+c退出"
# sudo service grafana-server status
