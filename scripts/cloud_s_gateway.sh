#!/usr/bin/env bash

## Traffic going to the internet
route add default gw 172.30.30.1

## setting NAT for cloud s
iptables -t nat -A POSTROUTING -o enp0s8 -j MASQUERADE

## making cloud-s private by assigning servers on the cloud side the ip servers of the client side
echo 172.30.30.30 172.16.16.16 : PSK \"dD58fp51Pc8ktpFXZkiPncYS3TLUr3hFqf4ztNOQxG6ahetroQfsaIhkmzp6uaJEzDZec6U8dYyu5Pw57QVCGgMF0mABSC8KOtCUW5wZHd823fq4wbt2n2aQgvVT1vc227ZfmsrvKbolEQlENv55tq5lsYTKOjomWSPWx1XJLHsGAAfZcwyrYEykDwTtUeCVusohvptxGQPad8XmK744vz6gIolqRVhFK5X0JmcSJGZQRUSSqnBGn7ZYoVZXuOZwQJWEINRabFM0zXoerG2ezLGLOLT1PNZu3tvzmI7f8nQzedy8MJAwouUqGUHXFhTJ8wnPIPUydbYnV1aulGFKSpt3ayv8umwyLp17LVix3z77lb29x2n8eCV8TkLVtZPZt20AAlKAk1mCRWnOqj4VJqhCT3pMeIlvTBhexvzn0mXwicHxxMdte8CIooAGyFvUsR7QOjQV7fZ3zDg8nFW7WgFI84ipK7NHruNpBEdcmfprK2wRKzPDivMcvtzhXbMCaD7VRS3pwckQB7cZUweoOmLpWSBTSuyHfjaDQhyo7x2QI5AID9BAjMnrkmtPsL4wfTrapoSvmdo5Vgrv6ZMNifISpBhV7Sox5kp3TMjsiCQwarad7KSino3Ue0pTCNsGwHApU0nOgagNpIlikeqyy7MG9x5kWM2vzComAlyONF1ttF9rGxgxXUWVopV8lThSAtDZdkXFTrWNr5dR5SHK63X9c8b3z3iP2xf83ptBnH32QMLxCc7HpJP18e5ROYltbsETvtfvMZ9GCKphBoHhBA4mIpVvg3HwGorLZWtjfUNqlc5qiJBPSoBb30CEO21Z82xQrvZMSes4LPoeUr3oRdddMuGH9vivFTzJdu0L27FInAnAE9fV6jd9sCiJJGGDUNxK5QZn0tRoIjIeY6sUCpb7BKyoXsAn5WygGaLH6oFq1Erojgqbw2Hf7unW7Q9b1VW5Sc9sgZtJICAb04Hd5npEodPHI3SNP4pgFXNrNVHHZ0jCfWf2B7Y3XfLiR0Am\">> /etc/ipsec.secrets
echo 172.30.30.30 172.18.18.18 : PSK \"pffhZGEwdnkz1X1Cf0pNkyPvp4y4oLtcI9yvTFWeFSfCMBkL5TArojelYprACExdN4sfT8ArGmNYdV5fpAYP9oqJegNdqoATpgcKyWPwXFUW3YMEEXk2sFdskCFJ6Li7iv8C6TgBbwF928tIySlvffhZKi8IdkGszGBU32U91dDVGvcBV4uKL2S6HhBkljGRak2XQn8QphZ5HOqcASmlwkLaUzZJGJIh2iJcHmvZABShbSQJZQ1uuaKkFdILT3Suu7dmdX3Zx4MpesURqaQoLNwfeEfKGaz9cavarEL6l3RQfej0cUc82hiPvYEROCK8qPxa3EhE14uasESkdB8sNkj5S0P6FUcgBQEskQ16LnQLcZEkQIy2ilPzrc1NhFkH3lGaRQ8E2pglsvgSFJtnMkOQyHCTJLIwBrVdUsLhrZsIGU7wY062PjIFzF091eajSUlP1jnuM2WcyN1VQzZYBgEJtS9NKaYk5t6neCgyXkQEMbGkCpjWmw7tGnusoXoTolH4hEaQYzI1jvVGMrZB16T9GqfjYpWoZM6bmQziYTERuBCJ065sp5msHGT0F2lAthtlAqOCGhFe3gju59hXeGwuEyKi6bNxq9rVUfdyVnvV1fDKlALYW5voFhDIoyuygFbacOJbWvwMpWmfS1JdKY6qKYQtUApyM5e21e64d3DBUylacr13XmKyc2PdPSO59I2JoheOVD8eASmvw5kUB7xpow66ykbRBRFHxEAa1VwQcBIt1m3C8ZAAREM0P0OONdO9Jco7MQbRgMETNLS8EjKBL5xw0gUg6imYventhBHYuh689WIR4SebwwEVt070j3IQc7Sr4R31Ncg38Y4IvABhK4Rueio0vDNIAJz7Ds5mc17IXiHIhfVNFiyJY70GmZl0uVrN8QauRNnyit3UG2XMSSghajY2dyJJZRTD6s50E3hsIHVtEjQZXY6KQ6AmPlDJ00pgIFrNSFfEQEIRwNJYF1DETS5lEqhI6aUlQAbFnLOawJS2sZGuB5TI9kUZ\">> /etc/ipsec.secrets


## DNAT
iptables -t nat -A PREROUTING -i enp0s8 -p tcp --source 172.18.18.18 --dport 8080 -j DNAT --to-destination 10.1.0.2
iptables -t nat -A PREROUTING -i enp0s8 -p tcp --source 172.16.16.16 --dport 8080 -j DNAT --to-destination 10.1.0.3

## Save the iptables rules
iptables-save > /etc/iptables/rules.v4
ip6tables-save > /etc/iptables/rules.v6

## ipsec conf
cat > /etc/ipsec.conf <<EOL
config setup
        charondebug=all
        uniqueids=yes
        strictcrlpolicy=no
conn cloud-vpn
        type=tunnel
        keyexchange=ikev2
        authby=secret
        leftfirewall=yes
        left=172.30.30.30
        leftsubnet=172.30.30.30/32
        ike=aes256-sha2_256-modp2048!
        esp=aes256-sha2_256!
        dpdaction=restart
        auto=start
conn gateway-a-vpn
        also=cloud-vpn
        right=172.16.16.16
        rightsubnet=172.16.16.16/32
conn gateway-b-vpn
        also=cloud-vpn
        right=172.18.18.18
        rightsubnet=172.18.18.18/32
EOL

## restart ipsec
ipsec restart
