# Microsoft Office Template Framework

Create, version, brand, package, and deploy professional Microsoft Office templates using Git and GitHub.

This repository provides:

- A professionally styled Microsoft Office specimen document.
- A recommended repository structure.
- A GitHub Actions workflow that packages deployment-ready templates into GitHub Releases.
- A repeatable workflow for maintaining multiple branded templates from a single source.

The initial focus of this project is Microsoft Word (`.dotx`) templates, although the overall architecture also supports Microsoft PowerPoint (`.potx`), Microsoft Excel (`.xltx`), and other Microsoft Office template types.

---

# Quick Start

## Step 1 — Read this README

Before cloning any repository, read this README to understand the recommended repository structure and workflow.

---

## Step 2 — Create your own repository

Create a GitHub repository that will contain your Microsoft Office templates.

A recommended naming convention is:

```text
microsoft-office-template-<identity>
```

For example:

```text
microsoft-office-template-mytemplates
```

Your repository will become the home for all of your Microsoft Office templates.
It may contain templates for personal use, your employer, volunteer organizations, customers, projects,
or any other identities for which you prepare documents.

Clone your new repository to your computer and change into its top-level directory.

---

## Step 3 — Add the `microsoft-office-template` repository as a Git submodule

From the top-level directory of your repository, add the public repository as a Git submodule.

### HTTPS (recommended)

```bash
git submodule add https://github.com/SteveAmerige/microsoft-office-template.git
```

### SSH

```bash
git submodule add git@github.com:SteveAmerige/microsoft-office-template.git
```

Git creates the submodule directory:

```text
microsoft-office-template/
```

which remains an unmodified copy of the public project.

---

## Step 4 — Create your editable master specimen

Copy

```text
microsoft-office-template/src/Style-Specimen.docx
```

to

```text
src/Style-Specimen.docx
```

within your own repository.

This serves two important purposes.

First, it protects the original specimen document from accidental modification.

Second, it creates your own editable master copy that you may customize independently as the public project evolves.

Never edit the copy contained within the Git submodule. To contribute changes to the public project,
work from a separate clone or fork and submit a pull request.
---

## Step 5 — Create your branded source documents

Copy your editable master specimen into one or more brand-specific directories.

For example:

```text
src/
├── Style-Specimen.docx
│
└── brands/
    ├── <brand-a>/
    │   └── <brand-a>.docx
    │
    ├── <brand-b>/
    │   └── <brand-b>.docx
    │
    └── <brand-c>/
        └── <brand-c>.docx
```

Each copy becomes the editable source document for one brand.

You are free to organize your brands in whatever manner best suits your own requirements.
For example, you might maintain templates for personal correspondence,
your employer, an organization where you volunteer, one or more customers,
or any other identity for which you prepare Microsoft Office documents.

---

## Step 6 — Brand your templates

Customize each branded source document.

Typical changes include:

- replacing the header logo;
- updating contact information;
- making any organization- or project-specific customizations.

When the document is ready, save it as the appropriate Microsoft Office template.

Examples:

```text
Brand.docx
    ↓
Brand.dotx

Presentation.pptx
    ↓
Presentation.potx

Workbook.xlsx
    ↓
Workbook.xltx
```

Copy the resulting template files into:

```text
releases/
```

---

## Step 7 — Publish a release

Run the GitHub Actions workflow:

```text
Publish Office Templates
```

The workflow packages every template contained in the `releases/` directory into a GitHub Release.

The resulting release can then be downloaded and installed on any computer or virtual machine where you use Microsoft Office.
Detailed instructions for creating a release are provided in:

```text
.github/workflows/README.md
```

---

## Step 8 — Install the templates

Download the latest release you have created onto computers or VMs on which you wish to use it.

Extract the ZIP archive.

Copy the templates into your Microsoft Office Personal Templates folder.

On Windows this is commonly:

```text
%USERPROFILE%\Documents\Custom Office Templates
```

Restart Microsoft Office if necessary so that the new templates appear in the available template list.

---

# Updating the Public Template

When improvements become available in the public repository:

```bash
cd microsoft-office-template

git pull
```

Review the updated specimen document.

Copy any desired improvements into your own editable master specimen.

From there, propagate those changes into whichever branded source documents require updating.

Regenerate the corresponding Office templates and publish a new release.

---

# Repository Layout

```text
.
├── README.md
├── LICENSE
├── .gitignore
├── .gitattributes
├── src/
│   └── Style-Specimen.docx
├── releases/
└── .github/
    └── workflows/
```

The public repository intentionally contains no organization-specific branding.

Your own repository contains your editable master specimen, your branded source documents, and the deployment-ready templates that will be packaged into releases.

---

# Workflow Documentation

The GitHub Actions workflow is documented separately in:

```text
.github/workflows/README.md
```

---

# Contributing

Suggestions, corrections, improvements, and new ideas are welcome.

Please consider opening an Issue before submitting a Pull Request for significant changes.

---

# License

This project is licensed under the MIT License.

See the accompanying `LICENSE` file for details.
