import React from "react";

export const REACTIVE_SEARCH_THEME = {
  typography: {
    fontFamily: "Akkurat Pro Regular",
  },
};

const facetClasses = {
  label: "facet-item-label",
  checkbox: "facet-checkbox",
};

const defaultListItemValues = {
  innerClass: facetClasses,
  showSearch: false,
};

// Map of Facet "sensor id" values which ReactiveSearch needs to pull in
// multiple ReactiveSearch "List Components" into search bar and results list
//
// Make each object match the shape of this API:
// https://docs.appbase.io/docs/reactivesearch/v3/list/multilist/
export const FACET_SENSORS = [
  {
    ...defaultListItemValues,
    componentId: "FacetContributor",
    dataField: "descriptiveMetadata.contributor.displayFacet",
    title: "Contributor",
  },
  {
    ...defaultListItemValues,
    componentId: "FacetCollection",
    dataField: "collection.id",
    title: "Collection",
  },
  {
    ...defaultListItemValues,
    componentId: "FacetGenre",
    dataField: "descriptiveMetadata.genre.displayFacet",
    title: "Genre",
  },
  {
    ...defaultListItemValues,
    componentId: "FacetLanguage",
    dataField: "descriptiveMetadata.language.displayFacet",
    title: "Language",
  },
  {
    ...defaultListItemValues,
    componentId: "FacetLicense",
    dataField: "descriptiveMetadata.license.label.keyword",
    title: "License",
  },
  {
    ...defaultListItemValues,
    componentId: "FacetLocation",
    dataField: "descriptiveMetadata.location.displayFacet",
    title: "Location",
  },
  {
    ...defaultListItemValues,
    componentId: "FacetPublished",
    dataField: "published",
    renderItem: function (label, count) {
      return (
        <span>
          <span>{label ? "YES" : "NO"}</span>
          <span>{count}</span>
        </span>
      );
    },
    title: "Published",
    // Need this as ReactiveSearch complains when we send back a 1/0, instead of true/false
    transformData: function (data) {
      return data.map((item) => ({ ...item, key: item.key === 1 }));
    },
  },
  {
    ...defaultListItemValues,
    componentId: "FacetRightsStatement",
    dataField: "descriptiveMetadata.rightsStatement.label.keyword",
    title: "Rights Statement",
  },
  {
    ...defaultListItemValues,
    componentId: "FacetVisibility",
    dataField: "visibility.label.keyword",
    title: "Visibility",
  },
];
