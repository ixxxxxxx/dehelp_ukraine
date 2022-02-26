# Code > War

1. Introduction

This project let people publish donations and claim them for other.

This smart contract have an owner, but this owner can do nothing.

Use it as safely as possible, it is made by and for people.

Donators publish their donation and send money to the contract.
This donation is freezed in the contract.

The recipient then publishes their contact (Telegram user, Twitter user, Instagram user, etc) to know donator.
The donator must be alert for when their offer has been claimed, and in a totally free and P2P way, they set up a conversation to get to know each other and verify recipient address.

If the donator agrees to help, they just release their payment. If he is not, he withdraws the offer.

2. Usage

- Adam is the donator
- Vlad is the grantee

- Adam publish a donation => addDonation
- Vlad sign up to receive donation => addGrantee(donationId, "@TelegramUser")
- If Vlad wants to change his contact => changeContact(donationId, "NewContact")
- When Adam wants to retire a donation => retireDonation(donationId)
- If Adam and Vlad contact each other and Adam feels it is right to donate => doDonation(donationId)

3. Considerations

This smart contract will be deployed in the network ...

4. TODO

[] A frontend to make this bad pill to swallow easier.
[] Publish frontend
[] Explain people how to get donations.

Disclaimer of liability: This code is free, feel free to modify and improve it.

Best of luck Ukraine.