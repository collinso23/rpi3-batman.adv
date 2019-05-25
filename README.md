# rpi3-batman.adv
Batman-adv Mesh Network
The solution is to configure a decentralized mesh network using batman-adv. To get the TENT up and running it is assumed the user has a limited amount Linux experience, such as flashing operating systems to bootable media, using commands and editing files via a CLI or GUI, and an intermediate amount of networking knowledge. On Raspbian, B.A.T.M.A.N is a built-in protocol. Thus, all a user would need to do is enable to module and configure the interface.

} 
Steps{ 

Step 1: flash the sd cards with Raspbian lite enable ssh on boot, login and change default passwords and hostnames. Enabling SSH will allow for headless configuration but is not necessary to getting the network up and running. Changing the password will improve the overall security of the devices. Altering the hostnames will also improve clarity for optional services like DNS.[9]

Step 2: Update Pi and install required packages for batctl, nginx, and snap for Rocket.chat. Then install Rocket.chat This step assumes that the users are connecting at least one node to the internet to download the  packages. If internet connection is not up, precompiled .iso images can be distributed containing required software.[5],[6]

Step 3: Download and install batctl in home directory (/home/pi/). batctl is the command line interface (CLI) tool used to manage the batman-adv kernel module. It offers a variety of features that will allow users to configure batman-adv, display debug information such as originator tables, translation table and the debug log. In combination with a bat-hosts file batctl allows the use of host names instead of MAC addresses. Since B.A.T.M.A.N operates on layer 2, batctl  includes layer 2 equivalents of commands ping, traceroute, tcpdump, and throughputmeter.[4]

Step 4: Create a script to configure wlan adapter as meshpoint and configure and turn on bat0. Which is batman-adv virtual interface (bat0) were all batman packets will be directed. Inside the home directory. The commands on the script can be input manually into the terminal to achieve the same result. Line 1-2 of the script will enable the B.A.T.M.A.N-adv kernel module which allows the device to transmit OGM’s. Lines 3-8 does a variety of commands. First is turns off the wlan0 interface which is the interface which is going to be configured to use B.A.T.M.A.N. Next the maximum transmission unit size(mtu) is set to 1532 which is the recommended size for B.A.T.M.A.N packets [4]. Then the project SSID is set to being “projMesh” using a randomly generate cell id(ap) on channel 11. After that the meshpoint is configured and the wlan0 interface can be turned back on, line 10. After that, the script bridges wlan0 with the bat0 interface utilizing batctl which is the virtual interface responsible for managing traffic. Finally, the script turns on the bat0 interface and assigns the ip address 172.28.0.1/16. After the script has been created the user needs to grant the script executable privileges so that once it has been added to the boot path it is able to execute properly. Note that if so desired a user manually run the script by moving to the home directory and running the script like so: $sudo ./batstartup.sh [10]

Step 5: Make a quick edit to the dhcpcd config file so that everything in our script runs correctly. From experimenting it was discovered that the dhcpcd service was causing the startup script to fail. This was amended by adding the “denyinterfaces wlan0” to the end of the dhcpcd configuration file. Which default denied any dynamic ip address leasing to wlan0 so that it can properly act as a meshpoint.[9]

Step 6:  Add startup scripts to boot path on pi’s and reboot. This step is optional but recommended as otherwise the startup script will have to be run manually upon boot after each shutdown. The file rc.local located in the /etc directory executes scripts after normal bootup. By adding the path to the batstartup.sh script in the home directory the mesh should start as a custom service.[8] If everything has be done correctly rebooting the pi should have it come online with a valid meshpoint operating B.A.T.M.A.N-adv.
}

Testing{ 

Verify device association

To check and see if both devices are on the same network first check iwconfig to see if both devices display the same cell id. If they display the same cell id it means the devices wireless adapters are linked via ad-hoc. Different cell ids would mean that the devices had been improperly configured and the startup script should be edited. A possible solution is replacing sudo iwconfig wlan0 ap <Node Cell: ID>. Next a user can check ifconfig to view the bat0 and wlan0 interfaces. Both should be up and the bat0 interface should be displaying an ip address assigned by the script in this case using the 172.28.x.x/16 scheme. Note again, that if duplicate ip addresses are assigned the nodes will not be able to communicate.

Check neighbors and originators

Utilizing batctl a user can see the nearby OGM originators table. Each node maintains information about the known other originators (bat# Interfaces) in the network in an Originator List.  The Originator List contains one entry for each Originator from which or via which an OGM has been received within the last PURGE_TIMEOUT seconds.  If OGMs from different Originators (B.A.T.M.A.N. interfaces) of the same node are received, then there MUST be one entry for each Originator.  In fact, the receiving node does not necessarily know that certain different Originators (and corresponding IP addresses) are belonging to the same B.A.T.M.A.N. node.[7] The command batctl n and batctl tp <target> will display both the next-hop neighbors and the throughput on the network. The neighbors table can be used to determine who is on the network and their associated mac addresses will be displayed along with when their OGM was last seen. Throughput shows a relatively small transmission rate at only 2.95MB/s but it is suitable for the limited services that need to be run on the network.

Confirm communication services
Once connection has been established a user should be able to log into any of the services on the wireless mesh network. The website configured was minimal and served only to direct traffic to the chat service on the network where users could communicate needs. 
} 
