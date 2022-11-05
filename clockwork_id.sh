
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
