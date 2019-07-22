import React, { useState } from "react";
import axios from "axios";
import { toast } from "react-toastify";
import PropTypes from "prop-types";
import { withRouter } from "react-router-dom";
import ButtonGroup from "../UI/ButtonGroup";
import UIForm from "../UI/Form/Form";
import UIInput from "../UI/Form/Input";
import UIButton from "../UI/Button";

const InventorySheetForm = ({ history, projectId }) => {
  const [values, setValues] = useState({ ingest_job_name: "", file: "" });

  const handleInputChange = event => {
    event.persist();
    const { name, value } = event.target;
    setValues({ ...values, [name]: value });
  };

  const handleCancel = () => {
    history.push(`/project/${projectId}`);
  };

  const handleSubmit = async event => {
    if (event) event.preventDefault();

    let options = {
      headers: {
        "Content-Type": "binary/octet-stream"
      }
    };

    const { ingest_job_name, file } = values;

    try {
      const response = await axios.get("/api/v1/ingest_jobs/presigned_url");
      const presignedUrl = response.data.data.presigned_url;
      const filename = presignedUrl
        .split("?")[0]
        .split("/")
        .pop();

      await axios.put(presignedUrl, file, options);
      const ingestJobResponse = await axios.post("/api/v1/ingest_jobs", {
        ingest_job: {
          name: ingest_job_name,
          presigned_url: presignedUrl,
          project_id: id,
          filename: filename
        }
      });

      toast(`${ingest_job_name} created successfully`);
      history.push(
        `/project/${id}/inventory-sheet/${ingestJobResponse.data.data.id}`
      );
    } catch (error) {
      if (error.response) {
        console.log(`Error Status Code: ${error.response.status}`);
        console.log(
          `Error creating ingest job: ${JSON.stringify(
            error.response.data.errors
          )}`
        );
        toast(
          `Status Code: ${
            error.response.status
          } error creating ingest job: ${JSON.stringify(
            error.response.data.errors
          )}`
        );
      } else {
        console.log(error);
        toast(`Error: ${error}`);
      }
    }
  };

  return (
    <UIForm
      testId="inventory-sheet-upload-form"
      classes="content-block"
      onSubmit={handleSubmit}
    >
      <UIInput
        label="Ingest Job Name"
        name="ingest_job_name"
        id="ingest_job_name"
        onChange={handleInputChange}
      />
      <UIInput
        label="Inventory sheet file"
        id="file"
        name="file"
        type="file"
        onChange={handleInputChange}
      />
      <ButtonGroup>
        <UIButton
          type="submit"
          label="Submit"
          disabled={!values.ingest_job_name || !values.file}
        />
        <UIButton label="Cancel" classes="btn-cancel" onClick={handleCancel} />
      </ButtonGroup>
    </UIForm>
  );
};

InventorySheetForm.propTypes = {
  history: PropTypes.shape({
    push: PropTypes.func.isRequired
  }).isRequired,
  projectId: PropTypes.string.isRequired
};

export default withRouter(InventorySheetForm);
