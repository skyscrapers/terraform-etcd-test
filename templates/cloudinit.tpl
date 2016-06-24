#cloud-config

---
coreos:
  update:
    reboot-strategy: etcd-lock
  etcd2:
    discovery: https://discovery.etcd.io/ad6cc122e5d4e4efaf332c21afe4ddba
    advertise-client-urls: http://$public_ipv4:2379
    initial-advertise-peer-urls: http://$private_ipv4:2380
    listen-client-urls: http://0.0.0.0:2379,http://0.0.0.0:4001
    listen-peer-urls: http://$private_ipv4:2380,http://$private_ipv4:7001
  fleet:
    public-ip: "$public_ipv4"
    metadata: role=kubernetes
  flannel:
    interface: "$public_ipv4"
  units:
  - name: etcd2.service
    command: start
  - name: fleet.service
    command: start
  - name: flanneld.service
    drop-ins:
    - name: 50-network-config.conf
      content: |
        [Service]
        ExecStartPre=/usr/bin/etcdctl set /coreos.com/network/config '{ "Network": "${subnet}" }'
    command: start
  - name: docker-tcp.socket
    command: start
    enable: true
    content: |
      [Unit]
      Description=Docker Socket for the API

      [Socket]
      ListenStream=2375
      Service=docker.service
      BindIPv6Only=both

      [Install]
      WantedBy=sockets.target
