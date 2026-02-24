const TokenContract = {
    init(state: any, owner: string, supply: number) {
        state.balances = {};
        state.balances[owner] = supply;
    },

    transfer(state: any, from: string, to: string, amount: number) {
        if (!state.balances[from] || state.balances[from] < amount) {
            throw new Error("Insufficient balance");
        }

        state.balances[from] -= amount;
        state.balances[to] = (state.balances[to] || 0) + amount;
    },

    balanceOf(state: any, user: string) {
        return state.balances[user] || 0;
    }
};
