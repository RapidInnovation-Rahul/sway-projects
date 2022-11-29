library wallet_lib;

abi Wallet{
    #[storage(read, write)]
    fn receive_funds() -> u64;
    
    #[storage(read, write)]
    fn send_funds(amount_to_send: u64, recipient_address: Address);
}
