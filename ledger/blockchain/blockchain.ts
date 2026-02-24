import { createHash, randomBytes } from "node:crypto"
import { Block } from "../block/block";
import { SmartContract } from "../smart_contracts/smart_contract";

export class Blockchain {
    chain: Block[];
    difficulty = 3;
    pendingTransactions: any[] = [];
    contracts: Map<string, SmartContract> = new Map();

    constructor() {
        this.chain = [this.createGenesisBlock()];
    }

    createGenesisBlock() {
        return new Block(0, [], "0");
    }

    getLatestBlock() {
        return this.chain[this.chain.length - 1];
    }

    addTransaction(tx: any) {
        this.pendingTransactions.push(tx);
    }

    minePendingTransactions() {
        const block = new Block(
            this.chain.length,
            this.pendingTransactions,
            this.getLatestBlock().hash
        );

        block.mineBlock(this.difficulty);
        this.chain.push(block);
        this.pendingTransactions = [];
    }

    deployContract(code: any) {
        const address = randomBytes(20).toString("hex");

        this.contracts.set(address, {
            address,
            code,
            state: {}
        });

        return address;
    }

    callContract(address: string, method: string, args: any[]) {
        const contract = this.contracts.get(address);
        if (!contract) throw new Error("Contract not found");

        return contract.code[method](contract.state, ...args);
    }
}
