const { expect } = require("chai");
const { ethers, waffle } = require("hardhat");

let x;
let owner;
let A1;
let A2;
let A3;
let A4;

describe("C:", function () {

  this.beforeAll(async function(){
    try{
      [owner,A1,A2,A3,A4] = await ethers.getSigners();
      const X = await ethers.getContractFactory("JustAnotherHelp");
      x = await X.deploy();
      await x.deployed();
    }
    catch(ex){
      console.error(ex);
    }
  });

  it("Get donations", async function () {
    const r = await x.getAllDonations()
    expect(r.length).to.equal(0)
  });

  //1
  it("New donation", async function(){
    const donation = ethers.utils.parseEther("1");

    const value = {
      value : donation
    }

    await expect(x.connect(A1).addDonation(value),'add donation').to.emit(x, "DonationAdded");

    expect(await x.getBalance(),'getBalance').to.equal(donation);
  });

  it("Try to do donation without grantee",async function(){
    await expect(x.connect(A1).doDonation(1),'doDonation revert').to.be.revertedWith("Grantee is zero address");
  });

  it("Grantee be added to first donation", async function(){
    await expect(x.connect(A2).addGrantee(1,"@Coco"),'add grantee').to.emit(x,"GranteeAdded");
  });

  it("A3 try to stole donation", async function(){
    await expect(x.connect(A3).retireDonation(1),'stole donation').to.be.revertedWith("Not the donator");
  });

  it("A3 try to change contact", async function(){
    await expect(x.connect(A3).changeContact(1,"x"),'change contact').to.be.revertedWith("Not the grantee");
  });

  it("A2 change contact", async function(){
    await expect(x.connect(A2).changeContact(1, "@Rocco")).to.emit(x,"ContactChanged");
  });

  it("Check if contact is changed",async function(){
    const exp_contact = "@Rocco";
    const r = await x.getDonation(1);
    expect(r.contact).to.equal(exp_contact);
  });

  //2
  it("New donation", async function(){
    const donation = ethers.utils.parseEther("0.1");

    const value = {
      value : donation
    }

    await expect(x.connect(A1).addDonation(value),'new donation added').to.emit(x,"DonationAdded");
  });

  it("Donation send", async function(){
    const provider = waffle.provider;
    let balance = await provider.getBalance(A2.address);
    let before = parseInt(ethers.utils.formatEther(balance.toString()));

    let donation = await x.getDonation(1);
    donation = parseInt(ethers.utils.formatEther(donation.quantity.toString()));

    await expect(x.connect(A1).doDonation(1)).to.emit(x,"DonationDone");
    
    balance = await provider.getBalance(A2.address);
    let after = parseInt(ethers.utils.formatEther(balance.toString()));

    expect(before + donation).to.equal(after);
  });

  it("Retire donation (revert)", async function(){
    await expect(x.connect(owner).retireDonation(2),'retire should revert').to.be.revertedWith("Not the donator");
  });

  it("Retire donation", async function(){
    await expect(x.connect(A1).retireDonation(2),'retire donation').to.emit(x,"DonationRetired");
  });

  it("No donations", async function(){
    const all = await x.getAllDonations();
    const activeDonations = all.filter(e => e.exists);

    expect(activeDonations.length).to.equal(0);
  });
});
