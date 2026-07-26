# Releases Directory

This directory contains the deployment-ready Microsoft Office template files that will be distributed to users.

Typical contents include:

```text
Example.dotx
Example.potx
Example.xltx
```

Only completed template files belong in this directory.

Do **not** place editable source documents such as `.docx`, `.pptx`, or `.xlsx` files here.

When you are ready to publish a new version of your templates:

1. Save each branded source document as the appropriate Microsoft Office template type.
2. Copy the completed template files into this directory.
3. Run the **Publish Office Templates** GitHub Actions workflow.

The workflow packages the contents of this directory into a downloadable GitHub Release.

## Learn More

- See the top-level [`README.md`](../README.md) for the complete workflow, including creating branded source documents.
- See [`.github/workflows/README.md`](../.github/workflows/README.md) for detailed instructions on creating, publishing, and installing template releases.
