import React, { useCallback, useEffect, useState } from "react";
import { useHistory, Link } from "react-router-dom";
import { FormField, CustomButton } from "../parts";
import { daysLeft } from "../utils";

const { ethers } = require("ethers");

export default function ExampleUI(props) {
  const navigate = useHistory();
  const [form, setForm] = useState({
    title: "",
    description: "",
    deadline: "",
    image: "",
    price: "",
    type: "",
  });
  const buttonStyles = {
    backgroundColor: "#1dc071",
  };

  const handleFormFieldChange = (fieldName, e) => {
    setForm(prev => ({ ...prev, [fieldName]: e.target.value }));
  };

  const handleSubmit = e => {
    e.preventDefault();
    alert("Item has been uploaded!");
    if (form.deadline) {
      const realDeadline = daysLeft(form.deadline);
      const tx = props.writeContracts.YourContract.createAuctionedArtwork(
        form.title,
        form.description,
        form.image,
        realDeadline,
        form.price,
        form.type,
      );
    }
    const tx = props.writeContracts.YourContract.createNormalArtWork(
      form.title,
      form.description,
      form.image,
      form.price,
      form.type,
    );
    console.log(tx);
  };

  return (
    <div className="create-campaign-container">
      <div className="create-campaign-top">
        <h1 className="campaign-header">Create New Listing</h1>
      </div>
      <form onSubmit={handleSubmit} className="create-campaign-form">
        <div className="select-type">
          <select
            value={form.type}
            onChange={e => {
              handleFormFieldChange("type", e);
            }}
          >
            <option value="option1">{(form.type = "ArtWork")}</option>
            <option value="option2">{(form.type = "Collectible")}</option>
          </select>
        </div>
        <div className="upload-image">
          <FormField
            labelName="Title *"
            placeholder="Write a Title"
            inputType="text"
            value={form.title}
            handleSubmit={e => {
              handleFormFieldChange("title", e);
            }}
          />
        </div>
        <div className="upload-image">
          <FormField
            labelName="Image *"
            placeholder="Upload Image"
            inputType="file"
            value={form.image}
            handleSubmit={e => {
              handleFormFieldChange("image", e);
            }}
          />
        </div>
        <div className="upload-image">
          <FormField
            labelName="Description *"
            placeholder="Description of the image *"
            isTextArea
            value={form.description}
            handleSubmit={e => {
              handleFormFieldChange("description", e);
            }}
          />
        </div>
        <div className="upload-image">
          <FormField
            labelName="Price *"
            placeholder="Set your Price in ETH"
            inputType="number"
            value={form.target}
            handleSubmit={e => {
              handleFormFieldChange("price", e);
            }}
          />
        </div>
        <div className="upload-image">
          <FormField
            labelName="End Date"
            placeholder="End Date"
            inputType="date"
            value={form.deadline}
            handleSubmit={e => {
              handleFormFieldChange("deadline", e);
            }}
          />
        </div>
        <div className="submit-button">
          <CustomButton buttonType="submit" text="Submit New ArtWork" styles={buttonStyles} />
        </div>
      </form>
    </div>
  );
}
