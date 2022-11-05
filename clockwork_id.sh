
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

#start long term validato process...validato is not a typo ;)
nohup solana-validator --geyser-plugin-config /root/clockwork/lib/geyser-plugin-config.json --identity ~/validator-keypair.json --rpc-port 8899 --entrypoint entrypoint.devnet.solana.com:8001 --limit-ledger-size --no-voting --log /var/log/solana-validator.log &

