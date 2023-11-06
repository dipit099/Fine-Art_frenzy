import React, { useCallback, useEffect, useState } from "react";
import { useHistory, Link } from "react-router-dom";

export default function FormField(props) {
  return (
    <label className="form-field-container">
      {props.labelName && <span className="form-field-label">{props.labelName}</span>}
      {props.inputType == "date" ? (
        <input
          className="form-field-input"
          type={props.inputType}
          placeholder={props.placeholder}
          value={props.value}
          onChange={props.handleSubmit}
        />
      ) : props.isTextArea ? (
        <textarea
          className="form-field-input"
          type={props.inputType}
          placeholder={props.placeholder}
          value={props.value}
          onChange={props.handleSubmit}
          rows={5}
          required
        />
      ) : (
        <input
          className="form-field-input"
          type={props.inputType}
          placeholder={props.placeholder}
          value={props.value}
          onChange={props.handleSubmit}
          step="0.1"
          required
        />
      )}
    </label>
  );
}
