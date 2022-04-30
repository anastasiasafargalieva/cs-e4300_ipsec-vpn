#!/usr/bin/env bash

## NAT traffic going to the internet
route add default gw 172.18.18.1
iptables -t nat -A POSTROUTING -o enp0s8 -j MASQUERADE

## Save the iptables rules
iptables-save > /etc/iptables/rules.v4
ip6tables-save > /etc/iptables/rules.v6


echo 172.30.30.30 172.18.18.18 : PSK \"pffhZGEwdnkz1X1Cf0pNkyPvp4y4oLtcI9yvTFWeFSfCMBkL5TArojelYprACExdN4sfT8ArGmNYdV5fpAYP9oqJegNdqoATpgcKyWPwXFUW3YMEEXk2sFdskCFJ6Li7iv8C6TgBbwF928tIySlvffhZKi8IdkGszGBU32U91dDVGvcBV4uKL2S6HhBkljGRak2XQn8QphZ5HOqcASmlwkLaUzZJGJIh2iJcHmvZABShbSQJZQ1uuaKkFdILT3Suu7dmdX3Zx4MpesURqaQoLNwfeEfKGaz9cavarEL6l3RQfej0cUc82hiPvYEROCK8qPxa3EhE14uasESkdB8sNkj5S0P6FUcgBQEskQ16LnQLcZEkQIy2ilPzrc1NhFkH3lGaRQ8E2pglsvgSFJtnMkOQyHCTJLIwBrVdUsLhrZsIGU7wY062PjIFzF091eajSUlP1jnuM2WcyN1VQzZYBgEJtS9NKaYk5t6neCgyXkQEMbGkCpjWmw7tGnusoXoTolH4hEaQYzI1jvVGMrZB16T9GqfjYpWoZM6bmQziYTERuBCJ065sp5msHGT0F2lAthtlAqOCGhFe3gju59hXeGwuEyKi6bNxq9rVUfdyVnvV1fDKlALYW5voFhDIoyuygFbacOJbWvwMpWmfS1JdKY6qKYQtUApyM5e21e64d3DBUylacr13XmKyc2PdPSO59I2JoheOVD8eASmvw5kUB7xpow66ykbRBRFHxEAa1VwQcBIt1m3C8ZAAREM0P0OONdO9Jco7MQbRgMETNLS8EjKBL5xw0gUg6imYventhBHYuh689WIR4SebwwEVt070j3IQc7Sr4R31Ncg38Y4IvABhK4Rueio0vDNIAJz7Ds5mc17IXiHIhfVNFiyJY70GmZl0uVrN8QauRNnyit3UG2XMSSghajY2dyJJZRTD6s50E3hsIHVtEjQZXY6KQ6AmPlDJ00pgIFrNSFfEQEIRwNJYF1DETS5lEqhI6aUlQAbFnLOawJS2sZGuB5TI9kUZ\">> /etc/ipsec.secrets

## ipsec conf
cat > /etc/ipsec.conf <<EOL
config setup
        charondebug=all
        uniqueids=yes
        strictcrlpolicy=no
conn gateway-a-to-cloud
        type=tunnel
        keyexchange=ikev2
        authby=secret
        left=172.18.18.18
        leftsubnet=172.18.18.18/32
        right=172.30.30.30
        rightsubnet=172.30.30.30/32
        ike=aes256-sha2_256-modp2048!
        esp=aes256-sha2_256!
        dpdaction=restart
        auto=start
EOL

## restart ipsec
ipsec restart
