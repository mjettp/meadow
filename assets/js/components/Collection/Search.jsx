import React from "react";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";

const CollectionSearch = () => {
  let items = [];

  for (let i = 0; i < 20; i++) {
    items.push(
      <li className="column is-one-quarter-desktop is-half-tablet" key={i}>
        <figure className="image is-square">
          <img src="/images/480x480.png" />
        </figure>
        <p className="text-center">{`Image title ${i} `}</p>
      </li>
    );
  }

  return (
    <>
      <section data-testid="collection-search" className="section">
        <div className="field">
          <div className="control has-icons-left">
            <input
              className="input"
              type="text"
              placeholder="Search collections"
            />
            <span className="icon is-small is-left">
              <FontAwesomeIcon icon="search" />
            </span>
          </div>
        </div>
        <p className="field">
          <a>Show Filters</a>
        </p>
      </section>

      <nav className="level">
        <div className="level-left">
          <div className="level-item">
            <p className="is-size-5">
              <strong>3000 results...</strong>
            </p>
          </div>
        </div>
        <div className="level-right">
          <div className="level-item">
            <button className="button">Batch Edit Records</button>
          </div>
          <div className="level-item">
            <button className="button">Export CSV</button>
          </div>
        </div>
      </nav>

      <section className="section">
        <ul className="columns is-multiline">{items}</ul>
      </section>
    </>
  );
};

export default CollectionSearch;
