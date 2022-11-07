
# Do the following on a Secure Laptop
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
sh -c "$(curl -sSfL https://release.solana.com/stable/install)"
sudo apt update
sudo apt upgrade
sudo apt install build-essential
sudo apt-get install libssl-dev
apt install pkg-config
git clone https://github.com/clockwork-xyz/clockwork
cd clockwork
./scripts/build-all.sh .
export PATH=$PWD/bin:$PATH
#pass sol to authority
solana-keygen new -o ~/authority.json
solana config set --keypair ~/authority.json
solana-keygen new -o ~/worker1.json
clockwork worker create ~/worker1.json

# Do the following on Validator pass small amount of SOL to pay for Transactions
solana-keygen new -o ~/validator-keypair.json
solana config set --keypair ~/validator-keypair.json
# rebuild clockwork see above 
git clone https://github.com/clockwork-xyz/clockwork
cd clockwork
./scripts/build-all.sh .
export PATH=$PWD/bin:$PATH
cd lib

#vi geyser-plugin-config.json
root@server:~/clockwork/lib# cat geyser-plugin-config.json
{
  "libpath": "/root/clockwork/lib/libclockwork_plugin.so",
  "keypath": "/root/validator-keypair.json",  <---- point to small fee payer 
  "transaction_timeout_threshold": 150,
  "thread_count": 10,
  "worker_id": 3 <---- put your worker id
}

#setup logrotate for /var/log/solana/*log
wget https://raw.githubusercontent.com/redazul/stream_server/main/logrotate -O /etc/logrotate.d/solana_validator
mkdir /var/log/solana
systemctl restart logrotate.service

#send metrics to influxDB on Solana's Foundation hosted Grafana Dashboard
export SOLANA_METRICS_CONFIG="host=https://metrics.solana.com:8086,db=mainnet-beta,u=mainnet-beta_write,p=password"

#clean old data
rm -rf ledger
 
#network config
sudo $(command -v solana-sys-tuner) --user $(whoami) > sys-tuner.log 2>&1 &

#start long term validato process...validato is not a typo ;)
nohup solana-validator --geyser-plugin-config /root/clockwork/lib/geyser-plugin-config.json --identity ~/validator-keypair.json --rpc-port 8899 --entrypoint entrypoint.mainnet-beta.solana.com:8001 --entrypoint entrypoint2.mainnet-beta.solana.com:8001 --entrypoint entrypoint3.mainnet-beta.solana.com:8001 --entrypoint entrypoint4.mainnet-beta.solana.com:8001 --entrypoint entrypoint5.mainnet-beta.solana.com:8001     --known-validator 7Np41oeYqPefeNQEHSv1UDhYrehxin3NStELsSKCT4K2  --known-validator GdnSyH3YtwcxFvQrVVJMm1JhTS4QVX7MFsX56uJLUfiZ  --known-validator DE1bawNcRJB9rVm3buyMVfr8mBEoyyu73NBovf2oXJsJ --known-validator CakcnaRDHka2gXyfbEd2d3xsvkJkqsLw2akB3zsN1D2S --limit-ledger-size --no-voting --log /var/log/solana/solana-validator.log &

