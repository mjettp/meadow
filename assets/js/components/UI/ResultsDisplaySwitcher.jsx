import React from "react";
import PropTypes from "prop-types";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";

const UIResultsDisplaySwitcher = ({ isListView, onGridClick, onListClick }) => {
  return (
    <div className="columns">
      <div className="column pt-0">
        <button
          className={`button is-fullwidth ${
            isListView ? "is-light" : "is-text"
          }`}
          onClick={onListClick}
          title="List View"
        >
          <span className={`icon`}>
            <FontAwesomeIcon icon="th-list" />
          </span>
          <span>List View</span>
        </button>
      </div>
      <div className="column pt-0">
        <button
          className={`button is-fullwidth ${
            isListView ? "is-text" : "is-light"
          }`}
          onClick={onGridClick}
          title="Grid View"
        >
          <span className={`icon`}>
            <FontAwesomeIcon icon="th-large" />
          </span>
          <span>Grid View</span>
        </button>
      </div>
    </div>
  );
};

UIResultsDisplaySwitcher.propTypes = {
  isListView: PropTypes.bool,
  onGridClick: PropTypes.func,
  onListClick: PropTypes.func,
};

export default UIResultsDisplaySwitcher;
