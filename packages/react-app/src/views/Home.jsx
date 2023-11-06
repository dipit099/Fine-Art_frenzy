import { useContractReader } from "eth-hooks";
import { ethers } from "ethers";
import React from "react";
import { Link, useHistory } from "react-router-dom";
import stylesheets from "./home.css";

/**
 * web3 props can be passed from '../App.jsx' into your local view component for use
 * @param {*} yourLocalBalance balance on current network
 * @param {*} readContracts contracts from current chain already pre-loaded using ethers contract module. More here https://docs.ethers.io/v5/api/contract/contract/
 * @returns react component
 **/
function Home({ yourLocalBalance, readContracts }) {
  // you can also use hooks locally in your component of choice
  // in this case, let's keep track of 'purpose' variable from our contract
  const purpose = useContractReader(readContracts, "YourContract", "purpose");
  const navigate = useHistory();

  return (
    <div>
      <div>
        <h1>
          <Link to="/exampleui" className="home_buttons">
            {" "}
            CREATOR
          </Link>
        </h1>
        <h1>
          <Link to="/hints" className="home_buttons">
            {" "}
            COLLECTOR
          </Link>
        </h1>
        <h1>
          <Link to="/subgraph" className="home_buttons">
            {" "}
            VERIFIER
          </Link>
        </h1>
      </div>
    </div>
  );
}

export default Home;
