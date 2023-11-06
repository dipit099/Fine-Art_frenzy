import React, { useCallback, useEffect, useState } from "react";
import { useHistory, Link } from "react-router-dom";

export default function CustomButton(props) {
  return (
    <button
      className="custom-button-container"
      type={props.buttonType}
      onClick={props.handleClick}
      style={props.styles}
    >
      {props.text}
    </button>
  );
}
