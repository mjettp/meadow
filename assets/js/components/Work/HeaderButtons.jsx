import React from "react";
import PropTypes from "prop-types";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import { Button } from "@nulib/admin-react-components";

export default function WorkHeaderButtons({
  handleCreateSharableBtnClick,
  handlePublishClick,
  onOpenModal,
  published,
}) {
  return (
    <div className="buttons is-right">
      <button
        className={`button is-primary ${published ? "is-outlined" : ""}`}
        data-testid="publish-button"
        onClick={handlePublishClick}
      >
        {!published ? "Publish" : "Unpublish"}
      </button>
      <Button onClick={handleCreateSharableBtnClick}>
        <span className="icon">
          <FontAwesomeIcon icon="link" />
        </span>
        <span>Create Sharable Link</span>
      </Button>
      <Button isText data-testid="delete-button" onClick={onOpenModal}>
        Delete
      </Button>
    </div>
  );
}

WorkHeaderButtons.propTypes = {
  handleCreateSharableBtnClick: PropTypes.func,
  handlePublishClick: PropTypes.func,
  onOpenModal: PropTypes.func,
  published: PropTypes.bool,
};
