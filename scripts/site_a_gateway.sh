#!/usr/bin/env bash

## NAT traffic going to the internet
route add default gw 172.16.16.1
iptables -t nat -A POSTROUTING -o enp0s8 -j MASQUERADE

## Save the iptables rules
iptables-save > /etc/iptables/rules.v4
ip6tables-save > /etc/iptables/rules.v6

echo 172.30.30.30 172.16.16.16 : PSK \"dD58fp51Pc8ktpFXZkiPncYS3TLUr3hFqf4ztNOQxG6ahetroQfsaIhkmzp6uaJEzDZec6U8dYyu5Pw57QVCGgMF0mABSC8KOtCUW5wZHd823fq4wbt2n2aQgvVT1vc227ZfmsrvKbolEQlENv55tq5lsYTKOjomWSPWx1XJLHsGAAfZcwyrYEykDwTtUeCVusohvptxGQPad8XmK744vz6gIolqRVhFK5X0JmcSJGZQRUSSqnBGn7ZYoVZXuOZwQJWEINRabFM0zXoerG2ezLGLOLT1PNZu3tvzmI7f8nQzedy8MJAwouUqGUHXFhTJ8wnPIPUydbYnV1aulGFKSpt3ayv8umwyLp17LVix3z77lb29x2n8eCV8TkLVtZPZt20AAlKAk1mCRWnOqj4VJqhCT3pMeIlvTBhexvzn0mXwicHxxMdte8CIooAGyFvUsR7QOjQV7fZ3zDg8nFW7WgFI84ipK7NHruNpBEdcmfprK2wRKzPDivMcvtzhXbMCaD7VRS3pwckQB7cZUweoOmLpWSBTSuyHfjaDQhyo7x2QI5AID9BAjMnrkmtPsL4wfTrapoSvmdo5Vgrv6ZMNifISpBhV7Sox5kp3TMjsiCQwarad7KSino3Ue0pTCNsGwHApU0nOgagNpIlikeqyy7MG9x5kWM2vzComAlyONF1ttF9rGxgxXUWVopV8lThSAtDZdkXFTrWNr5dR5SHK63X9c8b3z3iP2xf83ptBnH32QMLxCc7HpJP18e5ROYltbsETvtfvMZ9GCKphBoHhBA4mIpVvg3HwGorLZWtjfUNqlc5qiJBPSoBb30CEO21Z82xQrvZMSes4LPoeUr3oRdddMuGH9vivFTzJdu0L27FInAnAE9fV6jd9sCiJJGGDUNxK5QZn0tRoIjIeY6sUCpb7BKyoXsAn5WygGaLH6oFq1Erojgqbw2Hf7unW7Q9b1VW5Sc9sgZtJICAb04Hd5npEodPHI3SNP4pgFXNrNVHHZ0jCfWf2B7Y3XfLiR0Am\">> /etc/ipsec.secrets


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
        left=172.16.16.16
        leftsubnet=172.16.16.16/32
        right=172.30.30.30
        rightsubnet=172.30.30.30/32
        ike=aes256-sha2_256-modp2048!
        esp=aes256-sha2_256!
        dpdaction=restart
        auto=start
EOL

## restart ipsec
ipsec restart
