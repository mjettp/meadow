import React from "react";
import { waitFor } from "@testing-library/react";
import {
  renderWithRouterApollo,
  withReactHookFormControl,
} from "../../../services/testing-helpers";
import BatchEditAboutIdentifiersMetadata from "./IdentifiersMetadata";
import { IDENTIFIER_METADATA } from "../../../services/metadata";
import { codeListRelatedUrlMock } from "../../Work/controlledVocabulary.gql.mock";

describe("BatchEditAboutIdentifiersMetadata component", () => {
  function setupTest() {
    const Wrapped = withReactHookFormControl(BatchEditAboutIdentifiersMetadata);
    return renderWithRouterApollo(<Wrapped />, {
      mocks: [codeListRelatedUrlMock],
    });
  }
  it("renders the component", async () => {
    let { queryByTestId } = setupTest();
    await waitFor(() => {
      expect(queryByTestId("identifiers-metadata")).toBeInTheDocument();
    });
  });

  it("renders expected identifiers metadata fields", async () => {
    let { getByTestId } = setupTest();

    await waitFor(() => {
      for (let item of IDENTIFIER_METADATA) {
        expect(getByTestId(item.name)).toBeInTheDocument();
      }
      expect(getByTestId("relatedUrl")).toBeInTheDocument();
    });
  });
});
