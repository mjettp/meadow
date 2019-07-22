import React, { useEffect, useState } from "react";
import Main from "../../components/UI/Main";
import { withRouter } from "react-router-dom";
import axios from "axios";
import InventorySheetForm from "../../components/InventorySheet/Form";
import { toast } from "react-toastify";

const ScreensInventorySheetForm = ({ history, match, location }) => {
  const { id } = match.params;
  const [values, setValues] = useState({ ingestJobName: "", file: "" });

  const handleInputChange = event => {
    event.persist();
    const { name, value } = event.target;
    setValues({ ...values, [name]: value });
  };

  const handleCancel = () => {
    history.push(`/project/${id}`);
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
    <Main>
      <h1>New Ingest Job</h1>
      <InventorySheetForm
        handleCancel={handleCancel}
        handleSubmit={handleSubmit}
        handleInputChange={handleInputChange}
      />
    </Main>
  );
};

export default withRouter(ScreensInventorySheetForm);
