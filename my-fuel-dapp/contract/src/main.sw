contract;
use std::logging::log;


storage {
    counter: u64 = 0,
}

abi MyContract {

    #[storage(read)]
    fn counter() -> u64;
    #[storage(read, write)]
    fn increment(param: u64) -> u64;
}

impl MyContract for Contract {
    #[storage(read)]
    fn counter() -> u64 {
        log(123);
        storage.counter
    }

    #[storage(read, write)]
    fn increment(param: u64) -> u64 {
        // Read the current value of the counter from storage, increment the value read by the argument
        // received, and write the new value back to storage.
        storage.counter += param;

        // Return the new value of the counter from storage
        storage.counter
    }
}