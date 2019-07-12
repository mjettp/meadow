import React from "react";
import { render, cleanup } from "@testing-library/react";
// this adds custom jest matchers from jest-dom
import "@testing-library/jest-dom/extend-expect";
import HomePage from "./Home";

afterEach(cleanup);

test("Home page component renders", () => {
  const { container } = render(<HomePage />);
  expect(container).toBeTruthy();
});