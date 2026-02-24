import { createHash } from "node:crypto";

export class Block {
    index: number;
    timestamp: number;
    transactions: any[];
    previousHash: string;
    nonce: number = 0;
    hash: string;

    constructor(index: number, transactions: any[], previousHash: string) {
        this.index = index;
        this.timestamp = Date.now();
        this.transactions = transactions;
        this.previousHash = previousHash;
        this.hash = this.calculateHash();
    }

    calculateHash() {
        return createHash("sha256")
            .update(
                this.index +
                this.previousHash +
                this.timestamp +
                JSON.stringify(this.transactions) +
                this.nonce
            )
            .digest("hex");
    }

    mineBlock(difficulty: number) {
        while (!this.hash.startsWith("0".repeat(difficulty))) {
            this.nonce++;
            this.hash = this.calculateHash();
        }
        console.log("Block mined:", this.hash);
    }
}
