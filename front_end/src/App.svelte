<script lang="ts">
  import { ethers } from "ethers";
  import type { JsonRpcSigner } from "ethers";
  import { Contract } from "ethers";
  import { ABI } from "./abi";

  let msg: string = `Welcome to Bord!

Bord is a message board for bored people with money.

Prerequisites: Being bored, money (ETH).

Step 1: Read Bord.
Step 2: If you want to change the message on the Bord, proceed to Step 3, otherwise go to Step 6.
Step 3: Click the Edit Button and write your message on the Bord.
Step 4: Click the Post Button and complete the transaction.
Step 5: Go to Step 1.
Step 6: Become slightly less bored (required!).

Bord increments the Price of posting a message every submission.
You can see the number of submissions on the bottom-left corner.
You can see the Current Price at the bottom-right corner.

May you become less bored by reading the board named Bord :D

Click the Bord to load the current message!

*Bord is not liable for anyone, anything, anytime, anywhere, anyway, for any reason.*`;

  let price: number = 0;
  let displayPrice: number = 0;
  let isEditable: boolean = false;
  let numSubmissions: number = 0;
  const connectWallet = async () => {
    const { ethereum } = window as any;
    const provider = new ethers.BrowserProvider(ethereum);
    const account = await provider.send("eth_accounts", []);
    console.log(account);
  };

  const startBord = async () => {
    const { ethereum } = window as any;
    const provider = new ethers.BrowserProvider(ethereum);
    const signer = await provider.getSigner();
    const contract = await initializeContract(signer);
    console.log(contract);
    price = await contract.price();
    numSubmissions = await contract.numberSubmissions();
    displayPrice = Number(BigInt(price) / 10n**9n) / 10**9;
  };
  
  const readMsg = async () => {
    const { ethereum } = window as any;
    const provider = new ethers.BrowserProvider(ethereum);
    const signer = await provider.getSigner();
    const contract = await initializeContract(signer);
    console.log(contract);
    msg = await contract.message();
    price = await contract.price();
    numSubmissions = await contract.numberSubmissions();
    displayPrice = Number(BigInt(price) / 10n**9n) / 10**9;
    // alert(msg);
  };

  const submitMsg = async () => {
    const { ethereum } = window as any;
    const provider = new ethers.BrowserProvider(ethereum);
    const signer = await provider.getSigner();
    const contract = await initializeContract(signer);
    // console.log(contract.submitMsg.send);
    await contract.submitMsg(msg, {value: price});
    editText();
    readMsg();
    startReader();
  };

  const initializeContract = async (signer: JsonRpcSigner) => {
    return new Contract(
      "0x76D135dB61aaC57B3e7c44BD68eDc736234E3478",
      ABI,
      signer
    );
  };

  let colors = ["#9b74ffcb", "#74fffdcb"];
  let color: string = colors[0];
  const editText = async () => {
    if (isEditable) {
      isEditable = !isEditable;
      color = colors[0];
      readMsg();
      startReader();
    }
    else {
      isEditable = !isEditable;
      color = colors[1];
      stopReader();
    }
  };

  let ms: number = 500;
  let reader: any;
  const startReader = async () => {
    reader = setInterval(() => {
    // console.log("test interval thingy");
    readMsg();
  }, ms);
  };

  const stopReader = async () => {
    clearInterval(reader);
  };

</script>

<svelte:window on:load|once="{()=>startBord()}"/>

<main>
  <h2>Bord</h2>
  <p>A message board for bored people with money.</p>
  <textarea style="border-color: {color};" maxlength="1500" readonly={!isEditable} spellcheck=false on:click|once={readMsg} bind:value={msg}></textarea>
  <button id="connectWallet" on:click={connectWallet}>Connect Wallet</button>
  <button id="post" on:click={submitMsg}>Post</button>
  <button id="edit" on:click={editText}>Edit</button>
  <div id="cont">
    <span id="numSubmissions">Number of Submissions: {numSubmissions}</span>
    <span id="currPrice">Current Price: {displayPrice} ETH</span>
  </div>
</main>