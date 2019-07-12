import React from "react";
import { Link } from "react-router-dom";
import NavLink from "./NavLink";

const navLinks = [
  {
    url: "/project/list",
    title: "Projects"
  },
  {
    url: "/",
    title: "User Management"
  },
  {
    url: "/",
    title: "Works"
  },
  {
    url: "/",
    title: "Collections"
  },
  {
    url: "/",
    title: "Dashboards"
  },
  {
    url: "/",
    title: "Admin Sets"
  }
];

const Header = () => (
  <header>
    <section className="container mx-auto uppercase">
      <nav className="flex items-center justify-between flex-wrap bg-gray-300 p-6">
        <div className="flex items-center flex-shrink-0 text-white mr-6">
          <Link to="/" className="font-semibold text-xl tracking-tight">
            Meadow
          </Link>
        </div>
        <div className="block lg:hidden">
          <button className="flex items-center px-3 py-2 border rounded border-black hover:text-white hover:border-white">
            <svg
              className="fill-current h-3 w-3"
              viewBox="0 0 20 20"
              xmlns="http://www.w3.org/2000/svg"
            >
              <title>Menu</title>
              <path d="M0 3h20v2H0V3zm0 6h20v2H0V9zm0 6h20v2H0v-2z" />
            </svg>
          </button>
        </div>
        <div className="w-full block flex-grow lg:flex lg:items-center lg:w-auto">
          <div className="text-sm lg:flex-grow">
            {navLinks.map(item => (
              <NavLink key={item.title} url={item.url} title={item.title} />
            ))}
          </div>
          <div>
            <a href="#" className="btn">
              Login
            </a>
          </div>
        </div>
      </nav>
    </section>
  </header>
);

export default Header;