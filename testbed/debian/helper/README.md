| Command                                         | Description                                                |
|-------------------------------------------------|------------------------------------------------------------|
| `ip -6 addr`                                    | Show IPv6 addresses assigned to all interfaces             |
| `ip -6 addr show dev eth0`                      | Show IPv6 addresses for a specific interface (e.g., eth0)  |
| `ip -6 route`                                   | Display IPv6 routing table                                 |
| `ip -6 route add <prefix> via <gw>`             | Add an IPv6 route via a gateway                            |
| `ip -6 route del <prefix>`                      | Delete an IPv6 route                                       |
| `ip -6 neigh`                                   | Show IPv6 neighbor table (similar to ARP for IPv6)         |
| `ip -6 neigh add <ip> lladdr <mac> dev <iface>` | Add a static neighbor entry                                |
| `ip -6 neigh del <ip> dev <iface>`              | Delete a neighbor entry                                    |
| `ip -6 link`                                    | Show link-layer information for interfaces                 |
| `ip -6 link set dev eth0 up`                    | Bring up an interface                                      |
| `ip -6 link set dev eth0 down`                  | Bring down an interface                                    |
| `ip -6 tunnel`                                  | Manage IPv6 tunnels                                        |
| `ip -6 maddr`                                   | Show multicast addresses                                   |
| `ip -6 mroute`                                  | Show multicast routing table                               |
| `ip -6 rule`                                    | Show or manipulate IPv6 routing rules                      |
| `ip -6 rule add from <src> table <table>`       | Add a rule to route traffic from a specific source IP      |