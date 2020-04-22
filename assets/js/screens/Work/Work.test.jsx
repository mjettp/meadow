import React from "react";
import ScreensWork from "./Work";
import { Route } from "react-router-dom";
import { renderWithRouterApollo } from "../../services/testing-helpers";
import { GET_WORK } from "../../components/Work/work.query";
import { waitForElement } from "@testing-library/react";

const mocks = [
  {
    request: {
      query: GET_WORK,
      variables: {
        id: "ABC123"
      }
    },
    result: {
      data: {
        work: {
          accessionNumber: "Donohue_001",
          administrativeMetadata: {
            preservationLevel: 1,
            rightsStatement: "https://northwestern.edu"
          },
          collection: {
            id: "1287312378238293126321308",
            name: " Collection 1232432 Name"
          },
          descriptiveMetadata: {
            description: "Some description here",
            title: "Ima work title",
            genre: [
              {
                id: "https://theurioftheresource123",
                label: "This is the label"
              }
            ],
            language: [
              {
                id: "https://theurioftheresource",
                label: "This is the label"
              }
            ],
            location: [
              {
                id: "https://theurioftheresource",
                label: "This is the label"
              }
            ],
            stylePeriod: [
              {
                id: "https://theurioftheresource",
                label: "This is the label"
              }
            ],
            technique: [
              {
                id: "https://theurioftheresource",
                label: "This is the label"
              }
            ]
          },
          fileSets: [
            {
              accessionNumber: "Donohue_001_04",
              id: "01E08T3EXBJX3PWDG22NSRE0BS",
              role: "AM",
              metadata: {
                description: "Letter, page 2, If these papers, verso, blank",
                originalFilename: "coffee.jpg",
                location: "s3://bucket/foo/bar",
                label: "foo.tiff",
                sha256: "foobar"
              }
            },
            {
              accessionNumber: "Donohue_001_01",
              id: "01E08T3EW3TQ9T0AXCR6X9QDJW",
              role: "AM",
              metadata: {
                description: "Letter, page 1, Dear Sir, recto",
                originalFilename: "coffee.jpg",
                location: "s3://bucket/foo/bar",
                label: "foo.tiff",
                sha256: "foobar"
              }
            },
            {
              accessionNumber: "Donohue_001_03",
              id: "01E08T3EWRPXMWW0B1NHZ56AW6",
              role: "AM",
              metadata: {
                description: "Letter, page 2, If these papers, recto",
                originalFilename: "coffee.jpg",
                location: "s3://bucket/foo/bar",
                label: "foo.tiff",
                sha256: "foobar"
              }
            },
            {
              accessionNumber: "Donohue_001_02",
              id: "01E08T3EWFJB35RY3RVR65AXMK",
              role: "AM",
              metadata: {
                description: "Letter, page 1, Dear Sir, verso, blank",
                originalFilename: "coffee.jpg",
                location: "s3://bucket/foo/bar",
                label: "foo.tiff",
                sha256: "foobar"
              }
            }
          ],
          id: "ABC123",
          insertedAt: "2020-02-04T19:16:16",
          published: false,
          project: {
            id: "28b6dd45-ef3e-45df-b380-985c9af8b495",
            name: "Foo"
          },
          sheet: {
            id: "28b6dd45-ef3e-45df-b380-985c9af8b495",
            name: "Bar"
          },
          updatedAt: "2020-02-04T19:16:16",
          visibility: "RESTRICTED",
          workType: "IMAGE",
          manifestUrl: "http://foobar",
          representativeImage: "http://foobar"
        }
      }
    }
  }
];

// This function helps mock out a component's dependency on
// react-router's param object
function setupMatchTests() {
  return renderWithRouterApollo(
    <Route path="/work/:id" component={ScreensWork} />,
    {
      mocks,
      route: "/work/ABC123"
    }
  );
}

it("renders without crashing", () => {
  setupMatchTests();
});

it("renders Publish, and Delete buttons", async () => {
  const { findByTestId, getByTestId } = setupMatchTests();
  const buttonEl = await findByTestId("publish-button");
  expect(buttonEl).toBeInTheDocument();
  expect(getByTestId("delete-button")).toBeInTheDocument();
});

it("renders breadcrumbs", async () => {
  const { findByTestId, debug } = setupMatchTests();
  const crumbsEl = await findByTestId("work-breadcrumbs");
  expect(crumbsEl).toBeInTheDocument();
});

it("renders the Work component", () => {});

// it("displays the project title", async () => {
//   const { findAllByText, debug } = setupMatchTests();
//   const projectTitleArray = await findAllByText(MOCK_PROJECT_TITLE);

//   expect(projectTitleArray.length).toEqual(1);
// });
