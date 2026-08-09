# Download and run Microsoft Word 1.1a (x64 port)

You do not need Visual Studio or CMake to try this project. Prebuilt Windows
binaries are published for each tagged release, and you can also grab a build
from any run of the Windows release workflow.

## Requirements

- 64-bit Windows 10 or Windows 11
- No runtime installation is required beyond the Microsoft Visual C++
  Redistributable, which is already present on most machines. If `WORD1.exe`
  fails to start with a missing DLL error, install the latest
  [Visual C++ Redistributable for x64](https://aka.ms/vs/17/release/vc_redist.x64.exe).

## Option 1: Download a release (recommended)

1. Open the [Releases page](https://github.com/bahree/msword/releases).
2. Download one of the assets from the latest release:
   - `WORD1-windows-x64.zip` — portable build, just unzip and run.
   - `WORD1-windows-x64-<version>.msi` — installer that puts the app in
     Program Files and adds a Start menu shortcut.
3. Run it:
   - **ZIP**: right-click the file, choose **Properties**, tick **Unblock** if
     it is shown, then extract the archive and double-click `WORD1.exe`.
   - **MSI**: double-click the installer and follow the prompts, then launch
     **Microsoft Word for Windows 1.1a (x64 Port)** from the Start menu.

Keep the contents of the ZIP together. `WORD1.exe` loads the runtime files that
ship next to it, so copying only the EXE elsewhere will not work.

### SmartScreen and antivirus warnings

Releases are only Authenticode-signed when signing secrets are configured for
the repository. Unsigned builds may trigger a Microsoft Defender SmartScreen
prompt on first launch; choose **More info** → **Run anyway** if you trust the
download.

## Option 2: Download a build from GitHub Actions

Every run of the **Windows Release Build** workflow uploads the same ZIP and MSI
as a build artifact, so you can try changes that have not been tagged yet.

1. Open the
   [Windows Release Build workflow](https://github.com/bahree/msword/actions/workflows/windows-release.yml).
2. Click the most recent run.
3. Scroll to **Artifacts** and download `windows-release-assets`.
4. Unzip it to get `WORD1-windows-x64.zip` and the MSI, then follow the steps
   above.

The ZIP and MSI are produced even when the test suite fails, so a run marked
with a red X can still contain usable artifacts — check whether the failure came
from the `Build (Release)` step (no artifacts) or only from the tests (artifacts
present). Release assets are published only when the tests pass. To skip the
suite entirely for a manual run, set the **Run the Release test suite** input to
`false` when you click **Run workflow**.

Downloading workflow artifacts requires being signed in to GitHub, and artifacts
expire after the repository's retention period.

## Publishing a new download (maintainers)

Push a semantic version tag to build and publish assets automatically:

```powershell
git tag v0.2.0
git push origin v0.2.0
```

The workflow configures and builds `x64-release`, runs the Release test suite,
packages `bin\*` into the ZIP, builds the MSI from `packaging/wix/msword.wxs`,
optionally signs both artifacts, and attaches them to the GitHub Release for the
tag. Assets are attached only if the tests pass; if they fail, the run is marked
failed but the ZIP and MSI are still uploaded as run artifacts. The MSI
`ProductVersion` comes from the first `major.minor.patch` numbers in the tag.
You can also start the workflow manually with **Run workflow**
(`workflow_dispatch`) to produce artifacts without creating a release.

## Building it yourself instead

If you would rather build from source, see the
[Build and run](README.md#build-and-run) section of the README.
