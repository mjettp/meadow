export const VISIBILITY_OPTIONS = [
  { label: "Institution", value: "AUTHENTICATED" },
  { label: "Public", value: "OPEN" },
  { label: "Private", value: "RESTRICTED" }
];
export const IIIF_SIZES = {
  IIIF_SQUARE: "/square/500,500/0/default.jpg",
  IIIF_FULL: "/full/full/0/default.jpg"
};
export const PRESERVATION_LEVELS = [
  { label: "Level 1", id: 1 },
  { label: "Level 2", id: 2 },
  { label: "Level 3", id: 3 }
];
export const RIGHTS_STATEMENTS = [
  {
    id: " http://rightsstatements.org/vocab/InC/1.0/",
    term: "In Copyright",
    active: true
  },
  {
    id: " http://rightsstatements.org/vocab/InC-OW-EU/1.0/  ",
    term: "In Copyright - EU Orphan Work",
    active: true
  },
  {
    id: " http://rightsstatements.org/vocab/InC-EDU/1.0/",
    term: "In Copyright - Educational Use Permitted",
    active: true
  },
  {
    id: " http://rightsstatements.org/vocab/InC-NC/1.0/",
    term: "In Copyright - Non-Commercial Use Permitted",
    active: true
  },
  {
    id: " http://rightsstatements.org/vocab/InC-RUU/1.0/",
    term: "In Copyright - Rights-holder(s) Unlocatable or Unidentifiable",
    active: true
  },
  {
    id: " http://rightsstatements.org/vocab/NoC-CR/1.0/",
    term: "No Copyright - Contractual Restrictions",
    active: true
  },
  {
    id: " http://rightsstatements.org/vocab/NoC-NC/1.0/",
    term: "No Copyright - Non-Commercial Use Only ",
    active: true
  },
  {
    id: " http://rightsstatements.org/vocab/NoC-OKLR/1.0/",
    term: "No Copyright - Other Known Legal Restrictions",
    active: true
  },
  {
    id: " http://rightsstatements.org/vocab/NoC-US/1.0/",
    term: "No Copyright - United States",
    active: true
  },
  {
    id: " http://rightsstatements.org/vocab/CNE/1.0/",
    term: "Copyright Not Evaluated",
    active: true
  },
  {
    id: " http://rightsstatements.org/vocab/UND/1.0/",
    term: "Copyright Undetermined",
    active: true
  },
  {
    id: " http://rightsstatements.org/vocab/NKC/1.0/  ",
    term: "No Known Copyright",
    active: true
  }
];
