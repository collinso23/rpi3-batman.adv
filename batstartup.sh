# this script will enable batman-adv at startup and configure the mesh node
# it will also configure the node to run as a dhcp server for all other nodes on the
# network. To change this set
# sudo batctl gw_mode server to sudo batctl gw_mode client

#enable batman-adv
echo Starting Batman
sudo modprobe batman-adv
echo Sleeping 5 seconds!!!
sleep 5s

#turn off wlan0 configure is adhoc meshpoint
echo Setting wlan down
sudo ip link set wlan0 down
sudo ifconfig wlan0 mtu 1532
sudo iwconfig wlan0 mode ad-hoc
sudo iwconfig wlan0 essid projMesh #make sure essid is same
sudo iwconfig wlan0 ap any
sudo iwconfig wlan0 channel 11 #make sure channel is same

echo Sleeping for 2 seconds
sleep 2s

#turn wlan0 back up
echo Setting wlan up
sudo ip link set wlan0 up

#add wlan0 as meshpoint to batctl
echo Sleeping for 2 seconds
sleep 2s
sudo batctl if add wlan0

echo Sleeping for 2 seconds
sleep 2s
echo Setting bat0 up
sudo ifconfig bat0 up
sleep 2s
echo starting gateway mode
sudo batctl gw_mode server
echo sleeping for 2 seconds
sleep 2s
#sudo ifconfig bat0 172.28.0.50/16
sudo ip addr add 172.28.0.1/24 broadcast 172.28.0.255 dev bat0
#add wlan0 as meshpoint to batctl
echo Sleeping for 2 seconds
sleep 2s
sudo batctl if add wlan0

echo Sleeping for 2 seconds
sleep 2s
echo Setting bat0 up
sudo ifconfig bat0 up
sleep 2s
echo starting gateway mode
sudo batctl gw_mode server
echo sleeping for 2 seconds
sleep 2s
#sudo ifconfig bat0 172.28.0.50/16
sudo ip addr add 172.28.0.1/24 broadcast 172.28.0.255 dev bat0


######Was not able to get working#########
#echo Bridging eth0
#ip link add name mesh-bridge type bridge
#ip link set dev eth0 master mesh-bridge
#ip link set dev bat0 master mesh-bridge
#ip link set up dev eth0
#ip link set up dev bat0
#ip link set up dev mesh-bridge

######Was not able to get working#########
#echo conf iptables to route traffic
#sudo iptables -t nat -A POSTROUTING -o wlan1 -j MASQUERADE
#sudo iptables -A FORWARD -i wlan1 -o bat0 -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
#sudo iptables -A FORWARD -i bat0 -o wlan1 -j ACCEPT
echo Done!!!
