import React, { useCallback, useEffect, useState } from "react";
import { useHistory, Link } from "react-router-dom";
import { CustomButton, Unverified } from "../parts";
import { useContractReader } from "eth-hooks";
const { ethers } = require("ethers");

export default function Hints(props) {
  const unNormal = useContractReader(props.readContracts, "YourContract", "getUnverifiedNormalArtWorks", []);
  const unAuctioned = useContractReader(props.readContracts, "YourContract", "getUnverifiedAuctionedArtWorks", []);
  console.log("unNormal: ", unNormal);
  console.log("unAuctioned: ", unAuctioned);
  unNormal && unNormal.map(item => <Unverified key={item.id} title={item.title} description={item.description} />);
  unAuctioned &&
    unAuctioned.map(item => <Unverified key={item.id} title={item.title} description={item.description} />);

  function allNormal() {
    return (
      unNormal &&
      unNormal.map(item => (
        <Unverified
          key={item.id}
          title={item.title}
          description={item.description}
          type={item.typeOfWork}
          price={ethers.utils.formatUnits(item.price, 0)}
        />
      ))
    );
  }

  function allAuctioned() {
    return (
      unAuctioned &&
      unAuctioned.map(item => (
        <Unverified
          key={item.id}
          title={item.title}
          description={item.description}
          type={item.typeOfWork}
          price={ethers.utils.formatUnits(item.basePrice, 0)}
        />
      ))
    );
  }

  return (
    <div className="artworks-container">
      <div className="normal-container">
        <h1>Normal Artworks</h1>
        {allNormal()}
      </div>
      <div className="normal-container">
        <h1>Auctioned Artworks</h1>
        {allAuctioned()}
      </div>
    </div>
  );
}
