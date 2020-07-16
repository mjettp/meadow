import React from "react";
import { setVisibilityClass } from "../../services/helpers";
import PropTypes from "prop-types";

export default function WorkTagsList({ work }) {
  if (!work) {
    return null;
  }
  return (
    <p>
      <span className={`tag ${work.published ? "is-info" : "is-warning"}`}>
        {work.published ? "Published" : "Not Published"}
      </span>{" "}
      {work.visibility && (
        <span className={`tag ${setVisibilityClass(work.visibility.id)}`}>
          {work.visibility.label}
        </span>
      )}
      {work.workType && (
        <span className={`tag is-info`}>{work.workType.label}</span>
      )}
    </p>
  );
}

WorkTagsList.propTypes = {
  work: PropTypes.object,
};