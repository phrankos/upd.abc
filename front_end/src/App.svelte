<script lang="ts">
  import { ethers } from "ethers";
  import type { JsonRpcSigner } from "ethers";
  import { Contract } from "ethers";
  import { ABI } from "./abi";
  import { ABI_token } from "./abi_token";
	import Modal from './Modal.svelte';

  let msg: string = `Welcome to Bord!

Prerequisites: Being bored, BRD Tokens.

Buy BRD Tokens at the Shop.

Step 0: Connect Metamask Wallet.
Step 1: Read Bord.
Step 2: If you want to change the message on the Bord, proceed to Step 3, otherwise go to Step 6.
Step 3: Click the Edit Button and write your message on the Bord.
Step 4: Click the Post Button and complete the transactions.
Step 5: Go to Step 1.
Step 6: Become slightly less bored (required!).

Bord increments the Price of posting a message every submission.
You can see the number of submissions on the bottom-left corner.
You can see the Current Price at the bottom-right corner.

Click the Bord to load the current message!
May you become less bored by reading the board named Bord :D

*Bord is not liable for anyone, anything, anytime, anywhere, anyway, for any reason.*`;

  let isStarted: boolean = false;

  let tokenPrice: number = 0;
  let displayTokenPrice: number = 0;

  let submitPrice: number = 0;
  let displaySubmitPrice: number = 0;

  let isEditable: boolean = false;
  let numSubmissions: number = 0;

  let userTokens: number = 0;
  let displayUserTokens:number = 0;

  let shopItems: Array<number> = [1, 100, 1000];

  const connectWallet = async () => {
    const { ethereum } = window as any;
    const provider = new ethers.BrowserProvider(ethereum);
    const account = await provider.send("eth_accounts", []);
    // console.log(account);
  };

  const initializeContract = async (signer: JsonRpcSigner) => {
    return new Contract(
      "0xAc1bB9aaf6c9Ea728A2852027baCc10Dcb7F1d0F",
      ABI,
      signer
    );
  };

  const initializeToken = async (signer: JsonRpcSigner) => {
    return new Contract(
      "0x37462BC24cA3708631697D7a38Aa2BBF0b7b0BA1",
      ABI_token,
      signer
    );
  };

  const startBord = async () => {
    const { ethereum } = window as any;
    const provider = new ethers.BrowserProvider(ethereum);
    const signer = await provider.getSigner();
    const contract = await initializeContract(signer);
    const BordToken = await initializeToken(signer);
    // console.log(contract);
    startReader();
  };

  const introDone = async () => {
    isStarted = true;
  }

  const readMsg = async () => {
    const { ethereum } = window as any;
    const provider = new ethers.BrowserProvider(ethereum);
    const signer = await provider.getSigner();
    const contract = await initializeContract(signer);
    const BordToken = await initializeToken(signer);
    // console.log(contract);
    if (isStarted==true) {
      msg = await contract.message();
    }
    numSubmissions = await contract.numberSubmissions();
    submitPrice = await contract.submitPrice();
    tokenPrice = await contract.tokenPrice();
    userTokens = await BordToken.balanceOf(signer.address);
    displaySubmitPrice = Number(BigInt(submitPrice) / 10n**9n) / 10**9;
    displayTokenPrice = Number(BigInt(tokenPrice) / 10n**9n) / 10**9;
    displayUserTokens = Number(BigInt(userTokens) / 10n**9n) / 10**9;
    // alert(msg);
  };

  const submitMsg = async () => {
    const { ethereum } = window as any;
    const provider = new ethers.BrowserProvider(ethereum);
    const signer = await provider.getSigner();
    const contract = await initializeContract(signer);
    const BordToken = await initializeToken(signer);
    // console.log(contract.target);

    // BordToken.approve(signer.address, submitPrice, {gasLimit: 0.00001*10**18})

    try {
      const isTransferred = await BordToken.transfer(contract.target, submitPrice);
      await contract.submitMsg(msg);
      editText();
      readMsg();
      startReader();
    } catch (error) {
      console.log("FAILED BEEP BEEP");
    }
  };

  const buyTokens = async (_amountTokens: number) => {
    const { ethereum } = window as any;
    const provider = new ethers.BrowserProvider(ethereum);
    const signer = await provider.getSigner();
    const contract = await initializeContract(signer);

    const amountTokens = _amountTokens;
    const price: bigint = BigInt(tokenPrice) * BigInt(amountTokens);

    // console.log("Amount of Tokens:", amountTokens);
    // console.log("Price:", price);

    await contract.buyTokens(amountTokens, {value: price});

  };

  let colors = ["#9b74ffcb", "#74fffdcb"];
  let editColors = ["#1f6299", "#991f3e"];
  let editColor: string = editColors[0];
  let color: string = colors[0];
  let editState: string = "Edit";
  const editText = async () => {
    if (isEditable) {
      isEditable = !isEditable;
      color = colors[0];
      editColor = editColors[0];
      editState = "Edit";
      readMsg();
      startReader();
    }
    else {
      isEditable = !isEditable;
      color = colors[1];
      editColor = editColors[1];
      editState = "Cancel";
      stopReader();
    }
  };

  let ms: number = 500;
  let reader: any;
  const startReader = async () => {
    stopReader();
    reader = setInterval(() => {
    // console.log("test interval thingy");
    readMsg();
  }, ms);
  };

  const stopReader = async () => {
    clearInterval(reader);
  };

  // Modal Things
  let showModal: boolean = false;

</script>

<svelte:window on:load|once="{()=>startBord()}"/>

<main>
  <h2>Bord</h2>
  <p>A message board for bored people with money.</p>
  <textarea style="border-color: {color};" maxlength="1500" readonly={!isEditable} spellcheck=false on:click|once={introDone} bind:value={msg}></textarea>
  <button id="shop" on:click={() => (showModal = true)}>Shop</button>
  <button id="userTokens">{displayUserTokens} <span style="color: #bd91ff;">BRD</span></button>
  <button id="post" on:click={submitMsg}>Post</button>
  <button id="edit" style="background-color: {editColor};" on:click={editText}>{editState}</button>
  <div id="cont">
    <span id="numSubmissions">Number of Submissions: {numSubmissions}</span>
    <!-- <span id="tokenPrice">Submit Price: {submitPrice}</span> -->
    <span id="currPrice">Current Price: {displaySubmitPrice} BRD</span>
  </div>

  <Modal bind:showModal>
    <h2 id="modalHeader" slot="header">
      Buy Bord Tokens
    </h2>

    <table>
      <tr>
        <td style="width: 100%; text-align:left;">1 <span style="color: #bd91ff;">BRD</span></td>
        <td class="tokenPrice">{displayTokenPrice * shopItems[0]}</td>
        <td class="eth"> ETH</td>
        <td><button on:click={()=>buyTokens(shopItems[0])}>Buy</button></td>
      </tr>
      <tr>
        <td style="width: 100%; text-align:left;">10 <span style="color: #bd91ff;">BRD</span></td>
        <td class="tokenPrice">{displayTokenPrice * shopItems[1]}</td>
        <td class="eth"> ETH</td>
        <td><button on:click={()=>buyTokens(shopItems[1])}>Buy</button></td>
      </tr>
      <tr>
        <td style="width: 100%; text-align:left;">100 <span style="color: #bd91ff;">BRD</span></td>
        <td class="tokenPrice">{displayTokenPrice * shopItems[2]}</td>
        <td class="eth"> ETH</td>
        <td><button on:click={()=>buyTokens(shopItems[2])}>Buy</button></td>
      </tr>
    </table>
  </Modal>
</main>