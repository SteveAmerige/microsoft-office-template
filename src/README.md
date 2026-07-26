# Editable Source Documents

This directory contains the editable Microsoft Office documents from which deployment-ready templates are created.

The primary file is:

```text
Style-Specimen.docx
```

This specimen document is the authoritative source for document styles, typography, numbering, spacing, colors, and other reusable formatting conventions.

## Getting Started

Do **not** edit the copy of `Style-Specimen.docx` contained in the public `microsoft-office-template` repository.

Instead:

1. Copy `Style-Specimen.docx` into the `src/` directory of your own repository.
2. Use that copy as your editable master specimen.
3. Make any style improvements to your own copy.
4. Copy your master specimen to create one or more brand-specific source documents.
5. Customize each branded document as needed.
6. Save each branded document as the appropriate Microsoft Office template type.
7. Copy the completed template files into your repository's `releases/` directory.

Keeping the public specimen unchanged makes it easy to incorporate future improvements from the public repository while preserving your own customizations.

## What Belongs Here

Examples of files that belong in this directory include:

- Microsoft Word source documents (`.docx`)
- Microsoft PowerPoint source presentations (`.pptx`)
- Microsoft Excel source workbooks (`.xlsx`)
- Logos and other graphics
- Contact information
- Other editable source material used to generate templates

Deployment-ready Office template files do **not** belong here.

## Learn More

For the complete workflow, see:

- [`../README.md`](../README.md)

For information about deployment-ready templates, see:

- [`../releases/README.md`](../releases/README.md)

For instructions on packaging and publishing releases, see:

- [`../.github/workflows/README.md`](../.github/workflows/README.md)
