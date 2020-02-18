import React from "react";
import { useParams } from "react-router-dom";
import CollectionForm from "../../components/Collection/Form";
import Layout from "../Layout";
import Error from "../../components/UI/Error";
import Loading from "../../components/UI/Loading";
import { GET_COLLECTION } from "../../components/Collection/collection.query";
import { useQuery } from "@apollo/react-hooks";
import UIBreadcrumbs from "../../components/UI/Breadcrumbs";

const ScreensCollectionForm = () => {
  const { id } = useParams();
  const edit = !!id;
  let collection;
  let crumbs = [
    {
      label: "Collections",
      route: "/collection/list"
    }
  ];

  if (edit) {
    const { data, loading, error } = useQuery(GET_COLLECTION, {
      variables: { id }
    });

    if (loading) return <Loading />;
    if (error) return <Error error={error} />;

    crumbs.push(
      {
        label: data.collection.name,
        route: `/collection/${data.collection.id}`
      },
      {
        label: "Edit",
        isActive: true
      }
    );

    collection = data.collection;
  }

  if (!edit) {
    crumbs.push({
      label: "Add",
      isActive: true
    });
  }

  return (
    <Layout>
      <section className="hero is-light" data-testid="collection-form-hero">
        <div className="hero-body">
          <div className="container">
            <h1 className="title">
              {edit ? collection.name : "Create Collection"}
            </h1>
            <h2 className="subtitle">{edit ? "Collection" : ""}</h2>
          </div>
        </div>
      </section>
      <UIBreadcrumbs items={crumbs} />
      <section className="section">
        <div className="container">
          <CollectionForm collection={collection} />
        </div>
      </section>
    </Layout>
  );
};

export default ScreensCollectionForm;
