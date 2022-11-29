contract;
use MyLib::wallet_lib::*;

storage{
    counter : u64 = 0,
}

impl Wallet for Contract {
    #[storage(read, write)]
    fn receive_funds() -> u64{
        storage.counter = 1;
        storage.counter
    }

    #[storage(read, write)]
    fn send_funds(amount_to_send: u64, recipient_address: Address) {
        
    }
}

