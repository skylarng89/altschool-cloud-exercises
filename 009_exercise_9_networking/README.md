# **Networking**


What is the Network IP, number of hosts, range of IP addresses and broadcast IP from this subnet = 193.16.20.35/29?
<br><br>

**Network IP to Binary**<br>
193.16.20.35    =   11000001.00010000.00010100.00100011<br>
29              =   11111111.11111111.11111111.11111000<br><br>

**Binary to IP**
<hr>

11000001.00010000.00010100.00100011 =   193.16.20.32<br><br>

**Find the number of hosts**<br>
<hr>
2^(32 - 29) - 2 = 2^3 - 2 = 8 - 2 = 6<br>

Number of hosts on the network = 6<br><br>

**Calculating Broadcast IP**<br>
<hr>

11111111.11111111.11111111.11111000 = 00000000.00000000.00000000.00000111<br>

193.16.20.35    =   11000001.00010000.00010100.00100011<br>

Subnet          =   00000000.00000000.00000000.00000111<br>

Logical OR      =   11000001.00010000.00010100.00100111<br>

11000001.00010000.00010100.00100111 = 193.16.20.39<br>

Broadcast IP for 193.16.20.35/29 = 193.16.20.39<br><br>

**Calculating Range of IP addresses**<br>
<hr>

The range of IP addresses that can be assigned to hosts lie in between the value of the Network IP and the Broadcast IP.<br>

1. 193.16.20.33<br>
2. 193.16.20.34<br>
3. 193.16.20.35<br>
4. 193.16.20.36<br>
5. 193.16.20.37<br>
6. 193.16.20.38<br>