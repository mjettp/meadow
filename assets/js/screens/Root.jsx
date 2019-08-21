import React from "react";
import { BrowserRouter, Route, Switch } from "react-router-dom";
import { ToastContainer } from "react-toastify";
import "react-toastify/dist/ReactToastify.css";

import Header from "../components/UI/Header";
import FetchDataPage from "./fetch-data";
import ScreensProjectList from "./Project/List";
import ScreensProjectForm from "./Project/Form";
import Project from "./Project/Project";
import Home from "./Home/Home";
import NotFoundPage from "./404";
import ScreensInventorySheet from "./InventorySheet/InventorySheet";
import ScreensInventorySheetForm from "./InventorySheet/Form";
import Layout from "./Layout";

export default class Root extends React.Component {
  render() {
    return (
      <>
        <BrowserRouter>
          <Header />
          <ToastContainer
            position="top-center"
            hideProgressBar
            autoClose={7000}
          />
          <Layout>
            <Switch>
              <Route path="/fetch-data" component={FetchDataPage} />
              <Route path="/project/list" component={ScreensProjectList} />
              <Route path="/project/create" component={ScreensProjectForm} />
              <Route
                path="/project/:id/inventory-sheet/upload"
                component={ScreensInventorySheetForm}
              />
              <Route
                path="/project/:id/inventory-sheet/:inventorySheetId"
                component={ScreensInventorySheet}
              />
              <Route path="/project/:id" component={Project} />
              <Route path="/" component={Home} />
              <Route component={NotFoundPage} />
            </Switch>
          </Layout>
        </BrowserRouter>
      </>
    );
  }
}
