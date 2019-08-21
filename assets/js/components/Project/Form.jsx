import React from "react";
import { withRouter } from "react-router-dom";
import { useMutation } from "@apollo/react-hooks";
import { toast } from "react-toastify";
import UIButton from "../UI/Button";
import UIButtonGroup from "../UI/ButtonGroup";
import { CREATE_PROJECT, GET_PROJECTS } from "./project.query.js";

const ProjectForm = ({ history }) => {
  let inputTitle;
  const [createProject, { data }] = useMutation(CREATE_PROJECT, {
    onCompleted({ createProject }) {
      toast(`Project ${createProject.title} created successfully`);
      history.push("/project/list");
    },
    refetchQueries(mutationResult) {
      return [{ query: GET_PROJECTS }];
    }
  });

  const handleCancel = e => {
    history.push("/project/list");
  };

  return (
    <>
      <form
        onSubmit={e => {
          e.preventDefault();
          createProject({
            variables: { projectTitle: inputTitle.value }
          });
        }}
      >
        <div className="mb-4">
          <label
            className="block text-gray-700 text-sm font-bold mb-2"
            htmlFor="username"
          >
            Project Title
          </label>
          <input
            id="project-title"
            type="text"
            placeholder="Project Title"
            ref={node => {
              inputTitle = node;
            }}
            className="text-input"
          />
        </div>

        <UIButtonGroup>
          <UIButton type="submit">Submit</UIButton>
          <UIButton classes="btn-clear" onClick={handleCancel}>
            Cancel
          </UIButton>
        </UIButtonGroup>
      </form>
    </>
  );
};

export default withRouter(ProjectForm);
