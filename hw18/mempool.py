from web3.auto import Web3
import asyncio
import json

# enter your node credentials here
wss = 'wss://eth-mainnet.g.alchemy.com/v2/JTuVq5zntYPcIPoCk56GnAw82kRD69kT'
web3 = Web3(Web3.WebsocketProvider(wss))


# Check to see if you are connected to your node
print(web3.isConnected())

# add an address you want to filter pending transactions for
# make sure the address is in the correct format
router = web3.toChecksumAddress('0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D')

def handle_event(event):

    try:
        # remove the quotes in the transaction hash
        transaction = Web3.toJSON(event).strip('"')
        # use the transaction hash (that we removed the '"' from to get the details of the transaction
        transaction = web3.eth.get_transaction(transaction)
        # set the variable to the "to" address in the message
        to = transaction['to']
        # if the to address in the message is the router
        if to == router:
            # print the transaction and its details
            print(transaction)
        else:
            print('Not what we are looking for')
    except Exception as err:
        # print transactions with errors. Expect to see transactions people submitted with errors
        print(f'error: {err}')


async def log_loop(event_filter, poll_interval):
    while True:
        for event in event_filter.get_new_entries():
            handle_event(event)
        await asyncio.sleep(poll_interval)


def main():
    # filter for pending transactions
    tx_filter = web3.eth.filter('pending')
    loop = asyncio.get_event_loop()
    try:
        loop.run_until_complete(
            asyncio.gather(
                log_loop(tx_filter, 2)))
    finally:
        loop.close()


if __name__ == '__main__':
    main()