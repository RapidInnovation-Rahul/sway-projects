contract;

use std::{auth::{AuthError, msg_sender}, hash::sha256, logging::log};

// this is Event which emitts when a Token is sent
struct Sent {
    from: Address,
    to: Address,
    amount: u64,
}

// abi declaration for SubCurrency
abi Token {
    // this fn responsible to generate new Token & can only be called by the contract creator
    #[storage(read, write)]
    fn mint(receiver: Address, amount: u64);

    
    // fn is responsible to send amount from of an existing token to any Address
    #[storage(read, write)]
    fn send(receiver: Address, amount: u64);
}

//Address of contract creator.
const MINTER = Address::from(0x9299da6c73e6dc03eeabcce242bb347de3f5f56cd1c70926d76526d7ed199b8b);


// Contract storage persists across transactions.
storage {
    balances: StorageMap<Address, u64> = StorageMap {},
}

// Contract implements the token ABI.
impl Token for Contract {
    #[storage(read, write)]
    fn mint(receiver: Address, amount: u64) {
        // get the reciever address
        let sender: Result<Identity, AuthError> = msg_sender();
        let sender: Address = match sender.unwrap() {
            Identity::Address(addr) => {
                assert(addr == MINTER);
                addr
            },
            _ => revert(0),
        };

        // Increase the balance of receiver
        storage.balances.insert(receiver, storage.balances.get(receiver) + amount);
    }

    #[storage(read, write)]
    fn send(receiver: Address, amount: u64) {
        // get the sender Address
        let sender: Result<Identity, AuthError> = msg_sender();
        let sender = match sender.unwrap() {
            Identity::Address(addr) => addr,
            _ => revert(0),
        };

        // Reduce the balance of sender
        let sender_amount = storage.balances.get(sender);
        assert(sender_amount > amount);
        storage.balances.insert(sender, sender_amount - amount);

        // Increase the balance of receiver
        storage.balances.insert(receiver, storage.balances.get(receiver) + amount);

        log(Sent {
            from: sender,
            to: receiver,
            amount: amount,
        });
    }
}
