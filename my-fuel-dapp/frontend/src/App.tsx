import React, { useEffect, useState } from "react";
import { Wallet } from "fuels";
import "./App.css";


import { ContractAbi__factory } from "./contracts";

const WALLET_SECRET =
  "0xde97d8624a438121b86a1956544bd72ed68cd69f2c99555b08b1e8c51ffd511c";


const CONTRACT_ID =
  "0x5f82cbd7ea775fa79d301ee93a23711886aeb5142c92e3afac495870717a31da";

const wallet = Wallet.fromPrivateKey(WALLET_SECRET);


const contract = ContractAbi__factory.connect(CONTRACT_ID, wallet);

function App() {
  const [counter, setCounter] = useState(0);

  useEffect(() => {
    async function main() {
      const { value } = await contract.functions.counter().get();
      setCounter(Number(value));
    }
    main();
  }, 
  []);

  async function increment() {
    
    const value = await contract.functions.increment(1).call();
    setCounter(Number(value));
    // console.log(value);
  }

  return (
    <div className="App">
      <header className="App-header">
        <p>Counter: {counter}</p>
        <button onClick={increment}>Increment</button>
      </header>
    </div>
  );
}

export default App;