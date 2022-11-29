use fuels::{prelude::*, tx::ContractId};

// Load abi from json
abigen!(MyContract, "out/debug/fizzbuzz-abi.json");

async fn get_contract_instance() -> (MyContract, ContractId) {
    // Launch a local network and deploy the contract
    let mut wallets = launch_custom_provider_and_get_wallets(
        WalletsConfig::new(
            Some(1),             /* Single wallet */
            Some(1),             /* Single coin (UTXO) */
            Some(1_000_000_000), /* Amount per coin */
        ),
        None,
        None,
    )
    .await;
    let wallet = wallets.pop().unwrap();

    let id = Contract::deploy(
        "./out/debug/fizzbuzz.bin",
        &wallet,
        TxParameters::default(),
        StorageConfiguration::with_storage_path(Some(
            "./out/debug/fizzbuzz-storage_slots.json".to_string(),
        )),
    )
    .await
    .unwrap();

    let instance = MyContract::new(id.clone(), wallet);

    (instance, id.into())
}

#[tokio::test]
async fn can_get_contract_id() {
    let (instance, _id) = get_contract_instance().await;

    let result1 = instance.methods().fizzbuzz(15).call().await.unwrap();

    let result2 = instance.methods().fizzbuzz(15).call().await.unwrap();
    
    assert_eq!(result1.value, result2.value);
    
    // let result3 = instance.methods().fizzbuzz(5).call().await.unwrap();
    // log(result3.value);

    // let result4 = instance.methods().fizzbuzz(0).call().await.unwrap();
    // log(result4.value);
}
