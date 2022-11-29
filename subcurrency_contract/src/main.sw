script;
use std::constants::ZERO_B256;
abi Token {
    // this fn responsible to generate new Token & can only be called by the contract creator
    #[storage(read, write)]
    fn mint(receiver: Address, amount: u64);

    
    // fn is responsible to send amount from of an existing token to any Address
    #[storage(read, write)]
    fn send(receiver: Address, amount: u64);
}

fn main() {
    let contract_id = 0x6707853ca849da7a431dc2f0f2b8c243a4de4582c4d070f7636eccf03c7b2d2b;
    let caller = abi(Token, contract_id);
    let amount_to_send = 200;
    let reciever_address = Address::from(0x6707853ca849da7a431dc2f0f2b8c243a4de4582c4d070f7636eccf03c7b2d2b);
    caller.send{
        gas: 1000,
        coins: 0,
        asset_id: ZERO_B256,
    }(reciever_address, amount_to_send);
}
