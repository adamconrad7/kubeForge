## OpsMaxing


### Debug Commands
Trail logs:
sudo journalctl --since "5 minutes ago" -f

Basic grep:
sudo journalctl | grep k3s

sudo systemctl status k3s

Get IP:
hostname -I | awk '{print $1}'

Get nodes from cp:
sudo k3s kubectl get nodes -o wide

Check agent status:
sudo systemctl status k3s-agent

K3S_URL="https://52.26.179.29:6443"
sudo vi /etc/systemd/system/k3s-agent.service
