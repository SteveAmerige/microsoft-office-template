# Publishing and Installing Your Templates

The workflow in this directory packages your completed Microsoft Office templates into a ZIP file and publishes that ZIP file as a GitHub Release.

The intended process is:

```text
Copy the master specimen for each use
        ↓
Add the appropriate logo and contact information
        ↓
Save each branded source document as an Office template
        ↓
Place the completed templates in releases/
        ↓
Run the GitHub Actions workflow
        ↓
Download one ZIP file on each computer or VM
        ↓
Install the templates in Microsoft Office
```

The workflow does not create or modify Microsoft Office templates. You create and review the templates using Microsoft Office. The workflow packages the completed files only after you decide they are ready for use.

---

# 1. Create Your Branded Source Documents

Begin with the editable master specimen in your own repository:

```text
src/Style-Specimen.docx
```

Make one copy for each personal, professional, organizational, project, publication, or other presentation you wish to maintain.

A possible source layout is:

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

For example, one person might create separate source documents for:

- personal correspondence;
- an employer;
- an organization where the person volunteers;
- a business or customer;
- a project or publication.

All of those source documents may remain in the same repository.

Copying the master specimen instead of editing it directly preserves one authoritative style source from which additional branded documents can be created later.

---

# 2. Customize Each Branded Document

Open each copied `.docx` document in Microsoft Word.

Replace the content that identifies the document's intended use. Typical changes include:

- the logo or other graphic in the upper-left portion of the header;
- the name and contact information in the upper-right portion of the header;
- organization-specific footer information;
- any other content that should differ for that use.

The document styles, typography, numbering, spacing, tables, captions, and other reusable formatting should normally remain derived from the master specimen.

Review each branded document before converting it into a template.

---

# 3. Save Each Document as an Office Template

When a branded Word source document is ready:

1. Open the `.docx` file in Microsoft Word.
2. Select **File**.
3. Select **Save As**.
4. Choose the location where you want to save the generated template.
5. In **Save as type**, select **Word Template (`*.dotx`)**.
6. Preserve the intended template filename.
7. Select **Save**.

For example:

```text
src/brands/<brand>/<brand>.docx
        ↓
releases/<brand>.dotx
```

Other Microsoft Office applications use corresponding source and template formats:

```text
Microsoft Word
    .docx → .dotx

Microsoft PowerPoint
    .pptx → .potx

Microsoft Excel
    .xlsx → .xltx
```

Macro-enabled files use different template extensions, such as `.dotm`, `.potm`, and `.xltm`.

---

# 4. Place Completed Templates in `releases/`

Copy each completed template into the top-level `releases/` directory of your repository.

For example:

```text
releases/
├── <brand-a>.dotx
├── <brand-b>.dotx
├── <brand-c>.dotx
├── <brand-a>.potx
└── <brand-a>.xltx
```

The `releases/` directory is intentionally flat. Its contents correspond to the files that will be copied into a Microsoft Office Personal Templates directory.

Filenames must therefore be unique within `releases/`.

Everything in `releases/` is considered ready for deployment. Do not place editable `.docx`, `.pptx`, or `.xlsx` source files there.

Before continuing:

1. Open and inspect every template.
2. Verify the logo and contact information.
3. Confirm that no unwanted personal or organizational information remains.
4. Confirm that comments, tracked changes, and temporary content have been removed.
5. Delete obsolete templates from `releases/`.
6. Confirm that no Microsoft Office lock files beginning with `~$` are present.

---

# 5. Commit and Push the Release Files

From the top-level directory of your repository, review the pending changes:

```bash
git status
```

Add the completed templates and related source changes:

```bash
git add src releases
```

Commit them:

```bash
git commit -m "release: prepare Office templates"
```

Push the commit to GitHub:

```bash
git push
```

The GitHub Actions workflow packages the files from the commit and branch that you select when running it. Commit and push all intended changes before creating the release.

---

# 6. Run the Release Workflow

Ordinary commits and pushes do not create releases.

You explicitly decide when the files in `releases/` are ready to be published.

To create a release:

1. Open your repository on GitHub.
2. Select the **Actions** tab.
3. In the workflow list, select **Publish Office Templates**.
4. Select **Run workflow**.
5. Select the branch containing the completed templates.
6. Enter a release version.

Use a version in this format:

```text
vMAJOR.MINOR.PATCH
```

Examples:

```text
v1.0.0
v1.1.0
v1.1.1
v2.0.0
```

A practical interpretation is:

- increase `MAJOR` for a substantial redesign;
- increase `MINOR` for meaningful additions or improvements;
- increase `PATCH` for corrections or small refinements.

7. Enter an optional release title when the workflow provides that field.
8. Select **Run workflow**.
9. Wait for the workflow run to finish.

The workflow will:

1. verify that the requested version is valid;
2. verify that `releases/` exists and contains files;
3. package only the contents of `releases/`;
4. create a ZIP archive;
5. create a Git tag for the requested version;
6. create a GitHub Release;
7. attach the ZIP archive to the release.

The source documents under `src/`, the Git submodule, repository documentation, and other working files are not included in the ZIP archive.

---

# 7. Confirm That the Workflow Succeeded

Open the completed workflow run under the repository's **Actions** tab.

A successful run displays a green check mark.

Then:

1. Open the repository's main page.
2. Select **Releases**.
3. Open the release you just created.
4. Confirm that the downloadable ZIP file is listed under **Assets**.
5. Download the ZIP once and inspect its contents.

The archive should contain only the deployment-ready Office templates, such as:

```text
<brand-a>.dotx
<brand-b>.dotx
<brand-c>.dotx
<brand-a>.potx
<brand-a>.xltx
```

It should not contain a surrounding `releases/` directory.

---

# 8. Troubleshoot Workflow Permissions

The workflow must be able to create a Git tag, a GitHub Release, and release assets.

If the workflow reports a permission error:

1. Open the repository on GitHub.
2. Select **Settings**.
3. Select **Actions**.
4. Select **General**.
5. Locate **Workflow permissions**.
6. Allow the workflow the repository write access required to create releases.
7. Save the setting.
8. Run the workflow again.

The workflow uses GitHub's repository-scoped automation token. A separate personal access token should not normally be required.

---

# 9. Correct a Failed Release

A failed workflow run does not create a usable release.

Open the failed run and expand the step marked with a red failure indicator. Correct the reported problem, commit and push any required changes, and run the workflow again.

Common causes include:

- `releases/` does not exist;
- `releases/` contains no files;
- the version does not follow `vMAJOR.MINOR.PATCH`;
- the requested version already exists;
- the workflow lacks repository write permission;
- an unexpected file was placed in `releases/`.

If a version has already been published, use a new version rather than silently replacing the existing release.

For example:

```text
v1.0.0 → v1.0.1
```

This preserves an unambiguous history of the packages that may already have been installed on other computers.

---

# 10. Download the Templates on Another Computer

On each computer or virtual machine where you use Microsoft Office:

1. Sign in to GitHub.
2. Open your template repository.
3. Open **Releases**.
4. Open the desired release, normally the latest one.
5. Download the Office-template ZIP file.
6. Extract the ZIP into a temporary directory.
7. Review the extracted template files.
8. Copy them into the appropriate Microsoft Office Personal Templates directory.

For a private repository, the user downloading the release must have access to that repository.

---

# 11. Install the Templates on Windows

The usual Microsoft Office Personal Templates directory on Windows is:

```text
%USERPROFILE%\Documents\Custom Office Templates
```

The expanded path commonly resembles:

```text
C:\Users\<username>\Documents\Custom Office Templates
```

To install the release:

1. Extract the downloaded ZIP.
2. Select all extracted Office template files.
3. Copy them.
4. Open the Personal Templates directory.
5. Paste the files into that directory.
6. Replace older files with the same names when you intend to update them.
7. Restart the relevant Office application when necessary.

To verify or change the configured personal-template location in Word:

1. Open Word.
2. Select **File**.
3. Select **Options**.
4. Select **Save**.
5. Review **Default personal templates location**.

After installation, create a new document from a template:

1. Open the relevant Office application.
2. Select **File**.
3. Select **New**.
4. Select **Personal** or **Custom**, depending on the Office version.
5. Select the desired template.

Opening a template through **File → New** creates a new document based on the template rather than opening the template itself for editing.

---

# 12. Install the Templates on macOS

Microsoft Office for Mac stores user templates under the user's Library directory. A commonly used location is:

```text
~/Library/Group Containers/UBF8T346G9.Office/User Content/Templates
```

To install the release:

1. Download and extract the ZIP.
2. In Finder, select **Go**.
3. Select **Go to Folder**.
4. Enter:

   ```text
   ~/Library/Group Containers/UBF8T346G9.Office/User Content/Templates
   ```

5. Copy the extracted templates into that directory.
6. Replace older files with the same names when you intend to update them.
7. Restart the relevant Office application when necessary.

The exact location may vary with the Office version and local configuration. When Office provides a configured user-template location, use that configured location.

---

# 13. Update Templates on Multiple Computers

When you create a newer release:

1. Download the new release ZIP on each computer or VM.
2. Extract it.
3. Copy its contents into the configured Personal Templates directory.
4. Replace older files that have the same names.
5. Remove templates that are no longer included when you no longer want them available.
6. Restart Office when necessary.

Stable template filenames make updates straightforward:

```text
<brand-a>.dotx
<brand-b>.dotx
<brand-c>.dotx
```

Git tags and GitHub Releases provide the version history, so version numbers do not need to be included in the installed template filenames.

---

# Summary

The complete workflow is:

```text
Copy src/Style-Specimen.docx for each intended presentation
        ↓
Customize each copy with the appropriate logo and contact information
        ↓
Save each completed source document as an Office template
        ↓
Copy all deployment-ready templates into releases/
        ↓
Commit and push the changes
        ↓
Run Publish Office Templates from the GitHub Actions tab
        ↓
Download the release ZIP on each computer or VM
        ↓
Extract and copy the templates into the Office Personal Templates directory
```

The editable source documents remain under version control.

The `releases/` directory contains only approved deployment files.

GitHub Releases provide one convenient package that can be downloaded and installed wherever the templates are needed.
