import React, { useCallback, useEffect, useState } from "react";
import { useHistory, Link } from "react-router-dom";
const { ethers } = require("ethers");

export default function Unverified(props) {
  return (
    <div className="unverified-container">
      <p>{props.title}</p>
      <p>{props.description}</p>
      <p>{props.price}</p>
      <p>{props.type}</p>
      {<button onClick={props.verify}>Verify</button>}
    </div>
  );
}
