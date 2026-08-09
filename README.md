# Microsoft Word for Windows 1.1a - Native x64 Port

This project is a fully working native Windows x64 port of Microsoft Word for
Windows 1.1a, whose historical codename was **Opus**. It builds the original
Word source and resources together with modern replacements for the 16-bit
assembly, segmented-memory, and Win16 platform boundaries.

The result is the original Word application and user experience running as a
64-bit Windows executable. This is not an emulator or a reimplementation using
a modern editor control.

## Requirements

- 64-bit Windows
- Visual Studio 2022 with **Desktop development with C++**
- A Windows 10 or Windows 11 SDK installed through Visual Studio
- CMake 3.25 or newer
- PowerShell

## Build and run

Clone the repository, configure the included CMake preset, and build it from a
PowerShell prompt:

```powershell
git clone https://github.com/jmarshall23/msword.git
Set-Location msword\src

cmake --preset x64-debug
cmake --build --preset x64-debug

& ..\bin\WORD1.exe
```

For an optimized build, use the release preset instead:

```powershell
cmake --preset x64-release
cmake --build --preset x64-release
& ..\bin\WORD1.exe
```

## Windows release artifacts (EXE + MSI)

This repository includes a Windows release workflow at
`.github/workflows/windows-release.yml` that:

- Configures and builds `x64-release`
- Runs the full Release test suite (`ctest`)
- Produces `WORD1-windows-x64.zip` from `bin\*`
- Produces an MSI installer using WiX (`packaging/wix/msword.wxs`)
- Uploads both artifacts to the workflow run
- Publishes both artifacts to GitHub Releases for `v*` tags

To trigger a release build, push a semantic version tag (for example `v0.2.0`).
The MSI `ProductVersion` is derived from the first `major.minor.patch` numbers
in the tag.

### Optional artifact signing

If these repository secrets are configured, the workflow signs both `WORD1.exe`
and the generated MSI before publishing:

- `WINDOWS_CERT_BASE64` (base64-encoded `.pfx`)
- `WINDOWS_CERT_PASSWORD`

The presets use the Visual Studio 2022 x64 generator. After configuration, the
generated solution can also be opened directly from
`out\MicrosoftWordX64Port.sln`; use `WORD1` as the startup project.

## Test

Run the complete Debug test suite from the repository root:

```powershell
ctest --test-dir .\out -C Debug --output-on-failure
```

Or, when your current directory is `src`:

```powershell
ctest --test-dir ..\out -C Debug --output-on-failure
```

For a release build, replace `Debug` with `Release`. The suite covers the
ported x64 runtime, original Word data structures and command tables, process
startup, and automated UI workflows including typing, selection, formatting,
dialogs, and saving.

## Project layout

| Path | Purpose |
| --- | --- |
| `src/Opus/` | Original Microsoft Word/Opus application source and resources |
| `src/OpusEtAl/` | Original supporting tools, libraries, and build inputs |
| `src/OpusProg/` | Historical program documentation |
| `src/port/original/` | x64 compatibility layer, translated routines, and tests |
| `src/port/tools/` | Native replacements for historical build-time tools |
| `src/cmake/` | Resource and source-generation helpers |
| `out/` | CMake cache and generated Visual Studio solution |
| `build/` | Intermediate tools, tests, probes, PDBs, and diagnostics |
| `bin/` | Final executable and runtime files |

`out`, `build`, and `bin` are generated locally during configuration and
compilation.

## How the port works

The original C and resource files remain the authoritative implementation.
The port adds only the platform work needed to build and run that code safely
on 64-bit Windows:

- 16-bit x86 assembly entry points are translated to fixed-width C or C++.
- Segmented and double-indirect memory handles are mapped to an x64-safe native
  runtime.
- Win16-specific startup, messaging, graphics, file, and resource behavior is
  adapted to current Win32 APIs.
- Original command, dialog, cursor, bitmap, and other generated assets are
  rebuilt by native host tools as part of the CMake graph.
- Unit, runtime, smoke, and UI tests guard compatibility with the original
  algorithms and application behavior.

CMake inventories the legacy assembly tree but does not compile those modules
into native targets. This keeps the historical implementation available as a
reference while ensuring all shipped code is valid for AMD64.

## Useful targets

| Target | Description |
| --- | --- |
| `WORD1` | The native x64 Microsoft Word executable |
| `opus_original_engine` | Original Word application engine compiled for x64 |
| `opus_x64_runtime` | Native runtime and translated assembly behavior |
| `opus_word1_ui_test` | Automated end-to-end UI test driver |
| `legacy_sources` | IDE-visible reference collection of the original assembly |

Build a specific target with:

```powershell
cmake --build --preset x64-debug --target WORD1
```

## Contributing

Changes should preserve the original Word behavior while keeping all native
interfaces pointer-width safe. Prefer source-equivalent translations of
historical routines, isolate unavoidable Windows API adaptation at the port
boundary, and add focused tests for newly translated behavior.

## Copyright

The historical source files retain their original Microsoft and third-party
copyright notices. This repository does not currently include a top-level
license file; review the applicable rights before redistributing the source or
binaries.
